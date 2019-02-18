# 使用Vagrant和VirtualBox在本地搭建分布式的Kubernetes集群和Istio Service Mesh

https://github.com/rootsongjc/kubernetes-vagrant-centos-cluster/blob/master/README-cn.md

https://storage.googleapis.com/kubernetes-release/release/v1.13.1/kubernetes-server-linux-amd64.tar.gz


## 安装准备

### 1、克隆git项目


git clone https://github.com/rootsongjc/kubernetes-vagrant-centos-cluster.git
cd kubernetes-vagrant-centos-cluster


```

# w @ uw in ~/tool/vagrant/kubernetes-vagrant-centos-cluster on git:master o [9:35:26] 
$ du -sbh *
528K	addon
34K	conf
6.2K	hack
52M	images
6.3K	install.sh
169	ISSUE_TEMPLATE.md
12K	LICENSE
5.3K	node1
5.4K	node2
5.3K	node3
29K	pki
15K	README-cn.md
15K	README.md
6.8K	systemd
920	Vagrantfile
15K	yaml
5.6K	yum

```

### 2、下载kubernetes
https://storage.googleapis.com/kubernetes-release/release/v1.11.0/kubernetes-server-linux-amd64.tar.gz

https://storage.googleapis.com/kubernetes-release/release/v1.13.1/kubernetes-server-linux-amd64.tar.gz

注意：如果您是第一次运行该部署程序，那么可以直接执行下面的命令vagrant up，它将自动帮你下载 Kubernetes 安装包，下一次你就不需要自己下载了，另外您也可以在这里找到Kubernetes的发行版下载地址，下载 Kubernetes发行版后重命名为kubernetes-server-linux-amd64.tar.gz，并移动到该项目的根目录下。

### 3、安装NFS服务

Ubuntu：sudo apt install nfs-kernel-server

CentOS：yum install -y nfs-utils
```
使用说明

因为该项目是使用 NFS 的方式挂载到虚拟机的 /vagrant 目录中的，所以在安装 NFS 的时候需要您输入密码授权。







```

## 安装教程

``` python
使用Vagrant和VirtualBox在本地搭建分布式的Kubernetes集群和Istio Service Mesh
Setting up a Kubernetes cluster along with Istio service mesh locally with Vagrant and VirtualBox - English

当我们需要在本地开发时，更希望能够有一个开箱即用又可以方便定制的分布式开发环境，这样才能对Kubernetes本身和应用进行更好的测试。现在我们使用Vagrant和VirtualBox来创建一个这样的环境。

注意：因为使用虚拟机创建分布式Kubernetes集群比较耗费资源，所以我又仅使用Docker创建Standalone的Kubernetes的轻量级Cloud Native Sandbox。

Demo
点击下面的图片观看视频。

观看视频

准备环境
需要准备以下软件和环境：

8G以上内存
Vagrant 2.0+
VirtualBox 5.0 +
提前下载Kubernetes 1.9以上版本（支持最新的1.13.0）的release压缩包
Mac/Linux，Windows不完全支持，仅在windows10下通过
集群
我们使用Vagrant和Virtualbox安装包含3个节点的kubernetes集群，其中master节点同时作为node节点。

IP	主机名	组件
172.17.8.101	node1	kube-apiserver、kube-controller-manager、kube-scheduler、etcd、kubelet、docker、flannel、dashboard
172.17.8.102	node2	kubelet、docker、flannel、traefik
172.17.8.103	node3	kubelet、docker、flannel
注意：以上的IP、主机名和组件都是固定在这些节点的，即使销毁后下次使用vagrant重建依然保持不变。

容器IP范围：172.33.0.0/30

Kubernetes service IP范围：10.254.0.0/16

安装的组件
安装完成后的集群包含以下组件：

flannel（host-gw模式）
kubernetes dashboard
etcd（单节点）
kubectl
CoreDNS
kubernetes（版本根据下载的kubernetes安装包而定，支持Kubernetes1.9+）
可选插件

Heapster + InfluxDB + Grafana
ElasticSearch + Fluentd + Kibana
Istio service mesh
Helm
Vistio
Kiali
使用说明
将该repo克隆到本地，下载Kubernetes的到项目的根目录。

git clone https://github.com/rootsongjc/kubernetes-vagrant-centos-cluster.git
cd kubernetes-vagrant-centos-cluster
注意：如果您是第一次运行该部署程序，那么可以直接执行下面的命令，它将自动帮你下载 Kubernetes 安装包，下一次你就不需要自己下载了，另外您也可以在这里找到Kubernetes的发行版下载地址，下载 Kubernetes发行版后重命名为kubernetes-server-linux-amd64.tar.gz，并移动到该项目的根目录下。

因为该项目是使用 NFS 的方式挂载到虚拟机的 /vagrant 目录中的，所以在安装 NFS 的时候需要您输入密码授权。

使用vagrant启动集群。

vagrant up
如果是首次部署，会自动下载centos/7的box，这需要花费一些时间，另外每个节点还需要下载安装一系列软件包，整个过程大概需要10几分钟。

如果您在运行vagrant up的过程中发现无法下载centos/7的box，可以手动下载后将其添加到vagrant中。

手动添加centos/7 box

wget -c http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box
vagrant box add CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box --name centos/7
这样下次运行vagrant up的时候就会自动读取本地的centos/7 box而不会再到网上下载。

Windows 安装特别说明

执行vagrant up之后会有如下提示：

G:\code\kubernetes-vagrant-centos-cluster>vagrant up
Bringing machine 'node1' up with 'virtualbox' provider...
Bringing machine 'node2' up with 'virtualbox' provider...
Bringing machine 'node3' up with 'virtualbox' provider...
==> node1: Importing base box 'centos/7'...
==> node1: Matching MAC address for NAT networking...
==> node1: Setting the name of the VM: node1
==> node1: Clearing any previously set network interfaces...
==> node1: Specific bridge 'en0: Wi-Fi (AirPort)' not found. You may be asked to specify
==> node1: which network to bridge to.
==> node1: Available bridged network interfaces:
1) Realtek PCIe GBE Family Controller
2) TAP-Windows Adapter V9
==> node1: When choosing an interface, it is usually the one that is
==> node1: being used to connect to the internet.
    node1: Which interface should the network bridge to?
    node1: Which interface should the network bridge to?
    
输入1之后按回车继续。（根据自己真实网卡选择，node2、node3同样需要）

node3快要结束的时候可能会有如下错误：

node3: Created symlink from /etc/systemd/system/multi-user.target.wants/kubelet.service to /usr/lib/systemd/system/kubelet.service.
    node3: Created symlink from /etc/systemd/system/multi-user.target.wants/kube-proxy.service to /usr/lib/systemd/system/kube-proxy.service.
    node3: deploy coredns
    node3: /tmp/vagrant-shell: ./dns-deploy.sh: /bin/bash^M: bad interpreter: No such file or directory
    node3: error: no objects passed to apply
    node3: /home/vagrant
解决方法：

vagrant ssh node3
sudo -i
cd /vagrant/addon/dns
yum -y install dos2unix
dos2unix dns-deploy.sh
./dns-deploy.sh -r 10.254.0.0/16 -i 10.254.0.2 |kubectl apply -f -
访问kubernetes集群
访问Kubernetes集群的方式有三种：

本地访问
在VM内部访问
Kubernetes dashboard
通过本地访问

可以直接在你自己的本地环境中操作该kubernetes集群，而无需登录到虚拟机中。

要想在本地直接操作Kubernetes集群，需要在你的电脑里安装kubectl命令行工具，对于Mac用户执行以下步骤：

wget https://storage.googleapis.com/kubernetes-release/release/v1.11.0/kubernetes-client-darwin-amd64.tar.gz
tar xvf kubernetes-client-darwin-amd64.tar.gz && cp kubernetes/client/bin/kubectl /usr/local/bin
将conf/admin.kubeconfig文件放到~/.kube/config目录下即可在本地使用kubectl命令操作集群。

mkdir -p ~/.kube
cp conf/admin.kubeconfig ~/.kube/config
我们推荐您使用这种方式。

在虚拟机内部访问

如果有任何问题可以登录到虚拟机内部调试：

vagrant ssh node1
sudo -i
kubectl get nodes
Kubernetes dashboard

还可以直接通过dashboard UI来访问：https://172.17.8.101:8443

可以在本地执行以下命令获取token的值（需要提前安装kubectl）：

kubectl -n kube-system describe secret `kubectl -n kube-system get secret|grep admin-token|cut -d " " -f1`|grep "token:"|tr -s " "|cut -d " " -f2
注意：token的值也可以在vagrant up的日志的最后看到。

Kubernetes dashboard animation

只有当你安装了下面的heapster组件后才能看到上图中的监控metrics。

Windows下Chrome/Firefox访问

如果提示NET::ERR_CERT_INVALID，则需要下面的步骤

进入本项目目录

vagrant ssh node1
sudo -i
cd /vagrant/addon/dashboard/
mkdir certs
openssl req -nodes -newkey rsa:2048 -keyout certs/dashboard.key -out certs/dashboard.csr -subj "/C=/ST=/L=/O=/OU=/CN=kubernetes-dashboard"
openssl x509 -req -sha256 -days 365 -in certs/dashboard.csr -signkey certs/dashboard.key -out certs/dashboard.crt
kubectl delete secret kubernetes-dashboard-certs -n kube-system
kubectl create secret generic kubernetes-dashboard-certs --from-file=certs -n kube-system
kubectl delete pods $(kubectl get pods -n kube-system|grep kubernetes-dashboard|awk '{print $1}') -n kube-system #重新创建dashboard
刷新浏览器之后点击高级，选择跳过即可打开页面。

组件
Heapster监控

创建Heapster监控：

kubectl apply -f addon/heapster/
访问Grafana

使用Ingress方式暴露的服务，在本地/etc/hosts中增加一条配置：

172.17.8.102 grafana.jimmysong.io
访问Grafana：http://grafana.jimmysong.io

Grafana动画

Traefik

部署Traefik ingress controller和增加ingress配置：

kubectl apply -f addon/traefik-ingress
在本地/etc/hosts中增加一条配置：

172.17.8.102 traefik.jimmysong.io
访问Traefik UI：http://traefik.jimmysong.io

Traefik Ingress controller

EFK

使用EFK做日志收集。

kubectl apply -f addon/efk/
注意：运行EFK的每个节点需要消耗很大的CPU和内存，请保证每台虚拟机至少分配了4G内存。

Helm

用来部署helm。

hack/deploy-helm.sh
Service Mesh
我们使用 istio 作为 service mesh。

安装

到Istio release 页面下载istio的安装包，安装istio命令行工具，将istioctl命令行工具放到你的$PATH目录下，对于Mac用户：

wget https://github.com/istio/istio/releases/download/1.0.0/istio-1.0.0-osx.tar.gz
tar xvf istio-1.0.0-osx.tar.gz
mv bin/istioctl /usr/local/bin/
在Kubernetes中部署istio：

kubectl apply -f addon/istio/istio-demo.yaml
kubectl apply -f addon/istio/istio-ingress.yaml
运行示例

我们开启了Sidecar自动注入。

kubectl label namespace default istio-injection=enabled
kubectl apply -n default -f yaml/istio-bookinfo/bookinfo.yaml
kubectl apply -n default -f yaml/istio-bookinfo/bookinfo-gateway.yaml
kubectl apply -n default -f yaml/istio-bookinfo/destination-rule-all.yaml
在您自己的本地主机的/etc/hosts文件中增加如下配置项。

172.17.8.102 grafana.istio.jimmysong.io
172.17.8.102 prometheus.istio.jimmysong.io
172.17.8.102 servicegraph.istio.jimmysong.io
172.17.8.102 jaeger-query.istio.jimmysong.io
我们可以通过下面的URL地址访问以上的服务。

Service	URL
grafana	http://grafana.istio.jimmysong.io
servicegraph	http://servicegraph.istio.jimmysong.io/dotviz, http://servicegraph.istio.jimmysong.io/graph,http://servicegraph.istio.jimmysong.io/force/forcegraph.html
tracing	http://jaeger-query.istio.jimmysong.io
productpage	http://172.17.8.101:31380/productpage
详细信息请参阅：https://istio.io/zh/docs/examples/bookinfo/

Bookinfo Demo

Vistio
Vizceral是Netflix发布的一个开源项目，用于近乎实时地监控应用程序和集群之间的网络流量。Vistio是使用Vizceral对Istio和网格监控的改进。它利用Istio Mixer生成的指标，然后将其输入Prometheus。Vistio查询Prometheus并将数据存储在本地以允许重播流量。

# Deploy vistio via kubectl
kubectl -n default apply -f addon/vistio/

# Expose vistio-api
kubectl -n default port-forward $(kubectl -n default get pod -l app=vistio-api -o jsonpath='{.items[0].metadata.name}') 9091:9091 &

# Expose vistio in another terminal window
kubectl -n default port-forward $(kubectl -n default get pod -l app=vistio-web -o jsonpath='{.items[0].metadata.name}') 8080:8080 &
如果一切都已经启动并准备就绪，您就可以访问Vistio UI，开始探索服务网格网络，访问http://localhost:8080 您将会看到类似下图的输出。

vistio animation

更多详细内容请参考Vistio—使用Netflix的Vizceral可视化Istio service mesh。

Kiali
Kiali是一个用于提供Istio service mesh观察性的项目，更多信息请查看https://kiali.io。

在本地该项目的根路径下执行下面的命令：

kubectl apply -n istio-system -f addon/kiali
Kiali web地址：http://172.17.8.101:31439

用户名/密码：admin/admin

kiali

注意：Kilia使用Jaeger做追踪，请不用屏蔽kilia页面的弹出窗口。

Weave scope
Weave scope可用于监控、可视化和管理Docker&Kubernetes集群，详情见https://www.weave.works/oss/scope/

在本地该项目的根路径下执行下面的命令：

kubectl apply -f addon/weave-scope
在本地的/etc/hosts下增加一条记录。

172.17.8.102 scope.weave.jimmysong.io
现在打开浏览器，访问http://scope.weave.jimmysong.io/

Weave scope动画

管理
除了特别说明，以下命令都在当前的repo目录下操作。

挂起
将当前的虚拟机挂起，以便下次恢复。

vagrant suspend
恢复
恢复虚拟机的上次状态。

vagrant resume
注意：我们每次挂起虚拟机后再重新启动它们的时候，看到的虚拟机中的时间依然是挂载时候的时间，这样将导致监控查看起来比较麻烦。因此请考虑先停机再重新启动虚拟机。

重启
停机后重启启动。

vagrant halt
vagrant up
# login to node1
vagrant ssh node1
# run the prosivision scripts
/vagrant/hack/k8s-init.sh
exit
# login to node2
vagrant ssh node2
# run the prosivision scripts
/vagrant/hack/k8s-init.sh
exit
# login to node3
vagrant ssh node3
# run the prosivision scripts
/vagrant/hack/k8s-init.sh
sudo -i
cd /vagrant/hack
./deploy-base-services.sh
exit
现在你已经拥有一个完整的基础的kubernetes运行环境，在该repo的根目录下执行下面的命令可以获取kubernetes dahsboard的admin用户的token。

hack/get-dashboard-token.sh
根据提示登录即可。

清理
清理虚拟机。

vagrant destroy
rm -rf .vagrant
注意
仅做开发测试使用，不要在生产环境使用该项目。

参考
Kubernetes Handbook——Kubernetes中文指南/云原生应用架构实践手册
duffqiu/centos-vagrant
coredns/deployment
Kubernetes 1.8 kube-proxy 开启 ipvs
Vistio—使用Netflix的Vizceral可视化Istio service mesh
更多Istio和Service Mesh的资讯请访问ServiceMesher社区和关注社区的微信公众号。

```



## 

```


```

## 相关知识准备

### Centos7安装配置NFS服务和挂载

https://www.w3cschool.cn/doc_vagrant/vagrant-synced-folders-nfs.html

```

现在有3台服务器 s1(主)，s2(从), s3（从）需要实现文件实时同步，我们可以安装Nfs服务端和客户端来实现！



一、安装 NFS 服务器所需的软件包：

yum install -y nfs-utils
二、编辑exports文件，添加从机

  
vim /etc/exports
/home/nfs/ 192.168.248.0/24(rw,sync,fsid=0)
同192.168.248.0/24一个网络号的主机可以挂载NFS服务器上的/home/nfs/目录到自己的文件系统中

rw表示可读写；sync表示同步写，fsid=0表示将/data找个目录包装成根目录

三、启动nfs服务

先为rpcbind和nfs做开机启动：(必须先启动rpcbind服务)

 
systemctl enable rpcbind.service
systemctl enable nfs-server.service
然后分别启动rpcbind和nfs服务：

 
systemctl start rpcbind.service
systemctl start nfs-server.service
确认NFS服务器启动成功：

 
rpcinfo -p
检查 NFS 服务器是否挂载我们想共享的目录 /home/nfs/：

exportfs -r
#使配置生效

exportfs
#可以查看到已经ok
/home/nfs 192.168.248.0/24

四、在从机上安装NFS 客户端

首先是安裝nfs，同上，然后启动rpcbind服务

先为rpcbind做开机启动：

systemctl enable rpcbind.service

然后启动rpcbind服务：

systemctl start rpcbind.service

注意：客户端不需要启动nfs服务

检查 NFS 服务器端是否有目录共享：showmount -e nfs服务器的IP

showmount -e 192.168.248.208
Export list for 192.168.248.208:
/home/nfs 192.168.248.0/24
在从机上使用 mount 挂载服务器端的目录/home/nfs到客户端某个目录下：


cd /home && mkdir /nfs
mount -t nfs 192.168.248.208:/home/nfs /home/nfs

df -h 查看是否挂载成功。

 

http://blog.csdn.net/taiyang1987912/article/details/41696319

http://www.linuxidc.com/Linux/2015-05/117378.htm





```


## 

```


```


## 

```


```


## 

```


```


## 

```


```






## 

```


```










## 

```


```















## 安装提示



```javascript
$ vagrant up
Bringing machine 'node1' up with 'virtualbox' provider...
Bringing machine 'node2' up with 'virtualbox' provider...
Bringing machine 'node3' up with 'virtualbox' provider...
==> node1: Clearing any previously set network interfaces...
==> node1: Preparing network interfaces based on configuration...
    node1: Adapter 1: nat
    node1: Adapter 2: hostonly
==> node1: Forwarding ports...
    node1: 22 (guest) => 2222 (host) (adapter 1)
==> node1: Running 'pre-boot' VM customizations...
==> node1: Booting VM...
==> node1: Waiting for machine to boot. This may take a few minutes...
    node1: SSH address: 127.0.0.1:2222
    node1: SSH username: vagrant
    node1: SSH auth method: private key
    node1: Warning: Remote connection disconnect. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Remote connection disconnect. Retrying...
    node1: Warning: Remote connection disconnect. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: 
    node1: Vagrant insecure key detected. Vagrant will automatically replace
    node1: this with a newly generated keypair for better security.
    node1: 
    node1: Inserting generated public key within guest...
    node1: Removing insecure key from the guest if it's present...
    node1: Key inserted! Disconnecting and reconnecting using new SSH key...
==> node1: Machine booted and ready!
==> node1: Checking for guest additions in VM...
    node1: No guest additions were detected on the base box for this VM! Guest
    node1: additions are required for forwarded ports, shared folders, host only
    node1: networking, and more. If SSH fails on this machine, please install
    node1: the guest additions and repackage the box to continue.
    node1: 
    node1: This is not an error message; everything may continue to work properly,
    node1: in which case you may ignore this message.
==> node1: Setting hostname...
==> node1: Configuring and enabling network interfaces...
==> node1: Exporting NFS shared folders...
==> node1: Preparing to edit /etc/exports. Administrator privileges will be required...
==> node1: Mounting NFS shared folders...
==> node1: Running provisioner: shell...
    node1: Running: /tmp/vagrant-shell20190217-15309-1n1oqtk.sh
    node1: Loaded plugins: fastestmirror
    node1: Determining fastest mirrors
    node1: Resolving Dependencies
    node1: --> Running transaction check
    node1: ---> Package bind-utils.x86_64 32:9.9.4-73.el7_6 will be installed
    node1: --> Processing Dependency: bind-libs = 32:9.9.4-73.el7_6 for package: 32:bind-utils-9.9.4-73.el7_6.x86_64
    node1: --> Processing Dependency: liblwres.so.90()(64bit) for package: 32:bind-utils-9.9.4-73.el7_6.x86_64
    node1: --> Processing Dependency: libisccfg.so.90()(64bit) for package: 32:bind-utils-9.9.4-73.el7_6.x86_64
    node1: --> Processing Dependency: libisccc.so.90()(64bit) for package: 32:bind-utils-9.9.4-73.el7_6.x86_64
    node1: --> Processing Dependency: libisc.so.95()(64bit) for package: 32:bind-utils-9.9.4-73.el7_6.x86_64
    node1: --> Processing Dependency: libdns.so.100()(64bit) for package: 32:bind-utils-9.9.4-73.el7_6.x86_64
    node1: --> Processing Dependency: libbind9.so.90()(64bit) for package: 32:bind-utils-9.9.4-73.el7_6.x86_64
    node1: ---> Package ceph-common.x86_64 1:10.2.5-4.el7 will be installed
    node1: --> Processing Dependency: python-rbd = 1:10.2.5-4.el7 for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: python-rados = 1:10.2.5-4.el7 for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: librbd1 = 1:10.2.5-4.el7 for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: librados2 = 1:10.2.5-4.el7 for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: redhat-lsb-core for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: python-requests for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: hdparm for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: gdisk for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: cryptsetup for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: librbd.so.1()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: librados.so.2()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: libboost_thread-mt.so.1.53.0()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: libboost_system-mt.so.1.53.0()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: libboost_regex-mt.so.1.53.0()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: libboost_random-mt.so.1.53.0()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: libboost_program_options-mt.so.1.53.0()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: --> Processing Dependency: libboost_iostreams-mt.so.1.53.0()(64bit) for package: 1:ceph-common-10.2.5-4.el7.x86_64
    node1: ---> Package conntrack-tools.x86_64 0:1.4.4-4.el7 will be installed
    node1: --> Processing Dependency: libnetfilter_cttimeout.so.1(LIBNETFILTER_CTTIMEOUT_1.1)(64bit) for package: conntrack-tools-1.4.4-4.el7.x86_64
    node1: --> Processing Dependency: libnetfilter_cttimeout.so.1(LIBNETFILTER_CTTIMEOUT_1.0)(64bit) for package: conntrack-tools-1.4.4-4.el7.x86_64
    node1: --> Processing Dependency: libnetfilter_cthelper.so.0(LIBNETFILTER_CTHELPER_1.0)(64bit) for package: conntrack-tools-1.4.4-4.el7.x86_64
    node1: --> Processing Dependency: libnetfilter_queue.so.1()(64bit) for package: conntrack-tools-1.4.4-4.el7.x86_64
    node1: --> Processing Dependency: libnetfilter_cttimeout.so.1()(64bit) for package: conntrack-tools-1.4.4-4.el7.x86_64
    node1: --> Processing Dependency: libnetfilter_cthelper.so.0()(64bit) for package: conntrack-tools-1.4.4-4.el7.x86_64
    node1: ---> Package curl.x86_64 0:7.29.0-42.el7_4.1 will be updated
    node1: ---> Package curl.x86_64 0:7.29.0-51.el7 will be an update
    node1: --> Processing Dependency: libcurl = 7.29.0-51.el7 for package: curl-7.29.0-51.el7.x86_64
    node1: ---> Package dos2unix.x86_64 0:6.0.3-7.el7 will be installed
    node1: ---> Package kmod.x86_64 0:20-15.el7_4.6 will be updated
    node1: ---> Package kmod.x86_64 0:20-23.el7 will be an update
    node1: ---> Package net-tools.x86_64 0:2.0-0.24.20131004git.el7 will be installed
    node1: ---> Package ntp.x86_64 0:4.2.6p5-28.el7.centos will be installed
    node1: --> Processing Dependency: ntpdate = 4.2.6p5-28.el7.centos for package: ntp-4.2.6p5-28.el7.centos.x86_64
    node1: --> Processing Dependency: libopts.so.25()(64bit) for package: ntp-4.2.6p5-28.el7.centos.x86_64
    node1: ---> Package socat.x86_64 0:1.7.3.2-2.el7 will be installed
    node1: ---> Package tcpdump.x86_64 14:4.9.2-3.el7 will be installed
    node1: --> Processing Dependency: libpcap >= 14:1.5.3-10 for package: 14:tcpdump-4.9.2-3.el7.x86_64
    node1: --> Processing Dependency: libpcap.so.1()(64bit) for package: 14:tcpdump-4.9.2-3.el7.x86_64
    node1: ---> Package telnet.x86_64 1:0.17-64.el7 will be installed
    node1: ---> Package vim-enhanced.x86_64 2:7.4.160-5.el7 will be installed
    node1: --> Processing Dependency: vim-common = 2:7.4.160-5.el7 for package: 2:vim-enhanced-7.4.160-5.el7.x86_64
    node1: --> Processing Dependency: perl(:MODULE_COMPAT_5.16.3) for package: 2:vim-enhanced-7.4.160-5.el7.x86_64
    node1: --> Processing Dependency: libperl.so()(64bit) for package: 2:vim-enhanced-7.4.160-5.el7.x86_64
    node1: --> Processing Dependency: libgpm.so.2()(64bit) for package: 2:vim-enhanced-7.4.160-5.el7.x86_64
    node1: ---> Package wget.x86_64 0:1.14-18.el7 will be installed
    node1: --> Running transaction check
    node1: ---> Package autogen-libopts.x86_64 0:5.18-5.el7 will be installed
    node1: ---> Package bind-libs.x86_64 32:9.9.4-73.el7_6 will be installed
    node1: --> Processing Dependency: bind-license = 32:9.9.4-73.el7_6 for package: 32:bind-libs-9.9.4-73.el7_6.x86_64
    node1: ---> Package boost-iostreams.x86_64 0:1.53.0-27.el7 will be installed
    node1: ---> Package boost-program-options.x86_64 0:1.53.0-27.el7 will be installed
    node1: ---> Package boost-random.x86_64 0:1.53.0-27.el7 will be installed
    node1: ---> Package boost-regex.x86_64 0:1.53.0-27.el7 will be installed
    node1: --> Processing Dependency: libicuuc.so.50()(64bit) for package: boost-regex-1.53.0-27.el7.x86_64
    node1: --> Processing Dependency: libicui18n.so.50()(64bit) for package: boost-regex-1.53.0-27.el7.x86_64
    node1: --> Processing Dependency: libicudata.so.50()(64bit) for package: boost-regex-1.53.0-27.el7.x86_64
    node1: ---> Package boost-system.x86_64 0:1.53.0-27.el7 will be installed
    node1: ---> Package boost-thread.x86_64 0:1.53.0-27.el7 will be installed
    node1: ---> Package cryptsetup.x86_64 0:2.0.3-3.el7 will be installed
    node1: --> Processing Dependency: cryptsetup-libs(x86-64) = 2.0.3-3.el7 for package: cryptsetup-2.0.3-3.el7.x86_64
    node1: --> Processing Dependency: libcryptsetup.so.12(CRYPTSETUP_2.0)(64bit) for package: cryptsetup-2.0.3-3.el7.x86_64
    node1: --> Processing Dependency: libcryptsetup.so.12()(64bit) for package: cryptsetup-2.0.3-3.el7.x86_64
    node1: ---> Package gdisk.x86_64 0:0.8.10-2.el7 will be installed
    node1: ---> Package gpm-libs.x86_64 0:1.20.7-5.el7 will be installed
    node1: ---> Package hdparm.x86_64 0:9.43-5.el7 will be installed
    node1: ---> Package libcurl.x86_64 0:7.29.0-42.el7_4.1 will be updated
    node1: ---> Package libcurl.x86_64 0:7.29.0-51.el7 will be an update
    node1: --> Processing Dependency: nss-pem(x86-64) >= 1.0.3-5 for package: libcurl-7.29.0-51.el7.x86_64
    node1: --> Processing Dependency: libnss3.so(NSS_3.34)(64bit) for package: libcurl-7.29.0-51.el7.x86_64
    node1: ---> Package libnetfilter_cthelper.x86_64 0:1.0.0-9.el7 will be installed
    node1: ---> Package libnetfilter_cttimeout.x86_64 0:1.0.0-6.el7 will be installed
    node1: ---> Package libnetfilter_queue.x86_64 0:1.0.2-2.el7_2 will be installed
    node1: ---> Package libpcap.x86_64 14:1.5.3-11.el7 will be installed
    node1: ---> Package librados2.x86_64 1:10.2.5-4.el7 will be installed
    node1: ---> Package librbd1.x86_64 1:10.2.5-4.el7 will be installed
    node1: ---> Package ntpdate.x86_64 0:4.2.6p5-28.el7.centos will be installed
    node1: ---> Package perl.x86_64 4:5.16.3-294.el7_6 will be installed
    node1: --> Processing Dependency: perl(Socket) >= 1.3 for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Scalar::Util) >= 1.10 for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl-macros for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(threads::shared) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(threads) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(constant) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Time::Local) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Time::HiRes) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Storable) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Socket) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Scalar::Util) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Pod::Simple::XHTML) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Pod::Simple::Search) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Getopt::Long) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Filter::Util::Call) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(File::Temp) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(File::Spec::Unix) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(File::Spec::Functions) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(File::Spec) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(File::Path) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Exporter) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Cwd) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: --> Processing Dependency: perl(Carp) for package: 4:perl-5.16.3-294.el7_6.x86_64
    node1: ---> Package perl-libs.x86_64 4:5.16.3-294.el7_6 will be installed
    node1: ---> Package python-rados.x86_64 1:10.2.5-4.el7 will be installed
    node1: ---> Package python-rbd.x86_64 1:10.2.5-4.el7 will be installed
    node1: ---> Package python-requests.noarch 0:2.6.0-1.el7_1 will be installed
    node1: --> Processing Dependency: python-urllib3 >= 1.10.2-1 for package: python-requests-2.6.0-1.el7_1.noarch
    node1: ---> Package redhat-lsb-core.x86_64 0:4.1-27.el7.centos.1 will be installed
    node1: --> Processing Dependency: redhat-lsb-submod-security(x86-64) = 4.1-27.el7.centos.1 for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: spax for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/sbin/fuser for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/time for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/patch for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/m4 for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/lpr for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/lp for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/killall for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/bc for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/batch for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /usr/bin/at for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /bin/mailx for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: --> Processing Dependency: /bin/ed for package: redhat-lsb-core-4.1-27.el7.centos.1.x86_64
    node1: ---> Package vim-common.x86_64 2:7.4.160-5.el7 will be installed
    node1: --> Processing Dependency: vim-filesystem for package: 2:vim-common-7.4.160-5.el7.x86_64
    node1: --> Running transaction check
    node1: ---> Package at.x86_64 0:3.1.13-24.el7 will be installed
    node1: ---> Package bc.x86_64 0:1.06.95-13.el7 will be installed
    node1: ---> Package bind-license.noarch 32:9.9.4-51.el7_4.2 will be updated
    node1: --> Processing Dependency: bind-license = 32:9.9.4-51.el7_4.2 for package: 32:bind-libs-lite-9.9.4-51.el7_4.2.x86_64
    node1: ---> Package bind-license.noarch 32:9.9.4-73.el7_6 will be an update
    node1: ---> Package cryptsetup-libs.x86_64 0:1.7.4-3.el7_4.1 will be updated
    node1: ---> Package cryptsetup-libs.x86_64 0:2.0.3-3.el7 will be an update
    node1: --> Processing Dependency: libjson-c.so.2()(64bit) for package: cryptsetup-libs-2.0.3-3.el7.x86_64
    node1: ---> Package cups-client.x86_64 1:1.6.3-35.el7 will be installed
    node1: --> Processing Dependency: cups-libs(x86-64) = 1:1.6.3-35.el7 for package: 1:cups-client-1.6.3-35.el7.x86_64
    node1: --> Processing Dependency: libcups.so.2()(64bit) for package: 1:cups-client-1.6.3-35.el7.x86_64
    node1: --> Processing Dependency: libavahi-common.so.3()(64bit) for package: 1:cups-client-1.6.3-35.el7.x86_64
    node1: --> Processing Dependency: libavahi-client.so.3()(64bit) for package: 1:cups-client-1.6.3-35.el7.x86_64
    node1: ---> Package ed.x86_64 0:1.9-4.el7 will be installed
    node1: ---> Package libicu.x86_64 0:50.1.2-17.el7 will be installed
    node1: ---> Package m4.x86_64 0:1.4.16-10.el7 will be installed
    node1: ---> Package mailx.x86_64 0:12.5-19.el7 will be installed
    node1: ---> Package nss.x86_64 0:3.28.4-15.el7_4 will be updated
    node1: --> Processing Dependency: nss = 3.28.4-15.el7_4 for package: nss-sysinit-3.28.4-15.el7_4.x86_64
    node1: --> Processing Dependency: nss(x86-64) = 3.28.4-15.el7_4 for package: nss-tools-3.28.4-15.el7_4.x86_64
    node1: ---> Package nss.x86_64 0:3.36.0-7.1.el7_6 will be an update
    node1: --> Processing Dependency: nss-util >= 3.36.0-1.1 for package: nss-3.36.0-7.1.el7_6.x86_64
    node1: --> Processing Dependency: nss-softokn(x86-64) >= 3.36.0-1 for package: nss-3.36.0-7.1.el7_6.x86_64
    node1: --> Processing Dependency: nspr >= 4.19.0 for package: nss-3.36.0-7.1.el7_6.x86_64
    node1: --> Processing Dependency: libnssutil3.so(NSSUTIL_3.31)(64bit) for package: nss-3.36.0-7.1.el7_6.x86_64
    node1: ---> Package nss-pem.x86_64 0:1.0.3-4.el7 will be updated
    node1: ---> Package nss-pem.x86_64 0:1.0.3-5.el7 will be an update
    node1: ---> Package patch.x86_64 0:2.7.1-10.el7_5 will be installed
    node1: ---> Package perl-Carp.noarch 0:1.26-244.el7 will be installed
    node1: ---> Package perl-Exporter.noarch 0:5.68-3.el7 will be installed
    node1: ---> Package perl-File-Path.noarch 0:2.09-2.el7 will be installed
    node1: ---> Package perl-File-Temp.noarch 0:0.23.01-3.el7 will be installed
    node1: ---> Package perl-Filter.x86_64 0:1.49-3.el7 will be installed
    node1: ---> Package perl-Getopt-Long.noarch 0:2.40-3.el7 will be installed
    node1: --> Processing Dependency: perl(Pod::Usage) >= 1.14 for package: perl-Getopt-Long-2.40-3.el7.noarch
    node1: --> Processing Dependency: perl(Text::ParseWords) for package: perl-Getopt-Long-2.40-3.el7.noarch
    node1: ---> Package perl-PathTools.x86_64 0:3.40-5.el7 will be installed
    node1: ---> Package perl-Pod-Simple.noarch 1:3.28-4.el7 will be installed
    node1: --> Processing Dependency: perl(Pod::Escapes) >= 1.04 for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
    node1: --> Processing Dependency: perl(Encode) for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
    node1: ---> Package perl-Scalar-List-Utils.x86_64 0:1.27-248.el7 will be installed
    node1: ---> Package perl-Socket.x86_64 0:2.010-4.el7 will be installed
    node1: ---> Package perl-Storable.x86_64 0:2.45-3.el7 will be installed
    node1: ---> Package perl-Time-HiRes.x86_64 4:1.9725-3.el7 will be installed
    node1: ---> Package perl-Time-Local.noarch 0:1.2300-2.el7 will be installed
    node1: ---> Package perl-constant.noarch 0:1.27-2.el7 will be installed
    node1: ---> Package perl-macros.x86_64 4:5.16.3-294.el7_6 will be installed
    node1: ---> Package perl-threads.x86_64 0:1.87-4.el7 will be installed
    node1: ---> Package perl-threads-shared.x86_64 0:1.43-6.el7 will be installed
    node1: ---> Package psmisc.x86_64 0:22.20-15.el7 will be installed
    node1: ---> Package python-urllib3.noarch 0:1.10.2-5.el7 will be installed
    node1: --> Processing Dependency: python-six for package: python-urllib3-1.10.2-5.el7.noarch
    node1: --> Processing Dependency: python-ipaddress for package: python-urllib3-1.10.2-5.el7.noarch
    node1: --> Processing Dependency: python-backports-ssl_match_hostname for package: python-urllib3-1.10.2-5.el7.noarch
    node1: ---> Package redhat-lsb-submod-security.x86_64 0:4.1-27.el7.centos.1 will be installed
    node1: ---> Package spax.x86_64 0:1.5.2-13.el7 will be installed
    node1: ---> Package time.x86_64 0:1.7-45.el7 will be installed
    node1: ---> Package vim-filesystem.x86_64 2:7.4.160-5.el7 will be installed
    node1: --> Running transaction check
    node1: ---> Package avahi-libs.x86_64 0:0.6.31-19.el7 will be installed
    node1: ---> Package bind-libs-lite.x86_64 32:9.9.4-51.el7_4.2 will be updated
    node1: ---> Package bind-libs-lite.x86_64 32:9.9.4-73.el7_6 will be an update
    node1: ---> Package cups-libs.x86_64 1:1.6.3-35.el7 will be installed
    node1: ---> Package json-c.x86_64 0:0.11-4.el7_0 will be installed
    node1: ---> Package nspr.x86_64 0:4.13.1-1.0.el7_3 will be updated
    node1: ---> Package nspr.x86_64 0:4.19.0-1.el7_5 will be an update
    node1: ---> Package nss-softokn.x86_64 0:3.28.3-8.el7_4 will be updated
    node1: ---> Package nss-softokn.x86_64 0:3.36.0-5.el7_5 will be an update
    node1: --> Processing Dependency: nss-softokn-freebl(x86-64) >= 3.36.0-5.el7_5 for package: nss-softokn-3.36.0-5.el7_5.x86_64
    node1: ---> Package nss-sysinit.x86_64 0:3.28.4-15.el7_4 will be updated
    node1: ---> Package nss-sysinit.x86_64 0:3.36.0-7.1.el7_6 will be an update
    node1: ---> Package nss-tools.x86_64 0:3.28.4-15.el7_4 will be updated
    node1: ---> Package nss-tools.x86_64 0:3.36.0-7.1.el7_6 will be an update
    node1: ---> Package nss-util.x86_64 0:3.28.4-3.el7 will be updated
    node1: ---> Package nss-util.x86_64 0:3.36.0-1.1.el7_6 will be an update
    node1: ---> Package perl-Encode.x86_64 0:2.51-7.el7 will be installed
    node1: ---> Package perl-Pod-Escapes.noarch 1:1.04-294.el7_6 will be installed
    node1: ---> Package perl-Pod-Usage.noarch 0:1.63-3.el7 will be installed
    node1: --> Processing Dependency: perl(Pod::Text) >= 3.15 for package: perl-Pod-Usage-1.63-3.el7.noarch
    node1: --> Processing Dependency: perl-Pod-Perldoc for package: perl-Pod-Usage-1.63-3.el7.noarch
    node1: ---> Package perl-Text-ParseWords.noarch 0:3.29-4.el7 will be installed
    node1: ---> Package python-backports-ssl_match_hostname.noarch 0:3.5.0.1-1.el7 will be installed
    node1: --> Processing Dependency: python-backports for package: python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch
    node1: ---> Package python-ipaddress.noarch 0:1.0.16-2.el7 will be installed
    node1: ---> Package python-six.noarch 0:1.9.0-2.el7 will be installed
    node1: --> Running transaction check
    node1: ---> Package nss-softokn-freebl.x86_64 0:3.28.3-8.el7_4 will be updated
    node1: ---> Package nss-softokn-freebl.x86_64 0:3.36.0-5.el7_5 will be an update
    node1: ---> Package perl-Pod-Perldoc.noarch 0:3.20-4.el7 will be installed
    node1: --> Processing Dependency: perl(parent) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
    node1: --> Processing Dependency: perl(HTTP::Tiny) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
    node1: ---> Package perl-podlators.noarch 0:2.5.1-3.el7 will be installed
    node1: ---> Package python-backports.x86_64 0:1.0-8.el7 will be installed
    node1: --> Running transaction check
    node1: ---> Package perl-HTTP-Tiny.noarch 0:0.033-3.el7 will be installed
    node1: ---> Package perl-parent.noarch 1:0.225-244.el7 will be installed
    node1: --> Finished Dependency Resolution
    node1: 
    node1: Dependencies Resolved
    node1: 
    node1: ================================================================================
    node1:  Package                          Arch   Version                  Repository
    node1:                                                                            Size
    node1: ================================================================================
    node1: Installing:
    node1:  bind-utils                       x86_64 32:9.9.4-73.el7_6        updates 206 k
    node1:  ceph-common                      x86_64 1:10.2.5-4.el7           base    9.3 M
    node1:  conntrack-tools                  x86_64 1.4.4-4.el7              base    186 k
    node1:  dos2unix                         x86_64 6.0.3-7.el7              base     74 k
    node1:  net-tools                        x86_64 2.0-0.24.20131004git.el7 base    306 k
    node1:  ntp                              x86_64 4.2.6p5-28.el7.centos    base    549 k
    node1:  socat                            x86_64 1.7.3.2-2.el7            base    290 k
    node1:  tcpdump                          x86_64 14:4.9.2-3.el7           base    421 k
    node1:  telnet                           x86_64 1:0.17-64.el7            base     64 k
    node1:  vim-enhanced                     x86_64 2:7.4.160-5.el7          base    1.0 M
    node1:  wget                             x86_64 1.14-18.el7              base    547 k
    node1: Updating:
    node1:  curl                             x86_64 7.29.0-51.el7            base    269 k
    node1:  kmod                             x86_64 20-23.el7                base    121 k
    node1: Installing for dependencies:
    node1:  at                               x86_64 3.1.13-24.el7            base     51 k
    node1:  autogen-libopts                  x86_64 5.18-5.el7               base     66 k
    node1:  avahi-libs                       x86_64 0.6.31-19.el7            base     61 k
    node1:  bc                               x86_64 1.06.95-13.el7           base    115 k
    node1:  bind-libs                        x86_64 32:9.9.4-73.el7_6        updates 1.0 M
    node1:  boost-iostreams                  x86_64 1.53.0-27.el7            base     61 k
    node1:  boost-program-options            x86_64 1.53.0-27.el7            base    156 k
    node1:  boost-random                     x86_64 1.53.0-27.el7            base     39 k
    node1:  boost-regex                      x86_64 1.53.0-27.el7            base    300 k
    node1:  boost-system                     x86_64 1.53.0-27.el7            base     40 k
    node1:  boost-thread                     x86_64 1.53.0-27.el7            base     57 k
    node1:  cryptsetup                       x86_64 2.0.3-3.el7              base    154 k
    node1:  cups-client                      x86_64 1:1.6.3-35.el7           base    151 k
    node1:  cups-libs                        x86_64 1:1.6.3-35.el7           base    357 k
    node1:  ed                               x86_64 1.9-4.el7                base     72 k
    node1:  gdisk                            x86_64 0.8.10-2.el7             base    189 k
    node1:  gpm-libs                         x86_64 1.20.7-5.el7             base     32 k
    node1:  hdparm                           x86_64 9.43-5.el7               base     83 k
    node1:  json-c                           x86_64 0.11-4.el7_0             base     31 k
    node1:  libicu                           x86_64 50.1.2-17.el7            base    6.9 M
    node1:  libnetfilter_cthelper            x86_64 1.0.0-9.el7              base     18 k
    node1:  libnetfilter_cttimeout           x86_64 1.0.0-6.el7              base     18 k
    node1:  libnetfilter_queue               x86_64 1.0.2-2.el7_2            base     23 k
    node1:  libpcap                          x86_64 14:1.5.3-11.el7          base    138 k
    node1:  librados2                        x86_64 1:10.2.5-4.el7           base    1.8 M
    node1:  librbd1                          x86_64 1:10.2.5-4.el7           base    2.4 M
    node1:  m4                               x86_64 1.4.16-10.el7            base    256 k
    node1:  mailx                            x86_64 12.5-19.el7              base    245 k
    node1:  ntpdate                          x86_64 4.2.6p5-28.el7.centos    base     86 k
    node1:  patch                            x86_64 2.7.1-10.el7_5           base    110 k
    node1:  perl                             x86_64 4:5.16.3-294.el7_6       updates 8.0 M
    node1:  perl-Carp                        noarch 1.26-244.el7             base     19 k
    node1:  perl-Encode                      x86_64 2.51-7.el7               base    1.5 M
    node1:  perl-Exporter                    noarch 5.68-3.el7               base     28 k
    node1:  perl-File-Path                   noarch 2.09-2.el7               base     26 k
    node1:  perl-File-Temp                   noarch 0.23.01-3.el7            base     56 k
    node1:  perl-Filter                      x86_64 1.49-3.el7               base     76 k
    node1:  perl-Getopt-Long                 noarch 2.40-3.el7               base     56 k
    node1:  perl-HTTP-Tiny                   noarch 0.033-3.el7              base     38 k
    node1:  perl-PathTools                   x86_64 3.40-5.el7               base     82 k
    node1:  perl-Pod-Escapes                 noarch 1:1.04-294.el7_6         updates  51 k
    node1:  perl-Pod-Perldoc                 noarch 3.20-4.el7               base     87 k
    node1:  perl-Pod-Simple                  noarch 1:3.28-4.el7             base    216 k
    node1:  perl-Pod-Usage                   noarch 1.63-3.el7               base     27 k
    node1:  perl-Scalar-List-Utils           x86_64 1.27-248.el7             base     36 k
    node1:  perl-Socket                      x86_64 2.010-4.el7              base     49 k
    node1:  perl-Storable                    x86_64 2.45-3.el7               base     77 k
    node1:  perl-Text-ParseWords             noarch 3.29-4.el7               base     14 k
    node1:  perl-Time-HiRes                  x86_64 4:1.9725-3.el7           base     45 k
    node1:  perl-Time-Local                  noarch 1.2300-2.el7             base     24 k
    node1:  perl-constant                    noarch 1.27-2.el7               base     19 k
    node1:  perl-libs                        x86_64 4:5.16.3-294.el7_6       updates 688 k
    node1:  perl-macros                      x86_64 4:5.16.3-294.el7_6       updates  44 k
    node1:  perl-parent                      noarch 1:0.225-244.el7          base     12 k
    node1:  perl-podlators                   noarch 2.5.1-3.el7              base    112 k
    node1:  perl-threads                     x86_64 1.87-4.el7               base     49 k
    node1:  perl-threads-shared              x86_64 1.43-6.el7               base     39 k
    node1:  psmisc                           x86_64 22.20-15.el7             base    141 k
    node1:  python-backports                 x86_64 1.0-8.el7                base    5.8 k
    node1:  python-backports-ssl_match_hostname
    node1:                                   noarch 3.5.0.1-1.el7            base     13 k
    node1:  python-ipaddress                 noarch 1.0.16-2.el7             base     34 k
    node1:  python-rados                     x86_64 1:10.2.5-4.el7           base    156 k
    node1:  python-rbd                       x86_64 1:10.2.5-4.el7           base     86 k
    node1:  python-requests                  noarch 2.6.0-1.el7_1            base     94 k
    node1:  python-six                       noarch 1.9.0-2.el7              base     29 k
    node1:  python-urllib3                   noarch 1.10.2-5.el7             base    102 k
    node1:  redhat-lsb-core                  x86_64 4.1-27.el7.centos.1      base     38 k
    node1:  redhat-lsb-submod-security       x86_64 4.1-27.el7.centos.1      base     15 k
    node1:  spax                             x86_64 1.5.2-13.el7             base    260 k
    node1:  time                             x86_64 1.7-45.el7               base     30 k
    node1:  vim-common                       x86_64 2:7.4.160-5.el7          base    5.9 M
    node1:  vim-filesystem                   x86_64 2:7.4.160-5.el7          base     10 k
    node1: Updating for dependencies:
    node1:  bind-libs-lite                   x86_64 32:9.9.4-73.el7_6        updates 741 k
    node1:  bind-license                     noarch 32:9.9.4-73.el7_6        updates  87 k
    node1:  cryptsetup-libs                  x86_64 2.0.3-3.el7              base    338 k
    node1:  libcurl                          x86_64 7.29.0-51.el7            base    221 k
    node1:  nspr                             x86_64 4.19.0-1.el7_5           base    127 k
    node1:  nss                              x86_64 3.36.0-7.1.el7_6         updates 835 k
    node1:  nss-pem                          x86_64 1.0.3-5.el7              base     74 k
    node1:  nss-softokn                      x86_64 3.36.0-5.el7_5           base    315 k
    node1:  nss-softokn-freebl               x86_64 3.36.0-5.el7_5           base    222 k
    node1:  nss-sysinit                      x86_64 3.36.0-7.1.el7_6         updates  62 k
    node1:  nss-tools                        x86_64 3.36.0-7.1.el7_6         updates 515 k
    node1:  nss-util                         x86_64 3.36.0-1.1.el7_6         updates  78 k
    node1: 
    node1: Transaction Summary
    node1: ================================================================================
    node1: Install  11 Packages (+72 Dependent packages)
    node1: Upgrade   2 Packages (+12 Dependent packages)
    node1: Total download size: 50 M
    node1: Downloading packages:
    node1: No Presto metadata available for base
    node1: Public key for at-3.1.13-24.el7.x86_64.rpm is not installed
    node1: warning: /var/cache/yum/x86_64/7/base/packages/at-3.1.13-24.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
    node1: Public key for bind-libs-lite-9.9.4-73.el7_6.x86_64.rpm is not installed
    node1: --------------------------------------------------------------------------------
    node1: Total                                              918 kB/s |  50 MB  00:55     
    node1: Retrieving key from http://mirrors.163.com/centos/RPM-GPG-KEY-CentOS-7
    node1: Importing GPG key 0xF4A80EB5:
    node1:  Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
    node1:  Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
    node1:  From       : http://mirrors.163.com/centos/RPM-GPG-KEY-CentOS-7
    node1: Running transaction check
    node1: Running transaction test
    node1: Transaction test succeeded
    node1: Running transaction
    node1:   Updating   : nspr-4.19.0-1.el7_5.x86_64                                 1/111
    node1:  
    node1:   Updating   : nss-util-3.36.0-1.1.el7_6.x86_64                           2/111
    node1:  
    node1:   Installing : boost-system-1.53.0-27.el7.x86_64                          3/111
    node1:  
    node1:   Installing : boost-thread-1.53.0-27.el7.x86_64                          4/111
    node1:  
    node1:   Installing : boost-random-1.53.0-27.el7.x86_64                          5/111
    node1:  
    node1:   Installing : boost-iostreams-1.53.0-27.el7.x86_64                       6/111
    node1:  
    node1:   Updating   : 32:bind-license-9.9.4-73.el7_6.noarch                      7/111
    node1:  
    node1:   Installing : avahi-libs-0.6.31-19.el7.x86_64                            8/111
    node1:  
    node1:   Installing : python-ipaddress-1.0.16-2.el7.noarch                       9/111
    node1:  
    node1:   Installing : 1:cups-libs-1.6.3-35.el7.x86_64                           10/111
    node1:  
    node1:   Installing : 1:cups-client-1.6.3-35.el7.x86_64                         11/111
    node1:  
    node1:   Installing : 32:bind-libs-9.9.4-73.el7_6.x86_64                        12/111
    node1:  
    node1:   Updating   : nss-softokn-freebl-3.36.0-5.el7_5.x86_64                  13/111
    node1:  
    node1:   Updating   : nss-softokn-3.36.0-5.el7_5.x86_64                         14/111
    node1:  
    node1:   Updating   : nss-pem-1.0.3-5.el7.x86_64                                15/111
    node1:  
    node1:   Updating   : nss-3.36.0-7.1.el7_6.x86_64                               16/111
    node1:  
    node1:   Updating   : nss-sysinit-3.36.0-7.1.el7_6.x86_64                       17/111
    node1:  
    node1:   Installing : 1:librados2-10.2.5-4.el7.x86_64                           18/111
    node1:  
    node1:   Installing : 1:librbd1-10.2.5-4.el7.x86_64                             19/111
    node1:  
    node1:   Installing : 1:python-rados-10.2.5-4.el7.x86_64                        20/111
    node1:  
    node1:   Installing : 1:python-rbd-10.2.5-4.el7.x86_64                          21/111
    node1:  
    node1:   Updating   : libcurl-7.29.0-51.el7.x86_64                              22/111
    node1:  
    node1:   Installing : redhat-lsb-submod-security-4.1-27.el7.centos.1.x86_64     23/111
    node1:  
    node1:   Installing : mailx-12.5-19.el7.x86_64                                  24/111
    node1:  
    node1:   Installing : 1:perl-parent-0.225-244.el7.noarch                        25/111
    node1:  
    node1:   Installing : perl-HTTP-Tiny-0.033-3.el7.noarch                         26/111
    node1:  
    node1:   Installing : perl-podlators-2.5.1-3.el7.noarch                         27/111
    node1:  
    node1:   Installing : perl-Pod-Perldoc-3.20-4.el7.noarch                        28/111
    node1:  
    node1:   Installing : 1:perl-Pod-Escapes-1.04-294.el7_6.noarch                  29/111
    node1:  
    node1:   Installing : perl-Text-ParseWords-3.29-4.el7.noarch                    30/111
    node1:  
    node1:   Installing : perl-Encode-2.51-7.el7.x86_64                             31/111
    node1:  
    node1:   Installing : perl-Pod-Usage-1.63-3.el7.noarch                          32/111
    node1:  
    node1:   Installing : 4:perl-libs-5.16.3-294.el7_6.x86_64                       33/111
    node1:  
    node1:   Installing : perl-Socket-2.010-4.el7.x86_64                            34/111
    node1:  
    node1:   Installing : perl-threads-1.87-4.el7.x86_64                            35/111
    node1:  
    node1:   Installing : perl-Storable-2.45-3.el7.x86_64                           36/111
    node1:  
    node1:   Installing : perl-Carp-1.26-244.el7.noarch                             37/111
    node1:  
    node1:   Installing : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                     38/111
    node1:  
    node1:   Installing : perl-Filter-1.49-3.el7.x86_64                             39/111
    node1:  
    node1:   Installing : perl-Exporter-5.68-3.el7.noarch                           40/111
    node1:  
    node1:   Installing : perl-constant-1.27-2.el7.noarch                           41/111
    node1:  
    node1:   Installing : perl-Time-Local-1.2300-2.el7.noarch                       42/111
    node1:  
    node1:   Installing : 4:perl-macros-5.16.3-294.el7_6.x86_64                     43/111
    node1:  
    node1:   Installing : perl-threads-shared-1.43-6.el7.x86_64                     44/111
    node1:  
    node1:   Installing : perl-File-Temp-0.23.01-3.el7.noarch                       45/111
    node1:  
    node1:   Installing : perl-File-Path-2.09-2.el7.noarch                          46/111
    node1:  
    node1:   Installing : perl-PathTools-3.40-5.el7.x86_64                          47/111
    node1:  
    node1:   Installing : perl-Scalar-List-Utils-1.27-248.el7.x86_64                48/111
    node1:  
    node1:   Installing : 1:perl-Pod-Simple-3.28-4.el7.noarch                       49/111
    node1:  
    node1:   Installing : perl-Getopt-Long-2.40-3.el7.noarch                        50/111
    node1:  
    node1:   Installing : 4:perl-5.16.3-294.el7_6.x86_64                            51/111
    node1:  
    node1:   Installing : gdisk-0.8.10-2.el7.x86_64                                 52/111
    node1:  
    node1:   Installing : spax-1.5.2-13.el7.x86_64                                  53/111
    node1:  
    node1:   Installing : json-c-0.11-4.el7_0.x86_64                                54/111
    node1:  
    node1:   Updating   : cryptsetup-libs-2.0.3-3.el7.x86_64                        55/111
    node1:  
    node1:   Installing : cryptsetup-2.0.3-3.el7.x86_64                             56/111
    node1:  
    node1:   Installing : python-six-1.9.0-2.el7.noarch                             57/111
    node1:  
    node1:   Installing : ntpdate-4.2.6p5-28.el7.centos.x86_64                      58/111
    node1:  
    node1:   Installing : hdparm-9.43-5.el7.x86_64                                  59/111
    node1:  
    node1:   Installing : libnetfilter_queue-1.0.2-2.el7_2.x86_64                   60/111
    node1:  
    node1:   Installing : time-1.7-45.el7.x86_64                                    61/111
    node1:  
    node1:   Installing : 14:libpcap-1.5.3-11.el7.x86_64                            62/111
    node1:  
    node1:   Installing : patch-2.7.1-10.el7_5.x86_64                               63/111
    node1:  
    node1:   Installing : libicu-50.1.2-17.el7.x86_64                               64/111
    node1:  
    node1:   Installing : boost-regex-1.53.0-27.el7.x86_64                          65/111
    node1:  
    node1:   Installing : boost-program-options-1.53.0-27.el7.x86_64                66/111
    node1:  
    node1:   Installing : bc-1.06.95-13.el7.x86_64                                  67/111
    node1:  
    node1:   Installing : m4-1.4.16-10.el7.x86_64                                   68/111
    node1:  
    node1:   Installing : 2:vim-filesystem-7.4.160-5.el7.x86_64                     69/111
    node1:  
    node1:   Installing : 2:vim-common-7.4.160-5.el7.x86_64                         70/111
    node1:  
    node1:   Installing : ed-1.9-4.el7.x86_64                                       71/111
    node1:  
    node1:   Installing : psmisc-22.20-15.el7.x86_64                                72/111
    node1:  
    node1:   Installing : autogen-libopts-5.18-5.el7.x86_64                         73/111
    node1:  
    node1:   Installing : python-backports-1.0-8.el7.x86_64                         74/111
    node1:  
    node1:   Installing : python-backports-ssl_match_hostname-3.5.0.1-1.el7.noar    75/111
    node1:  
    node1:   Installing : python-urllib3-1.10.2-5.el7.noarch                        76/111
    node1:  
    node1:   Installing : python-requests-2.6.0-1.el7_1.noarch                      77/111
    node1:  
    node1:   Installing : at-3.1.13-24.el7.x86_64                                   78/111
    node1:  
    node1:   Installing : redhat-lsb-core-4.1-27.el7.centos.1.x86_64                79/111
    node1:  
    node1:   Installing : gpm-libs-1.20.7-5.el7.x86_64                              80/111
    node1:  
    node1:   Installing : libnetfilter_cthelper-1.0.0-9.el7.x86_64                  81/111
    node1:  
    node1:   Installing : libnetfilter_cttimeout-1.0.0-6.el7.x86_64                 82/111
    node1:  
    node1:   Installing : conntrack-tools-1.4.4-4.el7.x86_64                        83/111
    node1:  
    node1:   Installing : 2:vim-enhanced-7.4.160-5.el7.x86_64                       84/111
    node1:  
    node1:   Installing : 1:ceph-common-10.2.5-4.el7.x86_64                         85/111
    node1:  
    node1:   Installing : ntp-4.2.6p5-28.el7.centos.x86_64                          86/111
    node1:  
    node1:   Installing : 14:tcpdump-4.9.2-3.el7.x86_64                             87/111
    node1:  
    node1:   Updating   : curl-7.29.0-51.el7.x86_64                                 88/111
    node1:  
    node1:   Updating   : nss-tools-3.36.0-7.1.el7_6.x86_64                         89/111
    node1:  
    node1:   Installing : 32:bind-utils-9.9.4-73.el7_6.x86_64                       90/111
    node1:  
    node1:   Updating   : 32:bind-libs-lite-9.9.4-73.el7_6.x86_64                   91/111
    node1:  
    node1:   Installing : net-tools-2.0-0.24.20131004git.el7.x86_64                 92/111
    node1:  
    node1:   Installing : wget-1.14-18.el7.x86_64                                   93/111
    node1:  
    node1:   Updating   : kmod-20-23.el7.x86_64                                     94/111
    node1:  
    node1:   Installing : dos2unix-6.0.3-7.el7.x86_64                               95/111
    node1:  
    node1:   Installing : socat-1.7.3.2-2.el7.x86_64                                96/111
    node1:  
    node1:   Installing : 1:telnet-0.17-64.el7.x86_64                               97/111
    node1:  
    node1:   Cleanup    : nss-tools-3.28.4-15.el7_4.x86_64                          98/111
    node1:  
    node1:   Cleanup    : curl-7.29.0-42.el7_4.1.x86_64                             99/111
    node1:  
    node1:   Cleanup    : libcurl-7.29.0-42.el7_4.1.x86_64                         100/111
    node1:  
    node1:   Cleanup    : nss-pem-1.0.3-4.el7.x86_64                               101/111
    node1:  
    node1:   Cleanup    : nss-sysinit-3.28.4-15.el7_4.x86_64                       102/111
    node1:  
    node1:   Cleanup    : nss-3.28.4-15.el7_4.x86_64                               103/111
    node1:  
    node1:   Cleanup    : nss-softokn-3.28.3-8.el7_4.x86_64                        104/111
    node1:  
    node1:   Cleanup    : nss-util-3.28.4-3.el7.x86_64                             105/111
    node1:  
    node1:   Cleanup    : nss-softokn-freebl-3.28.3-8.el7_4.x86_64                 106/111
    node1:  
    node1:   Cleanup    : 32:bind-libs-lite-9.9.4-51.el7_4.2.x86_64                107/111
    node1:  
    node1:   Cleanup    : 32:bind-license-9.9.4-51.el7_4.2.noarch                  108/111
    node1:  
    node1:   Cleanup    : nspr-4.13.1-1.0.el7_3.x86_64                             109/111
    node1:  
    node1:   Cleanup    : kmod-20-15.el7_4.6.x86_64                                110/111
    node1:  
    node1:   Cleanup    : cryptsetup-libs-1.7.4-3.el7_4.1.x86_64                   111/111
    node1:  
    node1:   Verifying  : 1:librbd1-10.2.5-4.el7.x86_64                              1/111
    node1:  
    node1:   Verifying  : perl-HTTP-Tiny-0.033-3.el7.noarch                          2/111
    node1:  
    node1:   Verifying  : libnetfilter_cttimeout-1.0.0-6.el7.x86_64                  3/111
    node1:  
    node1:   Verifying  : libnetfilter_cthelper-1.0.0-9.el7.x86_64                   4/111
    node1:  
    node1:   Verifying  : libcurl-7.29.0-51.el7.x86_64                               5/111
    node1:  
    node1:   Verifying  : conntrack-tools-1.4.4-4.el7.x86_64                         6/111
    node1:  
    node1:   Verifying  : python-backports-ssl_match_hostname-3.5.0.1-1.el7.noar     7/111
    node1:  
    node1:   Verifying  : 1:telnet-0.17-64.el7.x86_64                                8/111
    node1:  
    node1:   Verifying  : perl-File-Temp-0.23.01-3.el7.noarch                        9/111
    node1:  
    node1:   Verifying  : boost-thread-1.53.0-27.el7.x86_64                         10/111
    node1:  
    node1:   Verifying  : gpm-libs-1.20.7-5.el7.x86_64                              11/111
    node1:  
    node1:   Verifying  : 2:vim-common-7.4.160-5.el7.x86_64                         12/111
    node1:  
    node1:   Verifying  : perl-Socket-2.010-4.el7.x86_64                            13/111
    node1:  
    node1:   Verifying  : boost-iostreams-1.53.0-27.el7.x86_64                      14/111
    node1:  
    node1:   Verifying  : boost-regex-1.53.0-27.el7.x86_64                          15/111
    node1:  
    node1:   Verifying  : 1:python-rbd-10.2.5-4.el7.x86_64                          16/111
    node1:  
    node1:   Verifying  : at-3.1.13-24.el7.x86_64                                   17/111
    node1:  
    node1:   Verifying  : python-backports-1.0-8.el7.x86_64                         18/111
    node1:  
    node1:   Verifying  : perl-File-Path-2.09-2.el7.noarch                          19/111
    node1:  
    node1:   Verifying  : python-ipaddress-1.0.16-2.el7.noarch                      20/111
    node1:  
    node1:   Verifying  : perl-Text-ParseWords-3.29-4.el7.noarch                    21/111
    node1:  
    node1:   Verifying  : socat-1.7.3.2-2.el7.x86_64                                22/111
    node1:  
    node1:   Verifying  : boost-system-1.53.0-27.el7.x86_64                         23/111
    node1:  
    node1:   Verifying  : redhat-lsb-submod-security-4.1-27.el7.centos.1.x86_64     24/111
    node1:  
    node1:   Verifying  : nss-tools-3.36.0-7.1.el7_6.x86_64                         25/111
    node1:  
    node1:   Verifying  : autogen-libopts-5.18-5.el7.x86_64                         26/111
    node1:  
    node1:   Verifying  : 4:perl-libs-5.16.3-294.el7_6.x86_64                       27/111
    node1:  
    node1:   Verifying  : nss-sysinit-3.36.0-7.1.el7_6.x86_64                       28/111
    node1:  
    node1:   Verifying  : 1:python-rados-10.2.5-4.el7.x86_64                        29/111
    node1:  
    node1:   Verifying  : psmisc-22.20-15.el7.x86_64                                30/111
    node1:  
    node1:   Verifying  : python-urllib3-1.10.2-5.el7.noarch                        31/111
    node1:  
    node1:   Verifying  : nss-3.36.0-7.1.el7_6.x86_64                               32/111
    node1:  
    node1:   Verifying  : cryptsetup-libs-2.0.3-3.el7.x86_64                        33/111
    node1:  
    node1:   Verifying  : 32:bind-utils-9.9.4-73.el7_6.x86_64                       34/111
    node1:  
    node1:   Verifying  : perl-Pod-Usage-1.63-3.el7.noarch                          35/111
    node1:  
    node1:   Verifying  : perl-threads-1.87-4.el7.x86_64                            36/111
    node1:  
    node1:   Verifying  : perl-Getopt-Long-2.40-3.el7.noarch                        37/111
    node1:  
    node1:   Verifying  : ed-1.9-4.el7.x86_64                                       38/111
    node1:  
    node1:   Verifying  : redhat-lsb-core-4.1-27.el7.centos.1.x86_64                39/111
    node1:  
    node1:   Verifying  : 2:vim-filesystem-7.4.160-5.el7.x86_64                     40/111
    node1:  
    node1:   Verifying  : dos2unix-6.0.3-7.el7.x86_64                               41/111
    node1:  
    node1:   Verifying  : 2:vim-enhanced-7.4.160-5.el7.x86_64                       42/111
    node1:  
    node1:   Verifying  : perl-threads-shared-1.43-6.el7.x86_64                     43/111
    node1:  
    node1:   Verifying  : perl-Storable-2.45-3.el7.x86_64                           44/111
    node1:  
    node1:   Verifying  : 1:perl-Pod-Escapes-1.04-294.el7_6.noarch                  45/111
    node1:  
    node1:   Verifying  : m4-1.4.16-10.el7.x86_64                                   46/111
    node1:  
    node1:   Verifying  : bc-1.06.95-13.el7.x86_64                                  47/111
    node1:  
    node1:   Verifying  : 1:perl-parent-0.225-244.el7.noarch                        48/111
    node1:  
    node1:   Verifying  : avahi-libs-0.6.31-19.el7.x86_64                           49/111
    node1:  
    node1:   Verifying  : ntp-4.2.6p5-28.el7.centos.x86_64                          50/111
    node1:  
    node1:   Verifying  : 14:tcpdump-4.9.2-3.el7.x86_64                             51/111
    node1:  
    node1:   Verifying  : boost-program-options-1.53.0-27.el7.x86_64                52/111
    node1:  
    node1:   Verifying  : 4:perl-5.16.3-294.el7_6.x86_64                            53/111
    node1:  
    node1:   Verifying  : perl-Encode-2.51-7.el7.x86_64                             54/111
    node1:  
    node1:   Verifying  : perl-Carp-1.26-244.el7.noarch                             55/111
    node1:  
    node1:   Verifying  : kmod-20-23.el7.x86_64                                     56/111
    node1:  
    node1:   Verifying  : libicu-50.1.2-17.el7.x86_64                               57/111
    node1:  
    node1:   Verifying  : wget-1.14-18.el7.x86_64                                   58/111
    node1:  
    node1:   Verifying  : patch-2.7.1-10.el7_5.x86_64                               59/111
    node1:  
    node1:   Verifying  : 14:libpcap-1.5.3-11.el7.x86_64                            60/111
    node1:  
    node1:   Verifying  : perl-Pod-Perldoc-3.20-4.el7.noarch                        61/111
    node1:  
    node1:   Verifying  : nss-softokn-freebl-3.36.0-5.el7_5.x86_64                  62/111
    node1:  
    node1:   Verifying  : time-1.7-45.el7.x86_64                                    63/111
    node1:  
    node1:   Verifying  : nspr-4.19.0-1.el7_5.x86_64                                64/111
    node1:  
    node1:   Verifying  : 32:bind-libs-9.9.4-73.el7_6.x86_64                        65/111
    node1:  
    node1:   Verifying  : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                     66/111
    node1:  
    node1:   Verifying  : perl-Filter-1.49-3.el7.x86_64                             67/111
    node1:  
    node1:   Verifying  : mailx-12.5-19.el7.x86_64                                  68/111
    node1:  
    node1:   Verifying  : nss-softokn-3.36.0-5.el7_5.x86_64                         69/111
    node1:  
    node1:   Verifying  : 32:bind-license-9.9.4-73.el7_6.noarch                     70/111
    node1:  
    node1:   Verifying  : libnetfilter_queue-1.0.2-2.el7_2.x86_64                   71/111
    node1:  
    node1:   Verifying  : perl-Exporter-5.68-3.el7.noarch                           72/111
    node1:  
    node1:   Verifying  : perl-constant-1.27-2.el7.noarch                           73/111
    node1:  
    node1:   Verifying  : perl-PathTools-3.40-5.el7.x86_64                          74/111
    node1:  
    node1:   Verifying  : 1:ceph-common-10.2.5-4.el7.x86_64                         75/111
    node1:  
    node1:   Verifying  : hdparm-9.43-5.el7.x86_64                                  76/111
    node1:  
    node1:   Verifying  : nss-util-3.36.0-1.1.el7_6.x86_64                          77/111
    node1:  
    node1:   Verifying  : cryptsetup-2.0.3-3.el7.x86_64                             78/111
    node1:  
    node1:   Verifying  : ntpdate-4.2.6p5-28.el7.centos.x86_64                      79/111
    node1:  
    node1:   Verifying  : nss-pem-1.0.3-5.el7.x86_64                                80/111
    node1:  
    node1:   Verifying  : 32:bind-libs-lite-9.9.4-73.el7_6.x86_64                   81/111
    node1:  
    node1:   Verifying  : 1:perl-Pod-Simple-3.28-4.el7.noarch                       82/111
    node1:  
    node1:   Verifying  : perl-Time-Local-1.2300-2.el7.noarch                       83/111
    node1:  
    node1:   Verifying  : boost-random-1.53.0-27.el7.x86_64                         84/111
    node1:  
    node1:   Verifying  : python-six-1.9.0-2.el7.noarch                             85/111
    node1:  
    node1:   Verifying  : 4:perl-macros-5.16.3-294.el7_6.x86_64                     86/111
    node1:  
    node1:   Verifying  : json-c-0.11-4.el7_0.x86_64                                87/111
    node1:  
    node1:   Verifying  : net-tools-2.0-0.24.20131004git.el7.x86_64                 88/111
    node1:  
    node1:   Verifying  : 1:librados2-10.2.5-4.el7.x86_64                           89/111
    node1:  
    node1:   Verifying  : perl-Scalar-List-Utils-1.27-248.el7.x86_64                90/111
    node1:  
    node1:   Verifying  : 1:cups-client-1.6.3-35.el7.x86_64                         91/111
    node1:  
    node1:   Verifying  : 1:cups-libs-1.6.3-35.el7.x86_64                           92/111
    node1:  
    node1:   Verifying  : perl-podlators-2.5.1-3.el7.noarch                         93/111
    node1:  
    node1:   Verifying  : python-requests-2.6.0-1.el7_1.noarch                      94/111
    node1:  
    node1:   Verifying  : spax-1.5.2-13.el7.x86_64                                  95/111
    node1:  
    node1:   Verifying  : curl-7.29.0-51.el7.x86_64                                 96/111
    node1:  
    node1:   Verifying  : gdisk-0.8.10-2.el7.x86_64                                 97/111
    node1:  
    node1:   Verifying  : nss-util-3.28.4-3.el7.x86_64                              98/111 
    node1:   Verifying  : nss-sysinit-3.28.4-15.el7_4.x86_64                        99/111 
    node1:   Verifying  : kmod-20-15.el7_4.6.x86_64                                100/111 
    node1:   Verifying  : cryptsetup-libs-1.7.4-3.el7_4.1.x86_64                   101/111 
    node1:   Verifying  : 32:bind-libs-lite-9.9.4-51.el7_4.2.x86_64                102/111 
    node1:   Verifying  : 32:bind-license-9.9.4-51.el7_4.2.noarch                  103/111 
    node1:   Verifying  : libcurl-7.29.0-42.el7_4.1.x86_64                         104/111 
    node1:   Verifying  : nss-softokn-freebl-3.28.3-8.el7_4.x86_64                 105/111 
    node1:   Verifying  : nspr-4.13.1-1.0.el7_3.x86_64                             106/111 
    node1:   Verifying  : nss-pem-1.0.3-4.el7.x86_64                               107/111 
    node1:   Verifying  : curl-7.29.0-42.el7_4.1.x86_64                            108/111
    node1:  
    node1:   Verifying  : nss-tools-3.28.4-15.el7_4.x86_64                         109/111 
    node1:   Verifying  : nss-softokn-3.28.3-8.el7_4.x86_64                        110/111 
    node1:   Verifying  : nss-3.28.4-15.el7_4.x86_64                               111/111
    node1:  
    node1: 
    node1: Installed:
    node1:   bind-utils.x86_64 32:9.9.4-73.el7_6                                           
    node1:   ceph-common.x86_64 1:10.2.5-4.el7                                             
    node1:   conntrack-tools.x86_64 0:1.4.4-4.el7                                          
    node1:   dos2unix.x86_64 0:6.0.3-7.el7                                                 
    node1:   net-tools.x86_64 0:2.0-0.24.20131004git.el7                                   
    node1:   ntp.x86_64 0:4.2.6p5-28.el7.centos                                            
    node1:   socat.x86_64 0:1.7.3.2-2.el7                                                  
    node1:   tcpdump.x86_64 14:4.9.2-3.el7                                                 
    node1:   telnet.x86_64 1:0.17-64.el7                                                   
    node1:   vim-enhanced.x86_64 2:7.4.160-5.el7                                           
    node1:   wget.x86_64 0:1.14-18.el7                                                     
    node1: 
    node1: Dependency Installed:
    node1:   at.x86_64 0:3.1.13-24.el7                                                     
    node1:   autogen-libopts.x86_64 0:5.18-5.el7                                           
    node1:   avahi-libs.x86_64 0:0.6.31-19.el7                                             
    node1:   bc.x86_64 0:1.06.95-13.el7                                                    
    node1:   bind-libs.x86_64 32:9.9.4-73.el7_6                                            
    node1:   boost-iostreams.x86_64 0:1.53.0-27.el7                                        
    node1:   boost-program-options.x86_64 0:1.53.0-27.el7                                  
    node1:   boost-random.x86_64 0:1.53.0-27.el7                                           
    node1:   boost-regex.x86_64 0:1.53.0-27.el7                                            
    node1:   boost-system.x86_64 0:1.53.0-27.el7                                           
    node1:   boost-thread.x86_64 0:1.53.0-27.el7                                           
    node1:   cryptsetup.x86_64 0:2.0.3-3.el7                                               
    node1:   cups-client.x86_64 1:1.6.3-35.el7                                             
    node1:   cups-libs.x86_64 1:1.6.3-35.el7                                               
    node1:   ed.x86_64 0:1.9-4.el7                                                         
    node1:   gdisk.x86_64 0:0.8.10-2.el7                                                   
    node1:   gpm-libs.x86_64 0:1.20.7-5.el7                                                
    node1:   hdparm.x86_64 0:9.43-5.el7                                                    
    node1:   json-c.x86_64 0:0.11-4.el7_0                                                  
    node1:   libicu.x86_64 0:50.1.2-17.el7                                                 
    node1:   libnetfilter_cthelper.x86_64 0:1.0.0-9.el7                                    
    node1:   libnetfilter_cttimeout.x86_64 0:1.0.0-6.el7                                   
    node1:   libnetfilter_queue.x86_64 0:1.0.2-2.el7_2                                     
    node1:   libpcap.x86_64 14:1.5.3-11.el7                                                
    node1:   librados2.x86_64 1:10.2.5-4.el7                                               
    node1:   librbd1.x86_64 1:10.2.5-4.el7                                                 
    node1:   m4.x86_64 0:1.4.16-10.el7                                                     
    node1:   mailx.x86_64 0:12.5-19.el7                                                    
    node1:   ntpdate.x86_64 0:4.2.6p5-28.el7.centos                                        
    node1:   patch.x86_64 0:2.7.1-10.el7_5                                                 
    node1:   perl.x86_64 4:5.16.3-294.el7_6                                                
    node1:   perl-Carp.noarch 0:1.26-244.el7                                               
    node1:   perl-Encode.x86_64 0:2.51-7.el7                                               
    node1:   perl-Exporter.noarch 0:5.68-3.el7                                             
    node1:   perl-File-Path.noarch 0:2.09-2.el7                                            
    node1:   perl-File-Temp.noarch 0:0.23.01-3.el7                                         
    node1:   perl-Filter.x86_64 0:1.49-3.el7                                               
    node1:   perl-Getopt-Long.noarch 0:2.40-3.el7                                          
    node1:   perl-HTTP-Tiny.noarch 0:0.033-3.el7                                           
    node1:   perl-PathTools.x86_64 0:3.40-5.el7                                            
    node1:   perl-Pod-Escapes.noarch 1:1.04-294.el7_6                                      
    node1:   perl-Pod-Perldoc.noarch 0:3.20-4.el7                                          
    node1:   perl-Pod-Simple.noarch 1:3.28-4.el7                                           
    node1:   perl-Pod-Usage.noarch 0:1.63-3.el7                                            
    node1:   perl-Scalar-List-Utils.x86_64 0:1.27-248.el7                                  
    node1:   perl-Socket.x86_64 0:2.010-4.el7                                              
    node1:   perl-Storable.x86_64 0:2.45-3.el7                                             
    node1:   perl-Text-ParseWords.noarch 0:3.29-4.el7                                      
    node1:   perl-Time-HiRes.x86_64 4:1.9725-3.el7                                         
    node1:   perl-Time-Local.noarch 0:1.2300-2.el7                                         
    node1:   perl-constant.noarch 0:1.27-2.el7                                             
    node1:   perl-libs.x86_64 4:5.16.3-294.el7_6                                           
    node1:   perl-macros.x86_64 4:5.16.3-294.el7_6                                         
    node1:   perl-parent.noarch 1:0.225-244.el7                                            
    node1:   perl-podlators.noarch 0:2.5.1-3.el7                                           
    node1:   perl-threads.x86_64 0:1.87-4.el7                                              
    node1:   perl-threads-shared.x86_64 0:1.43-6.el7                                       
    node1:   psmisc.x86_64 0:22.20-15.el7                                                  
    node1:   python-backports.x86_64 0:1.0-8.el7                                           
    node1:   python-backports-ssl_match_hostname.noarch 0:3.5.0.1-1.el7                    
    node1:   python-ipaddress.noarch 0:1.0.16-2.el7                                        
    node1:   python-rados.x86_64 1:10.2.5-4.el7                                            
    node1:   python-rbd.x86_64 1:10.2.5-4.el7                                              
    node1:   python-requests.noarch 0:2.6.0-1.el7_1                                        
    node1:   python-six.noarch 0:1.9.0-2.el7                                               
    node1:   python-urllib3.noarch 0:1.10.2-5.el7                                          
    node1:   redhat-lsb-core.x86_64 0:4.1-27.el7.centos.1                                  
    node1:   redhat-lsb-submod-security.x86_64 0:4.1-27.el7.centos.1                       
    node1:   spax.x86_64 0:1.5.2-13.el7                                                    
    node1:   time.x86_64 0:1.7-45.el7                                                      
    node1:   vim-common.x86_64 2:7.4.160-5.el7                                             
    node1:   vim-filesystem.x86_64 2:7.4.160-5.el7                                         
    node1: 
    node1: Updated:
    node1:   curl.x86_64 0:7.29.0-51.el7              kmod.x86_64 0:20-23.el7             
    node1: 
    node1: Dependency Updated:
    node1:   bind-libs-lite.x86_64 32:9.9.4-73.el7_6                                       
    node1:   bind-license.noarch 32:9.9.4-73.el7_6                                         
    node1:   cryptsetup-libs.x86_64 0:2.0.3-3.el7                                          
    node1:   libcurl.x86_64 0:7.29.0-51.el7                                                
    node1:   nspr.x86_64 0:4.19.0-1.el7_5                                                  
    node1:   nss.x86_64 0:3.36.0-7.1.el7_6                                                 
    node1:   nss-pem.x86_64 0:1.0.3-5.el7                                                  
    node1:   nss-softokn.x86_64 0:3.36.0-5.el7_5                                           
    node1:   nss-softokn-freebl.x86_64 0:3.36.0-5.el7_5                                    
    node1:   nss-sysinit.x86_64 0:3.36.0-7.1.el7_6                                         
    node1:   nss-tools.x86_64 0:3.36.0-7.1.el7_6                                           
    node1:   nss-util.x86_64 0:3.36.0-1.1.el7_6                                            
    node1: 
    node1: Complete!
    node1: --2019-02-17 14:25:26--  https://storage.googleapis.com/kubernetes-release/release/v1.11.0/kubernetes-server-linux-amd64.tar.gz
    node1: Resolving storage.googleapis.com (storage.googleapis.com)... 
    node1: 172.217.24.48, 2404:6800:4012:1::2010
    node1: Connecting to storage.googleapis.com (storage.googleapis.com)|172.217.24.48|:443... 
    node1: connected.
    node1: HTTP request sent, awaiting response... 
    node1: 200 OK
    node1: Length: 435331139 (415M) [application/x-tar]
    node1: Saving to: ‘/vagrant/kubernetes-server-linux-amd64.tar.gz’
    node1: 
    node1:      0K .
    node1: ...
    node1: .
    node1: ...
    node1: .. .
    node1: .
    node1:                                            0% 95.1 =2m15s
    node1: 2019-02-17 14:42:53 (95.1 B/s) - Read error at byte 12844/435331139 (Connection timed out). Retrying.
    node1: --2019-02-17 14:42:54--  (try: 2)  https://storage.googleapis.com/kubernetes-release/release/v1.11.0/kubernetes-server-linux-amd64.tar.gz
    node1: Connecting to storage.googleapis.com (storage.googleapis.com)|172.217.24.48|:443... 
    node1: connected.
    node1: Unable to establish SSL connection.
    node1: sync time
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/ntpd.service to /usr/lib/systemd/system/ntpd.service.
    node1: disable selinux
    node1: enable iptable kernel parameter
    node1: net.ipv4.ip_forward = 1
    node1: set host name resolution
    node1: 127.0.0.1	node1	node1
    node1: 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
    node1: ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
    node1: 172.17.8.101 node1
    node1: 172.17.8.102 node2
    node1: 172.17.8.103 node3
    node1: set nameserver
    node1: nameserver 8.8.8.8
    node1: disable swap
    node1: Loaded plugins: fastestmirror
    node1: Loading mirror speeds from cached hostfile
    node1: Resolving Dependencies
    node1: --> Running transaction check
    node1: ---> Package docker.x86_64 2:1.13.1-91.git07f3374.el7.centos will be installed
    node1: --> Processing Dependency: docker-common = 2:1.13.1-91.git07f3374.el7.centos for package: 2:docker-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: docker-client = 2:1.13.1-91.git07f3374.el7.centos for package: 2:docker-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: subscription-manager-rhsm-certificates for package: 2:docker-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Running transaction check
    node1: ---> Package docker-client.x86_64 2:1.13.1-91.git07f3374.el7.centos will be installed
    node1: ---> Package docker-common.x86_64 2:1.13.1-91.git07f3374.el7.centos will be installed
    node1: --> Processing Dependency: skopeo-containers >= 1:0.1.26-2 for package: 2:docker-common-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: oci-umount >= 2:2.3.3-3 for package: 2:docker-common-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: oci-systemd-hook >= 1:0.1.4-9 for package: 2:docker-common-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: oci-register-machine >= 1:0-5.13 for package: 2:docker-common-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: container-storage-setup >= 0.9.0-1 for package: 2:docker-common-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: container-selinux >= 2:2.51-1 for package: 2:docker-common-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: --> Processing Dependency: atomic-registries for package: 2:docker-common-1.13.1-91.git07f3374.el7.centos.x86_64
    node1: ---> Package subscription-manager-rhsm-certificates.x86_64 0:1.21.10-3.el7.centos will be installed
    node1: --> Running transaction check
    node1: ---> Package atomic-registries.x86_64 1:1.22.1-26.gitb507039.el7.centos will be installed
    node1: --> Processing Dependency: python-yaml for package: 1:atomic-registries-1.22.1-26.gitb507039.el7.centos.x86_64
    node1: --> Processing Dependency: python-setuptools for package: 1:atomic-registries-1.22.1-26.gitb507039.el7.centos.x86_64
    node1: --> Processing Dependency: python-pytoml for package: 1:atomic-registries-1.22.1-26.gitb507039.el7.centos.x86_64
    node1: ---> Package container-selinux.noarch 2:2.74-1.el7 will be installed
    node1: --> Processing Dependency: selinux-policy-targeted >= 3.13.1-216.el7 for package: 2:container-selinux-2.74-1.el7.noarch
    node1: --> Processing Dependency: selinux-policy-base >= 3.13.1-216.el7 for package: 2:container-selinux-2.74-1.el7.noarch
    node1: --> Processing Dependency: selinux-policy >= 3.13.1-216.el7 for package: 2:container-selinux-2.74-1.el7.noarch
    node1: --> Processing Dependency: policycoreutils-python for package: 2:container-selinux-2.74-1.el7.noarch
    node1: ---> Package container-storage-setup.noarch 0:0.11.0-2.git5eaf76c.el7 will be installed
    node1: ---> Package containers-common.x86_64 1:0.1.31-8.gitb0b750d.el7.centos will be installed
    node1: ---> Package oci-register-machine.x86_64 1:0-6.git2b44233.el7 will be installed
    node1: ---> Package oci-systemd-hook.x86_64 1:0.1.18-3.git8787307.el7_6 will be installed
    node1: --> Processing Dependency: libyajl.so.2()(64bit) for package: 1:oci-systemd-hook-0.1.18-3.git8787307.el7_6.x86_64
    node1: ---> Package oci-umount.x86_64 2:2.3.4-2.git87f9237.el7 will be installed
    node1: --> Running transaction check
    node1: ---> Package PyYAML.x86_64 0:3.10-11.el7 will be installed
    node1: --> Processing Dependency: libyaml-0.so.2()(64bit) for package: PyYAML-3.10-11.el7.x86_64
    node1: ---> Package policycoreutils-python.x86_64 0:2.5-29.el7_6.1 will be installed
    node1: --> Processing Dependency: policycoreutils = 2.5-29.el7_6.1 for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: setools-libs >= 3.3.8-4 for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: libsemanage-python >= 2.5-14 for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: audit-libs-python >= 2.1.3-4 for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: python-IPy for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: libqpol.so.1(VERS_1.4)(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: libqpol.so.1(VERS_1.2)(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: libcgroup for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: libapol.so.4(VERS_4.0)(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: checkpolicy for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: libqpol.so.1()(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: --> Processing Dependency: libapol.so.4()(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    node1: ---> Package python-pytoml.noarch 0:0.1.14-1.git7dea353.el7 will be installed
    node1: ---> Package python-setuptools.noarch 0:0.9.8-7.el7 will be installed
    node1: ---> Package selinux-policy.noarch 0:3.13.1-166.el7_4.7 will be updated
    node1: ---> Package selinux-policy.noarch 0:3.13.1-229.el7_6.9 will be an update
    node1: --> Processing Dependency: libsemanage >= 2.5-13 for package: selinux-policy-3.13.1-229.el7_6.9.noarch
    node1: ---> Package selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.7 will be updated
    node1: ---> Package selinux-policy-targeted.noarch 0:3.13.1-229.el7_6.9 will be an update
    node1: ---> Package yajl.x86_64 0:2.0.4-4.el7 will be installed
    node1: --> Running transaction check
    node1: ---> Package audit-libs-python.x86_64 0:2.8.4-4.el7 will be installed
    node1: --> Processing Dependency: audit-libs(x86-64) = 2.8.4-4.el7 for package: audit-libs-python-2.8.4-4.el7.x86_64
    node1: ---> Package checkpolicy.x86_64 0:2.5-8.el7 will be installed
    node1: ---> Package libcgroup.x86_64 0:0.41-20.el7 will be installed
    node1: ---> Package libsemanage.x86_64 0:2.5-8.el7 will be updated
    node1: ---> Package libsemanage.x86_64 0:2.5-14.el7 will be an update
    node1: --> Processing Dependency: libsepol >= 2.5-10 for package: libsemanage-2.5-14.el7.x86_64
    node1: --> Processing Dependency: libselinux >= 2.5-14 for package: libsemanage-2.5-14.el7.x86_64
    node1: ---> Package libsemanage-python.x86_64 0:2.5-14.el7 will be installed
    node1: ---> Package libyaml.x86_64 0:0.1.4-11.el7_0 will be installed
    node1: ---> Package policycoreutils.x86_64 0:2.5-17.1.el7 will be updated
    node1: ---> Package policycoreutils.x86_64 0:2.5-29.el7_6.1 will be an update
    node1: --> Processing Dependency: libselinux-utils >= 2.5-14 for package: policycoreutils-2.5-29.el7_6.1.x86_64
    node1: ---> Package python-IPy.noarch 0:0.75-6.el7 will be installed
    node1: ---> Package setools-libs.x86_64 0:3.3.8-4.el7 will be installed
    node1: --> Running transaction check
    node1: ---> Package audit-libs.x86_64 0:2.7.6-3.el7 will be updated
    node1: --> Processing Dependency: audit-libs(x86-64) = 2.7.6-3.el7 for package: audit-2.7.6-3.el7.x86_64
    node1: ---> Package audit-libs.x86_64 0:2.8.4-4.el7 will be an update
    node1: ---> Package libselinux.x86_64 0:2.5-11.el7 will be updated
    node1: --> Processing Dependency: libselinux(x86-64) = 2.5-11.el7 for package: libselinux-python-2.5-11.el7.x86_64
    node1: ---> Package libselinux.x86_64 0:2.5-14.1.el7 will be an update
    node1: ---> Package libselinux-utils.x86_64 0:2.5-11.el7 will be updated
    node1: ---> Package libselinux-utils.x86_64 0:2.5-14.1.el7 will be an update
    node1: ---> Package libsepol.x86_64 0:2.5-6.el7 will be updated
    node1: ---> Package libsepol.x86_64 0:2.5-10.el7 will be an update
    node1: --> Running transaction check
    node1: ---> Package audit.x86_64 0:2.7.6-3.el7 will be updated
    node1: ---> Package audit.x86_64 0:2.8.4-4.el7 will be an update
    node1: ---> Package libselinux-python.x86_64 0:2.5-11.el7 will be updated
    node1: ---> Package libselinux-python.x86_64 0:2.5-14.1.el7 will be an update
    node1: --> Finished Dependency Resolution
    node1: 
    node1: Dependencies Resolved
    node1: 
    node1: ================================================================================
    node1:  Package                 Arch   Version                           Repository
    node1:                                                                            Size
    node1: ================================================================================
    node1: Installing:
    node1:  docker                  x86_64 2:1.13.1-91.git07f3374.el7.centos extras   18 M
    node1: Installing for dependencies:
    node1:  PyYAML                  x86_64 3.10-11.el7                       base    153 k
    node1:  atomic-registries       x86_64 1:1.22.1-26.gitb507039.el7.centos extras   35 k
    node1:  audit-libs-python       x86_64 2.8.4-4.el7                       base     76 k
    node1:  checkpolicy             x86_64 2.5-8.el7                         base    295 k
    node1:  container-selinux       noarch 2:2.74-1.el7                      extras   38 k
    node1:  container-storage-setup noarch 0.11.0-2.git5eaf76c.el7           extras   35 k
    node1:  containers-common       x86_64 1:0.1.31-8.gitb0b750d.el7.centos  extras   21 k
    node1:  docker-client           x86_64 2:1.13.1-91.git07f3374.el7.centos extras  3.9 M
    node1:  docker-common           x86_64 2:1.13.1-91.git07f3374.el7.centos extras   95 k
    node1:  libcgroup               x86_64 0.41-20.el7                       base     66 k
    node1:  libsemanage-python      x86_64 2.5-14.el7                        base    113 k
    node1:  libyaml                 x86_64 0.1.4-11.el7_0                    base     55 k
    node1:  oci-register-machine    x86_64 1:0-6.git2b44233.el7              extras  1.1 M
    node1:  oci-systemd-hook        x86_64 1:0.1.18-3.git8787307.el7_6       extras   34 k
    node1:  oci-umount              x86_64 2:2.3.4-2.git87f9237.el7          extras   32 k
    node1:  policycoreutils-python  x86_64 2.5-29.el7_6.1                    updates 456 k
    node1:  python-IPy              noarch 0.75-6.el7                        base     32 k
    node1:  python-pytoml           noarch 0.1.14-1.git7dea353.el7           extras   18 k
    node1:  python-setuptools       noarch 0.9.8-7.el7                       base    397 k
    node1:  setools-libs            x86_64 3.3.8-4.el7                       base    620 k
    node1:  subscription-manager-rhsm-certificates
    node1:                          x86_64 1.21.10-3.el7.centos              updates 207 k
    node1:  yajl                    x86_64 2.0.4-4.el7                       base     39 k
    node1: Updating for dependencies:
    node1:  audit                   x86_64 2.8.4-4.el7                       base    250 k
    node1:  audit-libs              x86_64 2.8.4-4.el7                       base    100 k
    node1:  libselinux              x86_64 2.5-14.1.el7                      base    162 k
    node1:  libselinux-python       x86_64 2.5-14.1.el7                      base    235 k
    node1:  libselinux-utils        x86_64 2.5-14.1.el7                      base    151 k
    node1:  libsemanage             x86_64 2.5-14.el7                        base    151 k
    node1:  libsepol                x86_64 2.5-10.el7                        base    297 k
    node1:  policycoreutils         x86_64 2.5-29.el7_6.1                    updates 916 k
    node1:  selinux-policy          noarch 3.13.1-229.el7_6.9                updates 483 k
    node1:  selinux-policy-targeted noarch 3.13.1-229.el7_6.9                updates 6.9 M
    node1: 
    node1: Transaction Summary
    node1: ================================================================================
    node1: Install  1 Package  (+22 Dependent packages)
    node1: Upgrade             ( 10 Dependent packages)
    node1: 
    node1: Total download size: 35 M
    node1: Downloading packages:
    node1: No Presto metadata available for base
    node1: http://mirrors.163.com/centos/7/os/x86_64/Packages/PyYAML-3.10-11.el7.x86_64.rpm: [Errno 14] curl#6 - "Could not resolve host: mirrors.163.com; Unknown error"
    node1: Trying other mirror.
    node1: 
    node1: 
    node1: Error downloading packages:
    node1:   PyYAML-3.10-11.el7.x86_64: [Errno 256] No more mirrors to try.
    node1: Loaded plugins: fastestmirror
    node1: Loading mirror speeds from cached hostfile
    node1: No Match for available package: 2:docker-1.13.1-75.git8633870.el7.centos.x86_64
    node1: No Match for available package: 2:docker-client-1.13.1-75.git8633870.el7.centos.x86_64
    node1: Nothing to do
    node1: No Match for available package: 2:docker-common-1.13.1-75.git8633870.el7.centos.x86_64
    node1: /tmp/vagrant-shell: line 61: /etc/docker/daemon.json: No such file or directory
    node1: Loaded plugins: fastestmirror
    node1: Loading mirror speeds from cached hostfile
    node1: Resolving Dependencies
    node1: --> Running transaction check
    node1: ---> Package etcd.x86_64 0:3.3.11-2.el7.centos will be installed
    node1: --> Finished Dependency Resolution
    node1: 
    node1: Dependencies Resolved
    node1: 
    node1: ================================================================================
    node1:  Package      Arch           Version                       Repository      Size
    node1: ================================================================================
    node1: Installing:
    node1:  etcd         x86_64         3.3.11-2.el7.centos           extras          10 M
    node1: 
    node1: Transaction Summary
    node1: ================================================================================
    node1: Install  1 Package
    node1: 
    node1: Total download size: 10 M
    node1: Installed size: 45 M
    node1: Downloading packages:
    node1: Running transaction check
    node1: Running transaction test
    node1: Transaction test succeeded
    node1: Running transaction
    node1:   Installing : etcd-3.3.11-2.el7.centos.x86_64                              1/1
    node1:  
    node1:   Verifying  : etcd-3.3.11-2.el7.centos.x86_64                              1/1
    node1:  
    node1: 
    node1: Installed:
    node1:   etcd.x86_64 0:3.3.11-2.el7.centos                                             
    node1: 
    node1: Complete!
    node1: #[Member]
    node1: ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
    node1: ETCD_LISTEN_PEER_URLS="http://172.17.8.101:2380"
    node1: ETCD_LISTEN_CLIENT_URLS="http://172.17.8.101:2379,http://localhost:2379"
    node1: ETCD_NAME="node1"
    node1: 
    node1: #[Clustering]
    node1: ETCD_INITIAL_ADVERTISE_PEER_URLS="http://172.17.8.101:2380"
    node1: ETCD_ADVERTISE_CLIENT_URLS="http://172.17.8.101:2379"
    node1: ETCD_INITIAL_CLUSTER="node1=http://172.17.8.101:2380"
    node1: ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
    node1: ETCD_INITIAL_CLUSTER_STATE="new"
    node1: create network config in etcd
    node1: start etcd...
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/etcd.service to /usr/lib/systemd/system/etcd.service.
    node1: create kubernetes ip range for flannel on 172.33.0.0/16
    node1: {"Network":"172.33.0.0/16","SubnetLen":24,"Backend":{"Type":"host-gw"}}
    node1: member 6ae27f9fa2984b1d is healthy: got healthy result from http://172.17.8.101:2379
    node1: cluster is healthy
    node1: /kube-centos
    node1: install flannel...
    node1: Loaded plugins: fastestmirror
    node1: Loading mirror speeds from cached hostfile
    node1: Resolving Dependencies
    node1: --> Running transaction check
    node1: ---> Package flannel.x86_64 0:0.7.1-4.el7 will be installed
    node1: --> Finished Dependency Resolution
    node1: 
    node1: Dependencies Resolved
    node1: 
    node1: ================================================================================
    node1:  Package          Arch            Version                 Repository       Size
    node1: ================================================================================
    node1: Installing:
    node1:  flannel          x86_64          0.7.1-4.el7             extras          7.5 M
    node1: 
    node1: Transaction Summary
    node1: ================================================================================
    node1: Install  1 Package
    node1: 
    node1: Total download size: 7.5 M
    node1: Installed size: 41 M
    node1: Downloading packages:
    node1: Running transaction check
    node1: Running transaction test
    node1: Transaction test succeeded
    node1: Running transaction
    node1:   Installing : flannel-0.7.1-4.el7.x86_64                                   1/1
    node1:  
    node1:   Verifying  : flannel-0.7.1-4.el7.x86_64                                   1/1
    node1:  
    node1: 
    node1: Installed:
    node1:   flannel.x86_64 0:0.7.1-4.el7                                                  
    node1: 
    node1: Complete!
    node1: create flannel config file...
    node1: enable flannel with host-gw backend
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/flanneld.service to /usr/lib/systemd/system/flanneld.service.
    node1: Created symlink from /etc/systemd/system/docker.service.wants/flanneld.service to /usr/lib/systemd/system/flanneld.service.
    node1: enable docker
    node1: Failed to execute operation: No such file or directory
    node1: Failed to start docker.service: Unit not found.
    node1: copy pem, token files
    node1: kubernetes/
    node1: kubernetes/LICENSES
    node1: 
    node1: gzip: stdin: unexpected end of file
    node1: tar: Unexpected EOF in archive
    node1: tar: Unexpected EOF in archive
    node1: tar: kubernetes: Cannot change ownership to uid 0, gid 0: Operation not permitted
    node1: tar: Error is not recoverable: exiting now
    node1: cp: cannot stat ‘/vagrant/kubernetes/server/bin/*’: No such file or directory
    node1: configure master and node1
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/kube-apiserver.service to /usr/lib/systemd/system/kube-apiserver.service.
    node1: Job for kube-apiserver.service failed because the control process exited with error code. See "systemctl status kube-apiserver.service" and "journalctl -xe" for details.
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/kube-controller-manager.service to /usr/lib/systemd/system/kube-controller-manager.service.
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/kube-scheduler.service to /usr/lib/systemd/system/kube-scheduler.service.
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/kubelet.service to /usr/lib/systemd/system/kubelet.service.
    node1: Failed to start kubelet.service: Unit not found.
    node1: Created symlink from /etc/systemd/system/multi-user.target.wants/kube-proxy.service to /usr/lib/systemd/system/kube-proxy.service.
    node1: Configure Kubectl to autocomplete
    node1: /tmp/vagrant-shell: line 214: kubectl: command not found
==> node2: Importing base box 'centos/7'...
==> node2: Matching MAC address for NAT networking...
==> node2: Setting the name of the VM: node2
==> node2: Fixed port collision for 22 => 2222. Now on port 2200.
==> node2: Clearing any previously set network interfaces...
==> node2: Preparing network interfaces based on configuration...
    node2: Adapter 1: nat
    node2: Adapter 2: hostonly
==> node2: Forwarding ports...
    node2: 22 (guest) => 2200 (host) (adapter 1)
==> node2: Running 'pre-boot' VM customizations...
==> node2: Booting VM...
==> node2: Waiting for machine to boot. This may take a few minutes...
    node2: SSH address: 127.0.0.1:2200
    node2: SSH username: vagrant
    node2: SSH auth method: private key
    node2: Warning: Remote connection disconnect. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Remote connection disconnect. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Remote connection disconnect. Retrying...
    node2: 
    node2: Vagrant insecure key detected. Vagrant will automatically replace
    node2: this with a newly generated keypair for better security.
    node2: 
    node2: Inserting generated public key within guest...
    node2: Removing insecure key from the guest if it's present...
    node2: Key inserted! Disconnecting and reconnecting using new SSH key...
==> node2: Machine booted and ready!
==> node2: Checking for guest additions in VM...
    node2: No guest additions were detected on the base box for this VM! Guest
    node2: additions are required for forwarded ports, shared folders, host only
    node2: networking, and more. If SSH fails on this machine, please install
    node2: the guest additions and repackage the box to continue.
    node2: 
    node2: This is not an error message; everything may continue to work properly,
    node2: in which case you may ignore this message.
==> node2: Setting hostname...
==> node2: Configuring and enabling network interfaces...
==> node2: Exporting NFS shared folders...
==> node2: Preparing to edit /etc/exports. Administrator privileges will be required...
[sudo] w 的密码： 
==> node2: Mounting NFS shared folders...
Guest-specific operations were attempted on a machine that is not
ready for guest communication. This should not happen and a bug
should be reported.

# w @ uw in ~/tool/vagrant/kubernetes-vagrant-centos-cluster on git:master o [16:37:27] C:1
$ vagrant status
Current machine states:

node1                     running (virtualbox)
node2                     running (virtualbox)
node3                     not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed

# w



```







