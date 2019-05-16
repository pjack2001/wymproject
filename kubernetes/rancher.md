
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
docker logs -f 查看，网络问题，主机环境要按rancher官方文档配置

3、导入rancher镜像，执行到registry报错
执行到registry:2，会报错，手工执行

$ docker tag registry:2 192.168.102.3:8001/library/registry:2
$ docker push 192.168.102.3:8001/library/registry:2

$ docker tag registry:2 192.168.113.38/library/registry:2
$ docker push 192.168.113.38/library/registry:2
$ docker tag kibana:6.5.4 192.168.113.38/library/kibana:6.5.4
$ docker push 192.168.113.38/library/kibana:6.5.4
$ docker tag elasticsearch:6.5.4 192.168.113.38/library/elasticsearch:6.5.4
$ docker push 192.168.113.38/library/elasticsearch:6.5.4


为了以后执行方便，需要修改rancher-images.txt，把registry:2放到最后一行

4、问题：如果执行没有反应，应该是压缩包的问题，碰到过两次了，用现场带回来的就可以

已解决：必须加"./rancher-images.tar.gz"，即可导入成功
--images ./rancher-images.tar.gz

$ ./rancher-load-images.sh --image-list ./rancher-images.txt --images ./rancher-images.tar.gz --registry 192.168.113.38


5、
当前集群Updating中...，在API准备就绪之前，直接与API交互的功能将不可用。

[Failed to start [rke-port-checker] container on host [192.168.113.41]: error during connect: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/2d9fc5cf29aadaa5bc3ca4f3a453590f6eb979ac8778f3264a88f1f1b8aa183e/start: tunnel disconnect]; [controlPlane] Failed to bring up Control Plane: [Failed to verify healthcheck: Failed to check https://localhost:6443/healthz for service [kube-apiserver] on host [192.168.113.41]: Get https://localhost:6443/healthz: read tcp [::1]:36248->[::1]:6443: read: connection reset by peer, log: I0510 01:10:00.920683 1 plugins.go:161] Loaded 6 validating admission controller(s) successfully in the following order: LimitRanger,ServiceAccount,Priority,PersistentVolumeClaimResize,ValidatingAdmissionWebhook,ResourceQuota.]

 Rancher-鞠宏超
这个你需要检查一下你的主机端口是否开放了

https://rancher.com/docs/rke/latest/en/os/#ports
 
看下这个文档的说明，检查一下这些端口是不是都可以访问

sudo ufw disable

当前集群Updating中...，在API准备就绪之前，直接与API交互的功能将不可用。

[Failed to start [rke-port-checker] container on host [192.168.113.41]: error during connect: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/2d9fc5cf29aadaa5bc3ca4f3a453590f6eb979ac8778f3264a88f1f1b8aa183e/start: tunnel disconnect]; [[network] Host [192.168.113.42] is not able to connect to the following ports: [192.168.113.41:6443]. Please check network policies and firewall rules]


检查端口

$ sudo netstat -atunlp|grep 6443
$ sudo lsof -i:6443

$ sudo netstat -nlpt
$ sudo netstat -aon|grep 6443

$ sudo telnet 192.168.113.41 6443
Trying 192.168.113.41...
Connected to 192.168.113.41.
Escape character is '^]'.
Connection closed by foreign host.

$ sudo lsof -i:6443

$ sudo netstat -tln|grep 6443
tcp6       0      0 :::6443                 :::*                    LISTEN

$ sudo netstat -ntlp


好像是被tcp6占了6443端口


在Ubuntu上完全禁用IPv6
如果要在Ubuntu Linux系统上完全禁用IPv6，则需要对Linux内核参数进行一些更改。

$ sudo vi /etc/sysctl.d/99-sysctl.conf

net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

保存并关闭文件。 然后执行以下命令加载上述更改。

sudo sysctl -p
现在运行以下命令。 您应该看到1，这意味着IPv6已成功禁用。

$ cat /proc/sys/net/ipv6/conf/all/disable_ipv6
1

















```


### 环境检查

```yml

如果需要root权限，要加-b参数

ubuntu系统使用sudo ，需要在hosts配置become
192.168.113.41 ansible_ssh_user=wym  ansible_become_user=root ansible_become=true ansible_become_pass='newcapecwym'

$ ansible rancher1 -s -m shell -a 'shutdown -r now'
$ ansible rancher -s -m shell -a 'shutdown -h now'
$ ansible rancher1 -s -m shell -a 'ufw status'


$ ansible all --list

$ ansible rancher1 -m ping -u wym -k

$ ansible-playbook PushKey.yml -u wym -k


$ ansible rancher1 -m shell -a 'echo $HOSTNAME'

$ ansible rancher1 -m shell -a 'ss -ntl'

$ ansible rancher1 -m shell -a 'ls /home'



有些复杂命令，即使使用shell也可能会失败，
解决办法：写到脚本时，copy到远程，执行，再把需要的结果拉回执行命令的机器
#ansible web -m shell -a df | awk '{print $5}'
### script模块
$ cat hostname.sh 

#!/bin/bash
hostname

$ ansible test -m copy -a 'src=/home/y/python/wymproject01/ansiblewym/testw/hostname.sh dest=/home/hostnametest.sh backup=yes'

$ chmod +x hostname.sh
$ ansible rancher1 -m script -a 'hostname.sh' -u wym -k

$ ansible test -m shell -a 'ls -l /etc/selinux/config'



配置免密登录或修改密码，对应想要修改hosts文件的主机列表

# cat ansible.cfg 
[defaults]
inventory = hosts
remote_user = wym
host_key_checking = False

# cat hosts
[rancher]
192.168.113.41 ansible_ssh_user=wym  ansible_become_user=root ansible_become=true ansible_become_pass='newcapecwym'

# ansible all --list
# ansible all -m ping -u wym -k

批量推送公钥
# cat PushKey.yml 
---
- hosts: rancher
  remote_user: wym
  become: yes
  become_user: wym
  become_method: sudo
  tasks:
  - name: deliver authorized_keys
    authorized_key:
      user: wym
      key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
      state: present
      exclusive: yes

首先要登录一次
# ssh root@192.168.113.37
# ansible-playbook PushKey.yml -u wym -k
# ansible all -m ping

修改密码
# cat userpass.yml 
---
- hosts: rancher1
  gather_facts: false
  tasks:
  - name: change user passwd
    user: name={{ item.name }} password={{ item.chpass | password_hash('sha512') }}  update_password=always
    with_items:
         - { name: 'wym', chpass: 'newcapec' }

如果配置了免密登录，就不用加-u和-k参数
# ansible-playbook userpass.yml
# ansible-playbook userpass.yml -u wym -k

修改完密码，如果没有配置免密登录，就需要修改hosts里面的密码
# cat hosts
[rancher]
192.168.113.41 ansible_ssh_user=wym  ansible_become_user=root ansible_become=true ansible_become_pass='newcapec'

# ansible all -m ping



```







## 本机安装


### 一、准备
```yml
相关程序目录：

$ cd /home/w/tool/rancherk8s
$ cd /home/w/tool/rancherk8s/dockersh

sudo docker run -d --restart=unless-stopped -v /home/w/tool/rancher/:/var/lib/rancher/ -p 8099:80 -p 8443:443 rancher/rancher:v2.2.2


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

cd /home/wym/harbor

$ vim /home/w/tool/rancherk8s/harbor/harbor.cfg
hostname = 192.168.133.38
harbor_admin_password = newcapec   #Newcapec301

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

有新的镜像可以增加到rancher-images.txt，在harbor建立相应的项目，用rancher-load-images.sh导入
coredns minio rancher registry jimmidyson 
gitlab kibana elasticsearch


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


$ ./rancher-save-images.sh -h
$ ./rancher-save-images.sh --image-list ./rancher-images.txt --images ./rancher-images.tar.gz

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

$ ./rancher-load-images.sh --image-list ./rancher-images.txt --images ./rancher-images.tar.gz --registry 192.168.113.38

问题：如果执行没有反应，应该是压缩包的问题，碰到过两次了，用现场带回来的就可以


执行到registry:2，会报错，手工执行

$ docker tag registry:2 192.168.102.3:8001/library/registry:2
$ docker push 192.168.102.3:8001/library/registry:2

为了以后执行方便，需要修改rancher-images.txt，把registry:2放到最后一行


新建192.168.113.38仓库
$ docker login 192.168.113.38
Username: admin
Password: 

$ ./rancher-load-images.sh --images-list rancher-images.txt --images rancher-v2.2.2-images.tar.gz --registry 192.168.113.38










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
sudo docker run -d --restart=unless-stopped -p 8099:80 -p 8443:443 \
-v /home/y/kubernetes/rancher:/var/lib/rancher/ \
-v /root/var/log/auditlog:/var/log/auditlog \
-e AUDIT_LEVEL=3 \
-e CATTLE_SYSTEM_DEFAULT_REGISTRY=192.168.102.3:8001 \
192.168.102.3:8001/rancher/rancher:v2.2.2

深信服
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 \
-v /home/wym/rancher:/var/lib/rancher/ \
-v /root/var/log/auditlog:/var/log/auditlog \
-e AUDIT_LEVEL=3 \
-e CATTLE_SYSTEM_DEFAULT_REGISTRY=192.168.113.38 \
192.168.113.38/rancher/rancher:v2.2.2



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



单独安装虚拟机，用作rancher工作节点
IP：192.168.102.4,sudo ufw disable,
ssh wym@192.168.102.4,newcapec

```




### 以前安装


```yml


https://192.168.102.3:8443

https://192.168.40.3:8443

```



```yml


```

## 环境准备



### RKE环境要求-安装docker
```yml
https://www.cnrancher.com/docs/rke/latest/cn/requirements/
软件
Docker - 每个Kubernetes版本都支持不同的Docker版本。
Kubernetes版本	支持多克尔版本（一个或多个）
v1.13.x	RHEL Docker 1.13,17.03.2,18.06.2,18.09.2
v1.12.x	RHEL Docker 1.13,17.03.2,18.06.2,18.09.2
v1.11.x	RHEL Docker 1.13,17.03.2,18.06.2,18.09.2
您可以按照Docker安装说明操作，也可以使用Rancher的安装脚本安装Docker。对于RHEL，请参阅如何在Red Hat Enterprise Linux 7上安装Docker。

docker安装脚本
18.09.2	curl https://releases.rancher.com/install-docker/18.09.2.sh | sh
18.06.2	curl https://releases.rancher.com/install-docker/18.06.2.sh | sh
17.03.2	curl https://releases.rancher.com/install-docker/17.03.2.sh | sh
确认安装的docker版本： docker version --format '{{.Server.Version}}'

```






### rancher 1 - 基础环境配置

```yml
https://www.cnrancher.com/docs/rancher/v2.x/cn/install-prepare/basic-environment-configuration/





一、主机配置
1、配置要求
参考节点要求

2、主机名配置
因为K8S的规定，主机名只支持包含 - 和 .(中横线和点)两种特殊符号，并且主机名不能出现重复。

3、Hosts
配置每台主机的hosts(/etc/hosts),添加host_ip $hostname到/etc/hosts文件中。

4、CentOS关闭selinux
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

5、关闭防火墙(可选)或者放行相应端口
对于刚刚接触Rancher的用户，建议在关闭防火墙的测试环境或桌面虚拟机来运行rancher，以避免出现网络通信问题。

关闭防火墙

1、CentOS

systemctl stop firewalld.service && systemctl disable firewalld.service

2、Ubuntu

ufw disable

端口放行

端口放行请查看端口需求

6、配置主机时间、时区、系统语言
查看时区

date -R或者timedatectl

修改时区

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

修改系统语言环境

sudo echo 'LANG="en_US.UTF-8"' >> /etc/profile;source /etc/profile

配置主机NTP时间同步

7、Kernel性能调优
cat >> /etc/sysctl.conf<<EOF
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.neigh.default.gc_thresh1=4096
net.ipv4.neigh.default.gc_thresh2=6144
net.ipv4.neigh.default.gc_thresh3=8192
EOF
数值根据实际环境自行配置，最后执行sysctl -p保存配置。

8、内核模块(未配置)
警告
如果要使用ceph存储相关功能，需保证worker节点加载RBD模块

以下模块需要在主机上加载

模块名称
br_netfilter
ip6_udp_tunnel
ip_set
ip_set_hash_ip
ip_set_hash_net
iptable_filter
iptable_nat
iptable_mangle
iptable_raw
nf_conntrack_netlink
nf_conntrack
nf_conntrack_ipv4
nf_defrag_ipv4
nf_nat
nf_nat_ipv4
nf_nat_masquerade_ipv4
nfnetlink
udp_tunnel
VETH
VXLAN
x_tables
xt_addrtype
xt_conntrack
xt_comment
xt_mark
xt_multiport
xt_nat
xt_recent
xt_set
xt_statistic
xt_tcpudp
模块查询: lsmod | grep <模块名> 
模块加载: modprobe <模块名>

9、ETCD集群容错表
建议在ETCD集群中使用奇数个成员,通过添加额外成员可以获得更高的失败容错。具体详情可以查阅optimal-cluster-size。

集群大小	MAJORITY	失败容错
1	1	0
2	2	0
3	2	1
4	3	1
5	3	2
6	4	2
7	4	3
8	5	3
9	5	4
二、Docker安装与配置
1、Docker安装
Ubuntu 16.x
修改系统源

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF

deb http://mirrors.aliyun.com/ubuntu/ xenial main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe

EOF
Docker-ce安装

# 定义安装版本
export docker_version=18.06.3;
# step 1: 安装必要的一些系统工具
sudo apt-get remove docker docker-engine docker.io containerd runc -y;
sudo apt-get update;
sudo apt-get -y install apt-transport-https ca-certificates \
    curl software-properties-common bash-completion  gnupg-agent;
# step 2: 安装GPG证书
sudo curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | \
    sudo apt-key add -;
# Step 3: 写入软件源信息
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu \
    $(lsb_release -cs) stable";
# Step 4: 更新并安装 Docker-CE
sudo apt-get -y update;
version=$(apt-cache madison docker-ce|grep ${docker_version}|awk '{print $3}');
# --allow-downgrades 允许降级安装
sudo apt-get -y install docker-ce=${version} --allow-downgrades;
# 设置开机启动
sudo systemctl enable docker;
Docker-engine

Docker-Engine Docker官方已经不推荐使用，请安装Docker-CE。

CentOS 7.x
Docker-ce安装

因为CentOS的安全限制，通过RKE安装K8S集群时候无法使用root账户。所以，建议CentOS用户使用非root用户来运行docker,不管是RKE还是custom安装k8s,详情查看无法为主机配置SSH隧道。

# 添加用户(可选)
sudo adduser `<new_user>`
# 为新用户设置密码
sudo passwd `<new_user>`
# 为新用户添加sudo权限
sudo echo '<new_user> ALL=(ALL) ALL' >> /etc/sudoers
# 卸载旧版本Docker软件
sudo yum remove docker \
              docker-client \
              docker-client-latest \
              docker-common \
              docker-latest \
              docker-latest-logrotate \
              docker-logrotate \
              docker-selinux \
              docker-engine-selinux \
              docker-engine \
              container*
# 定义安装版本
export docker_version=18.06.3
# step 1: 安装必要的一些系统工具
sudo yum remove docker docker-client docker-client-latest \
    docker-common docker-latest docker-latest-logrotate \
    docker-logrotate docker-engine -y;
sudo yum update -y;
sudo yum install -y yum-utils device-mapper-persistent-data \
    lvm2 bash-completion;
# Step 2: 添加软件源信息
sudo yum-config-manager --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo;
# Step 3: 更新并安装 Docker-CE
sudo yum makecache all;
version=$(yum list docker-ce.x86_64 --showduplicates | sort -r|grep ${docker_version}|awk '{print $2}');
sudo yum -y install --setopt=obsoletes=0 docker-ce-${version} docker-ce-selinux-${version};
# 如果已经安装高版本Docker,可进行降级安装(可选)
yum downgrade --setopt=obsoletes=0 -y docker-ce-${version} docker-ce-selinux-${version};
# 把当前用户加入docker组
sudo usermod -aG docker `<new_user>`;
# 设置开机启动
sudo systemctl enable docker;
Docker-engine

Docker-Engine Docker官方已经不推荐使用，请安装Docker-CE。


2、Docker配置
对于通过systemd来管理服务的系统(比如CentOS7.X、Ubuntu16.X), Docker有两处可以配置参数: 一个是docker.service服务配置文件,一个是Docker daemon配置文件daemon.json。

docker.service

对于CentOS系统，docker.service默认位于/usr/lib/systemd/system/docker.service；对于Ubuntu系统，docker.service默认位于/lib/systemd/system/docker.service

daemon.json

daemon.json默认位于/etc/docker/daemon.json，如果没有可手动创建，基于systemd管理的系统都是相同的路径。通过修改daemon.json来改过Docker配置，也是Docker官方推荐的方法。

以下说明均基于systemd,并通过/etc/docker/daemon.json来修改配置。

配置镜像下载和上传并发数
从Docker1.12开始，支持自定义下载和上传镜像的并发数，默认值上传为3个并发，下载为5个并发。通过添加”max-concurrent-downloads”和”max-concurrent-uploads”参数对其修改:

"max-concurrent-downloads": 3,
"max-concurrent-uploads": 5
配置镜像加速地址
Rancher从v1.6.15开始到v2.x.x,Rancher系统相关的所有镜像(包括1.6.x上的K8S镜像)都托管在Dockerhub仓库。Dockerhub节点在国外，国内直接拉取镜像会有些缓慢。为了加速镜像的下载，可以给Docker配置国内的镜像地址。

编辑/etc/docker/daemon.json加入以下内容

{
"registry-mirrors": ["https://7bezldxe.mirror.aliyuncs.com/","https://IP:PORT/"]
}
可以设置多个registry-mirrors地址，以数组形式书写，地址需要添加协议头(https或者http)。

配置insecure-registries私有仓库
Docker默认只信任TLS加密的仓库地址(https)，所有非https仓库默认无法登陆也无法拉取镜像。insecure-registries字面意思为不安全的仓库，通过添加这个参数对非https仓库进行授信。可以设置多个insecure-registries地址，以数组形式书写，地址不能添加协议头(http)。

编辑/etc/docker/daemon.json加入以下内容:

{
"insecure-registries": ["192.168.1.100","IP:PORT"]
}
配置Docker存储驱动
OverlayFS是一个新一代的联合文件系统，类似于AUFS，但速度更快，实现更简单。Docker为OverlayFS提供了两个存储驱动程序:旧版的overlay，新版的overlay2(更稳定)。

先决条件:

overlay2: Linux内核版本4.0或更高版本，或使用内核版本3.10.0-514+的RHEL或CentOS。
overlay: 主机Linux内核版本3.18+
支持的磁盘文件系统
ext4(仅限RHEL 7.1)
xfs(RHEL7.2及更高版本)，需要启用d_type=true。 >具体详情参考 Docker Use the OverlayFS storage driver
编辑/etc/docker/daemon.json加入以下内容

{
"storage-driver": "overlay2",
"storage-opts": ["overlay2.override_kernel_check=true"]
}
配置日志驱动
容器在运行时会产生大量日志文件，很容易占满磁盘空间。通过配置日志驱动来限制文件大小与文件的数量。 >限制单个日志文件为100M,最多产生3个日志文件

{
"log-driver": "json-file",
"log-opts": {
    "max-size": "100m",
    "max-file": "3"
    }
}
3、Ubuntu\Debian系统 ，docker info提示WARNING: No swap limit support
Ubuntu\Debian系统下，默认cgroups未开启swap account功能，这样会导致设置容器内存或者swap资源限制不生效。可以通过以下命令解决:

# 统一网卡名称为ethx
sudo sed -i 's/en[[:alnum:]]*/eth0/g' /etc/network/interfaces;
sudo sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="net.ifnames=0 cgroup_enable=memory swapaccount=1 biosdevname=0 \1"/g' /etc/default/grub;
sudo update-grub;
注意
通过以上命令可自动配置参数，如果/etc/default/grub非默认配置，需根据实际参数做调整。
提示
以上配置完成后，建议重启一次主机。




```



















### 安装步骤




```yml
安装Ubuntu Server 16.04

安装深信服的虚拟机优化工具
请按下面的步骤完成安装：
1. 登录操作系统
2. 点击上方的“立即安装”按钮来加载虚拟机性能优化工具安装包
3. 打开终端，依次执行以下命令来开始安装：
sudo mkdir -p /mnt/cdrom
sudo mount -t iso9660 /dev/sr1 /mnt/cdrom
cd /mnt/cdrom
sudo ./install.sh
4. 根据提示完成安装

注意事项：
若系统内核未自带virtio驱动（linux 2.6.25以上内核有virtio驱动），则会导致安装失败
假如重启后系统启动失败，可尝试从虚拟机详情页面卸载虚拟机性能优化工具，再次重启系统
mount光驱的时候如果报错 "mount: special device /dev/sr1 does not exist"，可能是光驱设备路径不正确，可尝试挂载其他光驱路径（挂载后 /mnt/cdrom 目录应有VMOptimizationToolsLinux.tar.gz 文件）



改IP
$ sudo vi /etc/network/interfaces

auto enp0s3
iface enp0s3 inet static
    address 192.168.31.49
    netmask 255.255.254.0
    gateway 192.168.30.1

关闭防火墙：sudo ufw disable

添加代理


修改系统语言环境

sudo echo 'LANG="en_US.UTF-8"' >> /etc/profile;source /etc/profile

Kernel性能调优
cat >> /etc/sysctl.conf<<EOF
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.neigh.default.gc_thresh1=4096
net.ipv4.neigh.default.gc_thresh2=6144
net.ipv4.neigh.default.gc_thresh3=8192
EOF
数值根据实际环境自行配置，最后执行sysctl -p保存配置。

内核模块
警告
如果要使用ceph存储相关功能，需保证worker节点加载RBD模块


替换阿里源
Ubuntu 16.x
修改系统源

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF

deb http://mirrors.aliyun.com/ubuntu/ xenial main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe

EOF


安装docker
18.09.2	curl https://releases.rancher.com/install-docker/18.09.2.sh | sh
18.06.2	curl https://releases.rancher.com/install-docker/18.06.2.sh | sh

sudo usermod -aG docker wym

编辑sudo vi /etc/docker/daemon.json

{
"registry-mirrors": ["https://7bezldxe.mirror.aliyuncs.com/","https://IP:PORT/"],
"insecure-registries": ["192.168.1.100","IP:PORT"]
}

{
"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com/"],
"insecure-registries": ["192.168.102.3:8001"]
}

sudo systemctl daemon-reload && sudo systemctl restart docker
$ sudo docker ps


# 统一网卡名称为ethx
sudo sed -i 's/en[[:alnum:]]*/eth0/g' /etc/network/interfaces;
sudo sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="net.ifnames=0 cgroup_enable=memory swapaccount=1 biosdevname=0 \1"/g' /etc/default/grub;
sudo update-grub;



实验说明及实验所需环境信息，每个学员需要4台以下规格的主机完成全部实验：
 
l  主机操作系统：推荐Ubuntu16.04/18.04
l  主机硬件要求：2C/8G
l  主机安装软件：docker 18.06/18.09，docker-compose 1.6+(for harbor), python 2.7+(for harbor), openssl, helm 2.12+, rke 0.2.2
注：1. 建议使用阿里云或aws等公有云主机，如果是私有云主机或虚拟机环境需开通外网访问。
2. 如果现场虚拟机无法连接外网，需要自行搭建内网的harbor镜像仓库，并将附件的镜像内容上传到内网harbor仓库中。


对方提供的offline-images.txt，里面比rancherv2.2.2多了三个镜像
kibana:6.5.4
elasticsearch:6.5.4
gitlab/gitlab-ce:11.10.4-ce.0


$ sudo apt-get install python-minimal python-dev --fix-missing
$ python -V

sudo apt-get install openssl
sudo apt-get install libssl-dev

下载docker-compose
$ sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
或
$ scp v1.23.2-docker-compose-Linux-x86_64 wym@192.168.113.38:/home/wym
$ sudo cp v1.23.2-docker-compose-Linux-x86_64 /usr/local/bin/docker-compose

$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose --version


perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = "en_US:en",
	LC_ALL = (unset),
	LC_CTYPE = "zh_CN.UTF-8",
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to a fallback locale ("en_US.UTF-8").
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory

解决这个   在～/.bashrc中添加一句话
export LC_ALL=C
然后source ~/.bashrc 就行了


重启

9 - 最佳实践(持续更新)
https://www.cnrancher.com/docs/rancher/v2.x/cn/install-prepare/best-practices/

综合配置

touch /etc/docker/daemon.json
cat > /etc/docker/daemon.json <<EOF
{
    "log-driver": "json-file",
    "log-opts": {
    "max-size": "100m",
    "max-file": "3"
    },
    "max-concurrent-downloads": 10,
    "max-concurrent-uploads": 10,
    "registry-mirrors": ["https://7bezldxe.mirror.aliyuncs.com"],
    "insecure-registries": ["192.168.113.38","192.168.102.3:8001"]
    "storage-driver": "overlay2",
    "storage-opts": [
    "overlay2.override_kernel_check=true"
    ]
}
EOF
systemctl daemon-reload && systemctl restart docker


```






```yml
http://10.10.252.9
用户名：wangyuming   密码：
马晓东
ip：192.168.113.37-56
子网掩码：255.255.254.0
网关：192.168.112.1
DNS：211.138.24.66

38密码newcapec!1

克隆主机，在/etc/docker/daemon.json文件添加harbor仓库，需要修改IP，主机名

转模板，批量建立12台虚拟机，修改IP和主机名
us16-rancher0001（ip 192.168.113.41）～us16-rancher0012（ip 192.168.113.52）
$ sudo vi /etc/network/interfaces
$ sudo hostnamectl set-hostname rancher01
$ sudo vi /etc/hostname 
$ sudo vi /etc/hosts




$ sudo vi /etc/network/interfaces
$ sudo /etc/init.d/networking restart

$ sudo hostnamectl set-hostname rancher01
永久修改主机名
在Ubuntu系统中永久修改主机名也比较简单。主机名存放在/etc/hostname文件中，修改主机名时，编辑hostname文件，在文件中输入新的主机名并保存该文件即可。重启系统后，参照上面介绍的快速查看主机名的办法来确认主机名有没有修改成功。

第一步： 修改/etc/hostname 
/etc/hostname中存放的是主机名，hostname文件的一个例子：

第二步：修改/etc/hosts配置文件（可选） 
/etc/hosts存放的是域名与ip的对应关系，域名与主机名没有任何关系，你可以为任何一个IP指定任意一个名字。

$ sudo vi /etc/hosts
192.168.113.39  rancher1

192.168.113.41  rancher01

第三步：重启系统

root@itcast:~# sudo reboot



Ubuntu彻底清除history命令历史记录

# 第一步： 删除 .bash_history 文件
rm -rf ~/.bash_history
# 第二步： 清空命令历史记录
history -c


```




```yml


```





```yml


```



```yml


```


### rancher_day1.md

```yml
1. 部署单节点Rancher

使用Rancher自签名证书

docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  rancher/rancher:v2.2.2
2. 部署Kubernetes

安装rke

$ wget -O /usr/local/bin/rke https://github.com/rancher/rke/releases/download/v0.2.2/rke_linux-amd64
$ chmod +x /usr/local/bin/rke
编辑cluster.yml

nodes:
  - address: <ip1>
    user: <username>
    role:
      - controlplane
      - etcd
      - worker
    ssh_key_path: /home/ubuntu/.ssh/id_rsa
  - address: <ip2>
    user: <username>
    role:
      - worker
    ssh_key_path: /home/ubuntu/.ssh/id_rsa
创建集群

rke up --config cluster.yml
3. 将集群导入Rancher

4. 操作kubernetes资源对象

Pod

apiVersion: v1
kind: Pod
metadata:
  name: mynginx
  namespace: default
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    ports:
    - containerPort: 80
      name: 80tcp01
      protocol: TCP
    stdin: true
    tty: true
  restartPolicy: Always
deployment

apiVersion: apps/v1beta2 # for versions before 1.8.0 use apps/v1beta1
kind: Deployment
metadata:
  name: http-app
spec:
  selector:
    matchLabels:
      app: http
  replicas: 1 # tells deployment to run 2 pods matching the template
  template: # create pods using pod definition in this template
    metadata:
      labels:
        app: http
    spec:
      containers:
      - name: nginx
        image: nginx:1.9
statefulset

apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
          name: web
daemonset

apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
 name: node-exporter-daemon
spec:
 template:
   metadata:
     labels:
       app: prometheus
   spec:
     hostNetwork: true
     containers:
     - name: node-exporter
       image: prom/node-exporter
       imagePullPolicy: IfNotPresent
       command:
       - /bin/node_exporter
       - --path.procfs
       - /host/proc
       - --path.sysfs
       - /host/sys
       - --collector.filesystem.ignored-mount-points
       - ^/(sys|proc|dev|host|etc)($|/)

       volumeMounts:
       - name: proc
         mountPath: /host/proc
       - name: sys
         mountPath: /host/sys
       - name: root
         mountPath: /rootfs
     volumes:
     - name: proc
       hostPath:
          path: /proc
     - name: sys
       hostPath:
          path: /sys
     - name: root
       hostPath:
         path: /
Job/CronJob

apiVersion: batch/v1
kind: Job
metadata:
  name: demo
spec:
  template:
    spec:
      containers:
      - name: demo
        image: busybox
        command: ["echo",  "Hello World!"]
      restartPolicy: Never
  backoffLimit: 4
  parallelism: 3
  completions: 3
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
service

apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
  namespace: default
spec:
  selector:
    app: nginx
  ports:
  - name: 80tcp1
    port: 80
    protocol: TCP
    targetPort: 80
  type: NodePort
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: demo
  namespace: default
spec:
  rules:
  - host: <your-host-name>
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
Configmap

apiVersion: v1
kind: ConfigMap
metadata:
  name: demo
  namespace: default
data:
  conf: |-
    worker_processes 4;
    worker_rlimit_nofile 40000;

    events {
        worker_connections 8192;
    }

    http {
        server {
            listen         80;
            return 301 https://192.168.0.1;
        }
    }

    stream {
        upstream rancher_servers {
            least_conn;
            server 192.169.0.1:443 max_fails=3 fail_timeout=5s;
            server 192.169.0.2:443 max_fails=3 fail_timeout=5s;
            server 192.169.0.3:443 max_fails=3 fail_timeout=5s;
        }
        server {
            listen     443;
            proxy_pass rancher_servers;
        }
    }
Storage

部署NFS Provisioner
应用商店

开启应用商店
部署应用
集成日志

部署ES和kibana
docker run -itd -p 9200:9200 -p 9300:9300 -p 5601:5601 \
-e "discovery.type=single-node" \
--name elasticsearch \
docker.elastic.co/elasticsearch/elasticsearch:6.5.4

docker run -it -d \
-e ELASTICSEARCH_URL=http://127.0.0.1:9200 \
--name kibana \
--network=container:elasticsearch \
kibana:6.5.4
在日志中添加ES url
在kibana中查看日志
开启告警

配置通知者 demo（https://github.com/satomic/funny-toolkits/tree/master/python-webhook）
在集群中创建一个deployment，将80端口用nodeport暴露（satomic/python-webhook）192.168.113.38/satomic/python-webhook:1.0
查看控制台日志，webhook demo是否运行
在集群中添加通知者，选择Webhook，并配置<ip>:<nodePort>，点击测试验证并保存
集群配置告警规则
添加主机告警规则，当主机未就绪时发送告警
配置告警接收者为新创建的通知者
修改告警规则，添加新的接收者，使用webhook接收者
查看告警内容
让主机满足配置告警的规则，查看webhook demo的pod日志，是否收到告警信息。

```



```yml



```

### rancher_day2.md

```yml
Rancher HA部署
部署私有镜像仓库(Harbor)
下载并解压harbor离线安装包
tar xvf harbor-offline-installer-v1.7.5.tgz
修改配置harbor.cfg
## vi docker-compose.yml
proxy:
    image: goharbor/nginx-photon:v1.6.0
    container_name: nginx
    restart: always
    volumes:
      - ./common/config/nginx:/etc/nginx:z
    ports:
      - 8888:80
      - 443:443
    depends_on:
      - postgresql
      - registry
      - core
      - portal
      - log
    logging:
      driver: "syslog"
      options:  
        syslog-address: "tcp://127.0.0.1:1514"
        tag: "proxy"

## vi harbor.cfg
hostname = your-ip:your-port
安装harbor
./install.sh --with-clair
访问harbor镜像仓库
docker配置不安全镜像仓库
vi /etc/docker/daemon.json

{
  "insecure-registries" : [
    "your-private-registry-ip:port"
  ]
}
访问harbor服务，创建demo项目
http://39.107.143.115/web/demo/-/archive/master/demo-master.tar
git clone http://39.107.143.115/web/demo.git
编写Dockerfile
FROM 192.168.113.38/library/tomcat:7
COPY demo webapps/demo
EXPOSE 8080
ENTRYPOINT ["bin/catalina.sh", "run"]
发布上传镜像到harbor
docker build -t <your-registry-domain>/demo/demo:v1.0 .
docker login <your-registry-domain>
docker push <your-registry-domain>/demo/demo:v1.0

dockr run -itd -p 8080:8080 <your-registry-domain>/demo/demo:v1.0
Rancher HA 部署
准备Rancher离线镜像，并上传到harbor私有仓库
下载rancher-images.txt,rancher-save-images.sh,rancher-load-images.sh
在镜像仓库创建对应的项目
chmod +x rancher-save-images.sh
rke config --system-images >> ./rancher-images.txt
./rancher-save-images.sh --image-list ./rancher-images.txt

# publish to registry
docker login <your-registry-domain>
./rancher-load-images.sh --image-list ./rancher-images.txt --registry <your-registry-domain>
使用rke部署kubernetes集群
下载并安装rke(http://192.168.157.123:8666/rke_linux-amd64)
主机配置免密登录
ssh-keygen -t rsa
# 将生产的idrsa.pub内容拷贝到要部署集群的主机~/.ssh/authorized_keys
将用户加入docker用户组
usermod -aG docker <your-user-name>
编辑cluster.yml
nodes:
- address: 192.168.113.41
  user: wym
  role: [ "controlplane", "etcd", "worker" ]
  ssh_key_path: /home/wym/.ssh/id_rsa
- address: 192.168.113.42
  user: wym
  role: [ "controlplane", "etcd", "worker" ]
  ssh_key_path: /home/wym/.ssh/id_rsa
- address: 192.168.113.43
  user: wym
  role: [ "controlplane", "etcd", "worker" ]
  ssh_key_path: /home/wym/.ssh/id_rsa

private_registries:
- url: 192.168.113.38 # private registry url
  user: admin
  password: "newcapec"
  is_default: true

rke up --config cluster.yml
在线环境安装helm，并下载cert-manager及rancher-chart 下载地址：http://192.168.157.123:8666/helm-v2.12.1-linux-amd64.tar.gz，解压后，将helm二进制文件拷贝到/usr/local/bin，sudo chmod +x /usr/local/bin/helm
helm init -c --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

helm fetch stable/cert-manager

helm template ./cert-manager-0.2.2.tgz --output-dir . \
--name cert-manager --namespace kube-system

vi cert-manager/templates/deployment.yaml

## 修改镜像地址
192.168.113.38/jetstack/cert-manager-controller:v0.2.3
192.168.113.38/jetstack/cert-manager-ingress-shim:v0.2.3

部署helm
export KUBECONFIG=<your-kube_config_cluster.yml>
kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --skip-refresh --service-account tiller --tiller-image 192.168.113.38/rancher/tiller:v2.12.1

部署rancher
kubectl -n kube-system apply -R -f ./cert-manager

git clone -b v2.2.2 https://github.com/xiaoluhong/server-chart.git

# 需要修改rancherRegistry为私有镜像仓库地址
helm install  --kubeconfig=$kubeconfig \
 --name rancher \
 --namespace cattle-system \
 --set rancherImage=rancher/rancher \
 --set rancherRegistry=192.168.113.38 \
 --set busyboxImage=rancher/busybox \
 --set service.type=NodePort \
 --set service.ports.nodePort=30443  \
 server-chart/rancher
通过NodePort访问rancher，在 全局 > 系统设置 中修改system-default-registry 私有镜像仓库地址
配置rancher system charts 浏览器中访问https://<your-rancher-server>/v3/catalogs/system-library 点 编辑，url修改为http://39.107.143.115/root/system-charts.git
部署私有应用商店
部署gitlab
docker run --detach --env GITLAB_OMNIBUS_CONFIG="external_url 'http://<your-gitlab-ip>';" -p 443:443 -p 80:80 -p 2222:22 --name gitlab --restart always -v /root/gitlab/config:/etc/gitlab -v /root/gitlab/logs:/var/log/gitlab -v /root/gitlab/data:/var/opt/gitlab gitlab/gitlab-ce
创建charts项目
上传charts
在rancher中配置私有gitlab的charts项目
使用私有应用商店部署应用

```


