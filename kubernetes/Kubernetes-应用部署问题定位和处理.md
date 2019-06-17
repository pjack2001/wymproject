Kubernetes-应用部署问题定位和处理


2018-08-09 11:15 Daniel_Ji 分类：Kubernetes实践分享/开发实战 / Kubernetes教程/入门教程 阅读(5056)	评论(0) 
1、应用部署问题处理的整体思路
在将容器化的应用部署到Kubernetes集群中，可能会出现各种问题。根据Kubernetes的架构设计原理，容器化应用对外提供服务出现的主要问题在三个点上：

1）应用本身的问题：此问题为应用本身的问题，不在此文中进行详细的阐述；

2）作为容器化应用逻辑主机的Pod的问题：此部分的问题主要涉及到容器化应用是否在容器云中正常部署和运行，这里会涉及到CPU、内存、存储资源等问题；

3）代理容器化应用服务的问题：第三方服务或用户会通过代理服务访问容器化应用，如果代理服务存在问题，则容器云应用将无法对外提供服务能力，这里会涉及到服务是否存在、DNS解析是否正确等问题。

在本文中，以部署的高可用MySQL（请参考：Kubernetes-部署高可用的MySQL）为例展示如何进行问题定位和处理。另外为了能够在Kubernetes集群外访问MySQL数据库，对外暴露了MySQL master的NodePort类型服务，服务名称为mysql-0-svc。

2、调试Pods
在调试Pod之前，通过kubectl get pods命令查看一下Pod的运行状态。

$ kubectl get pods --namespace=kube-public


对于特定的Pod，可以通过kubectl describe pods命令查看详细的信息。

$ kubectl describe pods/mysql-0 --namespace=kube-public


在Pod的生命周期中，有如下的几个状态：

Pending: Pod已经被Kubernetes系统接受，但是还有一个或者多个容器镜像未被创建。这包括Pod正在被调度和从网络上下载镜像的时间。
Running: Pod已经被绑定到了一个Node，所有的容器也已经被创建。至少有一个容器已经在运行，或者在启动或者重新启动的过程中。
Succeeded: 在Pod中的所有的容器都已经被成功的终止，并且不会再重启。
Failed: 在Pod中所有容器都已经被终止，并且至少有一个容器是非正常终止的。即，容器以非零状态退出或者被系统强行终止的。
Unknown: 由于某些原因，Pod不能被获取，典型的情况是在与Pod的主机进行通信中发生了失败。
Waiting：由于某些原因，Pod已被调度到了Node节点上，但无法正常运行。
Crashing：由于某些原因，Pod处于崩溃状态。
根据Pod所处的状态，相应的处理方式不同。

2.1 Pod处于待命（Pending）状态
如果Pod被卡在待命（Pending）状态，则意味着它无法被安排到Node节点上。造成这种情况通常因为某种类型的资源不足，从而导致Pod无法被调度。通过查看kubectl describe …命令的输出内容，应该有为什么Pod无法被调度的原因。这些原因包括：

没有足够的资源：集群中的CPU或内存可能已经耗尽了，在这种情况下，需要删除Pod，调整资源请求或向集群中添加新的Node节点。
正在使用hostPort：将Pod绑定到了数量有限的hostPort。在大多数情况下，没有必要使用hostPort，可以尝试使用服务来暴露Pod。如果确实需要hostPort，那么只能调度与Kubernetes集群中的节点一样多的Pod。
2.2 Pod处于等待（Waiting）状态
如果Pod处于等待（Waiting）状态，则它已被调度到一个工作Node上，但它无法在该Node上运行。同样，通过kubectl describe …应该是能够获取有用的信息。处于等待（Waiting）状态的最常见的原因是无法拉取镜像。有三件事需要检查：

确保镜像名称正确无误。
确认镜像仓库中是否存在此镜像？
在机器上，运行docker pull <image>命令，查看是否可以拉取镜像。
2.3 Pod崩溃（Crashing）或其他不健康
首先，通过执行kubectl logs ${POD_NAME} ${CONTAINER_NAME}查看当前容器的日志：

$ kubectl logs mysql-0 mysql --namespace=kube-public
如果容器之前已崩溃，可以使用以下命令访问上一个容器的崩溃日志：

$ kubectl logs --previous mysql-0 mysql --namespace=kube-public
或者，也可以使用kubectl exec在该容器内运行命令：

$ kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -- ${CMD} ${ARG1} ${ARG2} ... ${ARGN}
请注意，这-c ${CONTAINER_NAME}是可选的，对于仅包含单个容器的Pod，可以省略。

如果这些方法都不起作用，可以找到运行该pod的主机，并通过SSH连接到该主机。

2.4 Pod正在运行，但没有按照要求执行
如果Pod没有按预期运行，可能是Pod描述中存在错误，并且在创建Pod时忽略了该错误。通常可能是，Pod描述的一部分嵌套不正确，或键名不正确，因此键被忽略。例如，如果拼写错误command，commnd则将创建Pod，但不会按照希望使用命令行。

首先，要做的第一件事是删除此Pod，并尝试使用–validate选项再次创建它。例如，运行kubectl create –validate -f mypod.yaml。如果拼写错误command，commnd那么会出现如下错误：

I0805 10:43:25.129850   46757 schema.go:126] unknown field: commnd
I0805 10:43:25.129973   46757 schema.go:129] this may be a false alarm, see https://github.com/kubernetes/kubernetes/issues/6842
pods/mypod
接下来，要检查的是apiserver上的Pod是否与要创建的Pod相匹配。例如，运行kubectl get pods/mypod -o yaml > mypod-on-apiserver.yaml，然后将原始的Pod描述mypod.yaml与从apiserver返回的描述文件mypod-on-apiserver.yaml进行比较。“apiserver”版本通常会有一些不在原始版本上的内容，这不影响。但是，如果原始版本上有不在apiserver版本上的行，则可能意味着原始版本Pod描述规范存在问题。

3、调试代理服务
根据Kubernetes的架构设计，用户或其它应用通过代理服务访问容器化应用。因此需要通过调试确认代理服务是否正常，需要做的工作包括：

1）检查代理服务本身是否存在；

2）检查代理服务是否能够正常通过DNS进行解析；

3）检查代理服务本身是否正确。

3.1 检查服务是否存在
在调试服务时，第一步要做的就是检查服务是否存在。在本文的前面说明了，在Kubernetes中通过NodePort类型对外暴露了MySQL master。通过执行kubectl get svc命令，可以获取是否存在相应服务：

$ kubectl get svc/mysql-0-svc --namespace=kube-public


通过返回的结果可以看出，在Kubernetes集群中存在此服务。

3.2 能否通过DNS解析正常解析代理服务
对于处于同一个命名空间的容器化应用，可以直接通过代理服务的名称(mysql-0-svc)访问MySQL master。

$ kubectl exec -it redis-ha-redis-ha-sentinel-5947b9569-r2b56 --namespace=kube-public -- nslookup mysql-0-svc


对Kubernetes集群中不同命名空间的容器化应用，则需要通过添加命名空间名称后(mysql-0-svc.kube-public)访问MySQL master：

$ kubectl exec -it gf1-6497d5df45-98g8v -- nslookup mysql-0-svc.kube-public


根据返回的可以看出，通过DNS能够正确的解析代理服务。

3.2.1 DNS是否正常工作
如果通过上述的操作都无法正常解析服务，通过kubectl exec -it  ${POD_NAME}  — nslookup命令检查一下Kubernetes master是否正常工作：

$ kubectl exec -it gf1-6497d5df45-98g8v -- nslookup kubernetes.default
如果此操作也失败，则需要检查Kubernetes集群中的DNS服务是否正常运行。

3.3 代理服务本身是否正确
如果代理服务也存在，DNS解析也没有问题。则需要检查一下代理服务本身是否有问题：

$ kubectl get service mysql-0-svc -o yaml --namespace=kube-public


例如访问的端口是否正确？targetPort是否指向了正确的Pods端口？这里的端口协议是否与Pod暴露出来的端口协议一致等。

 

参考材料
1.《Debug Services》地址：https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/#does-the-service-work-by-ip

2.《Troubleshooting》地址：https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/

3.《Application Introspection and Debugging》地址：https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application-introspection/

4.《Troubleshoot Applications》地址：https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/

作者简介：
季向远，北京神舟航天软件技术有限公司。本文版权归原作者所有。