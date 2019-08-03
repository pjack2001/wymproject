# linux常用命令 

https://github.com/DingGuodong/LinuxBashShellScriptForOps

## 常用命令

### 最常用
```yml

使用--help帮助查找命令

$ ssh root@192.168.113.69
scp -r wokinst root@192.168.113.69:/opt
ssh-copy-id root@192.168.113.69
ssh-keygen -f "/home/w/.ssh/known_hosts" -R "192.168.113.69"

du -shb *
tree -L 2
ss -unl

history | cut -c 8-|grep clone  #输出结果不加序号
netstat -tulnp |grep squid
netstat -ntpl|grep 3128
mkdir -p centos/7/{extras,os,updates}/x86_64


unzip -O GBK xxx.zip
unzip kube-prompt_v1.0.6_linux_amd64.zip
tar -zxvf k9s_0.7.11_Linux_x86_64.tar.gz

grep -v '^#' squid.conf-bak | grep -v '^$' > squid.conf2
sed -i 's#var/www/html#home/y/linuxiso/httpd#g' yum-updaterepo.sh

ip a |grep inet[^6]|sed -r 's#inet (.*)/[0-9].*#\1#'
ip a |grep inet[^6]|grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}'
ip a|grep -w 'inet'|grep 'global'|sed 's/.*inet.//g'|sed 's/\/[0-9][0-9].*$//g'




chmod -R 777 Ubuntu16.04-bak
chown -R root:root Ubuntu16.04-bak

setenforce 0
/usr/sbin/sestatus -v
systemctl disable firewalld.service
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo


wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache

rpm -ivh vagrant_2.1.5_x86_64.rpm
rpm -qa|grep vnc
vncserver -list
ps -ef|grep vnc
systemctl enable vncserver@:1.service
cp /usr/lib/systemd/system/vncserver@.service /usr/lib/systemd/system/vncserver@:1.service
vim /usr/lib/systemd/system/vncserver@:1.service

mount /home/y/linuxiso/httpd/iso/CentOS-7-x86_64-DVD-1804.iso /home/y/linuxiso/httpd/CentOS-ISO/centos7 -o loop





配置SSH登录，关闭SElinux和防火墙
# sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config && systemctl restart sshd && systemctl stop firewalld && setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config && sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

配置阿里yum源并安装
# mkdir -p /etc/yum.repos.d/repobak && mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && curl -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && yum clean all && yum makecache && yum install -y wget vim tree net-tools zip unzip tmux bash-completion && yum install -y docker-ce

配置内网yum源并安装
# mkdir -p /etc/yum.repos.d/repobak && mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak && curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo && curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo && curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo && yum clean all && yum makecache && yum install -y wget vim tree net-tools zip unzip tmux bash-completion dstat && yum install -y docker-ce

启动docker
# systemctl start docker && systemctl enable docker 

配置加速器和私有镜像仓库
# mkdir -p /etc/docker && echo -e '{"registry-mirrors": ["https://7bezldxe.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.37"]}' > /etc/docker/daemon.json && systemctl daemon-reload && systemctl restart docker




```



### 软件启动配置
```yml

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.on-my-zsh





cd /media/w/n/work/linux/Ubuntu16.04-bak/+tool/navicat_premium/navicat121_premium_cs_x64
./start_navicat

cd /media/w/n/work/python/Pythontool/pycharm/idea.lanyus.com注册/IntelliJIDEALicenseServer
./IntelliJIDEALicenseServer_linux_amd64
cd /media/w/n/work/python/Pythontool/pycharm/DataGrip-2017.3.4/bin
./datagrip.sh




sudo apt install bash-completion
source <(kubectl completion bash)
kubectl completion bash > ~/.kube/completion.bash.inc
source <(kubectl completion zsh)
kubectl completion zsh > "${fpath[1]}/_kubectl"

docker login 192.168.113.38
docker load -i secretkey.tar.gz
docker tag secretkey:latest 192.168.113.38/v8/secretkey:20190702
docker push 192.168.113.38/v8/secretkey:20190702
docker images |grep secre
docker rmi -f d1d
docker images | grep 113 | sed 's/192.168.113.38\/wymproject/192.168.102.3\/wymproject/g' | awk '{print "docker tag"" " $3" "$1":"$2}'|sh
docker rmi --force `docker images|grep wymproject|awk '{print $1":"$2}'`

tar xvf kubernetes-client-darwin-amd64.tar.gz && cp kubernetes/client/bin/kubectl /usr/local/bin
mkdir -p ~/.kube
cp conf/admin.kubeconfig ~/.kube/config
cd ~/.kube
vim config
kubectl -n kube-system describe secret `kubectl -n kube-system get secret|grep admin-token|cut -d " " -f1`|grep "token:"|tr -s " "|cut -d " " -f2






sudo zerotier-cli join e4da7455b2229432

git status
git add .
git commit -m '0626'
git push
git clone https://github.com/easzlab/kubeasz.git
git log
git show
git config --global user.email "wangyuming@newcapec.net"




ffmpeg -i simplescreenrecorder-2019-06-03_13.45.12.mp4 -ss 00:00:02 -to 00:38:35 -c copy wym-rancher01.mp4
ffmpeg -f concat -i wym-rancher.txt -c copy wym-rancher.mp4



cd ~/tool/oracle
scp p13390677_112040_Linux-x86-64_1of7.zip root@192.168.102.3:/home/y/linuxiso/httpd/iso
scp oracle11g自动静默安装.sh.txt root@192.168.102.3:/home/y/linuxiso/httpd/iso
scp p13390677_112040_Linux-x86-64_2of7.zip root@192.168.102.3:/home/y/linuxiso/httpd/iso
scp p13390677_112040_Linux-x86-64_3of7.zip root@192.168.102.3:/home/y/linuxiso/httpd/iso

sqlplus sys/newcapec@192.168.113.54:1521/ecard as sysdba
sqlplus datalook/newcapec@192.168.113.54:1521/ecard
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
exp datalook/123456@192.168.113.25:1521/orcl file=./datalook20190614.dmp log=./datalook.log
imp datalook/newcapec@192.168.113.54:1521/ecard file=./datalook20190614.dmp full=y

wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
yum --enablerepo=epel install dkms
yum install VirtualBox-5.2

sudo dpkg -i virtualbox-5.2_5.2.12-122591_Ubuntu_xenial_amd64.deb 
sudo dpkg -i vagrant_2.1.1_x86_64.deb 
sh VMware-Workstation-Full-14.1.1-7528167.x86_64.bundle
./VMware-Workstation-Full-12.1.1-3770994.x86_64.bundle

```



### 
```yml
linux&oracle常用命令

鸟哥的私房菜 http://vbird.dic.ksu.edu.tw/linux_server/

http://linux.vbird.org/linux_server/



Linux常用命令
使用ssh远程登录
$ ssh -l root 192.168.0.11
$ ssh root@192.168.0.11
$ scp /home/w/sonar-l10n-zh-plugin-1.16.jar bitnami@192.168.31.49:/home/bitnami/

##############################################################################
linux实现ssh免密码登录的正确方法
https://jingyan.baidu.com/article/c275f6ba08267ae33c756758.html

1.生成密钥和公钥
$ ssh-keygen -t rsa，三个回车，生成的密钥id_rsa和公钥id_rsa.pub保存在/home/w/.ssh/目录下

2.将公钥文件传输的远程机器，并生效
$ ssh-copy-id -i ~/.ssh/id_rsa.pub pi@192.168.31.49
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/w/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
pi@192.168.31.49's password:
Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'pi@192.168.31.49'"
and check to make sure that only the key(s) you wanted were added.

公钥就会被上传远程主机的/home/pi/.ssh/authorized_keys文件里面

3.再次使用已经做免密处理的用户登录远程机器，已经不需要密码了，免密登录处理完成
$ ssh pi@192.168.31.49，就不用输入密码了

4.查看远程机器的authorized_keys文件，可以看到对应的变化：本地机器的公钥已经增加到远程机器的配置文件中了

注意事项
免密码登录的处理是用户对用户的，切换其他用户后，仍然需要输入密码
公钥传到远程机器并生效的操作，可用其他方式实现，如scp后修改authorized_keys
远程机器的.ssh目录需要700权限，authorized_keys文件需要600权限
##############################################################################



# uname –r 或–a –m      显示内核
$ hostnamectl

# cat /proc/swaps        或  cat /proc/cpuinfo 等等硬件信息
# dmesg | more              查看开机硬件检测
# shutdown –h now        shutdown –r now          shutdown –yr 0 重启   
# netstat –tlp 或 –tlunp 或 –rn 或 -in 安装yum install net-tools
   ss -unl 可以查看到监听的67号端口。
# crontab –l  列出已有       -e  编辑
# ps   查进程PID             kill -9 PID   杀死进程

# ll 显示目录下的文件 ls -f 列出所有，包括隐藏
# rm –r 文件或文件夹          删除所有文件、子目录 -rf 删除非空    rmdir  删除目录 rm -rf 强制删除
# find 目录名 –name 文件名    查找文件
# which     从path中找出文件的位置
#  whereis     找出特定程序的路径
#  locate　　     从索引中找出文件位置

# df -h，–k或-m       # fdisk –l    # mount    # du -h  # du -sbh *
# lsblk
# du -h --max-depth=1 /var/svn/repos/ 查看repos目录下一级的文件夹大小
# chown –R oracle:dba /home/oracle     更改目录所有权
# chmod –R 775 /home/oracle            更改目录权限

# tar cvf ora10.tar /home/oracle          整个目录打包
# tar xvf ora10.tar                       按打包路径解压
X86_64为Oracle会用cpio.gz文件格式
# gunzip XXXX.cpio.gz              解压gz文件
# cpio –idmv < XXXX.cpio        解压到当前目录
# unzip 10201_clusterware_linux32.zip    解压到当前目录


# scp -r root@192.168.0.196:/var/svn/repos/ /var/svn/  #从远程拷贝到本地
# scp -r /var/svn/repos/ root@192.168.0.66:/var/svn/  #从本地拷贝到远程

# rlogin linux2
# rcp ora10.tar linux1:/home/oracle/tmp
# scp ora10.tar linux1:/home/oracle/tmp

# rpm –qa | grep ocfs       查询是否安装ocfs组件
# rpm –ivh ocfs*.rpm     安装ocfs组件 如果不能按照，加参数--nodeps --force
# rpm –e 软件名              卸载软件

ftp> help                显示帮助              ftp> dir或ls         显示远方主机的内容
ftp> cd                  变换远程主机的目录     ftp> pwd                 显示远程主机的路径
ftp> mkdir 目录名        在远程主机上建立目录    ftp> lcd 路径名          变换本地端路径
ftp> lls                 显示本地主机的内容     ftp> lpwd                显示本地主机的目录
ftp> lmkdir 目录名    在本地主机上建立目录    ftp> close或bye或exit 离开远程主机
ftp> ascii或binary       设置传输模式           
ftp> get 文件名          取得远程主机的文件
ftp> mget ocfs*.rpm      取得所有远程主机的多个文件
ftp> put 文件名          将本地文件放到远程主机
ftp> mput ocfs*.rpm      将本地多个文件放到远程主机                       
ftp> delete或rm 文件名    删除远程主机的文件

##################################################################

linux系统权限详解

在linux系统中644、755、777三种权限是非常重要的一些权限了，下面我来详细的介绍644、755、777三种权限的使用，希望对各位有帮助。

常用的linux文件权限：
444 r--r--r--
600 rw-------
644 rw-r--r--
666 rw-rw-rw-
700 rwx------
744 rwxr--r--
755 rwxr-xr-x
777 rwxrwxrwx
从左至右，1-3位数字代表文件所有者的权限，4-6位数字代表同组用户的权限，7-9数字代表其他用户的权限。
而具体的权限是由数字来表示的，读取的权限等于4，用r表示；写入的权限等于2，用w表示；执行的权限等于1，用x表示；
通过4、2、1的组合，得到以下几种权限：0（没有权限）；4（读取权限）；5（4+1 | 读取+执行）；6（4+2 | 读取+写入）；7（4+2+1 | 读取+写入+执行）
以755为例：
1-3位7等于4+2+1，rwx，所有者具有读取、写入、执行权限；
4-6位5等于4+1+0，r-x，同组用户具有读取、执行权限但没有写入权限；
7-9位5，同上，也是r-x，其他用户具有读取、执行权限但没有写入权限。

rwx权限数字解释 
chmod也可以用数字来表示权限如 chmod 777 file
语法为：chmod abc file
其中a,b,c各为一个数字，分别表示User、Group、及Other的权限。
r=4，w=2，x=1
若要rwx属性则4+2+1=7；
若要rw-属性则4+2=6；
若要r-x属性则4+1=7。
范例：
chmod a=rwx file 
和
chmod 777 file 
效果相同
chmod ug=rwx,o=x file 
和
chmod 771 file 
效果相同
若用chmod 4755 filename可使此程序具有root的权限
---------------------
作者：一块钱硬币2015
来源：CSDN
原文：https://blog.csdn.net/u010442302/article/details/51353243?utm_source=copy
版权声明：本文为博主原创文章，转载请附上博文链接！


##################################################################




##################################################################
3.防火墙的原因
通过 /etc/init.d/iptables  stop  关闭防火墙
# /etc/init.d/iptables status
我的问题，就是因为这个原因引起的。关闭mysql 服务器的防火墙就可以使用了。
CentOS开启端口
# iptables -A INPUT -p tcp --dport 80 -j ACCEPT
保存并重启防火墙
#/etc/rc.d/init.d/iptables save
#/etc/init.d/iptables restart
打开49152~65534之间的端口
# iptables -A INPUT -p tcp --dport 49152:65534 -j ACCEPT
开启防火墙(重启后永久生效)：chkconfig iptables on
关闭防火墙(重启后永久生效)：chkconfig iptables off

debian开启端口，关闭端口
$ sudo ufw allow 3306 ，打开mysql远程访问端口
$ sudo ufw deny PORT

##################################################################

# ntsysv     CentOS用命令行查看、设置服务启动

# cat | grep -iE '(rpc|nfs)' /var/log/messages  查看messages日志里面的rpc和nfs字段

# whereis mysql 经常出现忘了安装路径的情况，还有日志路径，可以用这个命令

# last|grep reboot          查看服务器重启
last

last | grep reboot

last | grep shutdown

或在/var/log/messages日志中查询reboot （重启） 或halt（关机）

grep reboot /var/log/messages

grep halt /var/log/messages


# uptime          看服务器运行了多久 ！ 就知道什么时候重启了

查看目录空间占用情况
# du -sbh *

# chkconfig –list # 列出所有系统服务
# chkconfig –list | grep on # 列出所有启动的系统服务
设置mysql数据库自动启动
# chkconfig mysqld on
# chkconfig --list mysqld 

###################################

1、#添加cron任务
$ sudo /etc/init.d/cron start
$ crontab -e
#每10分钟执行一次并生成日志，每天9点同步一次
*/10 * * * *  /home/w/tool/datax/bin/wymjob/run_datax_10minute.sh
* 9 * * *  /home/w/tool/datax/bin/wymjob/run_datax_1day.sh
#每天9点启动docker容器
* 9 * * *  $ sudo docker start a5e8453146be
$ crontab -l

注：
crontab默认编辑器为nano，不方便使用
Ubuntu设置默认的编辑器
$ sudo select-editor

2、Ubuntu查看crontab运行日志，默认没有开启crontab日志，手工开启
$ sudo vim /etc/rsyslog.d/50-default.conf
cron.*              /var/log/cron.log #将cron前面的注释符去掉
重启rsyslog
$ sudo service rsyslog restart
查看crontab日志
$ sudo less /var/log/cron.log



# vi 文件名           

指令模式

:q!               不保存退出  
:w                保存
:wq或ZZ       写退出     
:w  filename      保存为指定的文件名
:r  filename      读入指定的文件
:e！              还原到原始状态

ESC回到一般模式

数字0             移动到当前行的首字符
$                 移动到当前行的最后字符
:set nu           显示行号       :set nonu     取消行号
nG                移动到第n行
gg                移动到第一行，相当于1G
G                 移动到最后一行
n<Enter>          光标下移n行
?word             向上查找“word”字符
/word             向下查找“word”字符   查找的界面按n键，继续向下查找，按N键，反向查找
:1,$s/word1/word2/g         查找word1字符串，并用word2替换word1
:1,$s/word1/word2/gc     查找word1字符串，并用word2替换word1，替换前要求确认

编辑模式

i          进入编辑模式       
o          在光标下方建立一行                O 在光标上方建立一行
r          取代光标所在的那个字符            R 从光标开始一直取代后面的字符
x          向后删除一个字符       X 向前删除一个字符     nx 向后删除n个字符
dd         删除光标所在行                   ndd 向下删除n行
d1G        删除光标所在行到第一行的所有字符    dG 删除光标所在行到最后一行的所有字符
yy         复制光标行                       nyy 向下复制n行
y1G        复制光标所在行到第一行的所有字符    yG 复制光标所在行到最后一行的所有字符
p          将缓冲区的内容放在光标下一行       P将缓冲区的内容放在光标上一行
J          将光标所在行和下一行合并为一行
u          撤销上次操作
.小数点    重复上次操作


vim 查找多个文件, 替换 (2011-01-19 10:09)
标签:  vim 查找多个文件  替换  分类： vim


1、多文件查找
1.1、grep
       直接在vim中输入:grep abc * 这是直接调用unix下的grep命令
1.2、vimgrep
       基本用法就是
       :vimgrep /匹配模式/[g][j] 要搜索的文件/范围
       :vim[grep][!] /{pattern}/[g][j] {file} ...
       g 和 j 是两个可选的标志位，g表示是否把每一行的多个匹配结果都加入。j表示是否搜索完后定位到第一个匹配位置。
       要搜索的文件 可以是具体的文件路径，也可以是带通配符的路径比如 *.as **/*.as ，**表示递归所有子目录。 要搜索的文件和或搜索范围都可 以写多个，用空格分开。
例子：
:vimgrep /\<flash\>/ **/*.as 搜索当前目录以及所有子目录内as文件中的 "flash"
:vimgrep /an error/ *.c 就是在所有的.c文件中搜索an error。
:vimgrep/an error/* 意思是查找当前目录下的文件中的an error，不包括子目录

vimgrep会产生一个error list，其实就是搜索结果列表。并会打开第一个符合的文件中第一个符合的位置。

使用命令：

cnext可以看下一个符合的位置。

clist可以浏览符合的位置列表。

cc [nr]可以查看第nr个位置。

cp可以查看上一个符合的位置。

可以使用vim的help查看相关的命令格式：

help vimgrep，help cnext ,help clist, help cc，help cp

1.3、定位
       输入上述的命令后，可以像输入:make命令，那样定位匹配到的文件位置
       :cnext (:cn)           下一个匹配位置
       :cprevious (:cp)     上一个匹配位置
       :cwindow (:cw)     quickfix窗口，可以选择匹配的文件位置
       :cl(:clist)                查看所有匹配的位置

2、多文件替换(arg)
a、加入要处理的文件  :args *.txt
b、输入对上述文件的动作  :argdo %s/hate/love/gc | update  （这里将hate替换成love，update表示要写入到文件中，否则只作替换而不写入）



##################################################################################

使用vim删除多余的空行：
:g/^$/d

这条命令可以删除空白符，Tab，或者两者交错的空行。

如果想删除空行更狠一点，用：
:g/^\s*$/d

常用的方法来删除文件中的注释行
方法一：
采用grep命令的-v选项，输出除之外的所有行，容后重定向输出到配置文件。
$ cp xxx.conf xxx.conf.bak
#删除注释行到配置文件中
$ grep -v '^#' xxx.conf > conf.con
#删除文件中的空行
$ grep -v '^$' xxx.conf

#删除注释行和空行
$ grep -v '^#' xxx.conf | grep -v '^$' > xxx.conf

$ grep -v '^#' squid.conf-bak | grep -v '^$' > squid.conf

方法二：
使用sed命令:

$ sed '/^#/d' <file>
$ sed '/#/d'  <file>

# 删除空行
$ sed '/^$/d' <file>
# 删除空行并写入到文件
$ sed -i '/^$/d' <file>

删除空行和注释行
$ sed -i -e '/^$/d' -e '/#.*/d' xxx.conf


##################################################################################



##################################################################################




常见的侦听问题参考
笔记《ORA-12541:TNS:no listener 客户端tnsnames.ora配置，以及服务端listener.ora配置》



Oracle用户命令
http://IP:1158/em            端口配置文件：portlist.ini
http://IP:5560/isqlplus  http://IP:5560/isqlplus/dba

$ imp ccense/ccense@t5 file=/home/opc/t5\(5.0.0600\).dmp log=*.log full=y

导出exp，不要加full参数
exp ccense/ccense@t5 file=/home/opc/t5\(5.0.0600\).dmp 
log=*.log
 
 ps -ef | grep ora
$ netca
$ dbca
$ lsnrctl status                start或stop
$ emctl status dbconsole        start或stop

$ sqlplus /nolog
SQL>conn as sysdba或conn，输入用户名和密码即可
Oracle中默认的用户名和密码如下表格：
用户名 / 密码                           登录身份                                  说明   
sys/change_on_install    SYSDBA 或 SYSOPER    不能以 NORMAL 登录，可作为默认的系统管理员   
system/manager            SYSDBA 或 NORMAL    不能以 SYSOPER 登录，可作为默认的系统管理员   
scott/tiger  

SQL> select username from dba_users;  查看用户列表
SQL> alter user 用户名 identified by 新密码;

$ sqlplus “/as sysdba” 或sqlplus / as sysdba
SQL>shutdown immediate
SQL>startup
SQL>startup mount;
SQL>alter database open;

SQL>conn ccense/ccense
SQL>help set
SQL>show user;
SQL> show release;              显示数据库的版本
SQL> show all;                  显示当前环境变量的值
SQL> show SGA;                  显示SGA的大小
SQL> show error;                显示当前在创建函数、存储过程、触发器、包等对象的错误信息
SQL>show parameter 参数名
SQL> select * from tab;         列出所有表
SQL> desc 表名;                 列出表结构
SQL> select name from v$datafile;             查看表空间文件
SQL> select name from v$tempfile;             查看临时表空间文件
SQL> select member from v$logfile;        查看日志文件
SQL> select name from v$controlfile;          查看控制文件
SQL>select name from v$database;              查看实例名
select * from v$version;

select a.sql_text from v$sqlarea a order by a.first_load_time desc;
select * from v$sqltext

SQL>select username,sid,serial# from v$session;
SQL>select * from table_name where trunc(日期字段)＝to_date('2003-05-02','yyyy-mm-dd');
SQL>select * into 表2 from 表1 where …     查询并新建
SQL>insert into 表2 (select * from 表1@链接 where...)
SQL>truncate table 表



　　1、连接 　　SQL*Plus system/manager
　　2、显示当前连接用户 　　SQL> show user
　　3、查看系统拥有哪些用户 　　SQL> select * from all_users;
　　4、新建用户并授权
　　SQL> create user a identified by a;（默认建在SYSTEM表空间下）
　　SQL> grant connect,resource to a;
　　5、连接到新用户 　　SQL> conn a/a
　　6、查询当前用户下所有对象 　　SQL> select * from tab;
　　7、建立第一个表 　　SQL> create table a(a number);
　　8、查询表结构 　　SQL> desc a
　　9、插入新记录 　　SQL> insert into a values(1);
　　10、查询记录 　　SQL> select * from a;
　　11、更改记录 　　SQL> update a set a=2;
　　12、删除记录 　　SQL> delete from a;
　　13、回滚 　　SQL> roll; 　　SQL> rollback;
　　14、提交 　　SQL> commit;
　　
　　PL/SQL数据类型
　　名称              类型   说明
　　NUMBER            数字型 能存放整数值和实数值，并且可以定义精度和取值范围
　　BINARY_INTEGER    数字型 可存储带符号整数，为整数计算优化性能
　　DEC               数字型 NUMBER的子类型，小数
　　DOUBLE PRECISION 数字型 NUMBER的子类型，高精度实数
　　INTEGER           数字型 NUMBER的子类型，整数
　　INT               数字型 NUMBER的子类型，整数
　　NUMERIC           数字型 NUMBER的子类型，与NUMBER等价
　　REAL              数字型 NUMBER的子类型，与NUMBER等价
　　SMALLINT          数字型 NUMBER的子类型，取值范围比INTEGER小
　　VARCHAR2          字符型 存放可变长字符串，有最大长度
　　CHAR              字符型 定长字符串
　　LONG              字符型 变长字符串，最大长度可达32,767
　　DATE              日期型 以数据库相同的格式存放日期值
　　BOOLEAN           布尔型 TRUE OR FALSE
　　ROWID             ROWID 存放数据库的行号


====在Ubuntu下使用sqldeveloper导入数据库备份======================================

建立/home/opc/oradata/t5/相关目录，并给定oracle用户操作权限
#mkdir -p /home/opc/oradata/t5/ 建立多级目录
[opc@T5DB ~]$ chmod -R 777 /home/ 把home目录下的所有目录和文件给777权限

=====================================================================
sqldeveloper用sys作为sysdba登陆，建立表空间和ccense用户
--基本表空间
CREATE SMALLFILE TABLESPACE "CCEN"
DATAFILE '/home/opc/oradata/t5/CCEN.dbf' SIZE 1000M
 AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED LOGGING EXTENT MANAGEMENT
  LOCAL SEGMENT SPACE MANAGEMENT AUTO
/
--临时表空间
 CREATE SMALLFILE TEMPORARY TABLESPACE "CCEN_TMP"
 TEMPFILE '/home/opc/oradata/t5/ccen_tmp.dbf' SIZE 100M AUTOEXTEND
 ON NEXT 100M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
/
--分区表空间
CREATE SMALLFILE TABLESPACE "DETAIL01"
DATAFILE '/home/opc/oradata/t5/DETAIL01.dbf' SIZE 200M
 AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED LOGGING EXTENT MANAGEMENT
  LOCAL SEGMENT SPACE MANAGEMENT AUTO
/
  --分区表空间
  CREATE SMALLFILE TABLESPACE "DETAIL02"
DATAFILE '/home/opc/oradata/t5/DETAIL02.dbf' SIZE 100M
 AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED LOGGING EXTENT MANAGEMENT
  LOCAL SEGMENT SPACE MANAGEMENT AUTO
/
  --分区表空间
  CREATE SMALLFILE TABLESPACE "DETAIL03"
DATAFILE '/home/opc/oradata/t5/DETAIL03.dbf' SIZE 100M
 AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED LOGGING EXTENT MANAGEMENT
  LOCAL SEGMENT SPACE MANAGEMENT AUTO
/
  --分区表空间
  CREATE SMALLFILE TABLESPACE "DETAIL04"
DATAFILE '/home/opc/oradata/t5/DETAIL04.dbf' SIZE 100M
 AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED LOGGING EXTENT MANAGEMENT
  LOCAL SEGMENT SPACE MANAGEMENT AUTO
/
   CREATE USER "CCENSE"        PROFILE "DEFAULT" IDENTIFIED BY "ccense" DEFAULT
   TABLESPACE "CCEN" TEMPORARY TABLESPACE "CCEN_TMP"
/
GRANT CONNECT,RESOURCE,CREATE ANY VIEW TO CCENSE
/
grant EXECUTE   ON DBMS_JOB to CCENSE
/
grant debug connect session to CCENSE
/
GRANT dba TO ccense
/

导入备份文件
[oracle@T5DB ~]$ imp ccense/ccense@t5 file=/home/opc/t5.dmp full=y

sqldeveloper用ccense登陆，完成数据库恢复


=====================================================================

Ubuntu Linux更改PATH路径

[日期：2015-05-04]    来源：Linux社区  作者：bishopmoveon    [字体：大 中 小]
1、什么是环境变量(PATH)

在Linux中，在执行命令时，系统会按照PATH的设置，去每个PATH定义的路径下搜索执行文件，先搜索到的文件先执行。

我们知道查阅文件属性的指令ls 完整文件名为：/bin/ls(这是绝对路径)， 那你会不会觉得很奇怪："为什么我可以在任何地方执行/bin/ls这个指令呢？ " 为什么我在任何目录下输入 ls 就一定可以显示出一些讯息而不会说找不到该 /bin/ls 指令呢？ 这是因为环境变量 PATH 的帮助所致呀！


当我们在执行一个指令癿时候，举例来说"ls"好了，系统会依照PATH的设定去每个PATH定义的目录下搜寻文件名为ls 的可执行文件， 如果在PATH定义的目录中含有多个文件名为ls 的可执行文件，那么先搜寻到癿同名指令先被执行！

2、如何改变PATH

a.直接修改$PATH值：

echo $PATH //查看当前PATH的配置路径

export PATH=$PATH:/xxx/xxx //将需配置路径加入$PATH  等号两边一定不能有空格

//配置完后可以通过第一句命令查看配置结果。

生效方法：立即生效

有效期限：临时改变，只能在当前的终端窗口中有效，当前窗口关闭后就会恢复原有的path配置

用户局限：仅对当前用户

b.通过修改.bashrc文件：(.bashrc文件在根目录下)

vi .bashrc  //编辑.bashrc文件

//在最后一行添上：

export PATH=$PATH:/xxx/xxx  ///xxx/xxx位需要加入的环境变量地址 等号两边没空格

生效方法：（有以下两种）

..关闭当前终端窗口，重新打开一个新终端窗口就能生效

..输入“source .bashrc”命令，立即生效

有效期限：永久有效

用户局限：仅对当前用户



c.通过修改profile文件：（profile文件在/etc目录下）

vi /etc/profile //编辑profile文件

//在最后一行添上：

export PATH=$PATH:/xxx/xxx

生效方法：系统重启

有效期限：永久有效

用户局限：对所有用户

d.通过修改environment文件：（environment文件在/etc目录下）

vi /etc/profile //编辑profile文件

在PATH=/·········中加入“:/xxx/xxx”

生效方法：系统重启

有效期限：永久有效

用户局限：对所有用户


########################################################

Linux 中环境变量设置
　　本文主要整理自以下博文：

　　.bash_profile和.bashrc的什么区别及启动过程

　　linux环境变量设置方法总结（PATH／LD_LIBRARY_PATH）

.bash_profile 和 .bashrc 区别
相关文件介绍
　　/etc/profile: 此文件为系统的每个用户设置环境信息，当用户第一次登录时，该文件被执行。并从 /etc/profile.d 目录的配置文件中搜集shell的设置。

　　/etc/bashrc: 为每一个运行 bash shell 的用户执行此文件。当 bash shell 被打开时，该文件被读取。

　　~/.bash_profile: 每个用户都可使用该文件输入专用于自己使用的 shell 信息，当用户登录时，该文件仅仅执行一次！默认情况下，其他设置的一些环境变量，执行用户的 .bashrc 文件。

　　~/.bashrc: 该文件包含专用于登陆用户的 bash shell 的 bash 信息，当登录时以及每次打开新的 shell 时，该该文件被读取。

　　~/.bash_logout: 当每次退出 bash shell 时，执行该文件。

　　另外，/etc/profile中设定的变量（全局）的可以作用于任何用户，而~/.bashrc等中设定的变量（局部）只能继承/etc/profile中的变量，他们是"父子"关系。


　　~/.bash_profile 是交互式、login 方式进入 bash 运行的。

　　~/.bashrc 是交互式 non-login 方式进入 bash 运行的。

　　通常二者设置大致相同，前者会调用后者。

启动过程
　　在登录Linux时要执行文件的过程如下：

　　在刚登录 Linux 时，首先启动 /etc/profile 文件，然后再启动用户目录下的 ~/.bash_profile、 ~/.bash_login 或 ~/.profile 文件中的其中一个（根据不同的 Linux 操作系统的不同，命名不一样），

　　执行的顺序为：~/.bash_profile、 ~/.bash_login、 ~/.profile。

　　如果 ~/.bash_profile 文件存在的话，一般还会执行 ~/.bashrc文件。

　　因为在 ~/.bash_profile 文件中一般会有下面的代码：

# Get the aliases and functions
if [ -f ~/.bashrc ] ; then
    . ./bashrc
fi
　　~/.bashrc 中，一般还会有以下代码：

# Source global definitions
if [ -f /etc/bashrc ] ; then
    . /bashrc
fi
　　所以，~/.bashrc 会调用 /etc/bashrc 文件。最后，在退出 shell 时，还会执行 ~/.bash_logout 文件。

　　执行顺序为：/etc/profile -> (~/.bash_profile | ~/.bash_login | ~/.profile) -> ~/.bashrc -> /etc/bashrc -> ~/.bash_logout

环境变量设置
PATH:  可执行程序的查找路径
　　查看当前环境变量:

　　echo $PATH

　　设置:

　　方法一：export PATH=PATH:/XXX 但是登出后就失效

　　方法二：修改~/.bashrc或~/.bash_profile或系统级别的/etc/profile

　　1. 在其中添加例如export PATH=/opt/ActivePython-2.7/bin:$PATH

　　2. source .bashrc （Source命令也称为“点命令”，也就是一个点符号（.）。source命令通常用于重新执行刚修改的初始化文件，使之立即生效，而不必注销并重新登录）

LD_LIBRARY_PATH: 动态库的查找路径
　　设置：

　　方法一： export  LD_LIBRARY_PATH=LD_LIBRARY_PATH:/XXX 但是登出后就失效

　　方法二： 修改 ~/.bashrc 或 ~/.bash_profile 或系统级别的 /etc/profile

　　1. 在其中添加例如 export PATH=/opt/ActiveP/lib:$LD_LIBRARY_PATH     

　　2. source .bashrc

　　方法三：这个没有修改 LD_LIBRARY_PATH 但是效果是一样的实现动态库的查找，

　　1. /etc/ld.so.conf 下面加一行/usr/local/mysql/lib

　　2. 保存过后 ldconfig 一下（ldconfig 命令的用途,主要是在默认搜寻目录（/lib 和 /usr/lib）以及动态库配置文件 /etc/ld.so.conf 内所列的目录下，搜索出可共享的动态链接库（格式如前介绍，lib*.so*），进而创建出动态装入程序（ld.so）所需的连接和缓存文件.缓存文件默认为 /etc/ld.so.cache，此文件保存已排好序的动态链接库名字列表。）

　　方法三设置稍微麻烦，好处是比较不受用户的限制。

删除环境变量
unset PATH
unset LD_LIBRARY_PATH



=====================================================================
CentOS下的sosreport命令，可以生成整个linux系统的配置信息 

---------------------------------------------------------------------------------------------
工具使用
SecureCRT                          命令行工具
VNC V4.0 汉化版                     图形界面工具
SSHSecureShellClient-3.2.9          ftp工具
Xmanager_Enterprise_4


---------------------------------------------------------------------------------------------
SecureCRT 设置vi颜色高亮

1、设置SecureCRT vim 编辑高亮
  Options-->Global options--->Default Session
  
  Edit Default Settings
  Enulation（仿真） 下，设置Terminal：为Xterm ，勾选 AnSI Color，勾选 Use color scheme（使用颜色方案）
  
2、设置编码格式utf
      Options-->Global options--->Default Session
  
   Edit Default Settings 
   Appearance（外观） ： 可以选择 Current color scheme（当前颜色方案）：本人用 Traditional（传统）
   设置字体大小，在font可以修改
   在character encoding 选择utf-8

3、
终端-仿真-模式，初始模式选择“换行” ，如果命令较长，就会换行显示

---------------------------------------------------------------------------------------------
VNC使用：
redhat自带VNC Server，先打开服务
应用程序-》首选项-》远程桌面，勾选“允许其他人查看你的桌面”，设置访问密码
注意：只有主机在登录状态，VNC才能连接上

如果使用虚拟机，可以打开虚拟机的Remote Display
然后使用VNC Viewer访问虚拟机所在的主机IP即可（有时会出现鼠标控制不灵的情况，redhat出现过）
---------------------------------------------------------------------------------------------

如何通过Xmanager实现远程Linux图形化终端连接
由 mcsrainbow 发表在 Linux&Unix 分类，时间 2011/03/21

首先，个人认为网络上那些大篇幅的命令行配置都是误人子弟的，要实现该功能其实非常简单，下面是我总结出的方法，供各位参考。

服务端配置：

SUSE："yast2"-"network services"-"remote administration"选择"allow remote administration",然后执行rcxdm restart命令重启xdm服务后，通过X-manager登陆SUSE图形化终端。

RHEL4：在“系统设置”->“登录屏幕”启用xdmcp，关掉防火墙，然后通过X-manager登陆RedHat图形化终端。

RHEL5：在“系统设置”->“登录屏幕”-->“远程”-->“same as local”，关掉防火墙，然后通过X-manager登陆RedHat图形化终端。

Xmanager配置：

点击按钮“New” -> "XDMCP" -> 输入服务器IP -> 一直默认"Next"直到"Finish"。

Xmanager_Enterprise_4使用：
----第一种 Xmanager3.0？ 配置redhat5？----------------------------------
用xmanager远程连接linux图形端的配置。首先确保ssh可以正确登陆到redhat，以便修改文件。  以下是注意事项：
首先理解x-windows的基本工作原理。
在/etc/X11/xdm/Xaccess中启用 * #any host can get a login window
修改/etc/X11/gdm/gdm.conf中，修改port为177，并enable = true 或 enable =1
修改/etc/inittab: x:5:respawn:/usr/bin/gdm
修改/etc/X11/xdm/xdm-conifg最后一行 改为!DisplayManager.requestPort: 0
打开iptables的177端口
修改/etc/hosts 。将登陆机器的ip和机器名记录进去
最后执行/etc/init.d/xfs restart  & xdm
kdm -- /usr/share/config/kdmconfig 中修改
----第二种 Xmanager4.0 配置CentOS6.2----------------------------------
编辑配置文件 vi /etc/gdm/custom.conf 修改为如下所示
[security]
AllowRemoteRoot=true # 允许root登陆
[xdmcp]
Enable=true  #开启xdcmp 服务
Port=177  #指定服务端口
另外需要调整开机启动级别  
vi /etc/inittab 将默认启动级别改为5 ，即默认从图像化界面启动
然后重启服务器  
init 6
重启后登陆验证服务是否开启
lsof -i :177

虚拟机里的linux不能访问外网的解决方式

# vi /etc/resolv.conf
nameserver 192.168.30.1
nameserver 192.168.0.186
在VM里安装kali linux，发现浏览器能访问内网，但是外网无法访问，无法apt-get update，但能ping通8.8.8.8，
经过查找，发现在resolv.conf中添加192.168.0.186即可，可以添加多个
　　
千辛万苦进了一个很深层的目录，一不小心敲了“cd”后回车..
使用 cd - 回到上一个目录


如何结束命令的执行？

Ctrl-C，如果还是没反应，先按Ctrl-Z将任务转入后台，然后kill -TERM %n杀死这个后台任务，其中n是后台任务的编号（就是按下Ctrl-Z后出现的提示行中[]中的数字），在绝大多数情况下可以杀死。另一个办法是在开一个窗口（在命令行方式时切换到另一个控制台），用ps ax找到这个进程的PID，然后kill -TERM PID号就可以了，有些情况下程序可能挂起，用 kill -9 PID 试试看。


启动SSH
#/etc/init.d/ssh start
CentOS

################################################################

centos7 修改yum源为阿里源
2017年02月05日 15:23:19
阅读数：17151
centos7 修改yum源为阿里源,某下网络下速度比较快 首先是到yum源设置文件夹里
1.安装base reop源
   cd /etc/yum.repos.d

接着备份旧的配置文件
   sudo mv CentOS-Base.repo CentOS-Base.repo.bak

下载阿里源的文件
   sudo wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

2 安装epel repo源：
epel(RHEL 7)
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

epel(RHEL 6)
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

epel(RHEL 5)
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo

3.清理缓存
yum clean all

4.重新生成缓存
yum makecache




################################################################


1.     下载文件统一放到/root目录下
2.     添加yum代理
#vi /etc/yum.conf，
在最后添加proxy=http://192.168.102.71:8080


3.     添加wget代理
#vi /etc/wgetrc
http-proxy = 192.168.102.71:8080
ftp-proxy = 192.168.102.71:8080

网络yum163源更新
1. 下载repo文件
    下载地址：http://mirrors.163.com/.help/CentOS6-Base-163.repo

2. 备份并替换系统的repo文件
[root@localhost ~]# cd /etc/yum.repos.d/
[root@localhost ~]# mv CentOS-Base.repo CentOS-Base.repo.bak
[root@localhost ~]# mv /root/CentOS6-Base-163.repo CentOS-Base.repo

3. 执行yum源更新
[root@localhost ~]# yum clean all
[root@localhost ~]# yum makecache
[root@localhost ~]# yum update

4. 到此已结束，用yum安装一下文件，看是否OK
[root@localhost ~]# yum install vim*


+++++++++++++++++++++++++++++++++++++++++++
CentOS SSH安装与配置
时间:2013-09-26 00:43来源:Junn博客 作者:本站 举报 点击:31795次

SSH 为 Secure Shell 的缩写，由 IETF 的网络工作小组（Network Working Group）所制定；SSH 为建立在应用层和传输层基础上的安全协议。

传统的网络服务程序，如FTP、POP和Telnet其本质上都是不安全的；因为它们在网络上用明文传送数据、用户帐号和用户口令，很容易受到中间人（man-in-the-middle）攻击方式的攻击。就是存在另一个人或者一台机器冒充真正的服务器接收用户传给服务器的数据，然后再冒充用户把数据传给真正的服务器。

而 SSH 是目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。利用 SSH 协议可以有效防止远程管理过程中的信息泄露问题。透过 SSH 可以对所有传输的数据进行加密，也能够防止 DNS 欺骗和 IP 欺骗。

安装SSH： yum install ssh
启动SSH： service sshd start
设置开机运行： chkconfig sshd on

一般默认CentOS已经安装了OpenSSH，即使你是最小化安装也是如此。

SSH配置：

1、修改vi /etc/ssh/sshd_config，根据模板将要修改的参数注释去掉并修改参数值：

Port 22 指定SSH连接的端口号，安全方面不建议使用默认22端口

Protocol 2,1 允许SSH1和SSH2连接，建议设置成 Protocal 2

其他参数根据自己的需要进行调整。配置方法详见： man ssh_config

2、修改hosts.deny 在最后面添加一行：

sshd:All

3、修改hosts.allow 在最后面添加一行：

sshd:All

如果为了安装可以限制访问的IP，设置如下：

sshd:192.168.0.101

sshd:192.168.0.102

上述配置表示只允许101和102的服务器进行SSH连接

4、启动SSH

/etc/init.d/sshd start

至此SSH已经可以连接了


+++++++++++++++++++++++++++++++++++++++++++

Ubuntu命令

Ctrl+C 停止正在执行的命令，用大写的，按Shift+Ctrl+C

----------------------------------------------------------

Ubuntu的
默认root密码是随机的，即每次开机都有一个新的root密码。我们可以在终端输入命令 sudo passwd，然后输入当前用户的密码，
enter，终端会提示我们输入新的密码并确认，此时的密码就是root新密码。修改成功后，输入命令 su root，再输入新的密码就ok了。
没有默认的，因为你还没给root设置密码，，你第一个 user 是在 admin 组 ，所以他可以给 root 设置密码 , so
sudo passwd root
[sudo] password for you ：---> 输入你的密码，不回显
Enter new UNIX password: --- > 设置root 密码
Retype new UNIX password: --> 重复
=========================================================================
用安装时建立的用户登陆后在Shell执行
sudo passwd root回车Password:后输入刚建立的用户密码回车
Enter new UNIX password:
这时输入要设置的root密码两次就会看到
password updated successfully了！
=========================================================================
安装后可以到用户和组里面去改，随便改的。要在登录时用root的话，可以在“登录界面”里改，让管理员登录系统的选项就可以了

----------------------------------------------------------

sudo apt-get install openssh-server
ubuntu安装ssh服务
ubuntu默认并没有安装ssh服务，如果通过ssh链接ubuntu，需要自己手动安装ssh-server。判断是否安装ssh服务，可以通过如下命令进行：
1. xjj@xjj-desktop:~$ ssh localhost  
2. ssh: connect to host localhost port 22: Connection refused   
如上所示，表示没有还没有安装，可以通过apt安装，命令如下：
1. xjj@xjj-desktop:~$ sudo apt-get install openssh-server  
系统将自动进行安装，安装完成以后，先启动服务：
1. xjj@xjj-desktop:~$ sudo /etc/init.d/ssh start  
 启动后，可以通过如下命令查看服务是否正确启动
1. xjj@xjj-desktop:~$ ps -e|grep ssh  
2.  6212 ?        00:00:00 sshd  
 如上表示启动ok。注意，ssh默认的端口是22，可以更改端口，更改后先stop，
然后start就可以了。改配置在/etc/ssh/sshd_config下，如下所示。
Java代码
1. xjj@xjj-desktop:~$ vi /etc/ssh/sshd_config  
2. # Package generated configuration file  
3. # See the sshd(8) manpage for details  
4. # What ports, IPs and protocols we listen for  
5. Port 22  
 最后，应该是连接的时候了。请看如下命令：
Java代码
xjj@xjj-desktop:~$ ssh exceljava@192.168.158.129

----------------------------------------------------------
Ubuntu更新命令

　　apt-cache search package 搜索包
　　apt-cache show package 获取包的相关信息，如说明、大小、版本等
　　sudo apt-get install package 安装包
　　sudo apt-get install package - - reinstall 重新安装包
　　sudo apt-get -f install 修复安装"-f = ——fix-missing"
　　sudo apt-get remove package 删除包
　　sudo apt-get remove package - - purge 删除包，包括删除配置文件等
　　sudo apt-get update 更新源
　　sudo apt-get upgrade 更新已安装的包
　　sudo apt-get dist-upgrade 升级系统
　　sudo apt-get dselect-upgrade 使用 dselect 升级
　　apt-cache depends package 了解使用依赖
　　apt-cache rdepends package 是查看该包被哪些包依赖
　　sudo apt-get build-dep package 安装相关的编译环境
　　apt-get source package 下载该包的源代码
　　sudo apt-get clean && sudo apt-get autoclean 清理无用的包
　　sudo apt-get check 检查是否有损坏的依赖
----------------------------------------------------------
软件包维护

* apt-get update - 在你更改了/etc/apt/sources.list 或 /etc/apt/preferences 后，需要运行这个命令以令改动生效。同时也要定期运行该命令，以确保你的源列表是最新的。该命令等价于新立得软件包管理器中的“刷新”，或者是 Windows和OS X 下的 Adept 软件包管理器的 “check for updates”。
* apt-get upgrade - 更新所有已安装的软件包。类似一条命令完成了新立得软件包管理器中的“标记所有软件包以便升级”并且“应用”。
* apt-get dist-upgrade - 更新整个系统到最新的发行版。等价于在新立得软件包管理器中“标记所有更新”，并在首选项里选择“智能升级” -- 这是告诉APT更新到最新包，甚至会删除其他包（注：不建议使用这种方式更新到新的发行版）。
* apt-get -f install -- 等同于新立得软件包管理器中的“编辑->修正（依赖关系）损毁的软件包”再点击“应用。如果提示“unmet dependencies”的时候，可执行这行命令。修复安装”-f = ——fix-missing”
* apt-get autoclean - 如果你的硬盘空间不大的话，可以定期运行这个程序，将已经删除了的软件包的.deb安装文件从硬盘中删除掉。如果你仍然需要硬盘空间的话，可以试试apt-get clean，这会把你已安装的软件包的安装包也删除掉，当然多数情况下这些包没什么用了，因此这是个为硬盘腾地方的好办法。
* apt-get clean 类似上面的命令，但它删除包缓存中的所有包。这是个很好的做法，因为多数情况下这些包没有用了。但如果你是拨号上网的话，就得重新考虑了。
* 包缓存的路径为/var/cache/apt/archives，因此，du -sh /var/cache/apt/archives将告诉你包缓存所占用的硬盘空间。
* dpkg-reconfigure foo - 重新配置“foo”包。这条命令很有用。当一次配置很多包的时候， 要回答很多问题，但有的问题事先并不知道。例如，dpkg-reconfigure fontconfig-config，在Ubuntu系统中显示字体配置向导。每次我安装完一个 Ubuntu 系统，我都会运行这行命令，因为我希望位图字体在我的所有应用程序上都有效。
* echo "foo hold" | dpkg --set-selections - 设置包“foo”为hold，不更新这个包，保持当前的版本，当前的状态，当前的一切。类似新立得软件包管理器中的“软件包->锁定版本”。
* 注： apt-get dist-upgrade 会覆盖上面的设置，但会事先提示。 另外，你必须使用 sudo。输入命令echo "foo hold" | sudo dpkg --set-selections而不是sudo echo "foo hold" | dpkg --set-selections
* echo "foo install -- 删除“hold”“locked package”状态设置。命令行为echo "foo install" | sudo dpkg --set-selections

----------------------------------------------------------



----------------------------------------------------------

lspci 查看所有硬件信息
lspci | grep net 查看网卡硬件信息

----------------------------------------------------------

apt-get命令下载安装包的路径
/var/cache/apt/archives

sudo apt-get clean  删除包缓存中的所有包

一、准备工作

1、安装时只额外选择openssh和虚拟化，安装完后，ssh就可以用了，桌面版需要自己安装openssh-server

2、配置网络

sed -i -e "/BOOTPROTO/c BOOTPROTO=static\nIPADDR=192.168.102.79\nNETMASK=255.255.255.0\nGATEWAY=192.168.102.254\nPEERDNS=no\nDNS1=192.168.0.186" /etc/sysconfig/network-scripts/ifcfg-eth0

$ sudo vi /etc/network/interfaces
# The primary network interface
auto eth0
iface eth0 inet dhcp
改为固定IP
# The primary network interface
auto eth0
iface eth0 inet static
    address 192.168.102.204
    netmask 255.255.255.0
    gateway 192.168.102.254

重启网络：
$ sudo /etc/init.d/networking restart
也可以重启网卡：
$ sudo ifconfig eth0 down
$ sudo ifconfig eth0 up

3、设置代理
$sudo vi /etc/apt/apt.conf
Acquire::http::Proxy "http://192.168.102.71:8080/";

$ sudo vi /etc/wgetrc
http_proxy =  http://192.168.102.71:8080/

查看安装的软件包
$ dpkg -l | grep iscsi

列出服务列表
$ chkconfig
$ service --status-all

安装、删除
$ sudo apt-get install 包名
$ sudo apt-get remove 包名

列出有那些’安装任务‘，选择DNS等软件包
# tasksel --list-tasks
# tasksel


###########################################################

CentOS配置网卡IP

sed -i -e "/BOOTPROTO/c BOOTPROTO=static\nIPADDR=192.168.102.79\nNETMASK=255.255.255.0\nGATEWAY=192.168.102.254\nPEERDNS=no\nDNS1=192.168.0.186" /etc/sysconfig/network-scripts/ifcfg-eth0

echo 'nameserver 192.168.0.186' >> /etc/resolv.conf

# vim /etc/sysconfig/network-scripts/ifcfg-eno1
# service network restart命令 #重启网络服务

重启后发现170和196都存在，后来才明白，network-scripts目录下有ifcfg-eno1，ifcfg-eno1-20180917和ifcfg-eno1.old，
CentOS加载网卡只看ifcfg-，后面的都会作为网卡信息，所以eno1.old也会被认为是一个网卡，如果文件里出现两个IP，eno1网卡下就会都存在，只保留ifcfg-eno1即可


###########################################################








linux分区

# fdisk -l
# mkfs.ext3 /dev/hdb1
# mkdir /mnt/hdb1
# mount /dev/hdb1 /mnt/hdb1
# df -h
# umount /mnt/hdb1

在/etc/fstab中添加新硬盘的挂载信息.添加下面一行:
/dev/hdb1       /mnt/hdb1               ext3 defaults         1       2

/etc/fstab的设定方法
 /etc/fstab的格式如下：
 fs_spec　　　fs_file　　fs_type　　　fs_options　　fs_dump　fs_pass　
 fs_spec:该字段定义希望加载的文件系统所在的设备或远程文件系统,对于nfs这个参数一般设置为这样：192.168.0.1:/NFS
 fs_file:本地的挂载点
 fs_type：对于NFS来说这个字段只要设置成nfs就可以了
 fs_options:挂载的参数，可以使用的参数可以参考上面的mount参数。
 fs_dump　-　该选项被"dump"命令使用来检查一个文件系统应该以多快频率进行转储，若不需要转储就设置该字段为0
fs_pass　-　该字段被fsck命令用来决定在启动时需要被扫描的文件系统的顺序，根文件系统"/"对应该字段的值应该为1，其他文件系统应该为2。若该文件系统无需在启动时扫描则设置该字段为0 。

 关于Linux开机之后自动加载挂载的分区，这块，涉及到的文件是/etc/fstab文件
关于这个文件的描述说明如下:
要求：
1）根目录/必须载入，而且要先于其他载入点被载入
2）其他载入点必须为已建立的目录
3）若进行卸载，必须先将工作目录移到载入点及其子目录之外

/etc/fstab里面每列大概意思为：

第一列为设备号或该设备的卷标，即需要挂载的文件系统或存储设备；
第二列为挂载点
第三列为文件系统或分区的类型
第四列为文件系统参数，即挂载选项，详细参考man mount.命令，defaults就没有问题，除非你有特殊需求；
第五列为dump选项，设置是否让备份程序dump备份文件系统。0：不备份，1：备份，2：备份(但比1重要性小)。设置了该参数后，linux中使用dump命令备份系统的时候就可以备份相应设置的挂载点了。
第六列为是否在系统启动的时候，用fsck检验分区,告诉fsck程序以什么顺序检查文件系统。因为有些挂载点是不需要检验的，比如：虚拟内存swap、/proc等。0：不检验，1：要检验，2要检验(但比1晚检验)，一般根目录设置为1，其他设置为2就可以了。


lvm命令

创建lv
$ sudo lvcreate -L 30G -n lvnfs1 CUD10M
$ sudo lvcreate -L 101G -n lvnfs2 CUD10M

格式化lv
$ sudo mkfs.ext4 /dev/CUD10M/lvnfs1

紧接着挂载 LVM。
[root@vm ~]# mount /dev/vg01/lv01 /mnt/


--------------------------------------------------
《+LVM实验完全手册PDF文件下载》

A、   创建 LVM

1、    创建磁盘分区，转换文件系统类型为 LVM（8e）
[root@vm ~]# fdisk /dev/sdb
 
2、    创建物理卷  PV
[root@vm /]# pvcreate /dev/sdb[1-4]
Physical volume "/dev/sdb1" successfully created
Physical volume "/dev/sdb2" successfully created
Physical volume "/dev/sdb3" successfully created
Physical volume "/dev/sdb4" successfully created
[root@vm /]#
[root@vm /]# pvdisplay 

3、    创建卷组  VG[root@vm /]# vgcreate vg01 /dev/sdb{1,2,3,4}
[root@vm /]# vgcreate vg01 /dev/sdb{1,2,3,4}

4、    创建逻辑卷  LV
[root@vm ~]# lvcreate -L 2000M -n lv01 vg01 //创建名称为 lv01 的 LVM，注意最后必须跟前一步创建的卷组的名称，即 vg01

5、    格式化
[root@vm ~]# mkfs.ext3 /dev/vg01/lv01 //格式化为 EXT3 文件系统

6、    挂载
[root@vm ~]# mount /dev/vg01/lv01 /mnt/
[root@vm ~]# cd /mnt/
[root@vm mnt]# ll
total 16
drwx------ 2 root root 16384 Jul 31 22:45 lost+found
[root@vm mnt]#      //至此，LVM 创建完毕。


B、   为 LM 创建快照
LVM 提供了对任意一个 Logical  Volume(LV)做“快照”(snapshot)
的功能，以此来获得一个分区的状态一致性备份。


C、   添加、删除和调整 LVM 大小
增加 LVM 大小，2 种方法可以增加 LVM 大小，如果 VG 里面有剩余没有分配给 LVM 的空间，可以直接使用 lvresize 或者 lvextend 命令增加，如果没有足够的 VG 空间，可以在线添加新的 PV，然后将新增加的 PV 加入到 VG 里面，即加大了 VG 空间大小，然后再使用 lvresize或者 lvextend 命令即可。
需要注意的是，调整了 LVM 大小后，还需要使用 resize2fs 命令在线调整该 LVM 大小，否则使用 df    –h  命令查看 LVM 的大小没有改变的。

（1）增加 LVM 过程如下：

[root@vm ~]# vgdisplay
[root@vm ~]# lvcreate -L 2000M -n lv01 vg01 //创建一个 2000M 的 lv01：

上图显示 vg 大小为 4.59G，因此 VG 尚有未分配的空间。格式化lv01 并且挂载，拷入部分数据
[root@vm ~]# mkfs.ext3 /dev/vg01/lv01
[root@vm ~]# mount /dev/vg01/lv01 /mnt/
[root@vm ~]# cp /etc/*.conf /mnt  //拷贝一些文件到/mnt目录
[root@vm ~]# df -h  // 查看文件系统空间使用情况：

使用剩余的未分配的 vg 空间增大 LVM 的大小
[root@vm ~]# lvextend -L +2000M /dev/vg01/lv01

紧接着挂载 LVM。
[root@vm ~]# mount /dev/vg01/lv01 /mnt/

可以看到，挂载后磁盘空间并没有变化，此时需要在线调整大小：
[root@vm ~]# resize2fs /dev/vg01/lv01
[root@vm ~]# df -h
再查看 LVM 里面的文件内容：
可以看到文件内同没有变化。
以上是利用剩余的 vg 空间在线增加 LVM 大小，另外一种方法是在没有未分配的 vg 空间的情况下，通过增加 pv 的数量来增加 vg 的大小，从而实现增加 LVM 的大小：


在线添加一个 vg，结果如下：
[root@vm ~]# pvdisplay

将新创建的 pv （sdb8）在线假如到 vg 里面，然后查看 vg 大小：
[root@vm ~]# vgextend vg01 /dev/sdb8

同样，再调整 LVM 的大小：
用上面添加lv 的方法，把新的vg容量添加到lv里面


（2）减小 LVM 大小
虽然 Linux 提供了减小 LVM 的命令，但一般情况下不建议减小，



（3）删除 pv，vg 和 LVM：

删除 LVM：先卸载，然后删除

[root@vm ~]# umount /mnt/
[root@vm ~]# lvremove /dev/vg01/lv01

删除 vg：
[root@vm ~]# vgremove vg01
[root@vm ~]# vgdisplay

删除 pv：
[root@vm ~]# pvremove /dev/sdb5
[root@vm ~]# pvdisplay



如何查看Linux 硬件配置信息

dmidecode |more

dmesg |more

这2个命令出来的信息都非常多,所以建议后面使用"|more"便于查看

2.查看CPU信息

   方法一:
   Linux下CPU相关的参数保存在 /proc/cpuinfo 文件里
   cat /proc/cpuinfo |more
   方法二:
   采用命令 dmesg | grep CPU 可以查看到相关CPU的启动信息
   查看CPU的位数:

   getconf LONG_BIT

3.查看Mem信息

 cat /proc/meminfo |more （注意输出信息的最后一行:MachineMem:   41932272 kB）

 free -m

 top

4.查看磁盘信息

   方法一:
   fdisk -l 可以看到系统上的磁盘(包括U盘)的分区以及大小相关信息。
   方法二:
   直接查看 

   cat /proc/partitions

5.查看网卡信息

   方法一：
   ethtool eth0 采用此命令可以查看到网卡相关的技术指标
   （不一定所有网卡都支持此命令）
   ethtool -i eth1 加上 -i 参数查看网卡驱动
   可以尝试其它参数查看网卡相关技术参数
   方法二：
   也可以通过dmesg | grep eth0 等看到网卡名字(厂家)等信息
   通过查看 /etc/sysconfig/network-scripts/ifcfg-eth0 可以看到当前的网卡配置包括IP、网关地址等信息。
   当然也可以通过ifconfig命令查看。

6.如何查看主板信息？
 lspci

7.如何挂载ISO文件
mount -o loop *.iso mount_point
8.如何查看光盘相关信息
   方法一：
   插入CD光碟后，在本人的RHEL5系统里，光碟文件是 /dev/cdrom，
   因此只需 mount /dev/cdrom mount_point 即可。
   [root@miix tmp]# mount /dev/cdrom mount_point
   mount: block device /dev/cdrom is write-protected, mounting read-only
   其实仔细看一下，光驱的设备文件是 hdc 
   [root@miix tmp]# ls -l /dev/cdrom*
   lrwxrwxrwx 1 root root 3 01-08 08:54 /dev/cdrom -> hdc
   lrwxrwxrwx 1 root root 3 01-08 08:54 /dev/cdrom-hdc -> hdc
   因此我们也可以这样 mount /dev/hdc mount_point
   如果光驱里没放入有效光盘，则报错：
   [root@miix tmp]# mount /dev/hdc mount_point
   mount: 找不到介质
9.如何查看USB设备相关

   方法一：
   其实通过 fdisk -l 命令可以查看到接入的U盘信息，本人的U盘信息如下：
   
   Disk /dev/sda: 2012 MB, 2012217344 bytes
   16 heads, 32 sectors/track, 7676 cylinders
   Units = cylinders of 512 * 512 = 262144 bytes
   
      Device Boot      Start         End      Blocks   Id  System
   /dev/sda1   *          16        7676     1961024    b  W95 FAT32
   
   U盘的设备文件是 /dev/sda，2G大小，FAT32格式。
   
   如果用户登陆的不是Linux图形界面，U盘不会自动挂载上来。
   此时可以通过手工挂载(mount)：
   mount /dev/sda1 mount_point
   以上命令将U盘挂载到当前目录的 mount_point 目录，注意挂的是 sda1 不是 sda。
   卸载命令是 umount mount_point
   
   Linux默认没有自带支持NTFS格式磁盘的驱动，但对FAT32支持良好，挂载的时候一般不需要 -t vfat 参数 。
   如果支持ntfs，对ntfs格式的磁盘分区应使用 -t ntfs 参数。
   如果出现乱码情况，可以考虑用 -o iocharset=字符集 参数。
   
   可以通过 lsusb 命令查看 USB 设备信息哦：
   
   [root@miix tmp]# lsusb
   Bus 001 Device 001: ID 0000:0000
   Bus 002 Device 001: ID 0000:0000
   Bus 003 Device 001: ID 0000:0000
   Bus 004 Device 002: ID 0951:1613 Kingston Technology
   Bus 004 Device 001: ID 0000:0000



linux查看硬件设备信息
系统
# uname -a               # 查看内核/操作系统/CPU信息
 # head -n 1 /etc/issue   # 查看操作系统版本 # cat /etc/redhat-release
# cat /proc/cpuinfo      # 查看CPU信息
 # hostname               # 查看计算机名 
# lspci -tv              # 列出所有PCI设备
 # lsusb -tv              # 列出所有USB设备 
# lsmod                  # 列出加载的内核模块
 # env                    # 查看环境变量
资源
# free -m                # 查看内存使用量和交换区使用量 
# df -h                  # 查看各分区使用情况 
# du -sh <目录名>        # 查看指定目录的大小 
# grep MemTotal /proc/meminfo   # 查看内存总量
 # grep MemFree /proc/meminfo    # 查看空闲内存量
# uptime                 # 查看系统运行时间、用户数、负载 
# cat /proc/loadavg      # 查看系统负载
磁盘和分区
# mount | column -t      # 查看挂接的分区状态 
# fdisk -l               # 查看所有分区 
# swapon -s              # 查看所有交换分区
 # hdparm -i /dev/hda     # 查看磁盘参数(仅适用于IDE设备) 
# dmesg | grep IDE       # 查看启动时IDE设备检测状况
网络
# ifconfig               # 查看所有网络接口的属性
 # iptables -L            # 查看防火墙设置 
# route -n               # 查看路由表 
# netstat -lntp          # 查看所有监听端口 
# netstat -antp          # 查看所有已经建立的连接
 # netstat -s             # 查看网络统计信息
进程
# ps -ef                 # 查看所有进程 
# top                    # 实时显示进程状态
用户
# w                      # 查看活动用户 
# id <用户名>            # 查看指定用户信息 
# last                   # 查看用户登录日志 
# cut -d: -f1 /etc/passwd   # 查看系统所有用户 
# cut -d: -f1 /etc/group    # 查看系统所有组 
# crontab -l             # 查看当前用户的计划任务
服务
# chkconfig --list       # 列出所有系统服务 
# chkconfig --list | grep on    # 列出所有启动的系统服务
程序
# rpm -qa                # 查看所有安装的软件包
 
常用命令整理如下：
查看主板的序列号: dmidecode | grep -i ’serial number’
用硬件检测程序kuduz探测新硬件：service kudzu start ( or restart)
查看CPU信息：cat /proc/cpuinfo [dmesg | grep -i 'cpu'][dmidecode -t processor]
查看内存信息：cat /proc/meminfo [free -m][vmstat]
查看板卡信息：cat /proc/pci
查看显卡/声卡信息：lspci |grep -i ‘VGA’[dmesg | grep -i 'VGA']
查看网卡信息：dmesg | grep -i ‘eth’[cat /etc/sysconfig/hwconf | grep -i eth][lspci | grep -i 'eth']
<!--more-->
查看PCI信息：lspci (相比cat /proc/pci更直观）
查看USB设备：cat /proc/bus/usb/devices
查看键盘和鼠标:cat /proc/bus/input/devices
查看系统硬盘信息和使用情况：fdisk & disk – l & df
查看各设备的中断请求(IRQ):cat /proc/interrupts
查看系统体系结构：uname -a
查看及启动系统的32位或64位内核模式：isalist –v [isainfo –v][isainfo –b]
dmidecode查看硬件信息，包括bios、cpu、内存等信息
测定当前的显示器刷新频率：/usr/sbin/ffbconfig –rev \?
查看系统配置：/usr/platform/sun4u/sbin/prtdiag –v
查看当前系统中已经应用的补丁：showrev –p
显示当前的运行级别：who –rH
查看当前的bind版本信息：nslookup –class=chaos –q=txt version.bind
dmesg | more 查看硬件信息
lspci 显示外设信息, 如usb，网卡等信息
lsnod 查看已加载的驱动
lshw
psrinfo -v 查看当前处理器的类型和速度（主频）
prtconf -v 打印当前的OBP版本号
iostat –E 查看硬盘物理信息(vendor, RPM, Capacity)
prtvtoc /dev/rdsk/c0t0d0s 查看磁盘的几何参数和分区信息
df –F ufs –o i 显示已经使用和未使用的i-node数目
isalist –v
对于“/proc”中文件可使用文件查看命令浏览其内容，文件中包含系统特定信息：
Cpuinfo 主机CPU信息
Dma 主机DMA通道信息
Filesystems 文件系统信息
Interrupts 主机中断信息
Ioprots 主机I/O端口号信息
Meninfo 主机内存信息
Version Linux内存版本信息
备注： proc – process information pseudo-filesystem 进程信息伪装文件系统
RPM
    在Linux 操作系统中，有一个系统软件包，它的功能类似于Windows里面的“添加/删除程序”，但是功能又比“添加/删除程序”强很多，它就是 Red Hat Package Manager(简称RPM)。此工具包最先是由Red Hat公司推出的，后来被其他Linux开发商所借用。由于它为Linux使用者省去了很多时间，所以被广泛应用于在Linux下安装、删除软件。下面就 给大家介绍一下它的具体使用方法。
1.我们得到一个新软件，在安装之前，一般都要先查看一下这个软件包里有什么内容，假设这个文件是：Linux-1.4-6.i368.rpm，我们可以用这条命令查看：
rpm -qpi Linux-1.4-6.i368.rpm
系统将会列出这个软件包的详细资料，包括含有多少个文件、各文件名称、文件大小、创建时间、编译日期等信息。
2.上面列出的所有文件在安装时不一定全部安装，就像Windows下程序的安装方式分为典型、完全、自定义一样，Linux也会让你选择安装方式，此时我们可以用下面这条命令查看软件包将会在系统里安装哪些部分，以方便我们的选择：
rpm -qpl Linux-1.4-6.i368.rpm
3. 选择安装方式后，开始安装。我们可以用rpm-ivh Linux-1.4-6.i368.rpm命令安装此软件。在安装过程中，若系统提示此软件已安装过或因其他原因无法继续安装，但若我们确实想执行安装命 令，可以在 -ivh后加一参数“-replacepkgs”：
rpm -ivh -replacepkgs Linux-1.4-6.i368.rpm
4.有时我们卸载某个安装过的软件，只需执行rpm-e <文件名>;命令即可。
5.对低版本软件进行升级是提高其功能的好办法，这样可以省去我们卸载后再安装新软件的麻烦，要升级某个软件，只须执行如下命令：rpm -uvh <文件名>;，注意：此时的文件名必须是要升级软件的升级补丁
6. 另外一个安装软件的方法可谓是Linux的独到之处，同时也是RMP强大功能的一个表现：通过FTP站点直接在线安装软件。当找到含有你所需软件的站点并 与此网站连接后，执行下面的命令即可实现在线安装，譬如在线安装Linux-1.4-6.i368.rpm，可以用命令：
rpm -i ftp://ftp.pht.com/pub/linux/redhat/...-1.4-6.i368.rpm
7. 在我们使用电脑过程中，难免会有误操作，若我们误删了几个文件而影响了系统的性能时，怎样查找到底少了哪些文件呢?RPM软件包提供了一个查找损坏文件的 功能，执行此命令：rpm -Va即可，Linux将为你列出所有损坏的文件。你可以通过Linux的安装光盘进行修复。
8.Linux系统中文件繁多，在使用过程中，难免会碰到我们不认识的文件，在Windows下我们可以用“开始/查找”菜单快速判断某个文件属于哪个文件夹，在Linux中，下面这条命令行可以帮助我们快速判定某个文件属于哪个软件包：
rpm -qf <文件名>;
9.当每个软件包安装在Linux系统后，安装文件都会到RPM数据库中“报到”，所以，我们要查询某个已安装软件的属性时，只需到此数据库中查找即可。注意：此时的查询命令不同于1和8介绍的查询，这种方法只适用于已安装过的软件包！命令格式：
rpm -参数　<文件名>;
 
APT-GET
apt-get update——在修改/etc/apt/sources.list或者/etc/apt/preferences之后运行该命令。此外您需要定期运行这一命令以确保您的软件包列表是最新的。
apt-get install packagename——安装一个新软件包（参见下文的aptitude） 
apt-get remove packagename——卸载一个已安装的软件包（保留配置文件） 
apt-get --purge remove packagename——卸载一个已安装的软件包（删除配置文件） 
dpkg --force-all --purge packagename 有些软件很难卸载，而且还阻止了别的软件的应用，就可以用这个，不过有点冒险。 
apt-get autoclean apt会把已装或已卸的软件都备份在硬盘上，所以如果需要空间的话，可以让这个命令来删除你已经删掉的软件 
apt-get clean 这个命令会把安装的软件的备份也删除，不过这样不会影响软件的使用的。 
apt-get upgrade——更新所有已安装的软件包 
apt-get dist-upgrade——将系统升级到新版本 
apt-cache search string——在软件包列表中搜索字符串 
dpkg -l package-name-pattern——列出所有与模式相匹配的软件包。如果您不知道软件包的全名，您可以使用“*package-name-pattern*”。
aptitude——详细查看已安装或可用的软件包。与apt-get类似，aptitude可以通过命令行方式调用，但仅限于某些命令——最常见的有安装和卸载命令。由于aptitude比apt-get了解更多信息，可以说它更适合用来进行安装和卸载。
apt-cache showpkg pkgs——显示软件包信息。 
apt-cache dumpavail——打印可用软件包列表。 
apt-cache show pkgs——显示软件包记录，类似于dpkg –print-avail。 
apt-cache pkgnames——打印软件包列表中所有软件包的名称。 
dpkg -S file——这个文件属于哪个已安装软件包。 
dpkg -L package——列出软件包中的所有文件。 
apt-file search filename——查找包含特定文件的软件包（不一定是已安装的），这些文件的文件名中含有指定的字符串。apt-file是一个独立的软件包。您必须 先使用apt-get install来安装它，然后运行apt-file update。如果apt-file search filename输出的内容太多，您可以尝试使用apt-file search filename | grep -w filename（只显示指定字符串作为完整的单词出现在其中的那些文件名）或者类似方法，例如：apt-file search filename | grep /bin/（只显示位于诸如/bin或/usr/bin这些文件夹中的文件，如果您要查找的是某个特定的执行文件的话，这样做是有帮助的）。





cat

tail -f

日 志 文 件 说 明

/var/log/message 系统启动后的信息和错误日志，是Red Hat Linux中最常用的日志之一

/var/log/secure 与安全相关的日志信息

/var/log/maillog 与邮件相关的日志信息

/var/log/cron 与定时任务相关的日志信息

/var/log/spooler 与UUCP和news设备相关的日志信息

/var/log/boot.log 守护进程启动和停止相关的日志消息

系统：

# uname -a # 查看内核/操作系统/CPU信息

# cat /etc/issue

# cat /etc/redhat-release # 查看操作系统版本  Enterprise Linux Enterprise Linux Server release 5.1 (Carthage)企业Linux服务器版本迦太基

# cat /proc/cpuinfo # 查看CPU信息

# hostname # 查看计算机名

# lspci -tv # 列出所有PCI设备

# lsusb -tv # 列出所有USB设备

# lsmod # 列出加载的内核模块

# env # 查看环境变量

资源：

# free -m # 查看内存使用量和交换区使用量

# df -h # 查看各分区使用情况

# du -sh <目录名> # 查看指定目录的大小

# grep MemTotal /proc/meminfo # 查看内存总量

# grep MemFree /proc/meminfo # 查看空闲内存量

# uptime # 查看系统运行时间、用户数、负载

# cat /proc/loadavg # 查看系统负载

磁盘和分区：

# mount | column -t # 查看挂接的分区状态

# fdisk -l # 查看所有分区

# swapon -s # 查看所有交换分区

# hdparm -i /dev/hda # 查看磁盘参数(仅适用于IDE设备)

# dmesg | grep IDE # 查看启动时IDE设备检测状况

网络：

# ifconfig # 查看所有网络接口的属性

# iptables -L # 查看防火墙设置

# route -n # 查看路由表

# netstat -lntp # 查看所有监听端口

# netstat -antp # 查看所有已经建立的连接

# netstat -s # 查看网络统计信息

进程：

# ps -ef # 查看所有进程

# top # 实时显示进程状态(另一篇文章里面有详细的介绍)

用户：

# w # 查看活动用户

# id <用户名> # 查看指定用户信息

# last # 查看用户登录日志

# cut -d: -f1 /etc/passwd # 查看系统所有用户

# cut -d: -f1 /etc/group # 查看系统所有组

# crontab -l # 查看当前用户的计划任务

服务：

# chkconfig –list # 列出所有系统服务

# chkconfig –list | grep on # 列出所有启动的系统服务

程序：

# rpm -qa # 查看所有安装的软件包



linux 如何查看开关机记录

last |grep shutdown
last |grep reboot
last



-------------------------------------------------------------------------------------

解决Linux系统磁盘空间满的办法
 
查看目录空间占用情况
# du -sbh *

由于当初安装系统时设计不合理，有些分区分的过小，以及网络通讯故障等造成日志文件迅速增长等其他原因都可能表现为磁盘空间满，造成无法读写磁盘，应用程序无法执行等。下面就给你支几招(以/home空间满为例)：
 
　　1. 定期对重要文件系统扫描，并作对比，分析那些文件经常读写
 
　　#ls –lR /home >;files.txt
 
　　#diff filesold.txt files.txt
 
　　通过分析预测空间的增长情况，同时可以考虑对不经常读写文件进行压缩，以减少占用空间。
 
　　2. 查看空间满的文件系统的inodes消耗
 
　　#df – i /home
 
　　如果还有大量inode可用，说明大文件占用空间，否则是可能大量小文件占用空间。
 
　　3. 找出占用空间较大的目录
 
　　查看/home 占用的空间
 
　　#du –hs /home
 
　　查看/home 下占用空间超过1000m
 
　　#du |awk '$1>;2000'
 
　　4. 找出占用空间较大的文件
 
　　#find /home –size +2000k
 
　　5. 找出最近修改或创建的文件
 
　　先touch一个你想要的时间的文件如下：
 
　　# touch -t 08190800 test
 
　　#find /home -newer test -print
 
　　6. 删除系统日志等
 
　　删除生成 core,mbox等文件
 
　　#find / -name core|xargs rm –rf
 
　　删除日志
 
　　#rm -rf /var/log/*
 
　　7. 对分区做链接
 
　　在有空间的分区，对没有空间分区做链接
 
　　#ln -s /home /usr/home
 
　　8.找出耗费大量的空间的进程
 
　　根据不同的应用，找出对应的进程。分析原因。
 
　　9.检查并修复文件系统
 
　　#fsck –y /home
 
　　10.重起机器
 
　　有了以上的十招，应该可以解决大部分问题，但关键还是安装时要规划好分区。另外发现磁盘满时，不能急，小心操作，认真分析原因，然后小心应对。需要注意，以上十招不需要顺序执行，有的可能一招封喉，有的可能需要数招并用，删除操作一定要小心。如果还不行，只有采取增加硬盘，重新安装系统等"硬"办法了。
 
　　还可以：
 
　　cd \
 
　　du -h --max-depth=1|grep G|sort -n
 
　　找到最大的那个目录后进入该目录
 
　　再运行du -h --max-depth=1|grep G|-n
 
　　如果没有结果可以运行 du -h --max-depth=1|grep M|sort -n
 
　　找出来以后看是否有用的文件
 
　　没用就删掉
 
 
 
-------------------------------------------------------------------------------------
 
du -hs /var/log/httpd/
rm -rf /var/log/httpd/error_log.1
 
 df
网络安全:www.webtcp.com



-------------------------------------------------------------------------------------
2013-05-29 SVN配置库空间满，剪切 systemtesting配置库到备份盘的/svnbak/data/20130529目录下
2013-07-03 SVN配置库空间又满了，剪切 rj2minicusp配置库到备份盘的/svnbak/data/20130529目录下


df -h

cd /var/svn/repos
du -sbh *

mv -f rj2minicusp/ /svnbak/data/20130529
mv -f /var/svn/repos/rj2minicusp/ /svnbak/data/20130529

cd /svnbak/data/20130529
du -sbh *



centos 网络配置

centos的又图像界面去配制网络，但是感觉图像界面不方便，还是文本的方便

还是很简单的，和UBUNTU有点区别；

下面是文本配制网络：

1、网络的基本设置

    我们在设置网络环境的时候，提前要弄清楚以下的相关信息。
    IP                    IP地址                                                                    
    Netmark           子网掩码
    Gateway         默认网关
    HostName    主机名称
    DomainName    域名
    DNS                DNS的IP

2、配置文件

    /etc/sysconfig/network
    /etc/sysconfig/network-scripts/ifcfg-eth0
    /etc/resolv.conf
    /etc/hosts

    （1）文件 /etc/sysconfig/network

    这个/etc/sysconfig/network文件是定义hostname和是否利用网络的不接触网络设备的对系统全体定义的文件。
    设定形式：设定值=值
    /etc/sysconfig/network的设定项目如下：

    NETWORKING    是否利用网络                                      
    GATEWAY        默认网关
    IPGATEWAYDEV    默认网关的接口名
    HOSTNAME    主机名
    DOMAIN        域名

    （2）文件 /etc/sysconfig/network-scripts/ifcfg-eth0

    /etc/sysconfig/network-scripts在这个目录下面，存放的是网络接口（网卡）的制御脚本文件（控制文件），ifcfg- eth0是默认的第一个网络接口，如果机器中有多网络接口，那么名字就将依此类推ifcfg-eth1,ifcfg-eth2,ifcfg- eth3......（这里面的文件是相当重要的，涉及到网络能否正常工作）
    设定形式：设定值=值
    设定项目项目如下：
    DEVICE        接口名（设备,网卡）
    BOOTPROTO    IP的配置方法（static:固定IP， dhcpHCP， none:手动）        
    HWADDR        MAC地址
    ONBOOT        系统启动的时候网络接口是否有效（yes/no）
    TYPE        网络类型（通常是Ethemet）
    NETMASK        网络掩码
    IPADDR        IP地址
    IPV6INIT    IPV6是否有效（yes/no）
    GATEWAY        默认网关IP地址

    这里有一个例子：

    [root@linux ~]# cat -n /etc/sysconfig/network-scripts/ifcfg-eth0
         1 DEVICE=eth0
         2 BOOTPROTO=static
         3 BROADCAST=192.168.1.255
         4 HWADDR=00:0C:2x:6x:0x:xx
         5 IPADDR=192.168.1.23
         6 NETMASK=255.255.255.0
         7 NETWORK=192.168.1.0
         8 ONBOOT=yes
         9 TYPE=Ethernet

    （3）文件 /etc/resolv.conf

    这个文件是用来配置主机将用的DNS服务器信息。在这个文件中如果不设置DNS服务器的IP地址，那么在通信的时候，将无法指定像 www.centospub.com这样的域名。（DNS是Domain NameSystem的简称，中文名称域名解析服务器，主要是IP和域名转换功能）/etc/resolv.conf的设定项目：
    domain ←定义本地域名
    search ←定义域名和搜索列表
    nameserver←定义被参照的DNS服务器的IP地址（最多可指定3个）
    一般来说最重要的是第三个nameserver项目，没有这项定义，用域名将无法访问网站，并且yum等服务将无法利用。

    （4）文件 /etc/hosts

    /etc/hosts这个文件是记载LAN内接续的各主机的对应[HostName和IP]用的。在LAN内，我们各个主机间访问通信的时候，用的是内网的IP地址进行访问（例：192.168.1.22，192.168.1.23），从而确立连接进行通信。除了通过访问IP来确立通信访问之外，我们还可以通过HostName进行访问，我们在安装机器的时候都会给机器    起一个名字，这个名字就是这台机器的HostName，通过上图可以看到，HostA的 hostname是centos1，HostB的hostname是centos2那我们怎么能不但通过IP确立连接，通过这个IP对应的 HostName进行连接访问呢？解决的办法就是这个/etc/hosts这个文件，通过把LAN内的各主机的IP地址和HostName的一一对应写入这个文件的时候，就可以解决问题。

    比如说上图，我要在HostA上用ssh访问HostB的时候，在命令行下我做这样的操作：

    [root@centos1 ~]# ssh 192.168.1.23
    root@192.168.1.23's password:
    Last login: Mon Dec 25 15:04:58 2006 from centos1
    [root@centos2 ~]#

    访问成功后，我们看到hostname的地方变化了。
    那么我们用hostname试试看：

    [root@centos1 ~]# ssh centos2
    ssh:centos2: Name or service not known ←提示错误，不知道主机
    [root@centos1 ~]#

    那么我们编辑/etc/hosts文件，将HostB的IP和hostname的对应关系写入这个文件,如果主机有域名，可以将域名写在IP地址之后hostname之前，并且用空格隔开，形式如   

第三行127.0.0.1的设置。

    [root@centos1 ~]# cat -n /etc/hosts
    1 # Do not remove the following line, or various programs
         2 # that require network functionality will fail.
         3 127.0.0.1       localhost.localdomain   localhost
         4 192.168.1.23 centos2
    [root@centos2 ~]#

    然后我们再从复#ssh centos2的操作

    [root@centos1 ~]# ssh centos2
    root@centos2's password:
    Last login: Mon Dec 25 15:05:07 2006 from centos1
    [root@centos2 ~]#

    可以看到访问成功了，这个文件就是这样的，倘若你要用windowsXP访问局域网中的linux你也可以用上面的方法，只不过在 windowsXP下面你也要修改hosts这个文件，文件路径：C:\WINDOWS\system32\drivers\etc\hosts，在这个文件中添加你要访问的局域网中的主机的IP和hostname，就能通过主机名访问主机了。


TAG linux 网络 配置  

##############################################################

##安装CentOS7################################################################
安装时忘了GUI，用命令安装

CentOS 7下安装GUI图形界面
[日期：2017-03-07]     来源：Linux社区  作者：c-xiaohai     [字体：大 中 小]
1、如何在CentOS7下安装GUI图形界面

      当你安装CentOS7服务器版本的时候，系统默认是不会安装GUI的图形界面程序，这个需要手动安装CentOS7 Gnome GUI包。
2、在系统下使用命令安装gnome图形界面程序

      在安装Gnome包之前，需要检查一下安装源(yum)是否正常，因为需要在yum命令来安装gnome包。

      第一步：先检查yum 是否安装了，以及网络是否有网络。如果这两者都没有，先解决网络，在解决yum的安装。

　　（配置步骤可以查看我的博客文章-centOS-配置网络地址-的步骤来实现 ）

      第二步：在命令行下 输入下面的命令来安装Gnome包。

       # yum groupinstall "GNOME Desktop" "Graphical Administration Tools"

      第三步：更新系统的运行级别。

       # ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target

      第四步：重启机器。启动默认进入图形界面。

       # reboot

3、系统启动后直接进入图形界面


##############################################################


 Linux ssh登录命令
2014-04-07 22:19 106336人阅读 评论(1) 收藏 举报

ssh命令用于远程登录上Linux主机。

常用格式：ssh [-l login_name] [-p port] [user@]hostname
更详细的可以用ssh -h查看。

举例

不指定用户：

    ssh 192.168.0.11

指定用户：

    ssh -l root 192.168.0.11

    ssh root@192.168.0.11


如果修改过ssh登录端口的可以：

    ssh -p 12333 192.168.0.11

    ssh -l root -p 12333 216.230.230.114

    ssh -p 12333 root@216.230.230.114

另外修改配置文件/etc/ssh/sshd_config，可以改ssh登录端口和禁止root登录。改端口可以防止被端口扫描。

编辑配置文件：

    vim /etc/ssh/sshd_config

找到#Port 22，去掉注释，修改成一个五位的端口：

    Port 12333

找到#PermitRootLogin yes，去掉注释，修改为：

    PermitRootLogin no

重启sshd服务：

    service sshd restart





##############################################################






##############################################################













```


### 
```yml


```


### 
```yml


```


## 搜集的shell命令

### wymshell

```
:1,$s/word1/word2/g         查找word1字符串，并用word2替换word1
:1,$s/word1/word2/gc     查找word1字符串，并用word2替换word1，替换前要求确认

ls -l * |grep "^-"|wc -l ---- to count files

ls -l * |grep "^d"|wc -l





```


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
    sudo yum install -y docker-ce-18.06.1.ce
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

