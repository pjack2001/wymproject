# 常用命令
docker run -it -d --name xx -p 81:80 imagesname
--privileged
--restart=always  
docker update --restart=always 容器ID
docker update --restart=no 容器ID



docker exec -it 容器ID /bin/bash


docker run --help

docker logs -f 容器ID

docker stats 容器ID


docker save $(docker images | grep williamyeh | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o /home/w/tool/docker/images/williamyehansible20190105.tar

docker save $(docker images | grep geerlingguy | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o /home/wym/wymdockerimagesgeerlingguy.tar

docker save $(docker images | grep sath89 | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o /home/wym/wymdockerimagessath89.tar

docker save $(docker images | grep selenium | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o /home/y/docker/imagesbak/selenium20181121.tar

docker save 镜像　-o /home/xxx/xxx.tar

加载镜像：
docker load -i wymdockerimages.tar

titpetric/netdata

portainer/portainer
weaveworks/scope
helyho/dockerfly


amancevice/superset
tylerfowler/superset
docker run -d -p 19999:19999 --name netdata01 titpetric/netdata
netdata 默认访问端口是19999，http://127.0.0.1:19999


## ansible练习环境搭建

相关的镜像 chusiang20190105.tar



https://www.w3cschool.cn/automate_with_ansible/automate_with_ansible-oqiz27p6.html

### 使用docker

在终端机 (Terminal) 里启动 Jupyter 的容器，请依个人喜好选择 image，
其 latest 标签 (tag) 是对应到 alpine-3.4。

$ docker run -p 8888:8888 -d chusiang/ansible-jupyter
$ docker run -p 8888:8888 -d chusiang/ansible-jupyter:alpine-3.4

 http://localhost:8888/ 进入 Jupyter 网站


$ docker run --name server1 -d -P chusiang/ansible-managed-node:ubuntu-16.04

$ docker run --name server2 -d -P chusiang/ansible-managed-node:centos-7

### 使用docker-compose

或者使用docker-compose
参见docker/ansiblejupyter

/home/y/docker-compose/chusiangansible

$ vi docker-compose.yml

version: '2'
services:

  control_machine:
    ports:
      - 8004:8888/tcp
    image: chusiang/ansible-jupyter:latest

  server1:
    ports:
      - 4421:22/tcp
    image: chusiang/ansible-managed-node:ubuntu-16.04

  server2:
    ports:
      - 4422:22/tcp
    image: chusiang/ansible-managed-node:centos-7

  server3:
    ports:
      - 4423:22/tcp
    image: chusiang/ansible-managed-node:centos-7

$ docker-compose up -d
$ docker-compose ps
$ docker-compose stop
$ docker-compose start
$ docker-compose rm -f

登录
http://192.168.102.3:8004





1.若不想通过 Jupyter 操作 Ansible，可直接进入容器里操作，但要记得切换到 /home 目录底下

$ docker exec -it chusiangansible_control_machine_1 sh

vi /home/inventory

2、修改 inventory 档案，并填入步骤 1 取得的 IP 和步骤 2 取得的 OpenSSH port。这次容器的 Port mapping 将会依照 docker-compose.yml 所定义的内容建立，不像原先得一个个的手动设定。

server1  ansible_ssh_host=192.168.102.3  ansible_ssh_port=4421
server2  ansible_ssh_host=192.168.102.3  ansible_ssh_port=4422
server3  ansible_ssh_host=192.168.102.3  ansible_ssh_port=4423

3、环境建置完成！现在可以到 Control Managed (Jupyter + Ansible) 上对各个 Managed node (Ubuntu 14.04, CentOS 7, Debian 8) 进行操作了。

Play Ansible
现在我们可以通过 Ansible 操控 3 个 Managed node 了，记得把 inventory 的部份从 localhost 改成 all喔！




$ ansible all -m ping

$ ansible test -m shell -a 'cat /etc/hostname'
$ ansible test -m shell -a 'cat /etc/hosts'


















```
############################################################################
使用docker在搭建lvs环境        使用docker-compose自动生成lvs环境

https://blog.csdn.net/narry/article/details/51998206

进入docker-compose所在目录才能执行相关命令

$ docker-compose up  #Ctrl+C退出
$ docker-compose up -d  #后台运行

$ docker-compose ps


$ docker-compose restart #重启所有容器
$ docker-compose restart web2  #重启web2  ,dockerlvsmaster_web2_1，取中间的名字
$ docker-compose stop #停止所有容器
$ docker-compose stop web2    #停止App1

进入web2容器
$ docker-compose exec web2 bash

重建容器
docker-compose up -d --force-recreate 使用 --force-recreate 可以强制重建容器 （否则只能在容器配置有更改时才会重建容器）
docker-compose down 停止所有容器，并删除容器 （这样下次使用docker-compose up时就一定会是新容器了）

docker-compose up是创建和启动容器，具我所知只有在三种情况下会重新创建容器（即先删除旧的容器，再生成一个新的）：
1.当镜像有更新时，会重新创建容器；
2.容器不存在（即被删除了）;
3.当容器A重新创建时，其依赖此容器的容器将会重新创建（即docker-compose.yml文件中的容器设置了depends_on为容器A的容器）

build
创建或者再建服务
服务被创建后会标记为project_service(比如composetest_db)，如果改变了一个服务的Dockerfile或者构建目录的内容，可以使用docker-compose build来重建它



使用docker compose部署服务

谈到微服务的话题，技术上我们往往会涉及到多服务、多容器的部署与管理。
Docker 有三个主要的作用：Build, Ship和Run。使用docker compose我们可以在Run的层面解决很多实际问题，如：通过创建compose(基于YUML语法)文件，在这个文件上面描述应用的架构，如使用什么镜像、数据卷、网络、绑定服务端口等等，然后再用一条命令就可以管理所有的服务（如启动、停止、重启、日志监控等等）


https://docs.docker.com/compose/gettingstarted/#step-8-experiment-with-some-other-commands

```

### ansible练习

```

############################################################################
https://hub.docker.com/r/ansiblecheck/ansiblecheck

Docker图像
ubuntu-12.04，ubuntu-precise（ubuntu-precise / Dockerfile）
ubuntu-14.04，ubuntu-trusty（ubuntu-trusty / Dockerfile）
ubuntu-16.04，ubuntu-xenial（ubuntu-xenial / Dockerfile）
ubuntu-16.10，ubuntu-yakkety（ubuntu-yakkety / Dockerfile）
ubuntu-18.04，ubuntu-bionic（ubuntu-bionic / Dockerfile）
debian-9，debian-stretch（debian-stretch / Dockerfile）
debian-8，debian-jessie（debian-jessie / Dockerfile）
debian-7，debian-wheezy（debian-wheezy / Dockerfile）
centos-7，el-7 （el-7 / Dockerfile）
centos-6，el-6 （el-6 / Dockerfile）
fedora-24（fedora-24 / Dockerfile）
fedora-23（fedora-23 / Dockerfile）
archlinux-latest（archlinux-latest / Dockerfile）
oraclelinux-7，oraclelinux-7.3（oraclelinux-7.3 / Dockerfile）
oraclelinux-7.2（oraclelinux-7.2 / Dockerfile）
oraclelinux-7.1（oraclelinux-7.1 / Dockerfile）
oraclelinux-7.0（oraclelinux-7.0 / Dockerfile）
oraclelinux-6，oraclelinux-6.8（oraclelinux-6.8 / Dockerfile）
oraclelinux-6.7（oraclelinux-6.7 / Dockerfile）
oraclelinux-6.6（oraclelinux-6.6 / Dockerfile）
opensuse-42.2 opensuse-leap（opensuse-42.2 / Dockerfile）
opensuse-42.1（opensuse-42.1 / Dockerfile）

docker pull ansiblecheck/ansiblecheck:ubuntu-xenial
docker pull ansiblecheck/ansiblecheck:el-7
docker pull ansiblecheck/ansiblecheck:el-6

############################################################################
https://hub.docker.com/r/williamyeh/ansible

稳定版本（从官方PyPI repo安装）：
正常变种：

williamyeh/ansible:debian9
williamyeh/ansible:debian8
williamyeh/ansible:ubuntu18.04
williamyeh/ansible:ubuntu16.04
williamyeh/ansible:ubuntu14.04
williamyeh/ansible:centos7
williamyeh/ansible:alpine3

docker pull williamyeh/ansible:centos7


```
