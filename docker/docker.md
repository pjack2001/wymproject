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
