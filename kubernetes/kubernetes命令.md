
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


kubectl completion zsh > "${fpath[1]}/_kubectl"

# 使用浏览器访问前面``kubectl cluster-info ``获取的dashboard地址，最后一条命令获取的token登陆。

admin/test1234



6.安装主要组件
# 安装kubedns，默认已集成安装
#kubectl create -f /etc/ansible/manifests/kubedns
# 安装dashboard，默认已集成安装
#kubectl create -f /etc/ansible/manifests/dashboard

登陆 dashboard可以查看和管理集群，更多内容请查阅dashboard文档


```

### kubernetes帮助

```yml
学会使用帮助

$ kubectl --help

比如命令补全
$ kubectl completion --help

# source <(kubectl completion bash)
# kubectl completion bash > ~/.kube/completion.bash.inc
printf "
source '$HOME/.kube/completion.bash.inc'
" >> $HOME/.bash_profile

生效
# source $HOME/.bash_profile

如果使用zsh，按下列
  # Load the kubectl completion code for zsh[1] into the current shell
  source <(kubectl completion zsh)
  # Set the kubectl completion code for zsh[1] to autoload on startup
  kubectl completion zsh > "${fpath[1]}/_kubectl"

# 注意：Ubuntu使用.bashrc
$ source <(kubectl completion bash)
$ kubectl completion bash > ~/.kube/completion.bash.inc

$ printf "
# Kubectl shell completion
source '$HOME/.kube/completion.bash.inc'
" >> $HOME/.bashrc

$ source $HOME/.bashrc

```

### rancher环境命令

```yml
#使用帮助
$ kubectl --help

#配置本机访问rancher或远程登录
$ ssh-copy-id wym@192.168.113.51
$ ssh wym@192.168.113.51

#相关pods信息
$ kubectl get pods --all-namespaces
$ kubectl get pods -o wide --all-namespaces

$ kubectl get pods -n v8testnamespaces
$ kubectl get pods eureka-5ddbd9d548-mxdvn -n v8testnamespaces
$ kubectl get pods redis-55864f4c67-f82f9 -n v8testnamespaces

#describe 显示一个指定 resource 或者 group 的 resources 详情
$ kubectl describe pods/redis-55864f4c67-f82f9 -n v8testnamespaces
$ kubectl describe pods/eureka-5ddbd9d548-mxdvn -n v8testnamespaces 
$ kubectl describe pod eureka-5ddbd9d548-mxdvn -n v8testnamespaces 同上面的命令一样


$ kubectl get service -n v8testnamespaces
$ kubectl describe service/eureka -n v8testnamespaces
$ kubectl describe service/eureka-nodeport -n v8testnamespaces

$ kubectl get endpoints -n v8testnamespaces

#查看pods
$ kubectl get pods -n v8testnamespaces
NAME                           READY   STATUS              RESTARTS   AGE
auth-5d89877574-d2n4p          1/1     Running             0          45h
centos76test-7cc9d59dc-bkqfq   1/1     Running             0          33d
core-897fc8858-b5zkn           1/1     Running             0          5d7h
eureka-5ddbd9d548-mxdvn        1/1     Running             0          45h
nginx-nfs01-6d695bdc78-qkptb   1/1     Running             0          19d
nginx1159-5df8d55745-p488g     1/1     Running             0          33d
pre-core-6f44bc564-trb6t       1/1     Running             0          45h
redis-55864f4c67-f82f9         1/1     Running             0          63m
redisv8-75fbc88c74-mh5ht       1/1     Running             0          19d
redisv8-cf5755b5f-rlknm        0/1     ContainerCreating   0          19d
tomcat85-759f9bcb57-9bhjt      1/1     Running             0          33d
ykt-ui-656fc77df-m5wpj         1/1     Running             0          45h


#查看日志
$ kubectl logs pods/redis-55864f4c67-f82f9 -n v8testnamespaces
$ kubectl logs pods/core-897fc8858-b5zkn -n v8testnamespaces
$ kubectl logs pods/eureka-5ddbd9d548-mxdvn -n v8testnamespaces
$ kubectl logs pods/ykt-ui-656fc77df-m5wpj -n v8testnamespaces
$ kubectl logs pods/auth-5d89877574-d2n4p -n v8testnamespaces
$ kubectl logs pods/pre-core-6f44bc564-trb6t -n v8testnamespaces
$ kubectl logs pods/ -n v8testnamespaces
$ kubectl logs pods/ -n v8testnamespaces


#进入容器
$ kubectl exec -it redis-55864f4c67-f82f9 -n v8testnamespaces /bin/bash
# redis-cli -h 192.168.113.244 -p 6379 -a dkyw
192.168.113.244:6379> config set requirepass #设置密码
192.168.113.244:6379> config get requirepass #查看密码
192.168.113.244:6379> auth dkyw #验证密码





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

### 

```yml




```




### kubectl帮助

```yml

$ kubectl --help
kubectl controls the Kubernetes cluster manager. 

Find more information at: https://kubernetes.io/docs/reference/kubectl/overview/

Basic Commands (Beginner):
  create         Create a resource from a file or from stdin.
  expose         使用 replication controller, service, deployment 或者 pod 并暴露它作为一个 新的
Kubernetes Service
  run            在集群中运行一个指定的镜像
  set            为 objects 设置一个指定的特征

Basic Commands (Intermediate):
  explain        查看资源的文档
  get            显示一个或更多 resources
  edit           在服务器上编辑一个资源
  delete         Delete resources by filenames, stdin, resources and names, or by resources and label selector

Deploy Commands:
  rollout        Manage the rollout of a resource
  scale          为 Deployment, ReplicaSet, Replication Controller 或者 Job 设置一个新的副本数量
  autoscale      自动调整一个 Deployment, ReplicaSet, 或者 ReplicationController 的副本数量

Cluster Management Commands:
  certificate    修改 certificate 资源.
  cluster-info   显示集群信息
  top            Display Resource (CPU/Memory/Storage) usage.
  cordon         标记 node 为 unschedulable
  uncordon       标记 node 为 schedulable
  drain          Drain node in preparation for maintenance
  taint          更新一个或者多个 node 上的 taints

Troubleshooting and Debugging Commands:
  describe       显示一个指定 resource 或者 group 的 resources 详情
  logs           输出容器在 pod 中的日志
  attach         Attach 到一个运行中的 container
  exec           在一个 container 中执行一个命令
  port-forward   Forward one or more local ports to a pod
  proxy          运行一个 proxy 到 Kubernetes API server
  cp             复制 files 和 directories 到 containers 和从容器中复制 files 和 directories.
  auth           Inspect authorization

Advanced Commands:
  diff           Diff live version against would-be applied version
  apply          通过文件名或标准输入流(stdin)对资源进行配置
  patch          使用 strategic merge patch 更新一个资源的 field(s)
  replace        通过 filename 或者 stdin替换一个资源
  wait           Experimental: Wait for a specific condition on one or many resources.
  convert        在不同的 API versions 转换配置文件

Settings Commands:
  label          更新在这个资源上的 labels
  annotate       更新一个资源的注解
  completion     Output shell completion code for the specified shell (bash or zsh)

Other Commands:
  api-resources  Print the supported API resources on the server
  api-versions   Print the supported API versions on the server, in the form of "group/version"
  config         修改 kubeconfig 文件
  plugin         Provides utilities for interacting with plugins.
  version        输出 client 和 server 的版本信息

Usage:
  kubectl [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).



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




### 阿良运维

```yml
1、创建
# kubectl run nginx --replicas=3 --labels="app=example" --image=192.168.113.38/wymproject/nginx:1.14.2-alpine --port=80

2、查看
# kubectl get deployments
NAME    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx   3         3         3            3           44s

# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-57df7db684-m9qxr   1/1     Running   0          13s
nginx-57df7db684-snw7k   1/1     Running   0          13s
nginx-57df7db684-szvlf   1/1     Running   0          13s

# kubectl get pods --show-labels
# kubectl get pods -l app=example
# kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE     IP            NODE             NOMINATED NODE
nginx-57df7db684-m9qxr   1/1     Running   0          5m31s   172.20.0.15   192.168.113.53   <none>
nginx-57df7db684-snw7k   1/1     Running   0          5m31s   172.20.0.14   192.168.113.53   <none>
nginx-57df7db684-szvlf   1/1     Running   0          5m31s   172.20.0.16   192.168.113.53   <none>

# kubectl get all
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-57df7db684-m9qxr   1/1     Running   0          5m42s
pod/nginx-57df7db684-snw7k   1/1     Running   0          5m42s
pod/nginx-57df7db684-szvlf   1/1     Running   0          5m42s

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes      ClusterIP   10.68.0.1      <none>        443/TCP        9d
service/nginx-service   NodePort    10.68.113.90   <none>        88:36318/TCP   30s

NAME                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   3         3         3            3           5m42s

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-57df7db684   3         3         3       5m42s

# curl 172.20.0.16:80

3、发布
# kubectl expose deployment nginx --port=88 --type=NodePort --target-port=80 --name=nginx-service

# kubectl describe service nginx-service 
Name:                     nginx-service
Namespace:                default
Labels:                   app=example
Annotations:              <none>
Selector:                 app=example
Type:                     NodePort
IP:                       10.68.113.90
Port:                     <unset>  88/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  36318/TCP
Endpoints:                172.20.0.14:80,172.20.0.15:80,172.20.0.16:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

# curl 172.20.0.16:80  # pods间访问
# curl 10.68.113.90:88   # 服务访问
# curl 192.168.113.53:36318  #外部访问

4、故障排查
# kubectl describe TYPE NAME_PREFIX
# kubectl logs nginx-xxx

# kubectl get all
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-57df7db684-m9qxr   1/1     Running   0          13m
pod/nginx-57df7db684-snw7k   1/1     Running   0          13m
pod/nginx-57df7db684-szvlf   1/1     Running   0          13m

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes      ClusterIP   10.68.0.1      <none>        443/TCP        9d
service/nginx-service   NodePort    10.68.113.90   <none>        88:36318/TCP   8m28s

NAME                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   3         3         3            3           13m

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-57df7db684   3         3         3       13m

# kubectl describe pod/nginx-57df7db684-m9qxr
Name:           nginx-57df7db684-m9qxr
Namespace:      default
Node:           192.168.113.53/192.168.113.53
Start Time:     Wed, 26 Jun 2019 14:24:55 +0800
Labels:         app=example
                pod-template-hash=57df7db684
Annotations:    <none>
Status:         Running
IP:             172.20.0.15
Controlled By:  ReplicaSet/nginx-57df7db684
Containers:
  nginx:
    Container ID:   docker://9a93caea450968d978669c7ab8391cd9bc00e6bc5f3a2090738cf6d701650120
    Image:          192.168.113.38/wymproject/nginx:1.14.2-alpine
    Image ID:       docker-pullable://192.168.113.38/wymproject/nginx@sha256:adfd8ccf00554bd6a79abcdf9fee7866f7ac1a9c0473d144615b79eee429864c
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 26 Jun 2019 14:24:58 +0800
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-rrqfc (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-rrqfc:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-rrqfc
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     <none>
Events:
  Type    Reason     Age   From                     Message
  ----    ------     ----  ----                     -------
  Normal  Scheduled  14m   default-scheduler        Successfully assigned default/nginx-57df7db684-m9qxr to 192.168.113.53
  Normal  Pulling    14m   kubelet, 192.168.113.53  pulling image "192.168.113.38/wymproject/nginx:1.14.2-alpine"
  Normal  Pulled     13m   kubelet, 192.168.113.53  Successfully pulled image "192.168.113.38/wymproject/nginx:1.14.2-alpine"
  Normal  Created    13m   kubelet, 192.168.113.53  Created container
  Normal  Started    13m   kubelet, 192.168.113.53  Started container

# kubectl describe service/nginx-service
Name:                     nginx-service
Namespace:                default
Labels:                   app=example
Annotations:              <none>
Selector:                 app=example
Type:                     NodePort
IP:                       10.68.113.90
Port:                     <unset>  88/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  36318/TCP
Endpoints:                172.20.0.14:80,172.20.0.15:80,172.20.0.16:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

# kubectl describe deployment.apps/nginx
Name:                   nginx
Namespace:              default
CreationTimestamp:      Wed, 26 Jun 2019 14:24:55 +0800
Labels:                 app=example
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=example
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=example
  Containers:
   nginx:
    Image:        192.168.113.38/wymproject/nginx:1.14.2-alpine
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-57df7db684 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  16m   deployment-controller  Scaled up replica set nginx-57df7db684 to 3

# kubectl describe replicaset.apps/nginx-57df7db684
Name:           nginx-57df7db684
Namespace:      default
Selector:       app=example,pod-template-hash=57df7db684
Labels:         app=example
                pod-template-hash=57df7db684
Annotations:    deployment.kubernetes.io/desired-replicas: 3
                deployment.kubernetes.io/max-replicas: 4
                deployment.kubernetes.io/revision: 1
Controlled By:  Deployment/nginx
Replicas:       3 current / 3 desired
Pods Status:    3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=example
           pod-template-hash=57df7db684
  Containers:
   nginx:
    Image:        192.168.113.38/wymproject/nginx:1.14.2-alpine
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  17m   replicaset-controller  Created pod: nginx-57df7db684-szvlf
  Normal  SuccessfulCreate  17m   replicaset-controller  Created pod: nginx-57df7db684-snw7k
  Normal  SuccessfulCreate  17m   replicaset-controller  Created pod: nginx-57df7db684-m9qxr


# kubectl logs pod/nginx-57df7db684-m9qxr
172.20.0.1 - - [26/Jun/2019:06:27:35 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
# kubectl logs service/nginx-service
Found 3 pods, using pod/nginx-57df7db684-m9qxr
172.20.0.1 - - [26/Jun/2019:06:27:35 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
# kubectl logs deployment.apps/nginx
Found 3 pods, using pod/nginx-57df7db684-m9qxr
172.20.0.1 - - [26/Jun/2019:06:27:35 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
# kubectl logs replicaset.apps/nginx-57df7db684
Found 3 pods, using pod/nginx-57df7db684-m9qxr
172.20.0.1 - - [26/Jun/2019:06:27:35 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"


5、更新
# kubectl set image deployment/nginx nginx=192.168.113.38/wymproject/nginx:1.14.2
# kubectl set image deployment/nginx nginx=192.168.113.38/wymproject/nginx:1.15.9
# kubectl set image deployment/nginx nginx=192.168.113.38/wymproject/nginx:1.15.9-alpine
or
# kubectl edit deployment/nginx  #打开配置文件，vi编辑保存即可

# kubectl get pods
NAME                         READY   STATUS        RESTARTS   AGE
pod/nginx-57df7db684-m9qxr   0/1     Terminating   0          21m
pod/nginx-57df7db684-snw7k   0/1     Terminating   0          21m
pod/nginx-57df7db684-szvlf   0/1     Terminating   0          21m
pod/nginx-68d5c569c6-4nv5c   1/1     Running       0          6s
pod/nginx-68d5c569c6-bhtmv   1/1     Running       0          10s
pod/nginx-68d5c569c6-n4d7c   1/1     Running       0          5s



资源发布管理
# kubectl rollout status deployment.apps/nginx
# kubectl rollout history deployment.apps/nginx
# kubectl rollout history deployment.apps/nginx --revision=3  #查看版本3的信息

# kubectl scale deployment nginx --replicas=5



6、回滚
# kubectl rollout undo deployment.apps/nginx
# kubectl rollout undo deployment.apps/nginx --to-revision=3

# kubectl get pods
# kubectl describe nginx-7f454bcb6-2pxss

7、删除
# kubectl delete/nginx 
# kubectl delete/nginx-service


```




### Kubernetes 的奇技淫巧

```yml
https://mp.weixin.qq.com/s?__biz=MzU1MzY4NzQ1OA==&mid=2247484203&idx=1&sn=97078722f7f9929afe5258d455c78a76&chksm=fbee43e6cc99caf00e48c3c048ba1542721648dea8141c647d32d0b4777eadcbd28d5b23f27e&mpshare=1&scene=1&srcid=&pass_ticket=z6LouKF7qfLqYVrhtkindKj6cCo%2ByhpVOgiEgEzKMVQ7%2FHSHlqOKeMoE03rMxV4j#rd
Kubernetes 的奇技淫巧
原创： 米开朗基杨  云原生实验室  昨天
引导关注
前言

Kubernetes 作为云原生时代的“操作系统”，熟悉和使用它是每名用户（User）的必备技能。如果你正在 Kubernetes 上工作，你需要正确的工具和技巧来确保 Kubernetes 集群的高可用以及工作负载的稳定运行。

随着 Kubernetes 的发展和演变，人们可以从内部来驯服它的无节制行为。但有些人并不情愿干等 Kubernetes 变得易于使用，并且为已投入生产的 Kubernetes 中遇到的很多常见问题制定了自己的解决方案。

这里我们将介绍一些提高操作效率的技巧，同时列举几个比较有用的开源 Kubernetes 工具，这些工具以各种方式简化 Kubernetes，包括简化命令行交互，简化应用程序部署语法等。

kubectl 自动补全

kubectl 这个命令行工具非常重要，与之相关的命令也很多，我们也记不住那么多的命令，而且也会经常写错，所以命令自动补全是很有必要的，kubectl 工具本身就支持自动补全，只需简单设置一下即可。

1 bash 用户

大多数用户的 shell 使用的是 bash，Linux 系统可以通过下面的命令来设置：

$ echo "source <(kubectl completion bash)" >> ~/.bashrc
$ source ~/.bashrc
如果发现不能自动补全，可以尝试安装 bash-completion 然后刷新即可！

2 zsh 用户

如果你使用的 shell 是 zsh，可以通过下面的命令来设置：

$ echo "source <(kubectl completion zsh)" >> ~/.zshrc
$ source ~/.zshrc

自定义 kubectl get 输出

kubectl get 相关资源，默认输出为 kubectl 内置，一般我们也可以使用 -o json 或者 -o yaml 查看其完整的资源信息。但是很多时候，我们需要关心的信息并不全面，因此我们需要自定义输出的列，那么可以使用 go-template 来进行实现。

go-template 是 golang 的一种模板，可以参考 template 的相关说明。

比如仅仅想要查看获取的 pods 中的各个 pod 的 uid，则可以使用以下命令：

$ kubectl get pods --all-namespaces -o go-template='{{range .items}}{{.metadata.uid}}
{{end}}'

2ea418d4-533e-11e8-b722-005056a1bc83
7178b8bf-4e93-11e8-8175-005056a1bc83
a0341475-5338-11e8-b722-005056a1bc83
...

因为 get pods 的返回结果是 List 类型，获取的 pods 都在 items 这个的 value 中，因此需要遍历 items，也就有了 {{range .items}}。而后通过模板选定需要展示的内容，就是 items 中的每个 {{.metadata.uid}}。

这里特别注意，要做一个特别的处理，就是要把 {{end}} 前进行换行，以便在模板中插入换行符。

当然，如果觉得这样处理不优雅的话，也可以使用 printf 函数，在其中使用 \n 即可实现换行符的插入。

$ kubectl get pods --all-namespaces -o go-template --template='{{range .items}}{{printf "%s\n" .metadata.uid}}{{end}}'
或者可以这样：

$ kubectl get pods --all-namespaces -o go-template --template='{{range .items}}{{.metadata.uid}}{{"\n"}}{{end}}'
其实有了 printf，就可以很容易的实现对应字段的输出，且样式可以进行自己控制。比如可以这样

$ kubectl get pods --all-namespaces -o go-template --template='{{range .items}}{{printf "|%-20s|%-50s|%-30s|\n" .metadata.namespace .metadata.name .metadata.uid}}{{end}}'

|default             |details-v1-64b86cd49-85vks                        |2e7a2a66-533e-11e8-b722-005056a1bc83|
|default             |productpage-v1-84f77f8747-7tkwb                   |2eb4e840-533e-11e8-b722-005056a1bc83|
|default             |ratings-v1-5f46655b57-qlrxp                       |2e89f981-533e-11e8-b722-005056a1bc83|
...
下面举两个 go-template 高级用法的例子：

range 嵌套

# 列出所有容器使用的镜像名
$ kubectl get pods --all-namespaces -o go-template --template='{{range .items}}{{range .spec.containers}}{{printf "%s\n" .image}}{{end}}{{end}}'

istio/examples-bookinfo-details-v1:1.5.0
istio/examples-bookinfo-productpage-v1:1.5.0
istio/examples-bookinfo-ratings-v1:1.5.0
...
条件判断

# 列出所有不可调度节点的节点名与 IP
$ kubectl get no -o go-template='{{range .items}}{{if .spec.unschedulable}}{{.metadata.name}} {{.spec.externalID}}{{"\n"}}{{end}}{{end}}'

除了使用 go-template 之外，还可以使用逗号分隔的自定义列列表打印表格：

$ kubectl -n kube-system get pods coredns-64b597b598-7547d -o custom-columns=NAME:.metadata.name,hostip:.status.hostIP

NAME                       hostip
coredns-64b597b598-7547d   192.168.123.250

也可以使用 go-template-file 自定义模板列表，模板不用通过参数传进去，而是写成一个文件，然后需要指定 template 指向该文件即可。

$ cat > test.tmpl << EOF 
NAME                      HOSTIP
metadata.name       status.hostIP
EOF

$ kubectl -n kube-system get pods coredns-64b597b598-7547d -o custom-columns-file=test.tmpl

NAME                       HOSTIP
coredns-64b597b598-7547d   192.168.123.250

交互式 Kubernetes 客户端

Kube-prompt 可以让你在 Kubernetes 客户端输入相当于交互式命令会话的东西，并为每个命令提供自动填充的背景信息，你不必键入 kubectl 来为每个命令添加前缀。

生成 kubectl 别名

如果你需要频繁地使用 kubectl 和 kubernetes api 进行交互，使用别名将会为你节省大量的时间，开源项目 kubectl-aliases 可以通过编程的方式生成 kubectl 别名，别名生成规则如下：


简单别名示例

kd → kubectl describe

高级别名示例

kgdepallw → kubectl get deployment --all-namespaces --watch

校验配置文件


如果你手动写 Kubernetes manifest 文件，检查 manifest 文件的语法是很困难的，特别是当你有多个不同版本的 Kubernetes 集群时，确认配置文件语法是否正确更是难上加难。

Kubeval 是一个用于校验Kubernetes YAML或JSON配置文件的工具，支持多个Kubernetes版本，可以帮助我们解决不少的麻烦。

使用示例

$ kubeval nginx.yaml

The document nginx.yaml contains an invalid Deployment
---> spec.replicas: Invalid type. Expected: integer, given: string
简化 Kubernetes 部署定义


很多人都抱怨 Kubernetes manifest 文件的定义太复杂和冗长。它们很难写，而且很难维护，如果能够简化部署定义就会极大地降低维护难度。

Kedge 提供更简单、更简洁的语法，然后 kedge 将其转换为 Kubernetes manifest 文件。

使用示例

参考

为高效 Ops 和 SRE 团队准备的 10 个开源 k8s 工具

打造高效的 Kubernetes 命令行终端

推荐阅读
kubectl 创建 Pod 背后到底发生了什么？

Kubernetes Pod 驱逐详解

Kubernetes 内存资源限制实战


```


## k8s工具

### kube-prompt

```yml

https://github.com/c-bata/kube-prompt

wget https://github.com/c-bata/kube-prompt/releases/download/v1.0.6/kube-prompt_v1.0.6_linux_amd64.zip
unzip kube-prompt_v1.0.6_linux_amd64.zip
chmod +x kube-prompt
sudo mv ./kube-prompt /usr/local/bin/kube-prompt

Goal
Hopefully support following commands enough to operate kubernetes.

 get Display one or many resources
 describe Show details of a specific resource or group of resources
 create Create a resource by filename or stdin
 replace Replace a resource by filename or stdin.
 patch Update field(s) of a resource using strategic merge patch.
 delete Delete resources by filenames, stdin, resources and names, or by resources and label selector.
 edit Edit a resource on the server
 apply Apply a configuration to a resource by filename or stdin
 namespace SUPERSEDED: Set and view the current Kubernetes namespace
 logs Print the logs for a container in a pod.
 rolling-update Perform a rolling update of the given ReplicationController.
 scale Set a new size for a Deployment, ReplicaSet, Replication Controller, or Job.
 cordon Mark node as unschedulable
 drain Drain node in preparation for maintenance
 uncordon Mark node as schedulable
 attach Attach to a running container.
 exec Execute a command in a container.
 port-forward Forward one or more local ports to a pod.
 proxy Run a proxy to the Kubernetes API server
 run Run a particular image on the cluster.
 expose Take a replication controller, service, or pod and expose it as a new Kubernetes Service
 autoscale Auto-scale a Deployment, ReplicaSet, or ReplicationController
 rollout rollout manages a deployment
 label Update the labels on a resource
 annotate Update the annotations on a resource
 config config modifies kubeconfig files
 cluster-info Display cluster info
 api-versions Print the supported API versions on the server, in the form of "group/version".
 version Print the client and server version information.
 explain Documentation of resources.
 convert Convert config files between different API versions
 top Display Resource (CPU/Memory/Storage) usage

```



### k9s

```yml
https://github.com/derailed/k9s

K9s - Kubernetes CLI管理你的风格集群！

K9s提供了一个基于curses的终端UI，可与您的Kubernetes集群进行交互。该项目的目的是使您可以更轻松地在野外导航，观察和管理您的应用程序。K9s不断观察Kubernetes的变化，并提供后续命令与观察到的Kubernetes资源进行交互。

wget https://github.com/derailed/k9s/releases/download/0.7.11/k9s_0.7.11_Linux_x86_64.tar.gz

$ tar -zxvf k9s_0.7.11_Linux_x86_64.tar.gz 
sudo mv ./kube-prompt /usr/local/bin/kube-prompt


关键绑定
K9s使用别名来导航大多数K8资源。

命令	结果	例
:别号<ENTER>	查看Kubernetes资源别名	:po<ENTER>
?	显示键盘快捷键和帮助	
Ctrl-a	显示所有可用的资源别名	选择+ <ENTER>查看
/过滤ENTER	在给定过滤器的情况下过滤出资源视图	/bumblebeetuna
/-l label-selectorENTER	按标签过滤资源视图	/-l app=fred
<Esc>	退出命令模式	
d，v，e，l，...	用于描述，查看，编辑，查看日志的键映射，......	d （描述资源）
:CTX<ENTER>	查看并切换到另一个Kubernetes上下文	:+ ctx+<ENTER>
:q， Ctrl-c	摆脱K9s


k9s -h

$ k9s -n v8testnamespaces  #k8s命名空间
$ k9s -n kube-system
$ k9s -n default


Context: v8test                     <0> all              <ctrl-d>  Dele ____  __.________        
Cluster: v8test                     <1> kube-system      <d>       Desc|    |/ _/   __   \______ 
User:    user-ntz8b                 <2> v8testnamesp…    <e>       Edit|      < \____    /  ___/ 
K9s Rev: 0.7.11                     <3> default          <l>       Logs|    |  \   /    /\___ \  
K8s Rev: v1.13.5                                         <shift-l> Logs|____|__ \ /____//____  > 
CPU:     27%                                             <ctrl-s>  Save        \/            \/  
MEM:     57%                                             <s>       Shel  





The Command Line
# List all available CLI options
k9s -h
# To get info about K9s runtime (logs, configs, etc..)
k9s info
# To run K9s in a given namespace
k9s -n mycoolns
# Start K9s in an existing KubeConfig context
k9s --context coolCtx
PreFlight Checks
K9s uses 256 colors terminal mode. On `Nix system make sure TERM is set accordingly.

export TERM=xterm-256color
K9s config file ($HOME/.k9s/config.yml)
K9s keeps its configurations in a dot file in your home directory.

NOTE: This is still in flux and will change while in pre-release stage!

k9s:
  # Indicates api-server poll intervals.
  refreshRate: 2
  # Indicates log view maximum buffer size. Default 1k lines.
  logBufferSize: 200
  # Indicates how many lines of logs to retrieve from the api-server. Default 200 lines.
  logRequestSize: 200
  # Indicates the current kube context. Defaults to current context
  currentContext: minikube
  # Indicates the current kube cluster. Defaults to current context cluster
  currentCluster: minikube
  # Persists per cluster preferences for favorite namespaces and view.
  clusters:
    cooln:
      namespace:
        active: coolio
        favorites:
        - cassandra
        - default
      view:
        active: po
    minikube:
      namespace:
        active: all
        favorites:
        - all
        - kube-system
        - default
      view:
        active: dp



```


### lazydocker

```yml
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
或
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.3/lazydocker_0.3_Linux_x86_64.tar.gz

之后直接解压执行就好

tar -zxvf lazydocker_0.2.4_Linux_x86_64.tar.gz

./lazydocker



lazydocker，一个简单的 docker 和 docker-compose 终端用户界面，用更懒惰的方式来管理所有的 docker

https://gitee.com/mirrors/lazydocker
https://github.com/jesseduffield/lazydocker/releases

curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

Usage
Call lazydocker in your terminal. I personally use this a lot so I've made an alias for it like so:

echo "alias lzd='lazydocker'" >> ~/.zshrc
(you can substitute .zshrc for whatever rc file you're using)



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


### 

```yml




```


### 

```yml




```



### 基础环境准备

```yml

改主机名
# hostnamectl set-hostname kubeasz171.example.com

改IP
# vi /etc/sysconfig/network-scripts/ifcfg-ens33


改网卡名称为eth0

修改centos7虚拟机的网卡名称为eth0
# cd /etc/sysconfig/network-scripts/
# mv ifcfg-ens33 ifcfg-eth0
# vi /etc/sysconfig/network-scripts/ifcfg-eth0
NAME="eth0"
DEVICE="eth0"

修改grub文件  在GRUB_CMDLINE_LINUX原有的参数后面加上"net.ifnames=0 biosdevname=0"
# vi /etc/default/grub
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet net.ifnames=0 biosdevname=0"

# grub2-mkconfig -o /boot/grub2/grub.cfg
# reboot

防火墙和selinux
# systemctl stop firewalld && systemctl disable firewalld.service && systemctl status firewalld
# systemctl stop NetworkManager && systemctl disable NetworkManager && systemctl status NetworkManager
# setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/selinux/config 


阿里源
# mkdir -p /etc/yum.repos.d/repobak && mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo


```



## kubeasz-总结

```bash

总结：
1、最小化安装的centos系统，可以上网
2、下载easzup，./easzup -D开始下载所有安装文件（安装docker，下载kubeasz镜像、下载k8s安装包）
3、执行成功后，所有文件均已整理好放入目录`/etc/ansilbe`，只要把该目录整体复制到任何离线的机器上，即可开始安装集群
4、设置参数启用离线安装
# cd /etc/ansible
# sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/chrony/defaults/main.yml
# sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/ex-lb/defaults/main.yml
# sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/kube-node/defaults/main.yml
# sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/prepare/defaults/main.yml
5、配置免密登录
6、离线服务器执行 # ./easzup -S
7、可以先添加镜像仓库方便做实验 # systemctl daemon-reload && systemctl restart docker
8、使用默认配置安装 aio 集群 # docker exec -it kubeasz easzctl start-aio


##########################################
备注：
# cat /etc/docker/daemon.json 
{
  "registry-mirrors": [
    "https://dockerhub.azk8s.cn",
    "https://docker.mirrors.ustc.edu.cn",
    "http://hub-mirror.c.163.com"
  ],
  "insecure-registries": [
    "http://192.168.113.38",
    "http://192.168.113.37:8001",
    "0.0.0.0/0"
  ],
  "max-concurrent-downloads": 10,
  "log-driver": "json-file",
  "log-level": "warn",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
    },
  "data-root": "/var/lib/docker"
}

# ./easzup 
Usage: easzup [options] [args]
  option: -{DdekSz}
    -C         stop&clean all local containers
    -D         download all into /etc/ansible
    -S         start kubeasz in a container
    -d <ver>   set docker-ce version, default "18.09.8"
    -e <ver>   set kubeasz-ext-bin version, default "0.3.0"
    -k <ver>   set kubeasz-k8s-bin version, default "v1.15.2"
    -m <str>   set docker registry mirrors, default "CN"(used in Mainland,China)
    -p <ver>   set kubeasz-sys-pkg version, default "0.3.2"
    -z <ver>   set kubeasz version, default "2.0.3"
  
see more at https://github.com/kubeasz/dockerfiles

# ./easzctl 
Usage: easzctl COMMAND [args]

Cluster-wide operation:
    checkout		To switch to context <clustername>, or create it if not existed
    destroy		To destroy the current cluster, '--purge' to also delete the context
    list		To list all of clusters managed
    setup		To setup a cluster using the current context
    start-aio		To quickly setup an all-in-one cluster for testing (like minikube)

In-cluster operation:
    add-etcd		To add a etcd-node to the etcd cluster
    add-master		To add a kube-master(master node) to the k8s cluster
    add-node		To add a kube-node(work node) to the k8s cluster
    del-etcd		To delete a etcd-node from the etcd cluster
    del-master		To delete a kube-master from the k8s cluster
    del-node		To delete a kube-node from the k8s cluster
    upgrade		To upgrade the k8s cluster

Extra operation:
    basic-auth   	To enable/disable basic-auth for apiserver

Use "easzctl help <command>" for more information about a given command.


```



## kubeasz-allinone安装

```bash

github/kubernetes/kubeasz/docs/setup/quickStart.md


3.配置 ssh 免密登陆

ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa
ssh-copy-id $IP  # $IP 为所有节点地址包括自身，按照提示输入 yes 和 root 密码

- 4.1 容器化运行 kubeasz，详见[文档](docker_kubeasz.md)
# ./easzup -S

- 4.2 使用默认配置安装 aio 集群

# docker exec -it kubeasz easzctl start-aio

5.验证安装

如果提示kubectl: command not found，退出重新ssh登陆一下，环境变量生效即可

$ kubectl version                   # 验证集群版本     
$ kubectl get componentstatus       # 验证 scheduler/controller-manager/etcd等组件状态
$ kubectl get node                  # 验证节点就绪 (Ready) 状态
$ kubectl get pod --all-namespaces  # 验证集群pod状态，默认已安装网络插件、coredns、metrics-server等
$ kubectl get svc --all-namespaces  # 验证集群服务状态





```



### kubeasz-offline_install

```bash

/home/w/SynologyDrive/github/kubernetes/kubeasz/docs/setup/offline_install.md

# 离线安装集群

kubeasz 2.0.1 开始支持**完全离线安装**，目前已测试 `Ubuntu1604|1804` `CentOS7` `Debian9|10` 系统。

## 离线文件准备

在一台能够访问互联网的服务器上执行：

# 下载工具脚本easzup，举例使用kubeasz版本2.0.2
export release=2.0.2
curl -C- -fLO --retry 3 https://github.com/easzlab/kubeasz/releases/download/${release}/easzup
chmod +x ./easzup
# 使用工具脚本下载
./easzup -D

执行成功后，所有文件均已整理好放入目录`/etc/ansilbe`，只要把该目录整体复制到任何离线的机器上，即可开始安装集群，离线文件包括：

- kubeasz 项目代码 --> /etc/ansible
- kubernetes 集群组件二进制 --> /etc/ansible/bin
- 其他集群组件二进制（etcd/CNI等）--> /etc/ansible/bin
- 操作系统基础依赖软件包（haproxy/ipvsadm/ipset/socat等）--> /etc/ansible/down/packages
- 集群基本插件镜像（coredns/dashboard/metrics-server等）--> /etc/ansible/down

离线文件不包括：

- 管理端 ansible 安装，但可以使用 kubeasz 容器运行 ansible 脚本
- 其他更多 kubernetes 插件镜像

## 离线安装

上述下载完成后，把`/etc/ansible`整个目录复制到目标离线服务器，然后在离线服务器上运行：

# 离线安装 docker，检查本地文件等
$ ./easzup -D

# 启动 kubeasz 容器
$ ./easzup -S

# 进入容器
$ docker exec -it kubeasz sh

# 设置参数启用离线安装
$ cd /etc/ansible
$ sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/chrony/defaults/main.yml
$ sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/ex-lb/defaults/main.yml
$ sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/kube-node/defaults/main.yml
$ sed -i 's/^INSTALL_SOURCE.*$/INSTALL_SOURCE: "offline"/g' roles/prepare/defaults/main.yml

# 按照文档 https://github.com/easzlab/kubeasz/blob/master/docs/setup/00-planning_and_overall_intro.md 集群规划后安装
$ ansible-playbook 90.setup.yml


```



### kubeasz下载日志

```yml

[root@kubeasz170 ~]# ./easzup -h
./easzup: 非法选项 -- h
Usage: easzup [options] [args]
  option: -{DdekSz}
    -C         stop&clean all local containers
    -D         download all into /etc/ansible
    -S         start kubeasz in a container
    -d <ver>   set docker-ce version, default "18.09.8"
    -e <ver>   set kubeasz-ext-bin version, default "0.3.0"
    -k <ver>   set kubeasz-k8s-bin version, default "v1.15.2"
    -m <str>   set docker registry mirrors, default "CN"(used in Mainland,China)
    -p <ver>   set kubeasz-sys-pkg version, default "0.3.2"
    -z <ver>   set kubeasz version, default "2.0.3"
  
see more at https://github.com/kubeasz/dockerfiles
[root@kubeasz170 ~]# ./easzup -D
[INFO] Action begin : download_all
Unit docker.service could not be found.
Unit containerd.service could not be found.
[INFO] downloading docker binaries 18.09.8
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 45.8M  100 45.8M    0     0   259k      0  0:03:01  0:03:01 --:--:--  312k
[INFO] generate docker service file
[INFO] generate docker config file
[INFO] prepare register mirror for CN
[INFO] turn off selinux in CentOS/Redhat
setenforce: SELinux is disabled
[INFO] enable and start docker
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /etc/systemd/system/docker.service.
[INFO] downloading kubeasz 2.0.3
[INFO] run a temporary container
Unable to find image 'easzlab/kubeasz:2.0.3' locally
2.0.3: Pulling from easzlab/kubeasz
e7c96db7181b: Pull complete 
116b16256f3f: Pull complete 
Digest: sha256:24a672bced557482699f9ce840c23ec46bbf269dca2e862ebc678d5038ece0f4
Status: Downloaded newer image for easzlab/kubeasz:2.0.3
3683f2cdd41def2692139d3e065383c782884c2abff4f55b44c1543674caf955
[INFO] cp kubeasz code from the temporary container
[INFO] stop&remove temporary container
temp_easz
[INFO] downloading kubernetes v1.15.2 binaries
v1.15.2: Pulling from easzlab/kubeasz-k8s-bin
e7c96db7181b: Already exists 
2baca36b775d: Pull complete 
Digest: sha256:e2c04f57fc3d27b0bb99ef5b316b308647520b2dc22bd1804ddae5470912466e
Status: Downloaded newer image for easzlab/kubeasz-k8s-bin:v1.15.2
[INFO] run a temporary container
9374967e308364f2a0643f1e5bc1a96c80a21138ffd53e4ceef14ce2a1d23be6
[INFO] cp k8s binaries
[INFO] stop&remove temporary container
temp_k8s_bin
[INFO] downloading extral binaries kubeasz-ext-bin:0.3.0
0.3.0: Pulling from easzlab/kubeasz-ext-bin
e7c96db7181b: Already exists 
fc74181adce3: Pull complete 
Digest: sha256:75c5955010408d73dcbc2548efbf8287ffc09756c013baca259fc7dddb434adf
Status: Downloaded newer image for easzlab/kubeasz-ext-bin:0.3.0
[INFO] run a temporary container
ae2064295434ce166812c070d4ca9c5f2431e95cb06365cea597e358a37197d4
[INFO] cp extral binaries
[INFO] stop&remove temporary container
temp_ext_bin
[INFO] downloading system packages kubeasz-sys-pkg:0.3.2
0.3.2: Pulling from easzlab/kubeasz-sys-pkg
e7c96db7181b: Already exists 
a5379a6b9b05: Pull complete 
4b9478026435: Pull complete 
e1bee6f2e3f0: Pull complete 
1609737ab51c: Pull complete 
1f0181455391: Pull complete 
Digest: sha256:283b47c6b0af8530d4bfe1aaf25e9880020b0c6ea97a4bcc6628f66aa5658bac
Status: Downloaded newer image for easzlab/kubeasz-sys-pkg:0.3.2
[INFO] run a temporary container
48f8bb25b9e030c9e38f5e6e6bd498ace9862c4a704a0caab52b141a88b8254d
[INFO] cp system packages
[INFO] stop&remove temporary container
temp_sys_pkg
[INFO] downloading offline images
v3.4.4: Pulling from calico/cni
c87736221ed0: Pull complete 
5c9ca5efd0e4: Pull complete 
208ecfdac035: Pull complete 
4112fed29204: Pull complete 
Digest: sha256:bede24ded913fb9f273c8392cafc19ac37d905017e13255608133ceeabed72a1
Status: Downloaded newer image for calico/cni:v3.4.4
v3.4.4: Pulling from calico/kube-controllers
c87736221ed0: Already exists 
e90e29149864: Pull complete 
5d1329dbb1d1: Pull complete 
Digest: sha256:b2370a898db0ceafaa4f0b8ddd912102632b856cc010bb350701828a8df27775
Status: Downloaded newer image for calico/kube-controllers:v3.4.4
v3.4.4: Pulling from calico/node
c87736221ed0: Already exists 
07330e865cef: Pull complete 
d4d8bb3c8ac5: Pull complete 
870dc1a5d2d5: Pull complete 
af40827f5487: Pull complete 
76fa1069853f: Pull complete 
Digest: sha256:1582527b4923ffe8297d12957670bc64bb4f324517f57e4fece3f6289d0eb6a1
Status: Downloaded newer image for calico/node:v3.4.4
1.5.0: Pulling from coredns/coredns
e0daa8927b68: Pull complete 
10ff8df5aaa5: Pull complete 
Digest: sha256:e83beb5e43f8513fa735e77ffc5859640baea30a882a11cc75c4c3244a737d3c
Status: Downloaded newer image for coredns/coredns:1.5.0
v1.10.1: Pulling from mirrorgooglecontainers/kubernetes-dashboard-amd64
63926ce158a6: Pull complete 
Digest: sha256:d6b4e5d77c1cdcb54cd5697a9fe164bc08581a7020d6463986fe1366d36060e8
Status: Downloaded newer image for mirrorgooglecontainers/kubernetes-dashboard-amd64:v1.10.1
v0.11.0-amd64: Pulling from easzlab/flannel
cd784148e348: Pull complete 
04ac94e9255c: Pull complete 
e10b013543eb: Pull complete 
005e31e443b1: Pull complete 
74f794f05817: Pull complete 
Digest: sha256:bd76b84c74ad70368a2341c2402841b75950df881388e43fc2aca000c546653a
Status: Downloaded newer image for easzlab/flannel:v0.11.0-amd64
v1.5.4: Pulling from mirrorgooglecontainers/heapster-amd64
b8f516daaab1: Pull complete 
684442675e9a: Pull complete 
Digest: sha256:3a9d4e2f6d8ee30602bb273b569a5d54e01cce4df152096d150913bc1b9e4968
Status: Downloaded newer image for mirrorgooglecontainers/heapster-amd64:v1.5.4
v0.3.3: Pulling from mirrorgooglecontainers/metrics-server-amd64
9fed77bd433c: Pull complete 
454ba71109e2: Pull complete 
Digest: sha256:3f2674fbad065f60044b3601ac0564c24447f0ddfa28fe2bdd467218ce359ea9
Status: Downloaded newer image for mirrorgooglecontainers/metrics-server-amd64:v0.3.3
3.1: Pulling from mirrorgooglecontainers/pause-amd64
67ddbfb20a22: Pull complete 
Digest: sha256:59eec8837a4d942cc19a52b8c09ea75121acc38114a2c68b98983ce9356b8610
Status: Downloaded newer image for mirrorgooglecontainers/pause-amd64:3.1
v1.7.12: Pulling from library/traefik
d572f7c8e983: Pull complete 
d62b0f6adf29: Pull complete 
Digest: sha256:02cfdb77b0cd82d973dffb3dafe498283f82399bd75b335797d7f0fe3ebeccb8
Status: Downloaded newer image for traefik:v1.7.12
2.0.3: Pulling from easzlab/kubeasz
Digest: sha256:24a672bced557482699f9ce840c23ec46bbf269dca2e862ebc678d5038ece0f4
Status: Image is up to date for easzlab/kubeasz:2.0.3
[INFO] Action successed : download_all
[root@kubeasz170 ~]# 



```


#### 容器化运行 kubeasz

```bash
- 1.准备一台全新虚机（ansible控制端）

$ wget https://github.com/easzlab/kubeasz/releases/download/1.3.0/easzup
$ chmod +x ./easzup
$ ./easzup -D

- 2.配置 ssh 密钥登陆集群节点

ssh-keygen -t rsa -b 2048 回车 回车 回车
ssh-copy-id $IP  # $IP 为所有节点地址包括自身，按照提示输入 yes 和 root 密码

- 3.容器化运行 kubeasz，然后执行安装 k8s 集群（举例aio集群）


$ ./easzup -S
$ docker exec -it kubeasz easzctl start-aio
# 若需要自定义集群创建，如下进入容器，然后配置/etc/ansible/hosts，执行创建即可
# docker exec -it kubeasz sh


#### 验证

使用容器化安装成功后，可以在 **容器内** 或者 **宿主机** 上执行 kubectl 命令验证集群状态。

#### easzup 工具介绍

初始化工具 tools/easzup 主要用于：

- 下载 kubeasz 项目代码/k8s 二进制文件/其他所需二进制文件/离线docker镜像等
- 【可选】容器化运行 kubeasz

详见脚本内容

#### 容器化运行 kubeasz

容器启动脚本详见文件 tools/easzup 中函数`start_kubeasz_docker`

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


- --env HOST_IP="$host_ip" 传递这个参数是为了快速在本机安装aio集群
- --volume /etc/ansible:/etc/ansible 挂载本地目录，这样可以在宿主机上修改集群配置，然后在容器内执行 ansible 安装
- --volume /root/.kube:/root/.kube 容器内与主机共享 kubeconfig，这样都可以执行 kubectl 命令
- --volume /root/.ssh/id_rsa:/root/.ssh/id_rsa:ro 等三个 volume 挂载保证：如果宿主机配置了免密码登陆所有集群节点，那么容器内也可以免密码登陆所有节点



老版本的kubeasz安装k8s1.11,1.12，镜像启动正常，
但是安装1.13版本，coredns和metrics-server提示ImagePullBackOff，怀疑是镜像版本不对

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


### 

```yml




```
