# docker培训

©王予明2019

## 学习参考资料
```
《Docker从入门到实践》
菜鸟教程http://www.runoob.com/docker/docker-tutorial.html

思维导图
https://www.processon.com/view/5bda9e15e4b0844e0bc2cdea
https://www.processon.com/view/5bfd2d4ee4b0f012f2346b33
```

## 准备

### 注意：root用户不用加sudo
```

设置用户的sudo权限
# yum install -y sudo
# chmod u+w /etc/sudoers
# echo 'wym    ALL=(ALL)       ALL' >> /etc/sudoers

检查selinux和防火墙是否关闭

# vim /etc/selinux/config
SELINUX=disabled

# setenforce 0  #临时关闭
# getenforce  #查看状态

# systemctl disable firewalld.service #禁止自启动
# systemctl stop firewalld.service
# systemctl status firewalld.service


```

## 安装

### 更换阿里yum源，需要连外网

```
sudo mkdir -p /etc/yum.repos.d/repobak
sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum clean all && yum makecache
```
### 公司内网yum源
```
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo

```

### 安装docker版本
```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum list docker-ce --showduplicates
sudo yum install -y docker-ce 或安装特定版本docker-ce-18.03.1.ce
sudo systemctl start docker
sudo systemctl enable docker

删除 Docker CE
$ sudo yum remove docker-ce
$ sudo rm -rf /var/lib/docker

yum -y remove docker docker-common docker-selinux docker-engine docker-engine-selinux container-selinux docker-ce

yum -y remove docker-ce-cli

#查看是否已经安装的Docker软件包
sudo yum list installed | grep docker

```

### 镜像加速

```
sudo mkdir -p /etc/docker

可以选择多个加速器，建议阿里，但是需要注册
# https://xxxx.mirror.aliyuncs.com
# http://hub-mirror.c.163.com 
# http://f1361db2.m.daocloud.io

默认没有daemon.json,自己用下面的一种方法新建
$vim /etc/docker/daemon.json
{
  "registry-mirrors": ["https://xxxx.mirror.aliyuncs.com"]
}
或
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
EOF
或
sudo echo -e "{\n \"registry-mirrors\": [\"http://hub-mirror.c.163.com\"]\n}" > /etc/docker/daemon.json
或
sudo curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io

注意查看格式是否正确
# cat /etc/docker/daemon.json

sudo systemctl daemon-reload
sudo systemctl restart docker

```


## docker常用命令

```

$ sudo docker #显示docker命令
$ sudo docker -v #显示 Docker 版本信息
$ sudo docker version #显示 Docker 版本信息
$ sudo docker info #显示 Docker 系统信息，包括镜像和容器数

$ sudo docker search centos
$ sudo docker search centos --no-trunc #可显示完整的镜像描述
$ sudo docker search -s 10 tomcat    # 搜索10星以上的tomcat镜像

镜像
$ sudo docker pull tomcat #拉取指定镜像，可以加版本

$ sudo docker images #显示所有镜像

把镜像保存成一个tar文件，注意如果目录没有，需要提前建立一下，docker不会帮你建立目录的
$ sudo docker save 镜像名 -o /imagesbak/xxx.tar

筛选关键字批量打包
# docker save $(docker images | grep 关键字 | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o /imagesbak/dockerimages.tar

加载镜像备份
$ sudo docker load -i /imagesbak/xxx.tar

$ sudo docker rmi 镜像ID

容器

实例：使用镜像 nginx:latest，以后台模式启动一个容器,将容器的 80 端口映射到主机的 8001 端口,主机的目录 /data 映射到容器的 /datatest，并将容器命名为mynginx。。
docker run --name mynginx -p 8001:80 -v /data:/datatest -d nginx:latest

docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
OPTIONS说明：
-a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
-d: 后台运行容器，并返回容器ID；
-i: 以交互模式运行容器，通常与 -t 同时使用；
-p: 端口映射，格式为：主机(宿主)端口:容器端口
-t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
--name="nginx-lb": 为容器指定一个名称；
--dns 8.8.8.8: 指定容器使用的DNS服务器，默认和宿主一致；
--dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致；
-h "mars": 指定容器的hostname；
-e username="ritchie": 设置环境变量；
--env-file=[]: 从指定文件读入环境变量；
--cpuset="0-2" or --cpuset="0,1,2": 绑定容器到指定CPU运行；
-m :设置容器使用内存最大值；
--net="bridge": 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；
--link=[]: 添加链接到另一个容器；
--expose=[]: 开放一个端口或一组端口；


$ sudo docker ps #列出所有运行中容器
$ sudo docker ps -a #列出所有容器（含沉睡镜像）
$ sudo docker ps -l #仅列出最新创建的一个容器
$ sudo docker ps -n=3 #列出最近创建的3个容器
$ sudo docker ps -s #显示容器大小

$ sudo docker stop 停止容器名或ID
$ sudo docker start 启动容器名或ID
$ sudo docker restart 重启容器名或ID

进入容器
$ sudo docker exec -it 容器ID /bin/sh

删除，容器要先停止
$ sudo docker rm 容器ID
-f 强行移除该容器，即使其正在运行；
-l 移除容器间的网络连接，而非容器本身；
-v 移除与容器关联的空间。


查看
$ sudo docker top #查看一个正在运行容器进程

$ sudo docker inspect 镜像或容器ID  #检查镜像或者容器的参数，默认返回 JSON 格式

$ sudo docker logs -f 容器ID #查看指定容器的日志记录


其他命令

#获取Container IP地址（Container状态必须是Up）
$ sudo docker inspect 容器ID | grep IPAddress | cut -d '"' -f 4    

#获取环境变量
$ sudo docker exec 677 env  
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=3863f1da45f4
HOME=/root


```

## docker使用tomcat环境

```
$ docker pull tomcat
$ docker inspect tomcat  #查看镜像信息，比如查看tomcat的路径CATALINA_HOME=/usr/local/tomcat

启动容器，映射到主机8018端口，挂载/opt/tomcat/test目录
$ docker run -dit -p 8018:8080 --name tomcat01 -v /opt/tomcat/test:/usr/local/tomcat/webapps/test tomcat

$ docker ps -l查看最新的容器

$ docker exec -it 677 /bin/bash  #进入容器

查看tomcat
http://127.0.0.1:8018/

查看相关页面
http://127.0.0.1:8018/test/helloworld.html


在本机操作，编写helloworld.html文件，容器里同时也有，页面也同时显示
# cd /opt/tomcat/test
# touch helloworld.html
# chmod -R 755 /opt/tomcat 
# echo "helloworld" > helloworld.html


```

## 安装jdk和tomcat环境

```
注意：自己准备jdk和tomcat安装文件

$ docker pull centos
$ docker run -dit -p 8080:8080 --name centos7w -v /opt/tomcat/test1:/home/wym/tomcat/test centos

进入容器，以下都在容器中操作
$ docker exec -it d08 /bin/bash

更新源
# yum update

安装scp
# yum -y install openssh-clients

远程拷贝jdk和tomcat的安装文件
# scp w@192.168.31.xx:/media/xh/i/java/*.tar.gz /home/wym/tomcat/

解压
# tar -zxvf jdk-8u181-linux-x64.tar.gz
# tar -zxvf apache-tomcat-8.5.33.tar.gz

# mv apache-tomcat-8.5.33 tomcat8.5
# mv jdk1.8.0_181 jdk1.8

配置环境变量
# cp /etc/profile /etc/profile-bak
# vi /etc/profile

#set java environment
JAVA_HOME=/home/wym/tomcat/jdk1.8
CLASSPATH=$JAVA_HOME/lib/
CATALINA_HOME=/home/wym/tomcat/tomcat8.5
PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin
export PATH JAVA_HOME CLASSPATH CATALINA_HOME

使配置生效
# source /etc/profile

验证java
# java -version

启动tomcat
# /home/wym/tomcat/tomcat8.5/bin/startup.sh
# /home/wym/tomcat/tomcat8.5/bin/shutdown.sh

# netstat -tln
# tail -f /home/wym/tomcat/tomcat8.5/logs/catalina.out

http://127.0.0.1:8080

http://127.0.0.1:8080/test/

如果因为权限问题，可以设置属组和访问权限
# chmod -R 755 /home/wym/tomcat/tomcat8.5/webapps/test/
# chown -R apache:apache /home/wym/tomcat/tomcat8.5/webapps/test/


注意防火墙和SElinux要关闭

```

## docker使用oracle(以前的记录，仅供参考)


### 数据库
```
http://IP:8080/apex
使用以下设置连接到Oracle Application Express Web管理控制台：

http://IP:8080/apex
workspace: INTERNAL
user: ADMIN
password: 
    Apex升级到v 5. *

docker run -it --rm --volumes-from ${DB_CONTAINER_NAME} \ 
--link ${DB_CONTAINER_NAME}:oracle-database \
-e PASS=YourSYSPASS sath89/apex install
    
使用以下设置连接到Oracle企业管理控制台：

http://IP:8080/em
user: sys
password: oracle
connect as sysdba: true
```

### 使用Docker创建oracle数据库 

```
使用sath89/oracle-12c镜像，５.7G

# chmod -R 777 /u01/app/oracle

# docker run -d -p 8080:8080 -p 5500:5500 -p 1521:1521 -v /u01/app/oracle:/u01/app/oracle -e DBCA_TOTAL_MEMORY=1024 --name oracle12c sath89/oracle-12c

查看日志 # docker logs -f bf2，发现正在创建数据库实例，安装成功

Database not initialized. Initializing database.
Starting tnslsnr
Copying database files
1% complete
Completing Database Creation
100% complete

Look at the log file "/u01/app/oracle/cfgtoollogs/dbca/xe/xe.log" for further details.
Configuring Apex console
Database initialized. Please visit http://#containeer:8080/em http://#containeer:8080/apex for extra configuration if needed
Starting web management console

PL/SQL procedure successfully completed.

Starting import from '/docker-entrypoint-initdb.d':
    ls: cannot access /docker-entrypoint-initdb.d/*: No such file or directory
    Import finished

    Database ready to use. Enjoy! ;)

# docker exec -it bf2 /bin/bash


```

## 物联网平台安装(以前的记录，仅供参考)

### 物联网

http://IP:8080/
使用用户名：
sysadmin，密码：sysadmin
tenant@newcapec.net，密码：123456登录.



### mysql
```
# docker -v
# docker ps

# sh loadmsql.sh

# docker exec -it mysql bash

bash-4.2# mysql -u root -p        
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 151
Server version: 8.0.11 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use mysql;
mysql> select user,host from user;
mysql> update user set host='%' where user='root';
mysql> flush privileges;
mysql> select user,host from user;
mysql> alter user 'root'@'%' identified with mysql_native_password by 'root123';

```

### 连接数，需要重启

```
# vi /etc/security/limits.conf
* soft nofile 1024000
* hard nofile 1024000
hive   - nofile 1024000
hive   - nproc  1024000

```

### 4.4	如何重启服务
执行sh restart.sh


### 4.5	如何判断服务是否正常启动
通过浏览器访问：
http://ip:8085/api/health
http://ip:8088/api/health
如果都能返回：

### 登录
http://IP:8080/

```
2.	在浏览器里，输入：http://服务器IP:8080，打开物联网管理平台。使用用户名：
sysadmin，密码：sysadmin登录，如果打不开或者登录失败，请查看下一章节。从系统设置-集群配置，设置集群部署信息，需要和deploys.sh配置的对应。如下图：
 

3.	规则插件的导入和配置（集群或者单机部署都需要执行这一步）。
输入：http://服务器IP:8080，打开物联网管理平台。使用用户名：
tenant@newcapec.net，密码：123456登录.
注意：
1．	先删除现有的插件和规则。导入有顺序，需要先导入插件，然后导入规则。
2．	只需要修改插件里的IP和端口。
3．	配置后，在插件和规则列表，点“激活”，激活插件和规则。

 
3.3.3.	安装结果验证
验证物联网平台服务
	可以使用telnet 服务器IP 端口， 端口默认是8088 8085， 确定后台服务是否启动成功。
命令如下：
  
 
	可以在浏览器里访问： http://ip:8085/api/health  http://ip:8088/api/health 如果能返回{"method":"HealthCheck","retcode":200,"retmsg":"ok","param":{"status":"ok"}}，表示服务正常启动。
	如果上述无法打开。登录服务器，查看日志信息（优先查看router.log）。Linux的在home/thingslink/tllog文件夹下，查看后台服务日志分析。如果无法确认，联系客服。

验证物联网管理平台：
	在浏览器里，输入：http://服务器IP:8080，打开物联网管理平台。默认租户用户名：tenant@newcapec.net 密码：123456 
```


##  docker-compose

### 常用docker-compose命令
```
首先要进入docker-compose.yml所在目录，再执行命令

其它命令（修改配置文件后最好把容器删除再创建）：
docker-compose up -d               ###后台启动，如果容器不存在根据镜像自动创建
docker-compose down -v         ###停止容器并删除容器
docker-compose start                 ###启动容器，容器不存在就无法启动，不会自动创建镜像
docker-compose stop                 ###停止容器
docker-compose logs        ###查看日志（harbor日志存放地址 /var/logs/harbor）
docke-compose ps             ###查看容器

如果用的不是标准yml名称docker-compose.yml，就要用-f参数指定自定义的yml文件

```
### 例子

```
$ cd tomcat/
$ cat docker-compose.yml 
version: '3.1'

services:

  tomcat:
    image: tomcat
    restart: always
    container_name: tomcat_w
    hostname: tomcat_w
    ports:
      - 8080:8080
    volumes:
      - /opt/tomcat/test:/webapps/test/

  mysql:
    image: mysql:5.7
    restart: always
    container_name: tomcat_db
    hostname: tomcat_db
    environment:
      MYSQL_ROOT_PASSWORD: newcapec


```

## Docker私有仓库使用说明

    注：
    现有仓库空间不大，仅作为测试使用，不要上传过多无用的镜像
    需要的镜像可以和管理员联系，管理员负责下载并上传私有仓库

### 1、访问路径：http://192.168.102.3:8001
### 2、首先，自己注册，然后登录，密码必须包含大小写、数字
### 3、登录后，可以看到公开的项目和自己的私有项目，可以自己新建私有项目
### 4、本地的Docker配置

#### 问题：
docker1.3.2版本开始默认docker registry使用的是https，我们设置Harbor默认http方式，所以当执行用docker login、pull、push等命令操作非https的docker regsitry的时就会报错。

#### 解决办法：

- 1)、 如果系统是MacOS，则可以点击“Preference”里面的“Advanced”在“InsecureRegistry”里加上192.168.102.3:8001，重启Docker客户端就可以了。
- 2)、 如果系统是Ubuntu，则修改配置文件/lib/systemd/system/docker.service，修改[Service]下ExecStart参数，增加– insecure-registry 192.168.102.3:8001
- 3)、 如果系统是Centos，可以修改配置/etc/sysconfig/docker，将OPTIONS增加 –insecure-registry 192.168.102.3:8001
- 4)、 如果是新版本的docker,在/etc/sysconfig/ 没有docker这个配置文件的情况下,在/etc/docker/目录下，如果没有daemon.json则新建，有了就添加insecure-registries。

> $ sudo vim /etc/docker/daemon.json

```
{
  "insecure-registries": ["http://192.168.102.3:8001"]
}
```

#### 重启

> $ sudo systemctl daemon-reload

> $ sudo systemctl restart docker

### 5、登录公开的仓库

公开的仓库不需要登录，在页面查看需要的镜像名称，通过pull命令下载

> $ sudo docker pull 192.168.102.3:8001/library/busybox


### 6、私有仓库，首先要用自己的账号登录

> $ sudo docker login 192.168.102.3:8001
```
Username: wym
Password: W1!harbor
Login Succeeded
```

给要上传的镜像打标签，注意必须包括私有仓库IP、端口和项目名称

> $ sudo docker tag busybox 192.168.102.3:8001/wymproject/busybox

上传镜像
> $ sudo docker push 192.168.102.3:8001/wymproject/busybox

下载镜像
> $ sudo docker pull 192.168.102.3:8001/wymproject/busybox

### 7、项目管理员可以添加项目成员，删除镜像等操作



## docker常见问题



### CentOS7中Docker-ce的卸载和安装

```

一、查看是否已安装了Docker软件包：
#查看是否已经安装的Docker软件包
sudo yum list installed | grep docker
 
二、如果已安装不想要的docker/docker-engine/docker-ce软件包，卸载掉
#如果已安装不想要docker、docker-engine、docker-ce相关的软件包，则卸载掉：
sudo yum -y remove docker docker-common docker-selinux docker-engine docker-engine-selinux container-selinux docker-ce
 
#删除所有的镜像、容器、数据卷、配置文件等
sudo rm -rf /var/lib/docker
 
三、安装Docker-ce
#先安装yum-utils工具和device-mapper相关依赖包
sudo yum install -y yum-utils \
device-mapper-persistent-data \
lvm2
 
#添加docker-ce stable版本的仓库
sudo yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
 
#更新yum缓存文件
sudo yum makecache fast
 
#查看所有可安装的docker-ce版本
sudo yum list docker-ce --showduplicates | sort -r
 
#安装docker-ce-selinux-17.03.2.ce，否则安装docker-ce会报错
yum install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm 
 
#安装指定版本docker-ce,这里安装的是docker-ce-17.03.2.ce
sudo yum install docker-ce-17.03.2.ce-1.el7.centos 
 
#允许开机启动docker-ce服务
sudo systemctl enable docker.service
 
#启动Docker-ce服务
sudo systemctl start docker
 
#检查是否正常安装：
sudo yum list installed | grep docker
sudo docker info
#运行测试容器hello-world
sudo docker run --rm hello-world
 
 
参考链接：
Docker官方文档（docker-ce）
https://docs.docker.com/engine/installation/linux/docker-ce/centos/#install-using-the-repository 
 
阿里云Docker CE 镜像源站
https://yq.aliyun.com/articles/110806?commentId=11066 
 
清华开源镜像站点docker-ce安装帮助
https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/ 
 
Docker官方文档（v1.12）
https://docs.docker.com/v1.12/engine/installation/linux/centos/ 

--------------------- 
作者：Docker猫猫 
来源：CSDN 
原文：https://blog.csdn.net/CSDN_duomaomao/article/details/78997138 
版权声明：本文为博主原创文章，转载请附上博文链接！

```

### centos 安装docker时出现依赖关系问题的解决办法

```

2018年12月19日 10:38:34 Summerplaying 阅读数：140
版权声明：本文为博主原创文章，未经博主允许不得转载。	https://blog.csdn.net/u010652906/article/details/85090379
我们在安装老版本的docker时可能会出现：
“正在处理依赖关系 docker-ce-selinux >= 17.03.0.ce-1.el7.centos，它被软件包 docker-ce-17.03.0.ce-1.el7.centos.x86_64 需要
软件包 docker-ce-selinux 已经被 docker-ce-cli 取代，但是取代的软件包并未满足需求”

等一大串的问题

在这里插入图片描述

这时我们需要通过 yum install 安装一个rpm包

通过这个地址我们查看和我们安装docker版本一直的rpm包
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/


要先安装docker-ce-selinux-17.03.2.ce，否则安装docker-ce会报错

yum install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm 
1
然后再安装 docker-ce-17.03.2.ce，就能正常安装

sudo yum install docker-ce-17.03.2.ce-1.el7.centos

无法安装软件包 docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch 。被已安装软件包 1:docker-ce-cli-18.09.0-3.el7.x86_64 标记为废除
错误：无须任何处理
[root@k8sm ~]# yum -y remove docker-ce-cli



```
### docker-ce-17.03.2 离线安装RPM包
```
https://www.cnblogs.com/liweiming/p/8656729.html
[root@docker05 docker]# ll
total 20796
-rw-r--r-- 1 root root    75032 Mar 26 23:52 audit-libs-python-2.7.6-3.el7.x86_64.rpm
-rw-r--r-- 1 root root   296980 Mar 26 23:52 checkpolicy-2.5-4.el7.x86_64.rpm
-rw-r--r-- 1 root root 19529520 Mar 26 23:25 docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
-rw-r--r-- 1 root root    29108 Mar 26 23:25 docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
-rw-r--r-- 1 root root    66536 Mar 26 23:51 libcgroup-0.41-13.el7.x86_64.rpm
-rw-r--r-- 1 root root   106604 Mar 26 23:50 libsemanage-python-2.5-8.el7.x86_64.rpm
-rw-r--r-- 1 root root    50076 Mar 26 23:26 libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm
-rw-r--r-- 1 root root   456316 Mar 26 23:43 policycoreutils-python-2.5-17.1.el7.x86_64.rpm
-rw-r--r-- 1 root root    32880 Mar 26 23:49 python-IPy-0.75-6.el7.noarch.rpm
-rw-r--r-- 1 root root   626528 Mar 26 23:47 setools-libs-3.3.8-1.1.el7.x86_64.rpm

[root@docker05 docker]# yum localinstall *.rpm


使用 yum localinstall *.rpm 它会自动匹配依赖包

```


### 

```


```


### 

```


```





### 让docker 容器开机自动启动

```

http://neo-it.iteye.com/blog/2291750
网上有些文章说，要让docker 的容器自动在开机启动，是写脚本，比如在 rc.local 中写。
其实完全没必要这么麻烦，docker 有相关指令，docker run 指令中加入 --restart=always 就行。
sudo docker run --restart=always .....  

如果创建时未指定 --restart=always ,可通过update 命令设置
docker update --restart=always 容器ID

如果你想取消掉
docker update –restart=no <CONTAINER ID>

```

###  迁移 /var/lib/docker 目录

/var/lib/docker/overlay2 占用很大，清理Docker占用的磁盘空间，迁移 /var/lib/docker 目录

```
迁移 /var/lib/docker 目录。

4.1 停止docker服务。
systemctl stop docker

4.2 创建新的docker目录，执行命令df -h,找一个大的磁盘。 我在 /home目录下面建了 /home/docker/lib目录，执行的命令是：
mkdir -p /home/docker/lib

4.3 迁移/var/lib/docker目录下面的文件到 /home/docker/lib：

rsync -avz /var/lib/docker /home/docker/lib/

mv /var/lib/docker /home/y/docker/lib/docker/

4.4 配置 /etc/systemd/system/docker.service.d/devicemapper.conf。
查看 devicemapper.conf 是否存在。如果不存在，就新建。

sudo mkdir -p /etc/systemd/system/docker.service.d/
sudo vim /etc/systemd/system/docker.service.d/deivcemapper.conf

4.5 然后在 devicemapper.conf 写入：（同步的时候把父文件夹一并同步过来，实际上的目录应在 /home/docker/lib/docker ）

[Service]
ExecStart=
ExecStart=/usr/bin/dockerd  --graph=/home/y/docker/lib/docker

ExecStart=/usr/bin/dockerd --insecure-registry=私服地址 --graph=/home/docker/lib
 注意：如果/etc/systemd/system/docker.service.d/devicemapper.conf，这个路径找不到的话，就新建，新建之后加入内容，没有私服地址的话就可以去掉”--insecure-registry=私服地址”。


4.6 重新加载 docker

systemctl daemon-reload
systemctl restart docker
systemctl enable docker

4.7 为了确认一切顺利，运行

# docker info
命令检查Docker 的根目录.它将被更改为  /home/y/docker/lib/docker

...
Docker Root Dir: /home/docker/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
...

4.8 启动成功后，再确认之前的镜像还在：

linlf@dacent:~$ docker images
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
AAA/AAA               v2                  7331b8651bcc        27 hours ago        3.85GB
BBB/BBB               v1                  da4a80dd8424        28 hours ago        3.47GB

4.9 确定容器没问题后删除/var/lib/docker/目录中的文件。

```

### 配置centos8解决 docker Failed to get D-Bus connection 报错

```

原因及解决方式：
在创建docker容器时添加--privileged
这个的原因是因为dbus-daemon没能启动。其实systemctl并不是不可以使用。将你的CMD或者entrypoint设置为/usr/sbin/init即可。会自动将dbus等服务启动起来。
然后就可以使用systemctl了。命令如下

docker run -it --name cobbler --privileged=true jasonlix/docker-cobbler /usr/sbin/init


```

### 不使用sudo命令执行docker

```

http://www.docker.org.cn/book/install/run-docker-without-sudo-30.html
2015-09-11 11:03:05  王春生  22890 最后编辑：王春生 于 2015-09-11 12:18:30
简介：本篇文章介绍如何不使用sudo命令就可以执行docker命令。
为什么需要创建docker用户组？
操作步骤：
为什么需要创建docker用户组？
Docker守候进程绑定的是一个unix socket，而不是TCP端口。这个套接字默认的属主是root，其他是用户可以使用sudo命令来访问这个套接字文件。因为这个原因，docker服务进程都是以root帐号的身份运行的。
为了避免每次运行docker命令的时候都需要输入sudo，可以创建一个docker用户组，并把相应的用户添加到这个分组里面。当docker进程启动的时候，会设置该套接字可以被docker这个分组的用户读写。这样只要是在docker这个组里面的用户就可以直接执行docker命令了。
警告：该dockergroup等同于root帐号，具体的详情可以参考这篇文章：Docker Daemon Attack Surface.
操作步骤：
使用有sudo权限的帐号登录系统。
创建docker分组，并将相应的用户添加到这个分组里面。
sudo usermod -aG docker your_username
退出，然后重新登录，以便让权限生效。
确认你可以直接运行docker命令。
$ docker run hello-world

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


### 

```


```


