# 每天5分钟玩转 Docker 容器技术（115）
https://www.cnblogs.com/CloudMan6/p/8194895.html
https://kubernetes.io/docs/tutorials/kubernetes-basics/

## 交互式教程

```
kubernetes.io 开发了一个交互式教程，通过 Web 浏览器就能使用预先部署好的一个 kubernetes 集群，快速体验 kubernetes 的功能和应用场景，下面我就带着大家去玩一下。

打开 https://kubernetes.io/docs/tutorials/kubernetes-basics/


学习笔记
https://wdxtub.com/2017/06/05/k8s-note/


```
## 简介

```
Kubernetes 基础
先来看一段来自这里的简介（我更新了一下链接）：

Kubernetes 是 Google 开源的容器集群管理系统，其提供应用部署、维护、扩展机制等功能，利用Kubernetes 能方便地管理跨机器运行容器化的应用。Kubernetes 可以在物理机或虚拟机上运行，且支持部署到 AWS，Azure，GCE 等多种公有云环境。介绍分布式训练之前，需要对 Kubernetes 有一个基本的认识，下面先简要介绍一下本文用到的几个 Kubernetes 概念。

    Node 表示一个 Kubernetes 集群中的一个工作节点，这个节点可以是物理机或者虚拟机，Kubernetes 集群就是由 node 节点与 master 节点组成的。
    Pod 是一组(一个或多个)容器，pod 是 Kubernetes 的最小调度单元，一个 pod 中的所有容器会被调度到同一个 node 上。Pod 中的容器共享 NET，PID，IPC，UTS 等 Linux namespace。由于容器之间共享 NET namespace，所以它们使用同一个 IP 地址，可以通过 localhost 互相通信。不同 pod 之间可以通过IP地址访问。
    Job 描述 Kubernetes 上运行的作业，一次作业称为一个 job，通常每个 job 包括一个或者多个pods，job 启动后会创建这些 pod 并开始执行一个程序，等待这个程序执行成功并返回 0 则成功退出，如果执行失败，也可以配置不同的重试机制。
    Volume 存储卷，是 pod 内的容器都可以访问的共享目录，也是容器与 node 之间共享文件的方式，因为容器内的文件都是暂时存在的，当容器因为各种原因被销毁时，其内部的文件也会随之消失。通过 volume，就可以将这些文件持久化存储。Kubernetes 支持多种 volume，例如 hostPath(宿主机目录)，gcePersistentDisk，awsElasticBlockStore等。
    Namespaces 命名空间，在 kubernetes 中创建的所有资源对象(例如上文的 pod，job)等都属于一个命名空间，在同一个命名空间中，资源对象的名字是唯一的，不同空间的资源名可以重复，命名空间主要为了对象进行逻辑上的分组便于管理。本文只使用了默认命名空间。
    PersistentVolume: 和 PersistentVolumeClaim 结合，将外部的存储服务在 Kubernetes 中描述成为统一的资源形式，便于存储资源管理和 Pod 引用。

如果看不懂，也没有关系，接下来会更详细介绍。PS. 官方文档很有灵性，建议有英文阅读能力的同学去通读一遍，这里只是我的一些学习笔记，不如原版这么有逻辑性。

Kubernetes 集群让多台机器像一个单一组件一样运行，但是有一个前提条件，就是应用需要被打包到容器里。打包好之后 Kubernetes 会自动化地以一种高效的形式去调度容器们。一个 Kubernetes 集群有两种类型的资源：

    Master 负责调度集群，维护应用状态，扩展应用和滚动更新
    Nodes 负责运行各个应用。每个节点有一个 Kubelet，是在每个节点上的客户端，负责与 master 交流。一个 Kubernetes 集群至少需要 3 个 node。

        如果想要体验一下，可以使用 Minikube，会在单机上创建虚拟机来搭建集群（本文的教程也是用这个来展示的）

```

## 1、Interactive Tutorial - Creating a Cluster 创建集群

```
创建 Kubernetes 集群
点击教程菜单 1. Create a Cluster -> Interactive Tutorial - Creating a Cluster
 
# 查看版本
minikube version
# 启动集群
minikube start
# 查看版本
kubectl version
# 查看集群状态
kubectl cluster-info
# 获取可用的 node
kubectl get nodes


```


## 2、Interactive Tutorial - Deploying an App 部署应用

```
Kubernetes 集群启动之后，就可以在这之上部署应用了。部署应用的时候 master 会进行调度并选择合适的 node，启动之后仍旧会继续监控，一旦出问题，就会自动重新启用。

我们可以使用 Kubernetes 命令行工具 Kubectl 通过 Kubernetes API 来管理部署。创建部署的时候需要指定镜像和要运行的副本个数（当然也可以后面更新），然后们就实际来部署一波，命令如下：


kubectl version

kubectl get nodes

# 部署应用
kubectl run kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --port=8080

# 列出部署
kubectl get deployments

# 查看部署
# 先通过 proxy 连接到正在运行的容器

新开一个终端2
kubectl proxy

# 输出 Pod 名字
回第一个终端1
curl http://localhost:8001/version

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# 获取这个 pod 的输出
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/

```


## 3、Interactive Tutorial - Exploring Your App 探索应用

```
查看应用
每个应用会在一个 Pod 中运行，一个 Pod 里可以有一个或多个应用（相当于给这些应用创建了一个共有的 localhost 环境，每个 pod 里的网络等环境是共享的）。

每个 Pod 都会运行在一个 Node 上，每个 Node 都由 Master 来管理。其中，每个 Node 都必须要有：
    Kubelet，负责与 Master 通讯，管理 node 上运行的 pods 和 containers
    一个容器的 runtime，比如 docker，用来从 registry 拉取镜像，解压与运行应用

常用的 kubectl 命令有

    kubectl get 列出所有的资源
    kubectl describe 显示资源的详细信息
    kubectl logs 输出一个 pod 中一个 container 的日志
    kubectl exec 在一个 pod 中的一个 container 中执行命令

例子如下：


kubectl获取列表资源
kubectl describe - 显示有关资源的详细信息
kubectl logs - 从pod中的容器打印日志
kubectl exec - 在pod中的容器上执行命令

# 获取 pod 信息
kubectl get pods

# 查看 pods 详细信息
# 包括 镜像、IP 等各类信息，describe 不仅可以用于 pods，node 和 deployment 都可以
kubectl describe pods

新开一个终端2
kubectl proxy

回第一个终端1
curl http://localhost:8001/version

# 获取 pod 信息
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/

# 查看 pod 日志
kubectl logs $POD_NAME

kubectl exec $POD_NAME env

kubectl exec -ti $POD_NAME bash

cat server.js

curl localhost:8080

exit


```

## 4、Interactive Tutorial - Exposing Your App 公开应用

```

Pods 是有生命周期的，也有独立的 IP 地址，随着 Pods 的创建与销毁，一个必不可少的工作就是保证各个应用能够感知这种变化。这就要提到 Service 了，Service 是 YAML 或 JSON 定义的由 Pods 通过某种策略的逻辑组合。更重要的是，Pods 的独立 IP 需要通过 Service 暴露到网络中，有以下几种方式：

    ClusterIP(默认)：只在集群内部可见的地址
    NodePort：可在集群外访问，需要指定端口
    LoadBalancer：创建一个负载均衡器，IP 是固定的
    ExternalName：使用任意的名字暴露服务

依然是通过实例来感受一下




ClusterIP（默认） - 在群集中的内部IP上公开服务。此类型使服务只能从群集中访问。
NodePort - 使用NAT在集群中每个选定节点的同一端口上公开服务。使用可从群集外部访问服务<NodeIP>:<NodePort>。ClusterIP的超集。
LoadBalancer - 在当前云中创建外部负载均衡器（如果支持），并为服务分配固定的外部IP。NodePort的超集。
ExternalName - externalName通过返回带有名称的CNAME记录，使用任意名称（在规范中指定）公开服务。没有代理使用。此类型需要v1.7或更高版本kube-dns。

# 查看 pods 信息
kubectl get pods
# 查看服务信息
kubectl get services
# 暴露服务
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

kubectl get services

kubectl describe services/kubernetes-bootcamp

export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

curl $(minikube ip):$NODE_PORT


kubectl describe deployment

kubectl get pods -l run=kubernetes-bootcamp

kubectl get services -l run=kubernetes-bootcamp

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

kubectl label pod $POD_NAME app=v1

kubectl describe pods $POD_NAME

kubectl get pods -l app=v1

kubectl delete service -l run=kubernetes-bootcamp

kubectl get services

curl $(minikube ip):$NODE_PORT

kubectl exec -ti $POD_NAME curl localhost:8080



```

## 5、Interactive Tutorial - Scaling Your App 扩展应用


```

当业务流量暴涨，就需要根据需要扩展应用（多几个 pods），具体的原理比较简单，我们直接来看例子：


kubectl get deployments

kubectl scale deployments/kubernetes-bootcamp --replicas=4

kubectl get deployments

kubectl get pods -o wide

kubectl describe deployments/kubernetes-bootcamp

# 暴露服务
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

kubectl describe services/kubernetes-bootcamp

export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

每次执行都不一样，说明负载均衡已经起作用了
curl $(minikube ip):$NODE_PORT


kubectl scale deployments/kubernetes-bootcamp --replicas=2

kubectl get deployments

kubectl get pods -o wide



```

## 6、Interactive Tutorial - Updating Your App 滚动更新应用

```

滚动更新可以保证 0 停机时间，其实逻辑和前面的扩展差不多，可以认为是用新版本的扩展，也直接来看例子：


kubectl get deployments

kubectl get pods

kubectl describe pods

kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2

kubectl get pods

kubectl describe services/kubernetes-bootcamp

export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

curl $(minikube ip):$NODE_PORT

kubectl rollout status deployments/kubernetes-bootcamp

kubectl describe pods


kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v10

kubectl get deployments

kubectl get pods

kubectl describe pods

kubectl rollout undo deployments/kubernetes-bootcamp

kubectl get pods

kubectl describe pods







```

## Interactive Tutorial - 

```

```


## 

```

```


## 

```

```

