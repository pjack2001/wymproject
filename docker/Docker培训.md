# Docker培训

©王予明2019

## 学习参考资料
```yml
注意：学习技术，最好的是官方文档
Docker官网： http://www.docker.com
https://docs.docker.com/install/linux/docker-ce/centos/

《Docker从入门到实践》
菜鸟教程 http://www.runoob.com/docker/docker-tutorial.html

参考网上别人的思维导图
https://www.processon.com/view/5bda9e15e4b0844e0bc2cdea

```

## 一、Docker简介

### 1、简介
```yml
Docker 是一个开源的应用容器引擎，基于 Go 语言 并遵从Apache2.0协议开源。

Docker 可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。

容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）,更重要的是容器性能开销极低。

Docker 从 17.03 版本之后分为 CE（Community Edition: 社区版） 和 EE（Enterprise Edition: 企业版），我们用社区版就可以了。

```

### 2、Docker的应用场景
```yml

Web 应用的自动化打包和发布。

自动化测试和持续集成、发布。

在服务型环境中部署和调整数据库或其他的后台应用。

从头编译或者扩展现有的OpenShift或Cloud Foundry平台来搭建自己的PaaS环境。

```

### 3、Docker 的优点
```yml

1、简化程序：
Docker 让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，便可以实现虚拟化。Docker改变了虚拟化的方式，使开发者可以直接将自己的成果放入Docker中进行管理。方便快捷已经是 Docker的最大优势，过去需要用数天乃至数周的	任务，在Docker容器的处理下，只需要数秒就能完成。

2、避免选择恐惧症：
如果你有选择恐惧症，还是资深患者。Docker 帮你	打包你的纠结！比如 Docker 镜像；Docker 镜像中包含了运行环境和配置，所以 Docker 可以简化部署多种应用实例工作。比如 Web 应用、后台应用、数据库应用、大数据应用比如 Hadoop 集群、消息队列等等都可以打包成一个镜像部署。

3、节省开支：
一方面，云计算时代到来，使开发者不必为了追求效果而配置高额的硬件，Docker 改变了高性能必然高价格的思维定势。Docker 与云的结合，让云空间得到更充分的利用。不仅解决了硬件管理的问题，也改变了虚拟化的方式。

```

### 
```yml


```

## 二、准备

### 1、centos7系统
```yml
注意：root用户执行命令不用加sudo

1)设置普通用户的sudo权限
# yum install -y sudo
# chmod u+w /etc/sudoers
# echo 'wym    ALL=(ALL)       ALL' >> /etc/sudoers

2)检查selinux和防火墙是否关闭

改配置文件禁用SELINUX
# vim /etc/selinux/config
SELINUX=disabled

# setenforce 0  #临时关闭
# getenforce  #查看状态

# systemctl disable firewalld.service   #禁止自启动
# systemctl stop firewalld.service      #停止防火墙
# systemctl status firewalld.service    #查看防火墙状态


```


### 2、更换阿里yum源，需要连外网

```
sudo mkdir -p /etc/yum.repos.d/repobak
sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum clean all && yum makecache

```

### 3、公司内网yum源
```
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo

```


## 三、安装

### 1、官方安装
```yml
https://docs.docker.com/install/linux/docker-ce/centos/

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum repolist
sudo yum install epel-release
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum list docker-ce --showduplicates | sort -r
sudo yum install docker-ce docker-ce-cli containerd.io

sudo systemctl start docker
sudo systemctl enable docker

$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh

如果您想将Docker用作非root用户，您现在应该考虑将您的用户添加到“docker”组，例如：
sudo usermod -aG docker your-user

$ sudo yum remove docker-ce
$ sudo rm -rf /var/lib/docker


安装低版本，解决依赖问题
通过这个地址我们查看和我们安装docker版本一直的rpm包
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/

要先安装docker-ce-selinux-17.03.2.ce，否则安装docker-ce会报错
sudo yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm 

然后再安装 docker-ce-17.03.2.ce，就能正常安装
sudo yum -y install docker-ce-17.03.2.ce docker-ce-cli-17.03.2.ce containerd.io


```

### 2、离线安装包

```yml

请注意：--downloadonly参数将自动下载程序包安装时所需要的所有依赖，所以建议在全新的系统中使用本命令，因为在已经安装过部分依赖的系统上，yum不会将所有需要的依赖下载完全，例如下面这幅图所示

使用--downloadonly参数之后，yum在下载完程序包后就会显示一句“exiting because "Download Only" specified”并自动退出，此时要下载的程序包已经被放置到了yum的默认存放位置，在CentOS 7 x64下，这个默认路径是：

/var/cache/yum/x86_64/7/<repo>/packages/

如果要指定yum的下载目录，还需要一个“--downloaddir”参数，例如我要将supervisor程序包安装到当前文件夹下，就使用下面的命令：

yum install -y --downloadonly --downloaddir=. nginx


# yum install -y --downloadonly --downloaddir=/oracle/rpmpackage/docker-ce docker-ce-18.06.1.ce 

yum离线安装程序包
在刚刚第二步中我们使用了yum --downloadonly命令离线下载了想要的程序包安装文件，现在我们有一台因为种种原因而不能上网的系统，我们现在要把刚刚下载下来的程序包安装到这台电脑上该怎么办呢？

很简单，用yum localinstall命令。

首先将我们下载下来的程序包及其依赖去使用U盘等方式拷贝到这台不能上网的电脑中，然后进入程序包存放目录，执行下面的命令（仍以supervisor为例）：


yum localinstall -y --nogpgcheck supervisor-3.1.4-1.el7.noarch.rpm \
       python-backports-1.0-8.el7.x86_64.rpm \
       python-backports-ssl_match_hostname-3.4.0.2-4.el7.noarch.rpm \
       python-meld3-0.6.10-1.el7.x86_64.rpm \
       python-setuptools-0.9.8-7.el7.noarch.rpm
 
```
#### 2.1 几个注意点：
```yml
1.使用yum localinstall命令需要的程序包时需要同时安装程序包所有的依赖项目，否则还是会尝试联网去下载缺少的依赖项目；
2.“--nogpgcheck”参数主要是为了不让yum对程序包进行GPG验证；
3.除了yum localinstall命令以外，还可以使用rpm -ivh命令安装rpm包，这里不再单独讨论。


或者构建本地yum库来安装。

需要说明的是，为了在目标机构建软件源，createrepo是必不可少的模块，因此需要在虚拟机上下载createrepo相关模块。

# yum install --downloadonly --downloaddir=/oracle/rpmpackage/createrepo createrepo
 
一般会下载三个包，一个是createrepo，另外两个是依赖包。

[root@oracle2 createrepo]# rpm -ivh python-deltarpm-3.6-3.el7.x86_64.rpm 
[root@oracle2 createrepo]# rpm -ivh createrepo-0.9.9-28.el7.noarch.rpm

centos7.4默认已经安装的
deltarpm-3.6-3.el7.x86_64
libxml2-python-2.9.1-6.el7_2.3.x86_64

createrepo构建本地软件源

假设安装包在目标机的/oracle/rpmpackage/createrepo目录下。

# createrepo  /oracle/rpmpackage/docker-ce/


修改yum软件源

移除现有的软件源

# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo_bk
 
开启本地软件源

# vim /etc/yum.repos.d/CentOS-Media.repo
[docker-ce]
name=local docker-ce
baseurl=file:////tmp/rpms/
enabled=1
gpgcheck=0

这样就可以使yum采用本地源安装软件。

输入yum repolist看是否可以看到自己构建的本地源 

清楚缓存yum clean all
创建缓存，yum makecache
查看本地源是否成功，通过yum list是否输出新的rpm包。查询到则证明成功

# yum info nginx
# yum info docker-ce


在目标机安装目标软件
使用yum正常安装软件即可。

# yum install -y docker-ce
 
如果用的是纯净的虚拟机环境，并且和目标机保持一致，那么依赖包就会都安装，yum安装就会很顺利。除非个别包会有依赖冲突，A依赖B，B又依赖A，导致无法安装，此时可以用rpm命令强制安装其中一个，再用yum安装软件即可。

# rpm -ivh demo.rpm --nodeps --force
如果安装中出现类似下面的错误：

 Package fglrx-glc22-4.1.0-3.2.5.i586.rpm is not signed

需要加个 --nogpgcheck 参数。

yum localinstall fglrx-glc22-4.1.0-3.2.5.i586.rpm --nogpgcheck


```

### 3、选择需要安装docker版本
```yml
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum list docker-ce --showduplicates
sudo yum install -y docker-ce 或安装特定版本docker-ce-18.06.1.ce
sudo systemctl start docker
sudo systemctl enable docker


$ yum list docker-ce --showduplicates
Failed to set locale, defaulting to C
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: mirrors.aliyun.com
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
Installed Packages
docker-ce.x86_64                  18.03.1.ce-1.el7.centos                   @docker-ce-stable
Available Packages
docker-ce.x86_64                  17.03.0.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.03.1.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.03.2.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.03.3.ce-1.el7                          docker-ce-stable 
docker-ce.x86_64                  17.06.0.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.06.1.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.06.2.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.09.0.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.09.1.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.12.0.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  17.12.1.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  18.03.0.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  18.03.1.ce-1.el7.centos                   docker-ce-stable 
docker-ce.x86_64                  18.06.0.ce-3.el7                          docker-ce-stable 
docker-ce.x86_64                  18.06.1.ce-3.el7                          docker-ce-stable 
docker-ce.x86_64                  18.06.2.ce-3.el7                          docker-ce-stable 
docker-ce.x86_64                  18.06.3.ce-3.el7                          docker-ce-stable 
docker-ce.x86_64                  3:18.09.0-3.el7                           docker-ce-stable 
docker-ce.x86_64                  3:18.09.1-3.el7                           docker-ce-stable 
docker-ce.x86_64                  3:18.09.2-3.el7                           docker-ce-stable 
docker-ce.x86_64                  3:18.09.3-3.el7                           docker-ce-stable 
docker-ce.x86_64                  3:18.09.4-3.el7                           docker-ce-stable 
docker-ce.x86_64                  3:18.09.5-3.el7                           docker-ce-stable 
```


### 4、删除
```yml

删除 Docker CE
$ sudo yum remove docker-ce
$ sudo rm -rf /var/lib/docker

yum -y remove docker docker-common docker-selinux docker-engine docker-engine-selinux container-selinux docker-ce

yum -y remove docker-ce-cli


#查看是否已经安装的Docker软件包
sudo yum list installed | grep docker


```

### 5、镜像加速

```yml
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


## 四、docker常用命令

```yml

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


进入docker 容器的小脚本

下面是一个通过nsenter进入docker容器的例子脚本： 
文件名字：ns 
使用方法：将文件放入系统PATH路径下，进入容器方式ns <container-name/container-id>

如果docker容器没有提供ssh,那么进入docker容器的方法，一般是 attach ,exec,nsenter
attach 进入后再退出，会引起docker 容器停止。exec 每次输入比较麻烦。
比较方便的是用 nsenter . nsenter 进入需要查docker 容器的pid 。所以，写了下面的脚本，方便进入。

#!/bin/bash  
docker ps  
echo "======================================\r"  
read -p "input docker name:" did  
PID=$(docker inspect --format "{{.State.Pid}}" $did)  
nsenter --target $PID --mount --uts --ipc --net --pid 
 
该脚本会提示当前运行的docker容器，然后输入docker 的id 后，就进入了docker容器


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

## 六、Docker实战

### 1、docker使用tomcat环境

```yml
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

### 2、安装jdk和tomcat环境

```yml
注意：自己准备jdk和tomcat安装文件

$ docker pull centos
$ docker run -dit -p 8080:8080 --name centos7w -v /opt/tomcat/test1:/home/wym/tomcat/test centos


$ docker run -dit --name ubuntu1604 ubuntu:16.04


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

### 3、docker使用oracle(以前的记录，仅供参考)


#### 3.1数据库访问
```yml
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

#### 3.2使用Docker创建oracle数据库 

```yml
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

### 4、物联网平台安装(以前的记录，仅供参考)

#### 4.1物联网访问

```yml
http://IP:8080/
使用用户名：
sysadmin，密码：sysadmin

tenant@newcapec.net，密码：123456登录.

```

#### 4.2 mysql
```yml
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

#### 4.3连接数，需要重启

```yml
# vi /etc/security/limits.conf
* soft nofile 1024000
* hard nofile 1024000
hive   - nofile 1024000
hive   - nproc  1024000

```

#### 4.4 如何重启服务


执行sh restart.sh


#### 4.5	如何判断服务是否正常启动
通过浏览器访问：
http://ip:8085/api/health
http://ip:8088/api/health
如果都能返回：

#### 4.6登录
```yml
http://IP:8080/

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


##  七、docker-compose

### 1、常用docker-compose命令
```yml
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
### 2、例子

```yml
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


##  八、docker-machine


```yml

注意：使用/bin/bash

https://rancher.com/docs/os/v1.x/en/quick-start-guide/
使用Docker Machine启动RancherOS
在继续之前，您需要安装Docker Machine和VirtualBox。一旦安装了VirtualBox和Docker Machine，它就只有一个命令可以让RancherOS运行。
$ docker-machine create -d virtualbox \
        --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso \
        --virtualbox-memory 2048 \
        <MACHINE-NAME>

# docker-machine create -d virtualbox --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso --virtualbox-memory 2048 ros1

# docker-machine create -d virtualbox --virtualbox-boot2docker-url rancheros.iso --virtualbox-memory 2048 ros1

# docker-machine ls

# docker-machine ssh ros1

$ sudo system-docker run -d --net=host --name busydash husseingalal/busydash

常用命令，许多命令需要联网

# docker-machine create -d virtualbox --virtualbox-boot2docker-url rancheros1.4.3.iso --virtualbox-memory 2048 ros1

# docker-machine
# docker-machine ls
# docker-machine ip ros1



# docker-machine ssh ros1

$ sudo system-docker ps
$ docker ps

$ sudo ros --version

$ sudo ros os list
$ sudo ros engine list

切换到Docker 17.03.2，再次查看Docker版本
$ sudo ros engine switch docker-17.03.2-ce

$ sudo docker version

配置镜像加速
$ sudo ros config set rancher.docker.registry_mirror https://al9ikvwc.mirror.aliyuncs.com
$ sudo ros config get rancher.docker.registry_mirror
$ sudo system-docker restart docker

测试镜像下载时间
$ time sudo docker pull nginx

$ sudo docker images

$ sudo docker info

$ sudo system-docker run -d --net=host --name busydash husseingalal/busydash

sudo ros config -h


#################################################################

安装docker-machine
https://docs.docker.com/machine/install-machine/
https://github.com/docker/machine/releases

If you are running Linux:
现在最新的是0.16.1

$ base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
或
$ curl -L https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

$ docker-machine version
docker-machine version 0.16.0, build 9371605


Install bash completion scripts
Machine存储库提供了几个bash脚本，可添加以下功能：

命令完成
一个在shell提示符下显示活动计算机的函数
一个函数包装器，它添加一个docker-machine use子命令来切换活动机器
确认版本并将脚本保存到/etc/bash_completion.d或 /usr/local/etc/bash_completion.d：

base=https://raw.githubusercontent.com/docker/machine/v0.16.0
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
  sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done

然后，您需要运行
source /etc/bash_completion.d/docker-machine-prompt.bash

在bash终端中，告诉您的设置，它可以找到您之前下载的文件docker-machine-prompt.bash 。

要启用docker-machineshell提示，请添加 $(__docker_machine_ps1)到您的PS1设置中~/.bashrc。

PS1='[\u@\h \W$(__docker_machine_ps1)]\$ '





```


## 九、安装virtualbox

```yml
https://www.virtualbox.org/wiki/Linux_Downloads
https://www.virtualbox.org/wiki/Download_Old_Builds_5_2


sudo curl -o /etc/yum.repos.d/virtualbox.repo https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo

# yum repolist ，选择y，下载virtualbox签名

更新yum缓存
yum clean all && yum makecache

安装virtualbox
yum --enablerepo=epel install -y dkms
yum install -y VirtualBox-5.2

# rpm -qa |grep VirtualBox

$ VBoxManage list runningvms | grep <MACHINE-NAME>


###################################################
启动报错：
WARNING: The vboxdrv kernel module is not loaded. Either there is no module available for the current kernel (3.10.0-957.1.3.el7.x86_64) or it failed to load. Please recompile the kernel module and install it by
 sudo /sbin/vboxconfig

# /sbin/vboxconfig 
vboxdrv.sh: Stopping VirtualBox services.
vboxdrv.sh: Starting VirtualBox services.
vboxdrv.sh: Building VirtualBox kernel modules.
This system is currently not set up to build kernel modules.
Please install the Linux kernel "header" files matching the current kernel
for adding new hardware support to the system.
The distribution packages containing the headers are probably:
    kernel-devel kernel-devel-3.10.0-957.1.3.el7.x86_64

# yum --enablerepo=epel install kernel-devel kernel-devel-3.10.0-957.1.3.el7.x86_64

# /sbin/vboxconfig 
vboxdrv.sh: Stopping VirtualBox services.
vboxdrv.sh: Starting VirtualBox services.
vboxdrv.sh: Building VirtualBox kernel modules.

出现vboxdrv.sh: Building VirtualBox kernel modules.说明编译成功


重新编译内核模块前身/etc/init.d/vboxdrv设置它后来被设置为/sbin/rcvboxdrv。所以两个命令都可以 
# /sbin/vboxconfig 
# rcvboxdrv setup

###################################################

VBoxManage是VirtualBox的命令行接口。利用他，你可以在主机操作系统的命令行中完全地控制VirtualBox。VBoxManage支持GUI可访问的全部功能，而且更多。VBoxManage展示了虚拟化引擎的全部特征，包括GUI无法访问的。

列一下，你需要使用命令行：
使用主GUI之外的用户接口（例如，VBoxSDL或VBoxHeadLess服务器）；
控制更多高级和实验性的配置。
 
使用VBoxManage时要记住两件事：
第一，VBoxManage必须和一个具体和“子命令”一起使用，比如“list”或“createvm“或“startvm”。
第二，大多数子命令需要在其后指定特定的虚拟机。有两种方式：
指定虚拟机的名称，和其在GUI中显示的一样。注意，如果名称包含空格，必须将全部名称包含在双引号中（和命令行参数包含空格时的要求一样）。
例如：
VBoxManage startvm "Windows XP"
指定其UUID，VirtualBox用来引用虚拟机的内部唯一标识符。设上述名称为“Windows XP”的虚拟机有如下UUID，下面的命令有同样的效果：
 
VBoxManage startvm 670e746d-abea-4ba6-ad02-2a3b043810a5
使用VBoxManage list vms可列出当前注册的所有虚拟机的名称及其对应的UUID。


常用命令
VBoxManage startvm name|id --type [gui|headless|svd] #启动
VBoxManage startvm name|id --type [gui|headless|svd] #启动
VBoxManage list runningvms # 列出运行中的虚拟机
VBoxManage controlvm XP acpipowerbutton # 关闭虚拟机，等价于点击系统关闭按钮，正常关机
VBoxManage controlvm XP poweroff # 关闭虚拟机，等价于直接关闭电源，非正常关机
VBoxManage controlvm XP pause # 暂停虚拟机的运行
VBoxManage controlvm XP resume # 恢复暂停的虚拟机
VBoxManage controlvm XP savestate # 保存当前虚拟机的运行状态




VirtualBox 命令汇总

在Linux平台安装的VirtualBox虚拟机，可以通过如下命令操作虚拟机：

查看有哪些虚拟机
VBoxManage list vms

查看虚拟的详细信息
VBoxManage list vms --long

查看运行着的虚拟机
VBoxManage list runningvms

开启虚拟机在后台运行
VBoxManage startvm backup -type headless

开启虚拟机并开启远程桌面连接的支持
VBoxManage startvm <vm_name> -type vrdp

改变虚拟机的远程连接端口,用于多个vbox虚拟机同时运行
VBoxManage controlvm <vm_name> vrdpprot <ports>

关闭虚拟机
VBoxManage controlvm <vm_name> acpipowerbutton

强制关闭虚拟机
VBoxManage controlvm <vm_name> poweroff

杀掉某个虚拟机的进程方法（强制关闭虚拟机）

经常遇到强制关闭虚拟机后，虚拟关不了的现象，状态一直是 stopping，而且一直卡死在这，没办法关闭，所以需要强制关闭这个虚拟机

（1） 查看所有virtualbox进程

ps -aux|grep virtualbox

会查出如下 信息：(蓝色背景文字 为 进程id 和 虚拟机名)

 vnc      19499 54.7  3.3 3746624 2177960 ?     Sl   15:46  55:49 /usr/lib/virtualbox/VirtualBox --comment SwiftSync2.0_Synctest25 --startvm 7fa1f49b-4dc2-4a7f-865d-5e0456f5482d --no-startvm-errormsgbox

....

然后强制杀进程id为 19499的进程，这个进程就是 虚拟机SwiftSync2.0_Synctest25的进程

kill -9 194999












```


## 十、Docker私有仓库使用说明
```yml

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


{
  "insecure-registries": ["http://192.168.102.3:8001"]
}


#### 重启

> $ sudo systemctl daemon-reload

> $ sudo systemctl restart docker

### 5、登录公开的仓库

公开的仓库不需要登录，在页面查看需要的镜像名称，通过pull命令下载

> $ sudo docker pull 192.168.102.3:8001/library/busybox


### 6、私有仓库，首先要用自己的账号登录

> $ sudo docker login 192.168.102.3:8001

Username: wym
Password: W1!harbor
Login Succeeded

$ sudo docker login -u admin -p admin 192.168.102.3:8001


给要上传的镜像打标签，注意必须包括私有仓库IP、端口和项目名称

> $ sudo docker tag busybox 192.168.102.3:8001/wymproject/busybox

上传镜像
> $ sudo docker push 192.168.102.3:8001/wymproject/busybox

下载镜像
> $ sudo docker pull 192.168.102.3:8001/wymproject/busybox

### 7、项目管理员可以添加项目成员，删除镜像等操作

```


## 使用docker-compose 大杀器来部署服务 

```yml
https://www.cnblogs.com/neptunemoon/p/6512121.html#toc_47

docker   # docker 命令帮助

Commands:
    attach    Attach to a running container                 # 当前 shell 下 attach 连接指定运行镜像
    build     Build an image from a Dockerfile              # 通过 Dockerfile 定制镜像
    commit    Create a new image from a container's changes # 提交当前容器为新的镜像
    cp        Copy files/folders from the containers filesystem to the host path
              # 从容器中拷贝指定文件或者目录到宿主机中
    create    Create a new container                        # 创建一个新的容器，同 run，但不启动容器
    diff      Inspect changes on a container's filesystem   # 查看 docker 容器变化
    events    Get real time events from the server          # 从 docker 服务获取容器实时事件
    exec      Run a command in an existing container        # 在已存在的容器上运行命令
    export    Stream the contents of a container as a tar archive   
              # 导出容器的内容流作为一个 tar 归档文件[对应 import ]
    history   Show the history of an image                  # 展示一个镜像形成历史
    images    List images                                   # 列出系统当前镜像
    import    Create a new filesystem image from the contents of a tarball  
              # 从tar包中的内容创建一个新的文件系统映像[对应 export]
    info      Display system-wide information               # 显示系统相关信息
    inspect   Return low-level information on a container   # 查看容器详细信息
    kill      Kill a running container                      # kill 指定 docker 容器
    load      Load an image from a tar archive              # 从一个 tar 包中加载一个镜像[对应 save]
    login     Register or Login to the docker registry server   
              # 注册或者登陆一个 docker 源服务器
    logout    Log out from a Docker registry server         # 从当前 Docker registry 退出
    logs      Fetch the logs of a container                 # 输出当前容器日志信息
    port      Lookup the public-facing port which is NAT-ed to PRIVATE_PORT
              # 查看映射端口对应的容器内部源端口
    pause     Pause all processes within a container        # 暂停容器
    ps        List containers                               # 列出容器列表
    pull      Pull an image or a repository from the docker registry server
              # 从docker镜像源服务器拉取指定镜像或者库镜像
    push      Push an image or a repository to the docker registry server
              # 推送指定镜像或者库镜像至docker源服务器
    restart   Restart a running container                   # 重启运行的容器
    rm        Remove one or more containers                 # 移除一个或者多个容器
    rmi       Remove one or more images                 
              # 移除一个或多个镜像[无容器使用该镜像才可删除，否则需删除相关容器才可继续或 -f 强制删除]
    run       Run a command in a new container
              # 创建一个新的容器并运行一个命令
    save      Save an image to a tar archive                # 保存一个镜像为一个 tar 包[对应 load]
    search    Search for an image on the Docker Hub         # 在 docker hub 中搜索镜像
    start     Start a stopped containers                    # 启动容器
    stop      Stop a running containers                     # 停止容器
    tag       Tag an image into a repository                # 给源中镜像打标签
    top       Lookup the running processes of a container   # 查看容器中运行的进程信息
    unpause   Unpause a paused container                    # 取消暂停容器
    version   Show the docker version information           # 查看 docker 版本号
    wait      Block until a container stops, then print its exit code   
              # 截取容器停止时的退出状态值
Run 'docker COMMAND --help' for more information on a command.



docker-compose 常用命令

Commands:
  build              Build or rebuild services
  bundle             Generate a Docker bundle from the Compose file
  config             Validate and view the compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information
解释一下

build 构建或重建服务
help 命令帮助
kill 杀掉容器
logs 显示容器的输出内容
port 打印绑定的开放端口
ps 显示容器
pull 拉取服务镜像
restart 重启服务
rm 删除停止的容器
run 运行一个一次性命令
scale 设置服务的容器数目
start 开启服务
stop 停止服务
up 创建并启动容器
docker-compose 如何配置
先看看我自己写的一个 docker-compose.yml

version: '2'
services:
    nginx:
            image: bitnami/nginx:latest
            ports:
                - '80:80'
                - '1443:443'
            volumes:
                - /root/wp_yunlan/nginx/:/bitnami/nginx/
    mariadb:
            image: bitnami/mariadb:latest
            volumes:
                - /root/wp_yunlan/mariadb:/bitnami/mariadb
    wordpress:
            image: bitnami/wordpress:latest
            depends_on:
                - mariadb
                - nginx
            environment:
                - WORDPRESS_USERNAME=neptunemoon    #这个账户你是自己设定的
                - WORDPRESS_PASSWORD=123123         #这个密码是你自己设定的
            ports:
                - '8080:80'
                - '8081:443'
            volumes:
                - /root/wp_yunlan/wordpress:/bitnami/wordpress
                - /root/wp_yunlan/apache:/bitnami/apache
                - /root/wp_yunlan/php:/bitnami/php
nginx 和 mariadb，wordpress 是要启动的三个服务

顺序不是重要的,我们看见wordpress中有个 depends_on: 的属性

depends_on: 依赖
代表wordpress 依赖于

- mariadb
- nginx
两个服务， 所以他们两个会先启动

image: 镜像
就是你的 docker 镜像
我们用
docker search mariadb
找到我们需要的镜像



```







## 十一、docker常见问题



### 1、CentOS7中Docker-ce的卸载和安装

```yml

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

### 2、centos 安装docker时出现依赖关系问题的解决办法

```yml

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
### 3、docker-ce-17.03.2 离线安装RPM包
```yml
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





### 4、让docker 容器开机自动启动

```yml

http://neo-it.iteye.com/blog/2291750
网上有些文章说，要让docker 的容器自动在开机启动，是写脚本，比如在 rc.local 中写。
其实完全没必要这么麻烦，docker 有相关指令，docker run 指令中加入 --restart=always 就行。
sudo docker run --restart=always .....  

如果创建时未指定 --restart=always ,可通过update 命令设置
docker update --restart=always 容器ID

如果你想取消掉
docker update –restart=no <CONTAINER ID>

```

###  5、迁移 /var/lib/docker 目录

/var/lib/docker/overlay2 占用很大，清理Docker占用的磁盘空间，迁移 /var/lib/docker 目录

```yml
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

### 6、配置centos8解决 docker Failed to get D-Bus connection 报错

```yml

原因及解决方式：
在创建docker容器时添加--privileged
这个的原因是因为dbus-daemon没能启动。其实systemctl并不是不可以使用。将你的CMD或者entrypoint设置为/usr/sbin/init即可。会自动将dbus等服务启动起来。
然后就可以使用systemctl了。命令如下

docker run -it --name cobbler --privileged=true jasonlix/docker-cobbler /usr/sbin/init


```

### 7、不使用sudo命令执行docker

```yml

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


### 8、Docker 容器中运行 Docker 命令

```yml

$ docker run -dit --name ubuntu1604 ubuntu:16.04

通常您可以通过安装Docker套接字从容器内管理主机容器。

docker run -it -v /var/run/docker.sock:/var/run/docker.sock --name ubuntu1604 ubuntu:16.04 sh -c "apt-get update ; apt-get install docker.io -y ; bash"

$ docker run -dit --name c761810 --privileged=true centos:7.6.1810 /usr/sbin/init

Docker里运行Docker docker in docker(dind)
http://www.wantchalk.com/c/devops/docker/2017/05/24/docker-in-docer.html

Docker 容器中运行 Docker 命令
在使用 GitLab/Jenkins 等 CI 软件的时候需要使用 Docker 命令来构建镜像，需要在容器中使用 Docker 命令；通过将宿主机的 Docker 共享给容器即可

在启动容器时添加以下命令：
     --privileged \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v $(which docker)r:/bin/docker \
--privileged 表示该容器真正启用 root 权限
-v /var/run/docker.sock:/var/run/docker.sock和-v $(which docker)r:/bin/docker命令将相关的 Docker 文件挂载到容器

$ docker run -dit --name c761810 --privileged=true -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker)r:/bin/docker centos:7.6.1810 /usr/sbin/init

$ docker rm -f 容器ID


```


### Docker 容器中运行命令

```yml


进入虚拟机执行命令
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config && systemctl restart sshd && systemctl stop firewalld && setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config && sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

mkdir -p /etc/yum.repos.d/repobak && mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak && curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo && curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo && curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo && yum clean all && yum makecache && yum install -y wget vim tree net-tools zip unzip tmux && yum install -y docker-ce

#systemctl start docker && systemctl enable docker 
mkdir -p /etc/docker && echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.3:8001"]}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker




# -*- mode: ruby -*-
# vi: set ft=ruby :
#
  Vagrant.configure("2") do |config|
    config.vm.box_check_update = false
    config.vm.provider 'virtualbox' do |vb|
     vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end  
    #config.vbguest.auto_update = false
  #config.vm.synced_folder ".", "/oracle", type: "nfs", nfs_udp: false
  #config.vm.synced_folder "./share_dir", "/vagrant", create: true, owner: "root", group: "root", mount_options: ["dmode=755","fmode=644"], type: "rsync"
    config.vm.synced_folder "/media/xh/f/linux/iSO/dockerimages", "/home/vagrant/images", type: "nfs", nfs_udp: false
    $num_instances = 1
    # curl https://discovery.etcd.io/new?size=3
    #i$etcd_cluster = "node1=http://172.17.8.101:2380"
    (1..$num_instances).each do |i|
      config.vm.define "kubeasz#{i}" do |node|
        node.vm.box = "centos7.6"
        node.vm.hostname = "kubeasz#{i}"
        ip = "172.17.8.#{i+160}"
        node.vm.network "private_network", ip: ip
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "6144"
          vb.cpus = 1
          vb.name = "kubeasz#{i}"
        end
    # node.vm.provision "shell", path: "install.sh", args: [i, ip, $etcd_cluster]
      end
    end

  config.vm.provision "shell", inline: <<-SHELL
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo setenforce 0
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    sudo sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
    sudo mkdir -p /etc/yum.repos.d/repobak
    sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak
    sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo
    sudo yum clean all && yum makecache
    sudo yum install -y wget vim tree
#sudo yum list docker-ce --showduplicates
    sudo yum install -y docker-ce-18.09.2 #docker-ce-18.06.1.ce
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo mkdir -p /etc/docker
# https://registry.docker-cn.com https://hub-mirror.c.163.com https://al9ikvwc.mirror.aliyuncs.com
    sudo echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"]}' > /etc/docker/daemon.json
    #sudo echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.3:8001"]}' > /etc/docker/daemon.json
    #sudo curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo systemctl restart sshd
  SHELL

end


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


