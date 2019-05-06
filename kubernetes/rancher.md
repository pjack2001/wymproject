
# rancher使用说明

## 帮助
https://www.cnrancher.com/docs/rancher/v2.x/cn/overview/


```yml


```

## 问题


```yml

1、harbor配置完，已经配置daemon.json，但就是连不上

mkdir -p /etc/docker && echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.3:8001","0.0.0.0/0"]}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker

2、rancher建立集群，报错








```

## 本机安装


### 一、准备
```yml
相关程序目录：

$ cd /home/w/tool/rancherk8s
$ cd /home/w/tool/rancherk8s/dockersh

sudo docker run -d --restart=unless-stopped -v /home/w/tool/rancher/:/var/lib/rancher/ -p 8099:80 -p 8443:443 rancher/rancher:v2.2.2

```

### 二、安装配置docker-compose

```yml


```


### 三、自签名证书（可选）

```yml
https://www.cnrancher.com/docs/rancher/v2.x/cn/install-prepare/self-signed-ssl/

一键生成ssl自签名证书脚本
$ touch create_self-signed-cert.sh

复制以上代码另存为create_self-signed-cert.sh或者其他您喜欢的文件名。
脚本参数
--ssl-domain: 生成ssl证书需要的主域名，如不指定则默认为localhost，如果是ip访问服务，则可忽略；
--ssl-trusted-ip: 一般ssl证书只信任域名的访问请求，有时候需要使用ip去访问server，那么需要给ssl证书添加扩展IP，多个IP用逗号隔开；
--ssl-trusted-domain: 如果想多个域名访问，则添加扩展域名（TRUSTED_DOMAIN）,多个TRUSTED_DOMAIN用逗号隔开；
--ssl-size: ssl加密位数，默认2048；
--ssl-date: ssl有效期，默认10年；
--ca-date: ca有效期，默认10年；
--ssl-cn: 国家代码(2个字母的代号),默认CN；

使用示例:
./create_self-signed-cert.sh --ssl-domain=www.test.com --ssl-trusted-domain=www.test2.com \
--ssl-trusted-ip=1.1.1.1,2.2.2.2,3.3.3.3 --ssl-size=2048 --ssl-date=3650


./create_self-signed-cert.sh --ssl-trusted-ip=192.168.31.50,192.168.31.116,192.168.102.3 --ssl-size=2048 --ssl-date=3650


通过openssl本地校验

openssl verify -CAfile cacerts.pem tls.crt 应该返回状态为 ok

openssl x509 -in tls.crt -noout -text 执行后查看对应的域名和扩展iP是否正确

不加CA证书验证

openssl s_client -connect demo.rancher.com:443 -servername demo.rancher.com

添加CA证书验证

openssl s_client -connect demo.rancher.com:443 -servername demo.rancher.com -CAfile server-ca.crt

```

### 四、配置docker加速器和私有仓库

```yml

如果先启动harbor，配置完daemon.json，重启docker，harbor总是有镜像（harbor-portal        nginx -g daemon off;）起不来
所以可以先配置好加速器和私有仓库，再启动harbor

cat /etc/docker/daemon.json 
{
  "registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],
  "insecure-registries": ["http://192.168.102.3:8001"]
}


cat >>/etc/docker/daemon.json<<EOF
{
"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],
"insecure-registries": ["http://192.168.31.50","http://192.168.102.3:8001","0.0.0.0/0"]
}
EOF

添加仓库地址后，
#sudo echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"]}' > /etc/docker/daemon.json
#sudo echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.3:8001"]}' > /etc/docker/daemon.json
#sudo echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["0.0.0.0/0"]}' > /etc/docker/daemon.json




sudo systemctl daemon-reload
sudo systemctl restart docker  #sudo service docker restart
sudo docker version

sudo docker info


$ docker login 192.168.31.50
Username: admin
Password:

问题：
$ docker login 192.168.31.50
Username: admin
Password: 
Error response from daemon: Get http://192.168.31.50/v2/: unable to decode token response: invalid character '<' looking for beginning of value


报错：
Error response from daemon: Get http://192.168.31.50/v2/: received unexpected HTTP status: 502 Bad Gateway

检查是否有镜像没有启动

```

### 五、harbor镜像仓库

```yml

harbor：
https://www.cnrancher.com/docs/rancher/v2.x/cn/install-prepare/registry/single-node-installation/

/home/w/tool/rancherk8s
$ tar zxvf harbor-offline-installer-v1.7.5.tgz

$ cd /home/w/tool/rancherk8s/harbor

$ vim /home/w/tool/rancherk8s/harbor/harbor.cfg
hostname = 192.168.31.50
harbor_admin_password = admin   #Newcapec301

sudo ./install.sh
$ sudo docker-compose ps


默认安装管理Harbor的生命周期
开始、停止、重启

sudo docker-compose start/stop/restart

更新配置
要更改Harbour的配置，请先停止现有的Harbor实例并进行更新harbor.cfg。然后运行prepare脚本以填充配置。最后重新创建并启动Harbor的实例:

  sudo docker-compose down -v
  sudo vim harbor.cfg
  sudo ./prepare
  sudo docker-compose up -d

删除Harbor的容器，同时将镜像数据和Harbor的数据库文件保存在文件系统上
sudo docker-compose down -v

删除Harbor的数据库和镜像数据(用于干净的重新安装)
  rm -r /data/database
  rm -r /data/registry


登录：http://192.168.31.50

admin用户密码配置在harbor.cfg的harbor_admin_password = 
admin/admin
注册用户 wym/Newcapec301

根据rancher-images.txt里的镜像仓库名字，在harbor建项目coredns minio rancher registry jimmidyson 都选择“公开”


使用http://192.168.102.3:8001

$ cat /etc/docker/daemon.json 
{
  "registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],
  "insecure-registries": ["http://192.168.102.3:8001"]
}



```


### 六、制作离线镜像包

```yml



官方发布页面
https://github.com/rancher/rancher/releases

例如：找到稳定版本v2.2.2，点开“资产”

rancher-images-digests.txt
rancher-images.txt
rancher-load-images.ps1
rancher-load-images.sh
rancher-mirror-to-rancher-org.ps1
rancher-mirror-to-rancher-org.sh
rancher-save-images.ps1
rancher-save-images.sh
rancher-windows-images.txt
sha256sum.txt

源代码（zip）
源代码（tar.gz）

准备离线镜像
https://www.cnrancher.com/docs/rancher/v2.x/cn/installation/air-gap-installation/single-node/registry/

从发行版的资产部分，下载以下三个文件，这些文件是在离线环境中安装牧场主所必需的：

文件	描述
rancher-images.txt	此文件包含安装牧场主所需的所有镜像的列表。
rancher-save-images.sh	此脚本rancher-images.txt从Docker Hub中下载所有镜像并将所有镜像保存为rancher-images.tar.gz。
rancher-load-images.sh	脚本此从rancher-images.tar.gz文件加载它的镜像就是，并将其推送到您的私有镜像仓库。


同步镜像
注意：
镜像同步需要接近20GB的空磁盘空间。

在可用访问Internet的主机中，使用rancher-save-images.sh和 rancher-images.txt创建所有所需镜像的压缩包。

./rancher-save-images.sh --image-list ./rancher-images.txt
复制rancher-load-images.sh、rancher-images.txt、rancher-images.tar.gz文件到可用访问私有镜像仓库的主机上。

如果需要，请登入私有镜像仓库。
 docker login <REGISTRY.YOURDOMAIN.COM:PORT>
使用rancher-load-images.sh加载rancher-images.tar.gz，并将镜像推送到私有仓库。
 ./rancher-load-images.sh --image-list ./rancher-images.txt \
 --registry <REGISTRY.YOURDOMAIN.COM:PORT>




```


### 七、导入镜像到仓库

```yml

# root @ CentOS003 in /home/y/kubernetes/rancher/dockersh [16:53:43] 
$ tree         
.
├── docker-compose
├── docker-compose-Linux-x86_64
├── harbor-offline-installer-v1.7.5.tgz
├── rancher-images.tar.gz    #v2.2.2版本所需镜像
├── rancher-images.txt
├── rancher-load-images.sh
└── rancher-load-images.sh.1

单个导入测试：


$ docker tag busybox:1.30.1 192.168.31.50/library/busybox:1.30.1
$ docker push 192.168.31.50/library/busybox:1.30.1


docker  tag   ykt-ui:latest  172.16.0.122/library/ykt-ui:v4 
docker  push  172.16.0.122/library/ykt-ui:v4    


批量导入：

harbor仓库：192.168.102.3:8001

$ md5sum rancher-images.tar.gz 
bde8dffcb2f3acbbca15f9ea50acbb24  rancher-images.tar.gz


根据rancher-images.txt里的镜像仓库名字，在harbor建项目 coredns minio rancher registry jimmidyson 都选择“公开”

admin/Newcapec!301
wym/W1!harbor

https://www.cnrancher.com/docs/rancher/v2.x/cn/installation/air-gap-installation/single-node/registry/
如果需要，请登入私有镜像仓库。
 docker login <REGISTRY.YOURDOMAIN.COM:PORT>
使用rancher-load-images.sh加载rancher-images.tar.gz，并将镜像推送到私有仓库。
 ./rancher-load-images.sh --image-list ./rancher-images.txt \
 --registry <REGISTRY.YOURDOMAIN.COM:PORT>

$ cd /home/y/kubernetes/rancher/dockersh

$ docker login 192.168.102.3:8001
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

$ sh rancher-load-images.sh -h

$ sh rancher-load-images.sh --image-list ./rancher-images.txt --registry 192.168.102.3:8001


$ sh rancher-load-images.sh --image-list rancher-images.txt --images rancher-images.tar.gz --registry 192.168.102.3:8001


执行到registry:2，会报错，手工执行

$ docker tag registry:2 192.168.102.3:8001/library/registry:2
$ docker push 192.168.102.3:8001/library/registry:2

为了以后执行方便，需要修改rancher-images.txt，把registry:2放到最后一行















本机测试
harbor仓库：192.168.31.50
$ cd /home/w/tool/rancherk8s/dockersh

# w @ uw in ~/tool/rancherk8s/dockersh [16:52:43] 


```

### 八、在主节点启动rancher

```yml
默认镜像仓库地址
https://www.cnrancher.com/docs/rancher/v2.x/cn/installation/air-gap-installation/single-node/config-rancher-for-private-reg/

注意:
如果要在启动rancher/rancher容器时配置`system-default-registry，可以使用环境变量 CATTLE_SYSTEM_DEFAULT_REGISTRY

#!/bin/sh
docker run -d --restart=unless-stopped -p 8099:80 -p 8443:443 \
-v /home/y/kubernetes/rancher:/var/lib/rancher/ \
-v /root/var/log/auditlog:/var/log/auditlog \
-e AUDIT_LEVEL=3 \
-e CATTLE_SYSTEM_DEFAULT_REGISTRY=192.168.102.3:8001 \
192.168.102.3:8001/rancher/rancher:v2.2.2


sudo docker run -d --restart=unless-stopped -v /home/w/tool/rancher/:/var/lib/rancher/ -p 8099:80 -p 8443:443 rancher/rancher:v2.2.2

登录：
http://192.168.102.3:8099
https://192.168.102.3:8443/


```



```yml



```



```yml



```



```yml






5、在主节点用docker run命令拉取harbor里的rancher镜像，
6、登录rancher，建立集群，注意配置默认镜像仓库为harbor的地址
7、在各节点拷贝rancher的命令，各节点rancher成功（master三台）
8、把迪科镜像pull到harbor，rancher建立集群，拉取迪科镜像，迪科的镜像需要配置文件，（所以需要在rancher建立configmap）






```



```yml




```

```yml


```


## rancher厂家安装20190425


### 主要安装步骤

```yml



1、把文件拷贝到服务器
2、用docker-compose安装harbor
3、登录harbor，根据rancher-images.txt里的镜像仓库名字，在harbor建项目coredns，minio，rancher，registry，jimmidyson
4、先用docker login登录，用rancher-load-images.sh把镜像导入harbor，用-h查参数，使用rancher-images.txt
5、在主节点用docker run命令拉取harbor里的rancher镜像，
6、登录rancher，建立集群，注意配置默认镜像仓库为harbor的地址
7、在各节点拷贝rancher的命令，各节点rancher成功（master三台）
8、把迪科镜像pull到harbor，rancher建立集群，拉取迪科镜像，迪科的镜像需要配置文件，（所以需要在rancher建立configmap）

```

### 安装

```yml



$ tree
.
├── docker-compose
├── docker-compose-Linux-x86_64
├── harbor-offline-installer-v1.7.5.tgz
├── rancher-images.tar.gz
├── rancher-images.txt
└── rancher-load-images.sh.1


$ cat rancher-images.txt 
coredns/coredns:1.2.2
coredns/coredns:1.2.6
coredns/coredns:1.3.1
minio/minio:RELEASE.2018-05-25T19-49-13Z
rancher/alertmanager-helper:v0.0.2
rancher/calico-cni:v3.1.3
rancher/calico-cni:v3.4.0
rancher/calico-ctl:v2.0.0
rancher/calico-node:v3.1.3
rancher/calico-node:v3.4.0
rancher/cluster-proportional-autoscaler-amd64:1.0.0
rancher/cluster-proportional-autoscaler:1.0.0
rancher/cluster-proportional-autoscaler:1.3.0
rancher/coreos-etcd:v3.2.18
rancher/coreos-etcd:v3.2.24-rancher1
rancher/coreos-etcd:v3.3.10-rancher1
rancher/coreos-flannel-cni:v0.3.0
rancher/coreos-flannel:v0.10.0
rancher/coreos-flannel:v0.10.0-rancher1
rancher/flannel-cni:v0.3.0-rancher1
rancher/fluentd-helper:v0.1.2
rancher/fluentd:v0.1.11
rancher/hyperkube:v1.11.9-rancher1
rancher/hyperkube:v1.12.7-rancher1
rancher/hyperkube:v1.13.5-rancher1
rancher/hyperkube:v1.14.1-rancher1
rancher/jenkins-jnlp-slave:3.10-1-alpine
rancher/jenkins-plugins-docker:17.12
rancher/k8s-dns-dnsmasq-nanny-amd64:1.14.10
rancher/k8s-dns-dnsmasq-nanny:1.14.13
rancher/k8s-dns-dnsmasq-nanny:1.15.0
rancher/k8s-dns-kube-dns-amd64:1.14.10
rancher/k8s-dns-kube-dns:1.14.13
rancher/k8s-dns-kube-dns:1.15.0
rancher/k8s-dns-sidecar-amd64:1.14.10
rancher/k8s-dns-sidecar:1.14.13
rancher/k8s-dns-sidecar:1.15.0
rancher/kube-api-auth:v0.1.3
rancher/log-aggregator:v0.1.4
rancher/metrics-server-amd64:v0.2.1
rancher/metrics-server:v0.3.1
rancher/nginx-ingress-controller-defaultbackend:1.4
rancher/nginx-ingress-controller-defaultbackend:1.4-rancher1
rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
rancher/nginx-ingress-controller:0.16.2-rancher1
rancher/nginx-ingress-controller:0.21.0-rancher3
rancher/pause-amd64:3.1
rancher/pause:3.1
rancher/pipeline-jenkins-server:v0.1.0
rancher/pipeline-tools:v0.1.9
rancher/prom-alertmanager:v0.15.2
rancher/rke-tools:v0.1.15
rancher/rke-tools:v0.1.27
rancher/rke-tools:v0.1.28
registry:2
rancher/coreos-kube-state-metrics:v1.5.0
rancher/nginx:1.15.8-alpine
rancher/prom-alertmanager:v0.16.1
rancher/kubernetes-external-dns:v0.5.11
rancher/fluentd:v0.1.12
rancher/coreos-prometheus-operator:v0.29.0
rancher/coreos-prometheus-config-reloader:v0.29.0
rancher/coreos-configmap-reload:v0.0.1
rancher/grafana-grafana:5.4.3
rancher/prom-prometheus:v2.7.1
jimmidyson/configmap-reload:v0.2.2
rancher/fluentd:v0.1.13
rancher/log-aggregator:v0.1.5
rancher/prometheus-auth:v0.2.0
rancher/prom-node-exporter:v0.17.0
rancher/rancher:v2.2.2
rancher/rancher-agent:v2.2.2


# sh rancher-load-images.sh -l rancher-images.txt -r ip

# w @ uw in ~/下载/dockersh/dockersh [14:10:58] C:1
$ cat rancher-load-images.sh                                
#!/bin/bash
list="rancher-images.txt"
images="rancher-images.tar.gz"

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -r|--registry)
        reg="$2"
        shift # past argument
        shift # past value
        ;;
        -l|--image-list)
        list="$2"
        shift # past argument
        shift # past value
        ;;
        -i|--images)
        images="$2"
        shift # past argument
        shift # past value
        ;;
        -h|--help)
        help="true"
        shift
        ;;
    esac
done

usage () {
    echo "USAGE: $0 [--image-list rancher-images.txt] [--images rancher-images.tar.gz] --registry my.registry.com:5000"
    echo "  [-l|--images-list path] text file with list of images. 1 per line."
    echo "  [-l|--images path] tar.gz generated by docker save."
    echo "  [-r|--registry registry:port] target private registry:port."
    echo "  [-h|--help] Usage message"
}

if [[ -z $reg ]]; then
    usage
    exit 1
fi
if [[ $help ]]; then
    usage
    exit 0
fi

set -e -x

docker load --input ${images}

for i in $(cat ${list}); do
    docker tag ${i} ${reg}/${i}
    docker push ${reg}/${i}
done

# w @ uw in ~/下载/dockersh/dockersh [14:11:23] 
$ 



```

## 102.3服务器安装

```yml



mkdir -p /home/y/docker-compose/harbor
tar zxvf harbor-offline-installer-v1.7.5.tgz


```




### 以前安装


```yml


https://192.168.102.3:8443

https://192.168.40.3:8443

```



```yml


```



```yml


```



```yml


```



```yml


```



```yml


```



```yml


```




