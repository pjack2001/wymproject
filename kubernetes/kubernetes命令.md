
# 目录

## 常用命令 


```yml
allinone
192.168.113.53

多主多节点
多master节点需要额外规划一个master VIP(虚地址)113.60
192.168.113.61~64

验证安装
如果提示kubectl: command not found，退出重新ssh登陆一下，环境变量生效即可

kubectl version
kubectl get componentstatus # 可以看到scheduler/controller-manager/etcd等组件 Healthy
kubectl get node # 可以看到单 node Ready状态
kubectl get pod --all-namespaces # 可以查看所有集群pod状态，默认已安装网络插件、coredns、metrics-server等
kubectl get svc --all-namespaces # 可以查看所有集群服务状态

# 可以看到
# kubernetes master(apiserver)组件 running
# kubernetes-dashboard is running at..

kubectl cluster-info 

Kubernetes master is running at https://192.168.113.60:8443
CoreDNS is running at https://192.168.113.60:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://192.168.113.60:8443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy


# 获取访问dashboard token 
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

Name:         admin-user-token-r4pd9
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: admin-user
              kubernetes.io/service-account.uid: 08fe1bca-8940-11e9-b536-fefcfe3db569

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1350 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXI0cGQ5Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIwOGZlMWJjYS04OTQwLTExZTktYjUzNi1mZWZjZmUzZGI1NjkiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.n3dXU3E3TX4WlnNUJHgQFHRxtz5aM4Oz9nTEKIklcGomZWZBcP9tCeFENDI8vSREy1k6F--6JQn38Fx6d90frRhjmbZjJYVErFxtynI4epjPr4n4v-k37upHVKHrc5_oCCcMlayRysEcGnUuJonOb-7__G_5aMGALhhTOIZIhN-wawrzlOW634KgtoAM2oueig7GhPGY_jec1A_YE2-diDX5wvQLx3YC1B-kqC7QQTpbii-TIs6VZc-874j_QE8LnUdXAZU8u7pI_jNiX6DIgHL0BGzWYhZbgWJRFnKxSiA8Rn-4hxlCrJ0hvGvWwaY8fsHJg443BslrgeY3koSdIg




# 使用浏览器访问前面``kubectl cluster-info ``获取的dashboard地址，最后一条命令获取的token登陆。

admin/test1234



6.安装主要组件
# 安装kubedns，默认已集成安装
#kubectl create -f /etc/ansible/manifests/kubedns
# 安装dashboard，默认已集成安装
#kubectl create -f /etc/ansible/manifests/dashboard

登陆 dashboard可以查看和管理集群，更多内容请查阅dashboard文档



```

### kubernetes常用命令

```yml
https://www.cnblogs.com/liyongsan/p/9114561.html

#kubectl
source <(kubectl completion bash) #命令补全

#启动-状态

##master
systemctl daemon-reload
systemctl start kube-apiserver
systemctl start kube-controller-manager
systemctl start kube-scheduler

##etcd
systemctl start etcd.service

##client
systemctl start kube-proxy -l
systemctl start docker -l
systemctl start kubelet -l

##status
systemctl status etcd.service
systemctl status kube-apiserver -l
systemctl status kube-controller-manager -l
systemctl status kube-scheduler

systemctl status kube-proxy -l
systemctl status docker -l
systemctl status kubelet -l


#常用命令

kubectl get pods
kubectl get rc
kubectl get service
kubectl get componentstatuses
kubectl get endpoints
kubectl cluster-info
kubectl create -f redis-master-controller.yaml
kubectl delete -f redis-master-controller.yaml
kubectl delete pod nginx-772ai
kubectl logs -f pods/heapster-xxxxx -n kube-system #查看日志
kubectl scale rc redis-slave --replicas=3 #修改RC的副本数量，来实现Pod的动态缩放

etcdctl cluster-health #检查网络集群健康状态
etcdctl --endpoints=https://192.168.71.221:2379 cluster-health #带有安全认证检查网络集群健康状态
etcdctl member list
#etcdctl set /k8s/network/config '{ "Network": "10.1.0.0/16" }'
etcdctl get /k8s/network/config


#基础进阶
kubectl get services kubernetes-dashboard -n kube-system #查看所有service
kubectl get deployment kubernetes-dashboard -n kube-system #查看所有发布
kubectl get pods --all-namespaces #查看所有pod
kubectl get pods -o wide --all-namespaces #查看所有pod的IP及节点
kubectl get pods -n kube-system | grep dashboard
kubectl describe service/kubernetes-dashboard --namespace="kube-system"
kubectl describe pods/kubernetes-dashboard-349859023-g6q8c --namespace="kube-system" #指定类型查看
kubectl describe pod nginx-772ai #查看pod详细信息
kubectl scale rc nginx --replicas=5 # 动态伸缩
kubectl scale deployment redis-slave --replicas=5 #动态伸缩
kubectl scale --replicas=2 -f redis-slave-deployment.yaml #动态伸缩
kubectl exec -it redis-master-1033017107-q47hh /bin/bash #进入容器
kubectl label nodes node1 zone=north #增加节点lable值 spec.nodeSelector: zone: north #指定pod在哪个节点
kubectl get nodes -lzone #获取zone的节点
kubectl label pod redis-master-1033017107-q47hh role=master #增加lable值 [key]=[value]
kubectl label pod redis-master-1033017107-q47hh role- #删除lable值
kubectl label pod redis-master-1033017107-q47hh role=backend --overwrite #修改lable值
kubectl rolling-update redis-master -f redis-master-controller-v2.yaml #配置文件滚动升级
kubectl rolling-update redis-master --image=redis-master:2.0 #命令升级
kubectl rolling-update redis-master --image=redis-master:1.0 --rollback #pod版本回滚


```



### Kubernetes service中的故障排查

```yml
https://jimmysong.io/kubernetes-handbook/appendix/debug-kubernetes-services.html

Kubernetes service中的故障排查
查看某个资源的定义和用法
kubectl explain
查看Pod的状态
kubectl get pods
kubectl describe pods my-pod
监控Pod状态的变化
kubectl get pod -w
可以看到一个 namespace 中所有的 pod 的 phase 变化，请参考 Pod 的生命周期。

查看 Pod 的日志
kubectl logs my-pod
kubectl logs my-pod -c my-container
kubectl logs -f my-pod
kubectl logs -f my-pod -c my-container
-f 参数可以 follow 日志输出。

交互式 debug
kubectl exec my-pod -it /bin/bash
kubectl top pod POD_NAME --containers

```



### kubernetes中文文档

```yml

### http://docs.kubernetes.org.cn/683.html

Kubernetes kubectl 命令表
kubectl命令列表

kubectl run（创建容器镜像）
kubectl expose（将资源暴露为新的 Service）
kubectl annotate（更新资源的Annotations信息）
kubectl autoscale（Pod水平自动伸缩）
kubectl convert（转换配置文件为不同的API版本）
kubectl create（创建一个集群资源对象
kubectl create clusterrole（创建ClusterRole）
kubectl create clusterrolebinding（为特定的ClusterRole创建ClusterRoleBinding）
kubectl create configmap（创建configmap）
kubectl create deployment（创建deployment）
kubectl create namespace（创建namespace）
kubectl create poddisruptionbudget（创建poddisruptionbudget）
kubectl create quota（创建resourcequota）
kubectl create role（创建role）
kubectl create rolebinding（为特定Role或ClusterRole创建RoleBinding）
kubectl create service（使用指定的子命令创建 Service服务）
kubectl create service clusterip
kubectl create service externalname
kubectl create service loadbalancer
kubectl create service nodeport
kubectl create serviceaccount
kubectl create secret（使用指定的子命令创建 secret）
kubectl create secret tls
kubectl create secret generic
kubectl create secret docker-registry
kubectl delete（删除资源对象）
kubectl edit（编辑服务器上定义的资源对象）
kubectl get（获取资源信息）
kubectl label（更新资源对象的label）
kubectl patch（使用patch更新资源对象字段）
kubectl replace（替换资源对象）
kubectl rolling-update（使用RC进行滚动更新）
kubectl scale（扩缩Pod数量）
kubectl rollout（对资源对象进行管理）
kubectl rollout history（查看历史版本）
kubectl rollout pause（标记资源对象为暂停状态）
kubectl rollout resume（恢复已暂停资源）
kubectl rollout status（查看资源状态）
kubectl rollout undo（回滚版本）
kubectl set（配置应用资源）
kubectl set resources（指定Pod的计算资源需求）
kubectl set selector（设置资源对象selector）
kubectl set image（更新已有资源对象中的容器镜像）
kubectl set subject（更新RoleBinding / ClusterRoleBinding中User、Group 或 ServiceAccount）

```




### 

```yml

# 查看版本
kubectl version
# 查看集群状态
kubectl cluster-info
# 获取可用的 node
kubectl get nodes


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






```




### https://www.katacoda.com

https://www.katacoda.com/courses/kubernetes

```yml


#### Launch A Single Node Cluster

```


kubectl cluster-info

kubectl get nodes

kubectl run first-deployment --image=katacoda/docker-http-server --port=80

kubectl get pods

kubectl expose deployment first-deployment --port=80 --type=NodePort

export PORT=$(kubectl get svc first-deployment -o go-template='{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}')
echo "Accessing host01:$PORT"
curl host01:$PORT




cat /opt/weave-kube

kubectl apply -f /opt/weave-kube

kubectl get pod -n kube-system



kubectl create deployment http --image=katacoda/docker-http-server:latest

kubectl get pods

docker ps | grep docker-http-server



kubectl run http --image=katacoda/docker-http-server:latest --replicas=1

kubectl get deployments

kubectl describe deployment http

kubectl expose deployment http --external-ip="172.17.0.11" --port=8000 --target-port=80

curl http://172.17.0.11:8000



kubectl run httpexposed --image=katacoda/docker-http-server:latest --replicas=1 --port=80 --hostport=8001

kubectl get svc

docker ps | grep httpexposed



kubectl scale --replicas=3 deployment http

kubectl get pods

kubectl describe svc http

curl http://172.17.0.11:8000



使用yaml文件创建部署
vi deployment.yaml

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webapp1
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp1
    spec:
      containers:
      - name: webapp1
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80

kubectl create -f deployment.yaml

kubectl get deployment

kubectl describe deployment webapp1



使用yaml文件创建服务
apiVersion: v1
kind: Service
metadata:
  name: webapp1-svc
  labels:
    app: webapp1
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30080
  selector:
    app: webapp1



kubectl create -f service.yaml

kubectl get svc. 、

kubectl describe svc webapp1-svc.

curl host01:30080



修改yaml文件扩展部署

vi deployment.yaml

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webapp1
spec:
  replicas: 4
  template:
    metadata:
      labels:
        app: webapp1
    spec:
      containers:
      - name: webapp1
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80

再次部署
kubectl apply -f deployment.yaml

查看是否扩展为4个
kubectl get deployment

kubectl get pods

curl host01:30080


部署留言板实例

kubectl cluster-info
kubectl get nodes

kubectl create -f redis-master-controller.yaml

$ vi redis-master-controller.yaml

apiVersion: v1
kind: ReplicationController
metadata:
  name: redis-master
  labels:
    name: redis-master
spec:
  replicas: 1
  selector:
    name: redis-master
  template:
    metadata:
      labels:
        name: redis-master
    spec:
      containers:
      - name: master
        image: redis:3.0.7-alpine
        ports:
        - containerPort: 6379

kubectl get rc

kubectl get pods


$ vi redis-master-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: redis-master
  labels:
    name: redis-master
spec:
  ports:
    # the port that this service should serve on
  - port: 6379
    targetPort: 6379
  selector:
    name: redis-master


kubectl create -f redis-master-service.yaml

kubectl get services

kubectl describe services redis-master



$ vi redis-slave-controller.yaml

apiVersion: v1
kind: ReplicationController
metadata:
  name: redis-slave
  labels:
    name: redis-slave
spec:
  replicas: 2
  selector:
    name: redis-slave
  template:
    metadata:
      labels:
        name: redis-slave
    spec:
      containers:
      - name: worker
        image: gcr.io/google_samples/gb-redisslave:v1
        env:
        - name: GET_HOSTS_FROM
          value: dns
          # If your cluster config does not include a dns service, then to
          # instead access an environment variable to find the master
          # service's host, comment out the 'value: dns' line above, and
          # uncomment the line below.
          # value: env
        ports:
        - containerPort: 6379

kubectl create -f redis-slave-controller.yaml

kubectl get rc



$ vi redis-slave-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: redis-slave
  labels:
    name: redis-slave
spec:
  ports:
    # the port that this service should serve on
  - port: 6379
  selector:
    name: redis-slave


kubectl create -f redis-slave-service.yaml

kubectl get services



$ vi frontend-controller.yaml

apiVersion: v1
kind: ReplicationController
metadata:
  name: frontend
  labels:
    name: frontend
spec:
  replicas: 3
  selector:
    name: frontend
  template:
    metadata:
      labels:
        name: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3
        env:
        - name: GET_HOSTS_FROM
          value: dns
          # If your cluster config does not include a dns service, then to
          # instead access environment variables to find service host
          # info, comment out the 'value: dns' line above, and uncomment the
          # line below.
          # value: env
        ports:
        - containerPort: 80



kubectl create -f frontend-controller.yaml

kubectl get rc

kubectl get pods



$ vi frontend-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    name: frontend
spec:
  # if your cluster supports it, uncomment the following to automatically create
  # an external load-balanced IP for the frontend service.
  # type: LoadBalancer
  type: NodePort
  ports:
    # the port that this service should serve on
    - port: 80
      nodePort: 30080
  selector:
    name: frontend

kubectl create -f frontend-service.yaml

kubectl get services

kubectl get pods

kubectl describe service frontend | grep NodePort




#### Networking Introduction

```yml
Step 1 - Cluster IP

kubectl apply -f clusterip.yaml.

master $ cat clusterip.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp1-clusterip-svc
  labels:
    app: webapp1-clusterip
spec:
  ports:
  - port: 80
  selector:
    app: webapp1-clusterip
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webapp1-clusterip-deployment
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: webapp1-clusterip
    spec:
      containers:
      - name: webapp1-clusterip-pod
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80
---



kubectl get pods

kubectl get svc

kubectl describe svc/webapp1-clusterip-svc

export CLUSTER_IP=$(kubectl get services/webapp1-clusterip-svc -o go-template='{{(index .spec.clusterIP)}}')
echo CLUSTER_IP=$CLUSTER_IP
curl $CLUSTER_IP:80

curl $CLUSTER_IP:80


Step 2 - Target Port

kubectl apply -f clusterip-target.yaml

master $ cat clusterip-target.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp1-clusterip-targetport-svc
  labels:
    app: webapp1-clusterip-targetport
spec:
  ports:
  - port: 8080
    targetPort: 80
  selector:
    app: webapp1-clusterip-targetport
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webapp1-clusterip-targetport-deployment
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: webapp1-clusterip-targetport
    spec:
      containers:
      - name: webapp1-clusterip-targetport-pod
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80
---
master $


kubectl get svc

kubectl describe svc/webapp1-clusterip-targetport-svc


export CLUSTER_IP=$(kubectl get services/webapp1-clusterip-targetport-svc -o go-template='{{(index .spec.clusterIP)}}')
echo CLUSTER_IP=$CLUSTER_IP
curl $CLUSTER_IP:8080

curl $CLUSTER_IP:8080


```












### Docker Kubernetes 常用命令

```yml

https://www.cnblogs.com/xiangsikai/p/9995385.html

增

# 通过文件名或标准输入创建资源。
kubectl create
　　# 读取指定文件内容，进行创建。(配置文件可指定json，yaml文件)。
　　kubectl create -f 配置文件
　　# 创建指定文件内容，创建并指定服务版本。(配置文件可指定json，yaml文件)。
　　kubectl create -f 配置文件 --edit --output-version=版本号 -o json
 # 将一个资源公开为一个新的Kubernetes服务，暴露服务。
kubectl expose
　　# 创建Kubernetes 资源类型，并添加暴露端口。
　　kubectl expose 资源类型 资源名称 --port=暴露端口 --target-port=容器端口
　　# 创建Kubernetes service 服务，并添加暴露端口。
　　kubectl expose service 资源名称 --port=暴露端口 --target-port=容器端口 --name=创建服务名称
　　# 创建Kubernetes ，并添加UDP暴露端口,使用默认容器端口。
　　kubectl expose 资源类型 资源名称 --port=暴露端口 --protocol=udp --name=创建服务名称
　　# 创建Kubernetes服务，根据yaml文件，并添加暴露端口。(配置文件可指定json，yaml文件)。
　　kubectl expose -f 配置文件 --port=暴露端口 --target-port=容器端口
# 创建并运行一个特定的镜像，可能是副本。创建一个deployment或job管理创建的容器。
kubectl run
　　# 创建一个镜像，运行。
　　kubectl run 容器名 --image=镜像名
　　# 创建一个镜像，运行。并启用暴露端口。
　　kubectl run 容器名 --image=镜像名 --port=暴露端口
　　# 创建一个镜像，运行。并引入变量。
　　kubectl run 容器名 --image=镜像名 --env=“变量”
　　# 创建一个镜像，运行。并引入标签。
　　kubectl run 容器名 --image=镜像名 --labels="key=value,env=prod"
　　# 创建一个镜像，运行。并设置副本数。默认1。
　　kubectl run 容器名 --image=镜像名 --replicas=副本数
　　# 创建一个镜像，运行。并添加-i-t访问容器终端。并设置重启策略（Never不重启）。
　　kubectl run -i -t 容器名 --image=镜像名 --restart=重启策略
　　# 创建一个镜像，运行。并指定容器内执行指定命令。
　　kubectl run 容器名 --image=镜像名 --command -- 指定命令
删

# 通过文件名、标准输入、资源名称或标签选择器来删除资源
kubectl delete
　　# 删除指定资源。
　　kubectl delete 资源类型 资源名
　　# 删除所有指定资源。
　　kubectl delete 资源类型 -all
　　# 通过指定文件删除指定资源。（配置文件.json .yaml）
　　kubectl delete -f 配置文件
# 维护期间排除容器名
kubectl drain
　　# 排除指定容器名。
　　kubectl drain 容器名
改

# 配置应用资源。修改现有应用程序资源。
kubectl set
　　# 更新pod内的环境变量。
　　kubectl set env 资源类型 资源名称 添加变量=值
　　# 更新pod镜像。
　　kubectl set image 资源类型 资源名称 容器名=升级镜像版本
　　# 更新pod内的资源。
　　kubectl set resources 资源类型 资源名称 [请求——限制= & =请求][选项]
　　# 通过配置文件更新pod内的资源。（配置文件.json .yaml）
　　kubectl set resources -f 配置文件
# 使用默认的编辑器编辑一个资源。
kubectl edit
　　# 动态更新服务配置参数。
　　kubectl edit 资源类型 资源名称
# 管理资源的发布。
kubectl rollout
　　# 回滚到上一个版本。
　　kubectl rollout undo 资源类型 资源名称
　　# 指定版本回滚。
　　kubectl rollout undo 资源类型 资源名称 --to-revision=3
　　# 查看当前的资源状态。
　　kubectl rollout status 资源类型 资源名称
　　# 查看历史修订版本
　　kubectl rollout history 资源类型 资源名称
　　# 查看指定历史修订版本
　　kubectl rollout history 资源类型 资源名称 --revision=版本数
# 执行指定复制控制的滚动更新。
kubectl rolling-update
　　# 滚动更新v1版本，通过json配置文件跟新到v2版本。
　　kubectl rolling-update 服务名称-v1 -f 服务名称-v2.json
　　# 滚动更新v1版本，到v2，并指定更新镜像。
　　kubectl rolling-update 服务名称-v1 服务名称-v2 --image=image:v2
# 扩容或缩容Pod数量，Deployment、ReplicaSet、RC或Job
kubectl scale
　　# 扩容缩容副本数。
　　kubectl scale --replicas=副本数 资源类型 资源名称
　　# 扩容缩容副本数。对多个资源扩容。
　　kubectl scale --replicas=副本数 资源类型/资源名称1 资源类型/资源名称2
　　# 扩容缩容副本数。如果当前副本数为N个就扩容为Y个。
　　kubectl scale --current-replicas=副本数N --replicas=副本数Y 资源类型 资源名称
# 创建一个自动选择扩容或缩容并设置Pod数量
kubectl autoscale
　　# 设置该资源类型的副本数自动扩容到相关值
　　kubectl autoscale 资源类型 资源名称 --min=最小值 --max=最大值
　　# 设置该资源类型的副本数自动扩容到相关值。并根据CPU阈值扩容缩容。
　　kubectl autoscale 资源类型 资源名称 --max=最大值 --最小值 --cpu-percent=80
# 修改证书资源。
kubectl certificate
# 标记节点不可调度
kubectl cordon
　　# 标记指定节点不可调度
　　kubectl cordon 节点名
# 标记节点可调度
kubectl uncordon
　　# 标记指定节点可调度
　　kubectl uncordon 节点名
 # 更新一个或多个节点上的nodes。
kubectl taint
 # 执行命令到容器。
kubectl exec
　　# 执行指定命令到容器中。
　　kubectl exec 容器名 命令
　　# 分配伪终端已宿主级向容器添加命令。
　　kubectl exec 容器名 -- bash -c “命令”
　　# 进入指定节点容器内。
　　kubectl exec 容器名 -it bash
# 转发一个或多个本地端口到一个pod。
kubectl port-forward
　　# 将宿主级端口转发到容器中。
　　kubectl port-forward 容器名 宿主级端口:容器端口
# 为kubernetes API Server启动服务代理
kubectl proxy
# 拷贝文件或目录到容器中。
kubectl cp
 # 附加到一个进程到一个已经运行的容器。
kubectl attach
　　# 进入到一个运行的容器终端。
　　kubectl attach 容器名
 # 通过文件名或标准输入对资源应用配置
kubectl apply
# 更新部署配置文件信息（配置文件格式.json .yaml）
kubectl apply -f 配置文件
 # 使用补丁修改、更新资源的字段。
kubectl patch
# 通过文件名或标准输入替换一个资源。
kubectl replace
　　# 重新创建配置文件内的资源 。配置文件可是（.yaml、.json）
　　kubectl replace -f 配置文件 --force
 # 不同的API版本之间转换配置文件。YAML和JSON格式都接受。
kubectl convert
# 更新资源上的标签
kubectl label
# 在一个或多个资源上更新注释。
kubectl annotate
# 修改kubeconfig文件（用于访问API，比如配置认证信息）
kubectl config
查

# 显示一个或多个资源
kubectl get
　　# 查看组件运行状态
　　kubectl get componentstatus
　　# 查看节点加入信息
　　kubectl get node
　　# 查看所有资源
　　kubectl get all
　　# 查看pods状态
　　kubectl get pods
　　# 查看pods及运行节点位置，查看更多信息
　　kubectl get pods -o wide
　　# 查看endpoints节点
　　kubectl get endpoints
　　# 查看sservice暴露宿主级访问地址描述信息
　　kubectl get service
　　# 根据标签查找资源描述信息。--output=wide查看更多信息。
　　kubectl get 资源类型 --selector="key=value" --output=wide
　　# 查看资源所有标签
　　kubectl get 资源类型 --show-labels
　　# 根据标签查看资源
　　kubectl get 资源类型 -l app=example
　　# 查看指定命名空间的资源
　　kubectl get 资源类型 --namespace=kube-system
# 文档参考资料，可查看yaml文件字段指令含义。
kubectl explain
　　# 获得资源的特定字段的文档
　　kubectl explain pods.spec.containers
　　# 获得资源及其字段的文档
　　kubectl explain pods
# 显示集群信息
kubectl cluster-info
　　# 显示详细集群信息
　　kubectl cluster-info dump
# 显示资源（CPU/Memory/Storage）使用。需要Heapster运行。
kubectl top
# 显示特定资源或资源组的详细信。
kubectl describe
　　# 查看资源详细信息
　　kubectl describe 资源类型 资源名称
　　# 指定标签。详细信息。
　　kubectl describe 资源类型 -l name=标签名
# 在od或指定的资源中容器打印日志。如果od只有一个容器，容器名称是可选的。
kubectl logs
　　# 查看指定节点服务日志。
　　kubectl logs 容器名
　　# 查看指定容器日志。
　　kubectl logs pod 节点名 -c 容器名
　　# 查看指定容器日志。实时查看。
　　kubectl logs pod 容器名 -f
　　# 通过标签查看容器日志
　　kubectl logs -l key=value
其他

# 检查认证授权
kubectl auth
# 用于实现kubectl工具自动补全
kubectl completion
# 执行实现自动补全动作
source <(kubectl completion bash)
# 打印受支持的API版本
kubectl api-versions
# 所有命令帮助。
kubectl help
# 运行一个命令行插件。
kubectl plugin
# 打印客户端和服务版本信息
kubectl version


```




### 

```yml




```


# 容器化运行 kubeasz

## TL;DR;

- 1.准备一台全新虚机（ansible控制端）
```
$ wget https://github.com/easzlab/kubeasz/releases/download/1.3.0/easzup
$ chmod +x ./easzup
$ ./easzup -D
``` 
- 2.配置 ssh 密钥登陆集群节点
``` bash
ssh-keygen -t rsa -b 2048 回车 回车 回车
ssh-copy-id $IP  # $IP 为所有节点地址包括自身，按照提示输入 yes 和 root 密码
```
- 3.容器化运行 kubeasz，然后执行安装 k8s 集群（举例aio集群）

``` bash
$ ./easzup -S
$ docker exec -it kubeasz easzctl start-aio
# 若需要自定义集群创建，如下进入容器，然后配置/etc/ansible/hosts，执行创建即可
# docker exec -it kubeasz sh
```

## 验证

使用容器化安装成功后，可以在 **容器内** 或者 **宿主机** 上执行 kubectl 命令验证集群状态。

## easzup 工具介绍

初始化工具 tools/easzup 主要用于：

- 下载 kubeasz 项目代码/k8s 二进制文件/其他所需二进制文件/离线docker镜像等
- 【可选】容器化运行 kubeasz

详见脚本内容

### 容器化运行 kubeasz

容器启动脚本详见文件 tools/easzup 中函数`start_kubeasz_docker`

``` bash
  docker run --detach \
      --name kubeasz \
      --restart always \
      --env HOST_IP="$host_ip" \
      --volume /etc/ansible:/etc/ansible \
      --volume /root/.kube:/root/.kube \
      --volume /root/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
      --volume /root/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub:ro \
      --volume /root/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
      easzlab/kubeasz:${KUBEASZ_VER}
```

- --env HOST_IP="$host_ip" 传递这个参数是为了快速在本机安装aio集群
- --volume /etc/ansible:/etc/ansible 挂载本地目录，这样可以在宿主机上修改集群配置，然后在容器内执行 ansible 安装
- --volume /root/.kube:/root/.kube 容器内与主机共享 kubeconfig，这样都可以执行 kubectl 命令
- --volume /root/.ssh/id_rsa:/root/.ssh/id_rsa:ro 等三个 volume 挂载保证：如果宿主机配置了免密码登陆所有集群节点，那么容器内也可以免密码登陆所有节点




##

```yml
老版本的kubeasz安装k8s1.11,1.12，镜像启动正常，
但是安装1.13版本，coredns和metrics-server提示ImagePullBackOff，怀疑是镜像版本不对

```

##

```yml
/home/w/SynologyDrive/github/kubernetes/kubeasz/docs/setup/docker_kubeasz.md
/home/w/SynologyDrive/github/kubernetes/kubeasz/docs/setup/easzctl_cmd.md

$ docker pull easzlab/kubeasz:1.2.0
$ docker pull easzlab/kubeasz:1.3.0
$ docker pull easzlab/kubeasz:2.0.0

$ docker pull easzlab/kubeasz-k8s-bin:v1.11.10
$ docker pull easzlab/kubeasz-k8s-bin:v1.12.9
$ docker pull easzlab/kubeasz-k8s-bin:v1.13.7
$ docker pull easzlab/kubeasz-k8s-bin:v1.14.3

$ docker pull easzlab/kubeasz-ext-bin:0.2.0
$ docker pull easzlab/kubeasz-ext-bin:0.3.0


```




### 

```yml




```




### 

```yml




```




### 

```yml




```




### 

```yml




```




### 

```yml




```





