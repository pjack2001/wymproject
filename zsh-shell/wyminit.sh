#!/bin/sh
# File    :   wyminit.sh
# Time    :   2019/05/05 16:06:40
# Author  :   wangyuming 
# Version :   0.1
# License :   (C)Copyright 2018-2019, MIT
# Desc    :   None


sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config && systemctl restart sshd && systemctl stop firewalld && setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config && sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

mkdir -p /etc/yum.repos.d/repobak && mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak && curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo && curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo && curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo && yum clean all && yum makecache && yum install -y wget vim tree net-tools zip unzip tmux dstat && yum install -y docker-ce

#systemctl start docker && systemctl enable docker 
mkdir -p /etc/docker && echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.3:8001","0.0.0.0/0"]}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker

#mkdir -p /etc/docker && echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["0.0.0.0/0"]}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker

#mkdir -p /etc/docker && echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.3:8001","http://192.168.31.50"]}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker
