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

#筛选IP地址
ifconfig |egrep -o "\<(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[4-9][0-9]|25[0-5])\>"















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


# -------------- 目录 ----------------
#当前目录current_path
#/oracle/wokishell/wokinst/scripts
basepath=$(cd `dirname $0`; pwd)
current_path=$(cd `dirname $0`; pwd)
#上级目录/oracle/wokishell/wokinst
prepath=$(dirname "$PWD") 
#上上级目录 (原理同上)/oracle/wokishell
pprepath=$(dirname $(dirname "$PWD")) 
#/oracle/wokishell/wokinst/files/rpmpackages
rpmdir=${prepath}/files/rpmpackages
#/oracle/wokishell/wokinst/files/software
softdir=${prepath}/files/software

echo -e "current_path目录："$current_path
echo -e "basepath目录："$basepath
echo -e "prepath目录："$prepath
echo -e "pprepath目录："$pprepath
echo -e "rpmdir目录："$rpmdir
echo -e "softdir目录："$softdir

Linux shell 提取文件名和目录名
${}用于字符串的读取，提取和替换功能，可以使用${} 提取字符串
1、提取文件名
[root@localhost log]# var=/dir1/dir2/file.txt
[root@localhost log]# echo ${var##*/}
file.txt
2、提取后缀
[root@localhost log]# echo ${var##*.}
txt
3、提取不带后缀的文件名，分两步
[root@localhost log]# tmp=${var##*/}
[root@localhost log]# echo $tmp
file.txt
[root@localhost log]# echo ${tmp%.*}
file
4、提取目录
[root@localhost log]# echo ${var%/*}
/dir1/dir2

echo -e "\e[1;31m****** temp ******\e[0m"
var=`ls /opt/*.iso`
echo ${var##*/} #显示文件名+后缀
echo ${var##*.} #显示后缀名

tmp=${var##*/}
echo $tmp #显示文件名+后缀
echo ${tmp%.*} #显示文件名
echo ${var%/*} #显示目录名

echo -e "\e[1;31m****** temp ******\e[0m"



linux 下shell中if的“-e，-d，-f”是什么意思
文件表达式
-e filename 如果 filename存在，则为真
-d filename 如果 filename为目录，则为真 
-f filename 如果 filename为常规文件，则为真
-L filename 如果 filename为符号链接，则为真
-r filename 如果 filename可读，则为真 
-w filename 如果 filename可写，则为真 
-x filename 如果 filename可执行，则为真
-s filename 如果文件长度不为0，则为真
-h filename 如果文件是软链接，则为真
filename1 -nt filename2 如果 filename1比 filename2新，则为真。
filename1 -ot filename2 如果 filename1比 filename2旧，则为真。


整数变量表达式
-eq 等于
-ne 不等于
-gt 大于
-ge 大于等于
-lt 小于
-le 小于等于


字符串变量表达式
If  [ $a = $b ]                 如果string1等于string2，则为真
                                字符串允许使用赋值号做等号
if  [ $string1 !=  $string2 ]   如果string1不等于string2，则为真       
if  [ -n $string  ]             如果string 非空(非0），返回0(true)  
if  [ -z $string  ]             如果string 为空，则为真
if  [ $sting ]                  如果string 非空，返回0 (和-n类似) 


    逻辑非 !                   条件表达式的相反
if [ ! 表达式 ]
if [ ! -d $num ]               如果不存在目录$num


    逻辑与 –a                   条件表达式的并列
if [ 表达式1  –a  表达式2 ]


    逻辑或 -o                   条件表达式的或
if [ 表达式1  –o 表达式2 ]


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

### 

```yml


```

### 

```yml


```

### 

```yml
Linux 运维常用组合命令
kuangling关注14人评论1512人阅读2013-07-13 14:53:18

1.删除0字节文件

find -type f -size 0 -exec rm -rf {} \; 

find -type f -size 0 |xargs rm -fr


2.查看进程

按内存从大到小排列

ps -e -o "%C : %p : %z : %a"|sort -k5 –nr


3.按cpu利用率从大到小排列

ps -e -o "%C : %p : %z : %a"|sort –nr


4.打印cache里的URL

grep -r -a jpg /data/cache/* |strings |grep "http:" |awk -F'http:' '{print "http:"$2;}'


5.查看http的并发请求数及其TCP连接状态：

netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'

netstat -an |grep ^tcp |awk '{print $NF}' |sort -nr |uniq -c


6.sed -i '/Root/s/no/yes/' /etc/ssh/sshd_config sed在这个文里Root的一行，匹配Root一行，将no替换成yes.


7.如何杀掉mysql进程：

ps aux |grep mysql |grep -v grep |awk '{print $2}' |xargs kill -9 (从中了解到awk的用途)

killall -TERM mysqld

kill -9 `cat /usr/local/apache2/logs/httpd.pid` 试试查杀进程PID


8.如何杀掉僵尸进程

ps -A -o stat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}' | xargs kill -9 

或者 kill –HUPPID


9．使用lsof查看占用80端口

lsof -i:80 

lsof ‘which httpd’


10.显示运行3级别开启的服务:

ls /etc/rc3.d/S* |cut -c 15- (从中了解到cut的用途，截取数据)


11.如何在编写SHELL显示多个信息，用EOF

cat << EOF

+--------------------------------------------------------------+

| === Welcome to Tunoff services === |

+--------------------------------------------------------------+

EOF


12. for 的巧用(如给mysql建软链接)

cd /usr/local/mysql/bin

for i in *

do ln -s /usr/local/mysql/bin/$i /usr/bin/$i

done


13. 取IP地址：

ifconfig eth0 |grep "inet addr:" |awk '{print $2}'|cut -c 6- 或者


ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'


14.内存的大小:

free -m |grep "Mem" | awk '{print $2}'


13.

netstat -an -t | grep ":80" | grep ESTABLISHED | awk '{printf "%s %s\n",$5,$6}' | sort


14.查看Apache的并发请求数及其TCP连接状态：

netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'


15.因为同事要统计一下服务器下面所有的jpg的文件的大小,写了个shell给他来统计.原来用xargs实现,但他一次处理一部分,搞的有多个总和....,下面的命令就能解决啦.

find / -name *.jpg -exec wc -c {} \;|awk '{print $1}'|awk '{a+=$1}END{print a}'


16．CPU的数量

# cat /proc/cpuinfo |grep -c processor

越多，系统负载越低，每秒能处理的请求数也越多。


17．CPU负载 

# cat /proc/loadavg

检查前三个输出值是否超过了系统逻辑CPU的4倍。


18． CPU负载

#mpstat 1 1

检查%idle是否过低(比如小于5%)


19． 内存空间

# free –m

检查free值是否过低也可以用 # cat /proc/meminfo


20．swap空间 

# free -m |grep Swap

检查swap used值是否过高如果swap used值过高，进一步检查swap动作是否频繁：

# vmstat 1 5

观察si和so值是否较大


21．磁盘空间 

# df -Th

检查是否有分区使用率(Use%)过高(比如超过90%) 如发现某个分区空间接近用尽，可以进入该分区的挂载点，用以下命令找出占用空间最多的文件或目录：

# du -cks * | sort -rn | head -n 10


22．磁盘I/O负载

# iostat -x 1 2

检查I/O使用率(%util)是否超过100%


23．网络负载

# sar -n DEV

检查网络流量(rxbyt/s, txbyt/s)是否过高


24．网络错误

# netstat -i

检查是否有网络错误(drop fifo colls carrier) 也可以用命令：

# cat /proc/net/dev


25．网络连接数目

# netstat -an |grep -E “^(tcp)”|cut -c 68- |sort |uniq -c |sort -n


26. 进程总数
# ps aux | wc -l

检查进程个数是否正常 (比如超过250)


27．可运行进程数目

# vmwtat 1 5

列给出的是可运行进程的数目，检查其是否超过系统逻辑CPU的4倍


28.进程 

# top -id 1

观察是否有异常进程出现


29. 网络状态 检查DNS, 网关等是否可以正常连通

# ping


30.查看用户

# who | wc -l

检查登录用户是否过多 (比如超过50个) 也可以用命令：

# uptime


31.系统日志

# cat /var/log/rflogview/*errors

检查是否有异常错误记录 也可以搜寻一些异常关键字，例如：

# grep -i error /var/log/messages

# grep -i fail /var/log/messages


32.系统启动核心日志 

# dmesg

检查是否有异常错误记录


33.系统时间 

# date

检查系统时间是否正确


34.打开文件数目 

# lsof | wc -l

检查打开文件总数是否过多


35. 日志
# logwatch –print 配置/etc/log.d/logwatch.conf，将 Mailto 设置为自己的email 地址，启动mail服务 (sendmail或者postfix)，这样就可以每天收到日志报告了。

缺省logwatch只报告昨天的日志，可以用# logwatch –print –range all 获得所有的日志分析结果。

可以用# logwatch –print –detail high 获得更具体的日志分析结果(而不仅仅是出错日志)。


36.杀掉80端口相关的进程

lsof -i :80|grep -v "PID"|awk '{print "kill -9",$2}'|sh


37.tcpdump 抓包 ，用来防止80端口被人攻击时可以分析数据

# tcpdump -c 10000 -i eth0 -n dst port 80 > /root/pkts


38.然后检查IP的重复数并从小到大排序 注意 "-t\ +0" 中间是两个空格

# less pkts | awk {'printf $3"\n"'} | cut -d. -f 1-4 | sort | uniq -c | awk {'printf $1" "$2"\n"'} | sort -n -t\ +0


39.查看有多少个活动的php-cgi进程

netstat -anp | grep php-cgi | grep ^tcp | wc -l

chkconfig --list | awk '{if ($5=="3:on") print $1}'


40.查找/usr/local/apache/logs目录最后修改时间大于30天的文件，并删除。

find  /usr/local/apache/logs -type f -mtime +30 -exec rm -f {} \;


41．添加一条到192.168.3.0/24的路由，网关为192.168.1.254

route add  -net 192.168.3.0 netmask 255.255.255.0 gw 192.168.1.254


42．编写个shell脚本将/usr/local/test 目录下大于100K的文件转移到/tmp目录

#!/bin/bash

for i in $(ls -l /usr/local/test |awk '($5 > 10000) {print $NF}')

do

mv $i /tmp

done


43．在每周6的凌晨3:15执行/home/shell/collect.pl，并将标准输出和标准错误输出到/dev/null设备，请写出crontab中的语句

15 3 * * 6 /home/shell/collect.pl >/dev/null 2>&1


44．列出linux常见打包工具并写相应解压缩参数(至少三种)？

包类型

压缩实例

解压实例

压缩比率

Tar

tar -cvf

tar -xvf

只打包不压缩

Tar.gz

tar -czvf

tar -zxvf

中高

Tar.bz2

tar -cjvf

tar -jxvf

高


45.kudzu查看网卡型号

kudzu --probe --class=network


匹配中文字符的正则表达式： [\u4e00-\u9fa5]

评注：匹配中文还真是个头疼的事，有了这个表达式就好办了

匹配双字节字符(包括汉字在内)：[^\x00-\xff]

评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）

匹配空白行的正则表达式：\n\s*\r

评注：可以用来删除空白行

匹配HTML标记的正则表达式：<(\S*?)[^>]*>.*?</\1>|<.*? />

评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力

匹配首尾空白字符的正则表达式：^\s*|\s*$

评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，

非常有用的表达式

配Email地址的正则表达式：\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*

评注：表单验证时很实用

匹配网址URL的正则表达式：[a-zA-z]+://[^\s]*

评注：网上流传的版本功能很有限，上面这个基本可以满足需求

匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$

评注：表单验证时很实用

匹配国内电话号码：\d{3}-\d{8}|\d{4}-\d{7}

评注：匹配形式如 0511-4405222 或 021-87888822

匹配腾讯QQ号：[1-9][0-9]{4,}

评注：腾讯QQ号从10000开始

匹配中国邮政编码：[1-9]\d{5}(?!\d)

评注：中国邮政编码为6位数字

匹配×××：\d{15}|\d{18}

评注：中国的×××为15位或18位

匹配ip地址：\d+\.\d+\.\d+\.\d+

评注：提取ip地址时有用

匹配特定数字：

^[1-9]\d*$　 　 //匹配正整数

^-[1-9]\d*$ 　 //匹配负整数

^-?[1-9]\d*$　　 //匹配整数

^[1-9]\d*|0$　 //匹配非负整数（正整数 + 0）

^-[1-9]\d*|0$　　 //匹配非正整数（负整数 + 0）

^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$　　 //匹配正浮点数

^-([1-9]\d*\.\d*|0\.\d*[1-9]\d*)$　 //匹配负浮点数

^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$　 //匹配浮点数

^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$　　 //匹配非负浮点数（正浮点数 + 0）

^(-([1-9]\d*\.\d*|0\.\d*[1-9]\d*))|0?\.0+|0$　　//匹配非正浮点数（负浮点数 + 0）

评注：处理大量数据时有用，具体应用时注意修正

匹配特定字符串：

^[A-Za-z]+$　　//匹配由26个英文字母组成的字符串

^[A-Z]+$　　//匹配由26个英文字母的大写组成的字符串

^[a-z]+$　　//匹配由26个英文字母的小写组成的字符串

^[A-Za-z0-9]+$　　//匹配由数字和26个英文字母组成的字符串

^\w+$　　//匹配由数字、26个英文字母或者下划线组成的字符串

评注：最基本也是最常用的一些表达式

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

### 

```yml



```

### 

```yml



```

### 

```yml

```

