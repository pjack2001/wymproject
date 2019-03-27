# linux-shell 

https://github.com/DingGuodong/LinuxBashShellScriptForOps

## wym命令

```
:1,$s/word1/word2/g         查找word1字符串，并用word2替换word1
:1,$s/word1/word2/gc     查找word1字符串，并用word2替换word1，替换前要求确认

```



## 搜集的shell命令

### 马哥2019-王晓春

```yml
$ df
$ df | tr -s " "|cut -d " " -f5|tr -d "%"
$ df -h | tr -s " "|cut -d " " -f4|tr -d "%"
$ df|tr -s " " % |cut -d % -f5


$ ifconfig wlp2s0 |grep -o "[0-9.]\{7,\}" |head -n1
192.168.31.116

$ nmap -v -sP 192.168.31.0/24 |grep -B1 "up"
$ nmap -v -sP 192.168.31.0/24 |grep -B1 "up" |grep scan |cut -d" " -f5
```

### shell命令-系统信息


```yml

显示版本
rpm -qi centos-release

cat /etc/redhat-release
cat /etc/issue

软件版本
rpm -q --qf '%{NAME}-%{VERSION}-%{RELEASE}(%{ARCH})\n'  httpd

# rpm -q --qf %{version} centos-release;echo
7
# rpm -q --qf %{arch} centos-release;echo
x86_64




echo -e "\e[1;31m==========本地网络YUM源安装成功==========\e[0m"

#This is red text?\e[1;31m 将颜色设置为红色
#?\e[0m 将颜色重新置回
#颜色码：重置=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，洋红=35，青色=36，白色=37

用echo命令打印带有色彩的文字：

文字色：

echo -e "\e[1;31mThis is red text\e[0m"
This is red text?\e[1;31m 将颜色设置为红色
?\e[0m 将颜色重新置回
颜色码：重置=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，洋红=35，青色=36，白色=37

背景色：

echo -e "\e[1;42mGreed Background\e[0m"
Greed Background颜色码：重置=0，黑色=40，红色=41，绿色=42，黄色=43，蓝色=44，洋红=45，青色=46，白色=47

文字闪动：

echo -e "\033[37;31;5mMySQL Server Stop...\033[39;49;0m"
红色数字处还有其他数字参数：0 关闭所有属性、1 设置高亮度（加粗）、4 下划线、5 闪烁、7 反显、8 消隐

echo -n 不换行输出
$echo -n "123"
$echo "456"


#!/bin/sh
# 在某些情况下会拿到错误结果
echo -e ""测试1""
echo -e $(dirname $0)

echo -e ""测试2""
echo -e $(pwd)

echo -e ""测试3""
echo -e $(dirname $(readlink -f $0))

echo -e ""测试4""
cd ../software  # 当前位置跳到脚本位置
echo -e $(pwd)

echo -e ""测试5""
echo -e $0



```

### 17个Linux系统高频率常用命令行和shell小脚本

```yml

https://blog.51cto.com/dgd2010/1584952

urey_pp关注0人评论871人阅读2014-12-01 11:26:16
以下是在部署OpenStack以及使用Linux过程中摘录的一些较为常用的命令行或shell脚本，仅供参考。

1.杀死所有存在的僵尸进程

ps -ef | grep defunc | grep -v grep | awk '{print $3}' | xargs kill -9
#pkill dnsmasq
2.去掉配置文件中的#符号和空白行

cat >/root/delsc.sh <<eof
#!/bin/bash
# delete all spaces and comments of specialized file, using with  filename
[[ "\$1" == '' ]] && echo "delete all spaces and comments of specialized file, using with \$@ filename" && exit 1
grep -v \# \$1 | grep -v ^$
eof
cat /root/delsc.sh
chmod +x /root/delsc.sh
ln -s /root/delsc.sh /usr/local/bin/delsc
3.CentOS7安装vmtools

# mount /dev/cdrom /mnt/
# cp /mnt/VMwareTools-9.4.10-2092844.tar.gz /tmp/
# cd /tmp/
# tar zxf VMwareTools-9.4.10-2092844.tar.gz
# /tmp/vmware-tools-distrib/vmware-install.pl
yum install open-vm-tools -y
systemctl enable vmtoolsd.service
systemctl start vmtoolsd.service
systemctl status vmtoolsd.service
4.修改Linux系统时区

mv /etc/localtime /etc/localtime~
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
chown -h --reference=/etc/localtime~ /etc/localtime
chcon -h --reference=/etc/localtime~ /etc/localtime
5.中国大陆常用时间服务器列表

cat > /etc/ntp.conf <<eof
server 2.cn.pool.ntp.org iburst
server 3.asia.pool.ntp.org iburst
server 0.asia.pool.ntp.org iburst
restrict -4 default kod notrap nomodify
restrict -6 default kod notrap nomodify
eof
6.配置时间同步

rpm -qa | grep ntp || yum install -y ntp
ntpdate -u pool.ntp.org || ntpdate -u time.nist.gov || ntpdate -u time-nw.nist.gov
date
cat >>/etc/rc.local<<EOF
ntpdate -u pool.ntp.org || ntpdate -u time.nist.gov || ntpdate -u time-nw.nist.gov
hwclock -w
EOF
# Recommoned do
touch /etc/cron.daily/ntpdate
cat >>/etc/cron.daily/ntpdate<<EOF
ntpdate -u pool.ntp.org || ntpdate -u time.nist.gov || ntpdate -u time-nw.nist.gov
hwclock -w
EOF
7.对配置文件更改前先备份配置文件

operationfile=/etc/keystone/keystone.conf
bakoperationfile=$operationfile$(date +-%F-%H-%M-%S)"~"
cp $operationfile $bakoperationfile
chown -R --reference=$operationfile $bakoperationfile
chcon -R --reference=$operationfile $bakoperationfile
8.创建计划任务

(crontab -l -u keystone 2>&1 | grep -q token_flush) || echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' >> /var/spool/cron/keystone
9.不切换用户但以此用户的身份执行命令

su -s /bin/sh -c "glance-manage db_sync" glance
10.获取路由IP

ip=$(ifconfig `route | grep default | awk '{print $8}'` | grep inet | grep -v inet6 | awk '{print $2}')
11.判断CPU是否支持虚拟化

if [[ $(egrep -c '(vmx|svm)' /proc/cpuinfo) == 0 ]];then
	defaultnum=`grep -n "^\[libvirt\]$" $operationfile | awk -F ':' '{print $1}'`
	sedoperation=$defaultnum"a"
	sed -i "$sedoperation  virt_type = qemu" $operationfile
else
	defaultnum=`grep -n "^\[libvirt\]$" $operationfile | awk -F ':' '{print $1}'`
	sedoperation=$defaultnum"a"
	sed -i "$sedoperation  virt_type = kvm" $operationfile
fi
12.获取指定网卡名所对应的IP地址

ext_ens=ens160
local_ip=$(ifconfig `route | grep $ext_ens | awk '{print $8}'` | grep inet | grep -v inet6 | awk '{print $2}')
13.查找并删除文件

find /tmp -name core -type f -print0 | xargs -0 /bin/rm -f
14.查找并列出文件类型

find . -type f -exec file '{}' \;
15.查找大于1GB以上的文件，并列出

find / -size +1000M -exec ls -alh '{}' \;
16.测试磁盘性能

time dd if=/dev/zero of=/tmp/testfile bs=4k  count=80000
17.find查找文件大小大于10MB的文件，并find排除某些目录

find / -not \( -path /var/lib/docker -prune -o -path /proc -prune \) -type f -size +10M
--end--

```


### shell脚本

```yml

linux 脚本实现程序自动安装
#!/bin/bash

//设置脚本中所需命令的执行路径
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

// $? 是取得上面执行命令的返回值，一般正确为0，错误为1
if [ "$?" != 0 ] ;
then
 //echo 为输出到屏幕
 echo "Please check your need software"
 //exit 0 为强制终止脚本
 exit 0
fi


// 声明回滚函数（作用是删除解压出来的文件）
rollback(){
   rm -rf apache-tomcat.tar.gz
   rm -rf MySQL-client-5.5.31-2.rhel5.i386.rpm
   rm -rf MySQL-server-5.5.31-2.rhel5.i386.rpm
   rm -rf jdk-6u29-linux-i586-rpm.bin
   rm -rf mysql.cnf
}

echo "Please choose to install or uninstall? (Installation: 1 / Uninstall: 0)"

//接收键盘输入，并把输入的值存放在userinput变量中
read userinput

//判断变量的值
if [ "$userinput" == '1' ] ;
then

//判断文件是否存在
if [ ! -e medical.tar.gz ] ;
then
  echo "I cann't find medical.tar.gz file."
  exit 0
else
//存在则赋权并解压
chmod 755 medical.tar.gz
tar zxvf medical.tar.gz
fi

################################### Verify #################################

//判断本机是否安装了jdk
rpm -qa | grep jdk
if [ "$?" == 0 ] ;
then
echo "Already installed JDK, please uninstall!"
rollback;
exit 0
fi

//判断8080端口是否被占用
netstat -apn | grep 8080
if [ "$?" == 0 ] ;
then
echo "8080 port is occupied!"
rollback;
exit 0
fi

//判断本机是否安装了mysql
rpm -qa | grep -i mysql
if [ "$?" == 0 ] ;
then
echo "The system has been installed MySQL.Please run the uninstall!"
rollback;
exit 0
fi

//判断目录是否已存在
if [ -d /usr/tomcat-medical ] ;
　　then



echo "/usr/tomcat-medical Directory exists"
rollback;
exit 0
fi

//判断3306端口是否被占用
netstat -apn | grep 3306
if [ "$?" == 0 ] ;
then
echo "3306 port is occupied"
rollback;
exit 0
fi

##################################### JDK ################################

//赋权并安装jdk
　　chmod 755 jdk-6u29-linux-i586-rpm.bin



./jdk-6u29-linux-i586-rpm.bin
//安装jdk的时候需要回车确认一下jdk的许可协议

#########################################################################

//rpm包的jdk安装完成会自动生成 java/jdk**** 的文件夹，判断是否生成了jdk文件夹
if [ ! -d java/jdk1.6* ] ;
then
echo "I cann't find JDK directory."
rollback;
exit 0
fi

############################## Environment Variables #########################

//将一段文本追加到指定文件尾部（写入环境变量）
cat >> /etc/profile << EFF

JAVA_HOME=/usr/java/jdk1.6.0_29
JRE_HOME=\$JAVA_HOME/jre
CLASSPATH=:\$JAVA_HOME/lib:\$JRE_HOME/lib
PATH=\$JAVA_HOME:/bin:\$JRE_HOME/bin:\$PATH
export JAVA_HOME JRE_HOME CLASSPATH PATH

EFF
 //使环境变量立即生效
 source /etc/profile

#########################################################################

//判断环境变量是否已经生效
java -version
if [ "$?" != 0 ] ;
then
echo "I cann't set java path."
rollback;
exit 0
fi

####################### Delete JDK Installation file #############################

rm -rf jdk-6u29-linux-i586.rpm
rm -rf sun-javadb*

################################# MySQL ##################################

//赋权并安装mysql
chmod 755 MySQL-server-5.5.31-2.rhel5.i386.rpm
rpm -ivh MySQL-server-5.5.31-2.rhel5.i386.rpm

################### Copy MySQL configuration file ##############################

 //将一份已经准备好的配置文件替换mysql现有配置文件
 chmod 755 mysql.cnf
 cp mysql.cnf /usr/share/mysql/my-medium.cnf
 cp mysql.cnf /etc/my.cnf

 //启动或重启mysql
 netstat -apn | grep 3306
 if [ "$?" != 0 ] ;
 then
  service mysql start
 else
  service mysql restart
 fi

 //判断mysql是否启动成功
 netstat -apn | grep 3306
 if [ "$?" != 0 ] ;
 then
  echo "MySQL service failed to start!"
  rollback;
  exit 0
 fi

 //安装mysql用户端
 chmod 755 MySQL-client-5.5.31-2.rhel5.i386.rpm
 rpm -ivh MySQL-client-5.5.31-2.rhel5.i386.rpm

################################ Tomcat ##################################


 //赋权并解压tomcat
 chmod 755 apache-tomcat*.tar*
 tar zxvf apache-tomcat*.tar*
 mv apache-tomcat-6.0.32/ /usr/tomcat-medical/

################################ Medical ##################################

 //赋权并解压应用到tomcat/webapps目录下
 chmod 755 medical.zip
 unzip medical.zip -d /usr/tomcat-medical/webapps/

 //判断当前目录下是否存在Install.zdt文件，存在则copy文件到指定目录下
 if [ -e Install.zdt ] ;
 then
   cp Install.zdt /usr/tomcat-medical/webapps/medical/WEB-INF/data/installer/
 fi

########################### Change Password ################################

 //等待5秒
 sleep 5
 //mysql默认密码为空，修改mysql密码（需要当前用户有mysql执行权限）
 mysqladmin flush-privileges password '******'

########################## Environment Variables #############################

//环境变量
　　cat >> /etc/profile << TTD

　　TOMCAT_HOME=/usr/tomcat-medical/

　　PATH=\$PATH:\$TOMCAT_HOME/bin/:/usr/local/apache2/bin:

　　export JAVA_HOME JRE_HOME CLASSPATH PATH TOMCAT_HOME

　　TTD




source /etc/profile

#########################################################################

 //启动tomcat
 sh /usr/tomcat-medical/bin/startup.sh

 //这里延迟5秒等待tomcat启动完成
 sleep 5

 //判断tomcat状态
 curl 127.0.0.1:8080 | grep "Thanks for using Tomcat"
 if [ "$?" != 0 ] ;
 then
  echo "I think install tomcat is unfinished ."
  rollback;
  exit 0
 fi

 rollback;

######################## Auto Start Up Services ###############################

//把tomcat启动脚本加入rc.local文件中实现开机自动启动
cat >> /etc/rc.local << ASU

/usr/tomcat-medical/bin/startup.sh

ASU

 //设置mysql服务开机自动启动
 chkconfig --add mysql

########################################################################

//如果用户输入0的情况下执行卸载程序
elif [ "$userinput" == '0' ] ;
then

 echo "Uninstalling Tomcat......"

 netstat -apn | grep 8080
 if [ "$?" == 0 ] ;
 then
  sh /usr/tomcat-medical/bin/shutdown.sh
 fi

 rm -rf /usr/tomcat-medical/

 echo "Uninstalling JDK......"
 rpm -e jdk-1.6.0_29-fcs.i586

 echo "Uninstalling MySQL......"

 netstat -apn | grep 3306
 if [ "$?" == 0 ] ;
 then
  service mysql stop
 fi

 rpm -e MySQL-client-5.5.31-2.rhel5.i386
 rpm -e MySQL-server-5.5.31-2.rhel5.i386

 echo "Uninstall is complete please modify environment variables."

//如果用户输入的不是1或0则执行这里
else
 echo "You can only enter 1 or 0."

fi 


```


### Vagrantfile-k8sallinonekubeasz

```yml
# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure("2") do |config|

  config.vm.box = "centos7"

  config.vm.define "kubeasz10" do | w1 |
    w1.vm.hostname = "kubeasz10"
    w1.vm.network "public_network", bridge: "em1", ip: "192.168.102.10"
    w1.vm.network :forwarded_port, guest: 6443, host: 6443
    #w1.vm.synced_folder "/home/y/tools", "/home/vagrant/tools"
    w1.vm.provider "virtualbox" do |v|
      v.name = "kubeasz10"
      v.memory = 8192
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo mkdir -p /etc/yum.repos.d/repobak
    sudo mv /etc/yum.repos.d/* /etc/yum.repos.d/repobak
    sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo
    sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo
    sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo
    sudo yum clean all && yum makecache
    sudo yum install -y wget vim tree rsync docker-ce
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo setenforce 0
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    sudo echo "nameserver 192.168.0.186" >> /etc/resolv.conf
  SHELL

end


```

### Vagrantfile-k8sallinone
```yml

# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure("2") do |config|

  config.vm.box = "geerlingguy/centos7"

  config.vm.define "k8s161" do | w1 |
    w1.vm.hostname = "k8s161"
#w1.vm.network "private_network", ip: "10.19.1.11"
#w1.vm.network "public_network", bridge: "enp0s25", ip: "192.168.31.187"
w1.vm.network :public_network, ip: "192.168.31.161", bridge:"wlp3s0", bootproto: "static", gateway: "192.168.31.100"
    w1.vm.network :forwarded_port, guest: 80, host: 8080
    #w1.vm.synced_folder "/home/y/tools", "/home/vagrant/tools"
    w1.vm.provider "virtualbox" do |v|
      v.name = "k8s161"
      v.memory = 4096
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo setenforce 0
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    sudo sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
    #sed -i -e "/BOOTPROTO/c BOOTPROTO=static\nIPADDR=192.168.102.79\nNETMASK=255.255.255.0\nGATEWAY=192.168.102.254\nPEERDNS=no\nDNS1=192.168.0.186" /etc/sysconfig/network-scripts/ifcfg-eth0
    #echo 'nameserver 192.168.0.186' >> /etc/resolv.conf
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
    sudo yum install -y docker-ce-18.03.1.ce
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo mkdir -p /etc/docker
# https://registry.docker-cn.com https://hub-mirror.c.163.com https://al9ikvwc.mirror.aliyuncs.com
#sudo echo -e "{\n \"registry-mirrors\": [\"https://hub-mirror.c.163.com\"]\n}" > /etc/docker/daemon.json
    sudo curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
    sudo systemctl daemon-reload
    sudo systemctl restart docker
  SHELL

end


```

