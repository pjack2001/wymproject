# docker

## 学习资料

《Docker从入门到实践》
菜鸟教程http://www.runoob.com/docker/docker-tutorial.html

思维导图
https://www.processon.com/view/5bda9e15e4b0844e0bc2cdea
https://www.processon.com/view/5bfd2d4ee4b0f012f2346b33


## 准备

```

cd /home/y/vagrant/centos7wym 

设置用户的sudo权限
# yum install -y sudo
# chmod u+w /etc/sudoers
# echo 'wym    ALL=(ALL)       ALL' >> /etc/sudoers


#查看IP地址
# ip addr
# 假设查询结果为使用eth0网卡，IP为102.79

#设置DNS
# sudo echo 'nameserver 192.168.0.186' >> /etc/resolv.conf

#假设现有的IP地址79,替换为xxx，适用于修改为分配的IP地址
# sed -i '/IPADDR/s@102\.79@102.xxx@' /etc/sysconfig/network-scripts/ifcfg-eth0

#修改IP地址,替换xxx，适用于从dhcp改为static，正常情况下这一步可跳过
# sed -i -e "/BOOTPROTO/c BOOTPROTO=static\nIPADDR=192.168.102.xxx\nNETMASK=255.255.255.0\nGATEWAY=192.168.102.254\nPEERDNS=no\nDNS1=192.168.0.186" /etc/sysconfig/network-scripts/ifcfg-eth0

＃重启网络
# sudo systemctl restart network


检查selinux和防火墙是否关闭

#默认安装时已经关闭
# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config  #永久关闭
# sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
# setenforce 0  #临时关闭
# getenforce  #查看状态

# systemctl disable firewalld.service #禁止自启动
# systemctl stop firewalld.service
# systemctl status firewalld.service


```


## 安装

```


更换阿里yum源
sudo mkdir -p /etc/yum.repos.d/repobak
sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum clean all && yum makecache

# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo


安装docker版本
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum list docker-ce --showduplicates
sudo yum install -y docker-ce 或安装特定版本docker-ce-18.03.1.ce
sudo systemctl start docker
sudo systemctl enable docker

删除 Docker CE
$ sudo yum remove docker-ce
$ sudo rm -rf /var/lib/docker


镜像加速
sudo mkdir -p /etc/docker

# https://xxxx.mirror.aliyuncs.com
# http://hub-mirror.c.163.com 
# http://f1361db2.m.daocloud.io

sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo tee /etc/docker/3.json <<-'EOF'
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
EOF

sudo echo -e "{\n \"registry-mirrors\": [\"http://hub-mirror.c.163.com\"]\n}" > /etc/docker/daemon.json
或
sudo curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io






sudo systemctl daemon-reload
sudo systemctl restart docker

```


## docker常用命令

```


docker run -it -d --name centos701 ansible/centos7-ansible /usr/sbin/init

# 在创建docker容器时添加--privileged
docker run -it -d --privileged=true  -v /sys/fs/cgroup:/sys/fs/cgroup  ansible/centos7-ansible  /usr/sbin/init
docker run -it -d --privileged=true --name centos701 ansible/centos7-ansible /usr/sbin/init

docker exec -it 54a  /bin/bash

配置centos7解决 docker Failed to get D-Bus connection 报错
原因及解决方式：
在创建docker容器时添加--privileged
这个的原因是因为dbus-daemon没能启动。其实systemctl并不是不可以使用。将你的CMD或者entrypoint设置为/usr/sbin/init即可。会自动将dbus等服务启动起来。
然后就可以使用systemctl了。命令如下



不使用sudo命令执行docker
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

==================================================================
$sudo docker version
$ sudo docker run hello-world
$ sudo docker ps -a
$ sudo docker stop 容器名（每次启动随机生成）
$ sudo docker start 容器名（每次启动随机生成）
$ sudo docker rm 容器名（每次启动随机生成）

$ sudo docker search -s 10 bitnami/     搜索某个用户建立的镜像,10星以上

$ sudo docker search oracle
$ sudo docker pull wnameless/oracle-xe-11g
$ sudo docker pull alexeiled/docker-oracle-xe-11g

使用
$ sudo docker images

启动并指定一个容器名
$ sudo docker run -d --name oraw01 alexeiled/docker-oracle-xe-11g

$ sudo docker ps -a
$ sudo docker inspect oraw01

#获取Container IP地址（Container状态必须是Up）
$ sudo docker inspect oraw01 | grep IPAddress | cut -d '"' -f 4    

#获取环境变量
xh@xh:~$ sudo docker exec oraw01 env  
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=3863f1da45f4
HOME=/root

#登录
$ sudo docker exec -it oraw01 /bin/sh

#查看构建镜像所用过的命令
$ sudo docker history alexeiled/docker-oracle-xe-11g

把镜像保存成一个tar文件，注意如果目录没有，需要提前建立一下，docker不会帮你建立目录的
$ sudo docker save helyho/dockerfly -o /media/xh/i/docker/images/dockerfly20171129.tar

加载镜像备份
$ sudo docker load < /media/xh/i/docker/images/oracle11gxe.tar
















筛选关键字批量打包
# docker save $(docker images | grep geerlingguy | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o /home/wym/wymdockerimagesgeerlingguy.tar

docker save centos  -o  /home/wym/xxx.tar

加载镜像：
# docker load -i wymdockerimages.tar


```




##  docker-compose


```
常用docker-compose命令
其它命令（修改配置文件后最好把容器删除再创建）：
docker-compose up -d               ###后台启动，如果容器不存在根据镜像自动创建
docker-compose down -v         ###停止容器并删除容器
docker-compose start                 ###启动容器，容器不存在就无法启动，不会自动创建镜像
docker-compose stop                 ###停止容器
docker-compose logs        ###查看日志（harbor日志存放地址 /var/logs/harbor）
docke-compose ps             ###查看容器

如果用的不是标准yml名称docker-compose.yml，所以要用-f参数指定自定义的yml文件

cd /home/y/docker-compose/seleniumgrid



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


## 让docker 容器开机自动启动

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



##  迁移 /var/lib/docker 目录

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




## docker使用oracle

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







