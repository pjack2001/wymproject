# kubeasz安装

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




##

```yml
centos7.6系统

配置免密登录

CentOS 7 请执行以下脚本：

# 文档中脚本默认均以root用户执行
# 安装 epel 源并更新
yum install epel-release -y
yum update
# 删除不要的默认安装
yum erase firewalld firewalld-filesystem python-firewall -y
# 安装依赖工具
yum install git python python-pip -y




```


##

```yml
w：建立虚拟机
~/tool/vagrant/k8sallinone

1、虚拟机目录
git克隆的kubeasz安装文件放在/home/w/tool/vagrant/kubeasz，后来拷贝到~/tool/vagrant/k8sallinone目录下

启动虚拟机，做快照
$ vagrant snapshot save kubeasz1

2、配置ssh免密登录

$ ansible-playbook /media/xh/i/wymproject/ansible/testw/Verified/PushKey.yml -u root -k
$ ssh root@172.17.8.161

$ ansible all -m ping 如果报错，可能是用户不对

$ ansible all -m ping -u root

如果以前配置过，删除
$ ssh-keygen -f "/home/w/.ssh/known_hosts" -R "172.17.8.161"

3、按照文档后面，下载，解压到/etc/ansible的bin目录和down目录，并把kubeasz的所有文件拷贝到/etc/ansible目录

4、配置hosts
$ cp example/hosts.allinone.example hosts

5、执行安装
# 一步安装
#ansible-playbook 90.setup.yml

#如果安装时报错
$ ansible-playbook 90.setup.yml 
PLAY [all] **********************************************************************************
TASK [Gathering Facts] **********************************************************************
fatal: [172.17.8.161]: UNREACHABLE! => {"changed": false, "msg": "SSH Error: data could not be sent to remote host \"172.17.8.161\". Make sure this host can be reached over ssh", "unreachable": true}


加-u root，加sudo
$ sudo ansible-playbook 90.setup.yml -u root

6、安装完成，ssh登录，测试
$ ssh root@192.168.113.53

# kubectl cluster-info
Kubernetes master is running at https://192.168.113.53:6443
CoreDNS is running at https://192.168.113.53:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://192.168.113.53:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
[root@kubeasz53 ansible]# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
Name:         admin-user-token-lt999
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name=admin-user
              kubernetes.io/service-account.uid=edcf0f32-8873-11e9-bc35-fefcfeb23fe9

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1346 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWx0OTk5Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJlZGNmMGYzMi04ODczLTExZTktYmMzNS1mZWZjZmViMjNmZTkiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.aHPVlMa51udsf1geLmnIjbUizHTpHVXzhHUsKZJLTF4DCBWBc1ZNJLjlxCcDKBK5d8nRpzVnJPBwdWpNpnAGCh6yWw_-yBIlDogkcqJxhR8yhuMaYLi3MfDM5Dyoi_0IygOqxoEdX27nE72btoRYNCPe1Qmv1zqhLvTbpVgGs-3wWhH1nsR4SYLPJMfFvmG7hdDSUzxCSvbCeifPfmrfSbZUR4YPHKFB4iGPikzekb1FOoS9QFpS0XwIOb_ll7sFJi8G-Tyy8mLUQiL3Ij3GEO2b6ZMHntxuUptR2pgIWFyO-UKHrHU5vld9D7_pZxi6UXxnbPO401bY0iO4g7SqZw
[root@kubeasz53 ansible]#

浏览器登录：https://192.168.113.53:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy

并用默认用户 `admin:test1234` 登陆，输入token

7、做快照

$ vagrant snapshot save kubeasz1b


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

102：
https://192.168.102.10:6443
/home/y/vagrant/allinonekubeasz




```

## 配置k8s.1-11-6.tar.gz成功

在102.3上用Firefox可以正常访问,第一次登录admin/test1234,然后输入令牌即可
$ ssh root@192.168.102.10
# kubectl cluster-info 
Kubernetes master is running at https://192.168.102.10:6443
CoreDNS is running at https://192.168.102.10:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://192.168.102.10:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy

# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

```
建立一个vagrant虚拟机centos7，8G内存，安装docker,配置文件Vagrantfile-k8sallinonekubeasz

在主机使用ansible安装k8s到虚拟机192.168.102.10

ansible安装及准备

# 安装ansible (国内如果安装太慢可以直接用pip阿里云加速)
#pip install pip --upgrade
#pip install ansible
pip install pip --upgrade -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
pip install --no-cache-dir ansible -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

# 配置ansible ssh密钥登陆
ssh-keygen -t rsa -b 2048 回车 回车 回车
ssh-copy-id 192.168.102.10 #$IP为本虚机地址，按照提示输入yes 和root密码

配置ubuntu免密登录
ssh-keygen -t rsa -b 2048 回车 回车 回车
$ ssh-copy-id wym@192.168.113.44



下载项目源码
# 方式一：使用git clone
git clone https://github.com/gjmzj/kubeasz.git
mkdir -p /etc/ansible
mv kubeasz/* /etc/ansible

下载二进制文件
请从分享的百度云链接，下载解压到/etc/ansible/bin目录，如果你有合适网络环境也可以按照/down/download.sh自行从官网下载各种tar包
tar zxvf k8s.1-11-6.tar.gz   # 以安装k8s v1.9.8为例
mv bin/* /etc/ansible/bin

 [可选]下载离线docker镜像
服务器使用内部yum源/apt源，但是无法访问公网情况下，请下载离线docker镜像完成集群安装；
从百度云盘把basic_images_kubeasz_x.y.tar.gz 下载解压到/etc/ansible/down 目录,有0.2,0.3,0.4，可以都加压
tar zxvf extra_images_kubeasz_0.2.tar.gz -C /etc/ansible/down
tar zxvf basic_images_kubeasz_0.3.tar.gz -C /etc/ansible/down
tar zxvf basic_images_kubeasz_0.4.tar.gz -C /etc/ansible/down


配置集群参数
cd /etc/ansible
cp example/hosts.allinone.example hosts
vim hosts           # 根据实际情况修改此hosts文件，所有节点改成虚拟机IP:192.168.102.10

ubuntu节点需要在hosts文件添加如下root权限
# cat hosts
[rancher]
192.168.113.41 ansible_ssh_user=wym ansible_become_user=root ansible_become=true ansible_become_pass='newcapecwym'

# 验证ansible安装，正常能看到每个节点返回 SUCCESS
ansible all -m ping
ansible all -m ping -u wym


开始安装
如果你对集群安装流程不熟悉，请阅读项目首页 安装步骤 讲解后分步安装，并对 每步都进行验证
# 分步安装
ansible-playbook 01.prepare.yml
ansible-playbook 02.etcd.yml
ansible-playbook 03.docker.yml
ansible-playbook 04.kube-master.yml
ansible-playbook 05.kube-node.yml
ansible-playbook 06.network.yml
ansible-playbook 07.cluster-addon.yml 

# 一步安装
#ansible-playbook 90.setup.yml

$ ansible-playbook 90.setup.yml -u wym

[可选]对集群节点进行操作系统层面的安全加固 ansible-playbook roles/os-harden/os-harden.yml，详情请参考os-harden项目


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


# 获取访问dashboard token 
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

# 使用浏览器访问前面``kubectl cluster-info ``获取的dashboard地址，最后一条命令获取的token登陆。

6.安装主要组件
# 安装kubedns，默认已集成安装
#kubectl create -f /etc/ansible/manifests/kubedns
# 安装dashboard，默认已集成安装
#kubectl create -f /etc/ansible/manifests/dashboard

登陆 dashboard可以查看和管理集群，更多内容请查阅dashboard文档


清理集群以上步骤创建的K8S开发测试环境请尽情折腾，碰到错误尽量通过查看日志、上网搜索、提交issues等方式解决；当然如果是彻底奔溃了，可以清理集群后重新创建。

ansible-playbook 99.clean.yml
如果出现清理失败，类似报错：... Device or resource busy: '/var/run/docker/netns/xxxxxxxxxx'，需要手动umount该目录后重新清理

$ umount /var/run/docker/netns/xxxxxxxxxx
$ ansible-playbook /etc/ansible/tools/clean_one_node.yml

















```

## 原帖子

https://www.cnblogs.com/cheyunhua/p/9389650.html

最小化安装k8s
96 
Nick_4438 关注
2018.07.11 10:40* 字数 670 阅读 0评论 0喜欢 0
1.前言
之前写过一篇二进制手工安装k8s的文章，过程复杂，搞了多日才安装成功。
直到最近，在github上看到一个使用Ansible安装k8s的工程，安装过程之简单着实让我惊讶，感谢作者的开源精神。

原项目地址： https://github.com/gjmzj/kubeasz
作者fork项目地址：https://github.com/qiujiahong/kubeasz

本文是读该项目的的读书笔记，相对原文稍微有一点改动，文中介绍了最小话安装的流程，读者如果需要做高可用安装可以参考github项目；
本文介绍最小化安装k8s；
安装系统版本： CentOS Linux release 7.5.1804 (Core)

2.基础系统配置
推荐内存2G/硬盘30G以上
CentOS Linux release 7.5.1804 (Core)
配置基础网络、更新源、SSH登陆等

3.安装依赖工具
CentOS 7 请执行以下脚本：

# 文档中脚本默认均以root用户执行
# 安装 epel 源
yum install epel-release -y
# 安装依赖工具
yum install git python python-pip -y

3.ansible安装及准备
# 安装ansible (国内如果安装太慢可以直接用pip阿里云加速)
#pip install pip --upgrade
#pip install ansible
pip install pip --upgrade -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
pip install --no-cache-dir ansible -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
# 配置ansible ssh密钥登陆
ssh-keygen -t rsa -b 2048 回车 回车 回车
ssh-copy-id $IP #$IP为本虚机地址，按照提示输入yes 和root密码

4.安装kubernetes集群

4.1 下载项目源码
# 方式一：使用git clone
git clone https://github.com/gjmzj/kubeasz.git
mkdir -p /etc/ansible
mv kubeasz/* /etc/ansible
# 方式二：从发布页面 https://github.com/gjmzj/kubeasz/releases 下载源码解压到同样目录

4.2a 下载二进制文件
请从分享的百度云链接，下载解压到/etc/ansible/bin目录，如果你有合适网络环境也可以按照/down/download.sh自行从官网下载各种tar包
tar zxvf k8s.1-9-8.tar.gz   # 以安装k8s v1.9.8为例
mv bin/* /etc/ansible/bin

4.2b [可选]下载离线docker镜像
服务器使用内部yum源/apt源，但是无法访问公网情况下，请下载离线docker镜像完成集群安装；从百度云盘把basic_images_kubeasz_x.y.tar.gz 下载解压到/etc/ansible/down 目录
tar zxvf basic_images_kubeasz_0.2.tar.gz -C /etc/ansible/down

4.3 配置集群参数
cd /etc/ansible
cp example/hosts.allinone.example hosts
vim hosts           # 根据实际情况修改此hosts文件，所有节点改成本机IP
# 验证ansible安装，正常能看到每个节点返回 SUCCESS
ansible all -m ping

4.4 开始安装
如果你对集群安装流程不熟悉，请阅读项目首页 安装步骤 讲解后分步安装，并对 每步都进行验证
# 分步安装
ansible-playbook 01.prepare.yml
ansible-playbook 02.etcd.yml
ansible-playbook 03.docker.yml
ansible-playbook 04.kube-master.yml
ansible-playbook 05.kube-node.yml
ansible-playbook 06.network.yml
ansible-playbook 07.cluster-addon.yml 
# 一步安装
#ansible-playbook 90.setup.yml
[可选]对集群节点进行操作系统层面的安全加固 ansible-playbook roles/os-harden/os-harden.yml，详情请参考os-harden项目

5.验证安装
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
# 获取访问dashboard token 
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
# 使用浏览器访问前面``kubectl cluster-info ``获取的dashboard地址，最后一条命令获取的token登陆。

6.安装主要组件
# 安装kubedns，默认已集成安装
#kubectl create -f /etc/ansible/manifests/kubedns
# 安装dashboard，默认已集成安装
#kubectl create -f /etc/ansible/manifests/dashboard
登陆 dashboard可以查看和管理集群，更多内容请查阅dashboard文档

7.清理集群
以上步骤创建的K8S开发测试环境请尽情折腾，碰到错误尽量通过查看日志、上网搜索、提交issues等方式解决；当然如果是彻底奔溃了，可以清理集群后重新创建。

ansible-playbook 99.clean.yml
如果出现清理失败，类似报错：... Device or resource busy: '/var/run/docker/netns/xxxxxxxxxx'，需要手动umount该目录后重新清理

$ umount /var/run/docker/netns/xxxxxxxxxx
$ ansible-playbook /etc/ansible/tools/clean_one_node.yml


#################################################################################


https://github.com/gjmzj/kubeasz/blob/master/docs/setup/quickStart.md


gjmzj/kubeasz allinone部署k8s
 
快速指南
以下为快速体验k8s集群的测试、开发环境--allinone部署，国内环境下觉得比官方的minikube方便、简单很多。

1.基础系统配置
推荐内存2G/硬盘30G以上
最小化安装Ubuntu 16.04 server或者CentOS 7 Minimal
配置基础网络、更新源、SSH登陆等
2.安装依赖工具
Ubuntu 16.04 请执行以下脚本:

# 文档中脚本默认均以root用户执行
# 安装依赖工具
apt-get install python2.7 git python-pip
# Ubuntu16.04可能需要配置以下软连接
ln -s /usr/bin/python2.7 /usr/bin/python
CentOS 7 请执行以下脚本：

# 文档中脚本默认均以root用户执行
# 安装 epel 源
yum install epel-release -y
# 安装依赖工具
yum install git python python-pip -y
3.ansible安装及准备
# 安装ansible (国内如果安装太慢可以直接用pip阿里云加速)
#pip install pip --upgrade
#pip install ansible
pip install pip --upgrade -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
pip install --no-cache-dir ansible -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
# 配置ansible ssh密钥登陆
ssh-keygen -t rsa -b 2048 回车 回车 回车
ssh-copy-id $IP #$IP为本虚机地址，按照提示输入yes 和root密码
在Ubuntu 16.04中，如果出现以下错误:

Traceback (most recent call last):
  File "/usr/bin/pip", line 9, in <module>
    from pip import main
ImportError: cannot import name main
将/usr/bin/pip做以下修改：

#原代码
from pip import main
if __name__ == '__main__':
    sys.exit(main())

#修改后
from pip import __main__
if __name__ == '__main__':
    sys.exit(__main__._main())
4.安装kubernetes集群
4.1 下载项目源码
# 方式一：使用git clone
git clone https://github.com/gjmzj/kubeasz.git
mkdir -p /etc/ansible
mv kubeasz/* /etc/ansible
# 方式二：从发布页面 https://github.com/gjmzj/kubeasz/releases 下载源码解压到同样目录
4.2a 下载二进制文件
请从分享的百度云链接，下载解压到/etc/ansible/bin目录，如果你有合适网络环境也可以按照/down/download.sh自行从官网下载各种tar包
tar zxvf k8s.1-9-8.tar.gz	# 以安装k8s v1.9.8为例
mv bin/* /etc/ansible/bin
4.2b [可选]下载离线docker镜像
服务器使用内部yum源/apt源，但是无法访问公网情况下，请下载离线docker镜像完成集群安装；从百度云盘把basic_images_kubeasz_x.y.tar.gz 下载解压到/etc/ansible/down 目录
tar zxvf basic_images_kubeasz_0.2.tar.gz -C /etc/ansible/down
4.3 配置集群参数

4.3.1 必要配置：cd /etc/ansible && cp example/hosts.allinone.example hosts, 然后实际情况修改此hosts文件
4.3.2 可选配置，初次使用可以不做修改，详见配置指南
4.3.3 验证ansible 安装：ansible all -m ping 正常能看到节点返回 SUCCESS
4.4 开始安装 如果你对集群安装流程不熟悉，请阅读项目首页 安装步骤 讲解后分步安装，并对 每步都进行验证

# 分步安装
ansible-playbook 01.prepare.yml
ansible-playbook 02.etcd.yml
ansible-playbook 03.docker.yml
ansible-playbook 04.kube-master.yml
ansible-playbook 05.kube-node.yml
ansible-playbook 06.network.yml
ansible-playbook 07.cluster-addon.yml 
# 一步安装
#ansible-playbook 90.setup.yml
[可选]对集群节点进行操作系统层面的安全加固 ansible-playbook roles/os-harden/os-harden.yml，详情请参考os-harden项目

5.验证安装
如果提示kubectl: command not found，退出重新ssh登陆一下，环境变量生效即可

kubectl version
kubectl get componentstatus # 可以看到scheduler/controller-manager/etcd等组件 Healthy

kubectl get node # 可以看到单 node Ready状态
kubectl get pod --all-namespaces # 可以查看所有集群pod状态，默认已安装网络插件、coredns、metrics-server等
kubectl get svc --all-namespaces # 可以查看所有集群服务状态

kubectl cluster-info # 可以看到kubernetes master(apiserver)组件 running
# 获取访问dashboard token 
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
# 使用浏览器访问前面``kubectl cluster-info ``获取的dashboard地址，最后一条命令获取的token登陆。



6.安装主要组件
# 安装kubedns，默认已集成安装
#kubectl create -f /etc/ansible/manifests/kubedns
# 安装dashboard，默认已集成安装
#kubectl create -f /etc/ansible/manifests/dashboard
登陆 dashboard可以查看和管理集群，更多内容请查阅dashboard文档
7.清理集群
以上步骤创建的K8S开发测试环境请尽情折腾，碰到错误尽量通过查看日志、上网搜索、提交issues等方式解决；当然如果是彻底奔溃了，可以清理集群后重新创建。

ansible-playbook 99.clean.yml
如果出现清理失败，类似报错：... Device or resource busy: '/var/run/docker/netns/xxxxxxxxxx'，需要手动umount该目录后清理

$ umount /var/run/docker/netns/xxxxxxxxxx
$ rm -rf /var/run/docker/netns/xxxxxxxxxx







