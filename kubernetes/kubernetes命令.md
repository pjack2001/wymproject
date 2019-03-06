


## 常用命令 

```
kubectl version
kubectl cluster-info
kubectl top node
kubectl get nodes


```





### 

```

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

```ruby

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










```

### 

```




```

### 

```




```

### 

```




```

### 

```




```





