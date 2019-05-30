





### Linux等保测评常用查询命令

```yml

查询口令长度、最长使用时间、过期提前通知：
# cat /etc/login.defs

查询口令复杂度参数、账户登录失败处理：
# cat /etc/pam.d/system-auth

查询采用远程管理的方式：
# service --status-all |grep  sshd
# service --status-all |grep  running
# service --status-all |grep  运行

查询系统用户信息（唯一性-口令加密情况-系统帐户情况）：
# cat /etc/passwd
# cat /etc/shadow

查询关键文件权限：
# ls -la /etc/passwd  
# ls -la /etc/shadow  
# ls -la /etc/profile

查看日志审计：
# service syslog status  （系统日志）
# service auditd status（审计服务）
# ps -ef |grep auditd（审计服务）

审计服务启用情况：
# grep "@priv-ops" /etc/audit/filter.conf  
# grep "@mount-ops" /etc/audit/filter.conf  
# grep "@system-ops" /etc/audit/filter.conf

查看日志文件：
# cat /var/log/audit/audit.log
# cat /var/log/messages

查看日志文件权限：
# ls -la /var/log/messages  
# ls -la /var/log/audit/audit.log  


查看系统运行服务：
# service --status-all |grep running

查看补丁情况：
# rpm -qa |grep patch

查看登录限制情况：
# iptables -L

查看超时锁定情况：
# cat /etc/profile

查看资源分配情况：
# cat /etc/security/limits.conf

```

### 

```yml
[root@centos7wym ~]# chage -h
用法：chage [选项] 登录

选项：
  -d, --lastday 最近日期        将最近一次密码设置时间设为“最近日期”
  -E, --expiredate 过期日期     将帐户过期时间设为“过期日期”
  -h, --help                    显示此帮助信息并推出
  -I, --inactive INACITVE       过期 INACTIVE 天数后，设定密码为失效状态
  -l, --list                    显示帐户年龄信息
  -m, --mindays 最小天数        将两次改变密码之间相距的最小天数设为“最小天数”
  -M, --maxdays 最大天数        将两次改变密码之间相距的最大天数设为“最大天数”
  -R, --root CHROOT_DIR         chroot 到的目录
  -W, --warndays 警告天数       将过期警告天数设为“警告天数”

[root@centos7wym ~]# chage -l root
最近一次密码修改时间					：从不
密码过期时间					：从不
密码失效时间					：从不
帐户过期时间						：从不
两次改变密码之间相距的最小天数		：0
两次改变密码之间相距的最大天数		：99999
在密码过期之前警告的天数	：7

修改全局配置文件



单个用户修改
# chage -l root

# chage -M 90 root
# chage -m 2 root

# chage -l root

也可以用其它的工具

# sed -i.bak -e's / ^ \（PASS_MAX_DAYS \）。* / \ 1 90 /' / etc / login.defs 

查看一下是否

# cat / etc /login.defs | grep“PASS_M”; 

强制用户登陆时修改口令
# chage -d 0用户名（linux）
# passwd -f username（solaris）

强制用户下次登陆时修改密码，并且设置密码最低有效期0和最高有限期90，提前15天发警报提示
# chage -d 0 -m 0 -M 90 -W 15 root（linux）
# passwd -f -n 0 -x 90 -w 15 root（solaris）
查看某个用户的密码设置情况
# chage -l username 
修改密码配置文件
# vi /etc/login.defs中


```

### 

```yml
/etc/login.defs 文件内容及其解释
2017年07月01日 09:43:50 一步一个脚印儿 阅读数：1460
/etc/login.defs 是设置用户帐号限制的文件。该文件里的配置对root用户无效。

如果/etc/shadow文件里有相同的选项，则以/etc/shadow里的设置为准，也就是说/etc/shadow的配置优先级高于/etc/login.defs

# *REQUIRED* required
#  Directory where mailboxes reside, _or_ name of file, relative to the
#   home directory.  If you _do_ define both, MAIL_DIR takes precedence.
#   QMAIL_DIR is for Qmail
#
#QMAIL_DIR      Maildir
MAIL_DIR        /var/spool/mail
#创建用户时，要在目录/var/spool/mail中创建一个用户mail文件
#MAIL_FILE      .mail

# Password aging controls:
#
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
#       PASS_MIN_DAYS   Minimum number of days allowed between password changes.
#       PASS_MIN_LEN    Minimum acceptable password length.
#       PASS_WARN_AGE   Number of days warning given before a password expires.
#
PASS_MAX_DAYS   99999
#密码最大有效期
PASS_MIN_DAYS   0
#两次修改密码的最小间隔时间
PASS_MIN_LEN    5
#密码最小长度，对于root无效
PASS_WARN_AGE   7
#密码过期前多少天开始提示
#
# Min/max values for automatic uid selection in useradd
#创建用户时不指定UID的话自动UID的范围
UID_MIN                   500
#用户ID的最小值
UID_MAX                 60000
#用户ID的最大值
#
# Min/max values for automatic gid selection in groupadd
#自动组ID的范围
GID_MIN                   500
#组ID的最小值
GID_MAX                 60000
#组ID的最大值

#
# If defined, this command is run when removing a user.
# It should remove any at/cron/print jobs etc. owned by
# the user to be removed (passed as the first argument).
#
#USERDEL_CMD    /usr/sbin/userdel_local
#当删除用户的时候执行的脚本

#
# If useradd should create home directories for users by default
# On RH systems, we do. This option is overridden with the -m flag on
# useradd command line.
#
CREATE_HOME     yes
#使用useradd的时候是够创建用户目录

# The permission mask is initialized to this value. If not specified,
# the permission mask will be initialized to 022.
UMASK           077

# This enables userdel to remove user groups if no members exist.
#
USERGROUPS_ENAB yes
#用MD5加密密码


```

### 

```yml
Linux密码过期时间设置/etc/login.defs
Linux操作系统 作者：fjzcau 时间：2015-01-24 09:47:30  7031  0
Linux下对于新添加的用户，用户密码过期时间是从/etc/login.defs中PASS_MAX_DAYS提取的，普通系统默认就是99999，
而有些安全操作系统是90.更改此处，只是让新建的用户默认密码过程时间变化，已有用户密码过期时间仍然不变。

[root@centos7wym ~]# chage -h
用法：chage [选项] 登录

选项：
  -d, --lastday 最近日期        将最近一次密码设置时间设为“最近日期”
  -E, --expiredate 过期日期     将帐户过期时间设为“过期日期”
  -h, --help                    显示此帮助信息并推出
  -I, --inactive INACITVE       过期 INACTIVE 天数后，设定密码为失效状态
  -l, --list                    显示帐户年龄信息
  -m, --mindays 最小天数        将两次改变密码之间相距的最小天数设为“最小天数”
  -M, --maxdays 最大天数        将两次改变密码之间相距的最大天数设为“最大天数”
  -R, --root CHROOT_DIR         chroot 到的目录
  -W, --warndays 警告天数       将过期警告天数设为“警告天数”



chage：密码失效是通过此命令来管理的。

  参数意思：
  -m密码可更改的最小天数。为零时代表任何时候都可以更改密码。- 
  M密码保持有效的最大天数
  -W用户密码到期前，提前收到警告信息的天数。- 
  E帐号到期的日期。过了这天，此帐号将不可用。- 
  d上一次更改的日期
  -i停滞时期。如果一个密码已过期这些天，那么此帐号将不可用。- 
  l例出当前的设置。由非特权用户来确定他们的密码或帐号何时过期。

[root @ linuxidc~] #chage -l root 
密码更改时间：2010年10月19日
密码到期：从不
密码无效：永不
帐户过期：从不
密码更改之间的最小天数：0密码更改之间的
最大天
数：99999 密码过期前的警告天数：7 

更改用：chage -M 90 root 

[root @ linuxidc~] #chage -M 90 root 

[root @ linuxidc~] #chage -l root 

如果以后添加一个用户，那么默认的时间还是没改的，还必须得去/etc/login.defs修改PASS_MAX_DAYS的默认值。那么如果我直接修改全局/etc/login.defs文件所在的用户会跟着改变吗？据我的测试是不会改变的，除非重启后，但我们的服务器不是你想重启的就可以重启的！如果管理严格的地方，重启还得经过很多程序步骤。改完全局时，没有更改的用户，想要让他也同样具备此功能。就得一个个的执行！

你也可以直接用vim编辑器去编辑PASS_MAX_DAYS 99999 

也可以用其它的工具

[root @ linuxidc~] #sed -i.bak -e's / ^ \（PASS_MAX_DAYS \）。* / \ 1 90 /' / etc / login.defs 

查看一下是否

[root @ linuxidc~] #cat / etc /login.defs | grep“PASS_M”; 

强制用户登陆时修改口令
[root @ linuxidc~] #chage -d 0用户名（linux）
[root @ linuxidc~] #passwd -f username（solaris）

强制用户下次登陆时修改密码，并且设置密码最低有效期0和最高有限期90，提前15天发警报提示
[root @ linuxidc~] #chage -d 0 -m 0 -M 90 -W 15 root（linux）
[root @ linuxidc 〜] #passwd -f -n 0 -x 90 -w 15 root（solaris）
查看某个用户的密码设置情况
[root @ linuxidc~] #chage -l username 
修改密码配置文件
[root @ linuxidc~] #vi /etc/login.defs中

```

### 

```yml


```
### Linux服务器安全加固

```yml

Linux服务器安全加固
置顶 2018年09月30日 12:31:08 谢公子 阅读数：3517
目录

对未经过安全认证的RPM包进行安全检查

Linux用户方面的加固

设定密码策略​

对用户密码强度的设定

对用户的登录次数进行限制

禁止ROOT用户远程登录

设置历史命令保存条数和账户超时时间

设置只有指定用户组才能使用su命令切换到root用户

对Linux账户进行管理

对重要的文件进行锁定，即使ROOT用户也无法删除

建立日志服务器

对未经过安全认证的RPM包进行安全检查
rpm  -qp   xxx.rpm   --scripts     查看rpm包中的脚本信息

Linux用户方面的加固
设定密码策略
修改  /etc/login.defs 配置文件

PASS_MAX_DAYS      90               密码最长有效期
PASS_MIN_DAYS       10               密码修改之间最小的天数
PASS_MIN_LEN          8                密码长度
PASS_WARN_AGE     7                 口令失效前多少天开始通知用户修改密码

脚本实现设定密码策略

#！ /bin/bash
# Author:谢公子
# Date: 2018-10-12
# Function: 实现对用户密码策略的设定，如密码最长有效期等
read -p  "设置密码最多可多少天不修改：" A
read -p  "设置密码修改之间最小的天数：" B
read -p  "设置密码最短的长度：" C
read -p  "设置密码失效前多少天通知用户：" D
sed -i '/^PASS_MAX_DAYS/c\PASS_MAX_DAYS   '$A'' /etc/login.defs
sed -i '/^PASS_MIN_DAYS/c\PASS_MIN_DAYS   '$B'' /etc/login.defs
sed -i '/^PASS_MIN_LEN/c\PASS_MIN_LEN     '$C'' /etc/login.defs
sed -i '/^PASS_WARN_AGE/c\PASS_WARN_AGE   '$D'' /etc/login.defs
echo "已设置好密码策略......"


对用户密码强度的设定
打开 /etc/pam.d/sysetm-auth 文件 ，修改如下。我们设置新密码不能和旧密码相同，同时新密码至少8位，还要同时包含大字母、小写字母和数字

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=  difok=1 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1


difok= ：此选项用来定义新密码中必须要有几个字符和旧密码不同
minlen=：此选项用来设置新密码的最小长度
ucredit= ：此选项用来设定新密码中可以包含的大写字母的最大数目。-1 至少一个
lcredit=：此选项用来设定新密码中可以包含的小写字母的最大数目
dcredit=：此选项用来设定新密码中可以包含的数字的最大数目 
注：这个密码强度的设定只对普通用户有限制作用，root用户无论修改自己的密码还是修改普通用户的时候，不符合强度设置依然可以设置成功



脚本实现对用户密码强度的设定

#！ /bin/bash
# Author:谢公子
# Date: 2018-10-12
# Function: 对用户密码强度的设定，新密码不能和旧密码相同，同时新密码至少8位，还要同时包含大字母、小写字母和数字
sed -i '/pam_pwquality.so/c\password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=  difok=1 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1' /etc/pam.d/system-auth
对用户的登录次数进行限制
有一些攻击性的软件是专门采用暴力破解密码的形式反复进行登录尝试，对于这种情况，我们可以调整用户登录次数限制，使其密码输入3次后自动锁定，并且设置锁定时间，在锁定时间内即使密码输入正确也无法登录

打开 /etc/pam.d/sshd  文件，在 #%PAM-1.0 的下面，加入下面的内容，表示当密码输入错误达到3次，就锁定用户150秒，如果root用户输入密码错误达到3次，锁定300秒。锁定的意思是即使密码正确了也登录不了

auth required pam_tally2.so deny=3 unlock_time=150 even_deny_root root_unlock_time300


当输入3次密码错误时



pam_tally2   查看被锁定的用户

pam_tally2  --reset  -u  username      将被锁定的用户解锁



脚本设置对用户的登录次数做限制

#！ /bin/bash
# Author:谢公子
# Date: 2018-10-12
# Function: 对用户登录输入错误密码次数做限制
n=`cat /etc/pam.d/sshd | grep "auth required pam_tally2.so "|wc -l`
if [ $n -eq 0 ];then
sed -i '/%PAM-1.0/a\auth required pam_tally2.so deny=3 unlock_time=150 even_deny_root root_unlock_time300' /etc/pam.d/sshd
fi
禁止ROOT用户远程登录
禁止ROOT用户远程登录 。打开  /etc/ssh/sshd_config  



脚本设置禁止ROOT用户远程登录

#！ /bin/bash
# Author:谢公子
# Date: 2018-10-12
# Function: 禁止ROOT用户远程登录
sed -i '/PermitRootLogin/c\PermitRootLogin no'  /etc/ssh/sshd_config
设置历史命令保存条数和账户超时时间
设置账户保存历史命令条数，超时时间  。打开  /etc/profile ,修改如下



使用脚本修改配置文件

#！ /bin/bash
# Author:谢公子
# Date: 2018-10-12
# Function: 修改配置文件，设置历史命令保存条数和账户自动注销时间
read -p "设置历史命令保存条数：" E
read -p "设置账户自动注销时间：" F
sed -i '/^HISTSIZE/c\HISTSIZE='$E'' /etc/profile
sed -i '/^HISTSIZE/a\TMOUT='$F'' /etc/profile
设置只有指定用户组才能使用su命令切换到root用户
在linux中，有一个默认的管理组 wheel。在实际生产环境中，即使我们有系统管理员root的权限，也不推荐用root用户登录。一般情况下用普通用户登录就可以了，在需要root权限执行一些操作时，再su登录成为root用户。但是，任何人只要知道了root的密码，就都可以通过su命令来登录为root用户，这无疑为系统带来了安全隐患。所以，将普通用户加入到wheel组，被加入的这个普通用户就成了管理员组内的用户。然后设置只有wheel组内的成员可以使用su命令切换到root用户。

比如，我们将普通用户xie加入wheel组。   usermod  -G  wheel  xie 

然后，我们修改配置文件 /etc/pam.d/su  ，将这行的注释给去掉



然后去 /etc/login.defs 末尾加入   SU_WHEEL_ONLY yes  即可。



当 tom 用户使用su命令切换到root用户时，会提示拒绝权限



使用脚本设置配置文件

#！ /bin/bash
# Author:谢公子
# Date: 2018-10-12
# Function: 修改配置文件，使得只有wheel组的用户可以使用 su 权限
sed -i '/pam_wheel.so use_uid/c\auth            required        pam_wheel.so use_uid ' /etc/pam.d/su
n=`cat /etc/login.defs | grep SU_WHEEL_ONLY | wc -l`
if [ $n -eq 0 ];then
echo SU_WHEEL_ONLY yes >> /etc/login.defs
fi  
对Linux账户进行管理
使用命令 userdel  -r 用户名  删除不必要的账号
使用命令 passwd -l  用户名  锁定不必要的账号
使用命令 awk -F: '($7=="/bin/bash"){print $1}' /etc/passwd   查看具有登录权限的用户
使用命令 awk -F: '($3==0)' /etc/passwd    查看UID为0的账号，UID为0的用户会自动切换到root用户，所以危害很大
使用命令 awk -F: '($2=="")' /etc/shadow   查看空口令账号，如果存在空口令用户的话必须设置密码 
使用脚本对账户进行管理

#! /bin/bash
# Author:谢公子
# Date:2018-10-11
# Function: 对系统中的用户做检查，加固系统
echo "系统中有登录权限的用户有："
awk -F: '($7=="/bin/bash"){print $1}' /etc/passwd
echo "********************************************"
echo "系统中UID=0的用户有："
awk -F: '($3=="0"){print $1}' /etc/passwd
echo "********************************************"
N=`awk -F: '($2==""){print $1}' /etc/shadow|wc -l`
echo "系统中空密码用户有：$N"
if [ $N -eq 0 ];then
 echo "恭喜你，系统中无空密码用户！！"
 echo "********************************************"
else
 i=1
 while [ $N -gt 0 ]
 do
    None=`awk -F: '($2==""){print $1}' /etc/shadow|awk 'NR=='$i'{print}'`
    echo "------------------------"
    echo $None
    echo "必须为空用户设置密码！！"
    passwd $None
    let N--
 done
 M=`awk -F: '($2==""){print $1}' /etc/shadow|wc -l`
 if [ $M -eq 0 ];then
  echo "恭喜，系统中已经没有空密码用户了！"
 else
echo "系统中还存在空密码用户：$M"
 fi
fi
 
对重要的文件进行锁定，即使ROOT用户也无法删除
chattr    改变文件或目录的扩展属性

lsattr    查看文件目录的扩展属性

chattr  +i  /etc/passwd /etc/shadow                 //增加属性
chattr  -i  /etc/passwd /etc/shadow                 //移除属性  
lsattr  /etc/passwd /etc/shadow



使用脚本对重要文件进行锁定

#! /bin/bash
# Author: 谢公子
# Date：2018-10-10
# Function: 锁定创建用户和组的文件，使之无法对用户和组进行操作！
read -p "警告：此脚本运行后将无法添加删除用户和组！！确定输入Y，取消输入N；Y/N：" i
case $i in
      [Y,y])
            chattr +i /etc/passwd
            chattr +i /etc/shadow
            chattr +i /etc/group
            chattr +i /etc/gshadow
            echo "锁定成功！"
;;
      [N,n])
            chattr -i /etc/passwd
            chattr -i /etc/shadow
            chattr -i /etc/group
            chattr -i /etc/gshadow
            echo "取消锁定成功！！"
;;
       *)
            echo "请输入Y/y or  N/n"
esac
一个脚本对上面所有的合并了

#! /bin/bash
# Author:谢公子
# Date:2018-10-11
# Function:对账户的密码的一些加固
read -p  "设置密码最多可多少天不修改：" A
read -p  "设置密码修改之间最小的天数：" B
read -p  "设置密码最短的长度：" C
read -p  "设置密码失效前多少天通知用户：" D
sed -i '/^PASS_MAX_DAYS/c\PASS_MAX_DAYS   '$A'' /etc/login.defs
sed -i '/^PASS_MIN_DAYS/c\PASS_MIN_DAYS   '$B'' /etc/login.defs
sed -i '/^PASS_MIN_LEN/c\PASS_MIN_LEN     '$C'' /etc/login.defs
sed -i '/^PASS_WARN_AGE/c\PASS_WARN_AGE    '$D'' /etc/login.defs
 
echo "已对密码进行加固，新用户不得和旧密码相同，且新密码必须同时包含数字、小写字母，大写字母！！"
sed -i '/pam_pwquality.so/c\password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=  difok=1 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1' /etc/pam.d/system-auth
 
echo "已对密码进行加固，如果输入错误密码超过3次，则锁定账户！！"
n=`cat /etc/pam.d/sshd | grep "auth required pam_tally2.so "|wc -l`
if [ $n -eq 0 ];then
sed -i '/%PAM-1.0/a\auth required pam_tally2.so deny=3 unlock_time=150 even_deny_root root_unlock_time300' /etc/pam.d/sshd
fi
 
echo  "已设置禁止root用户远程登录！！"
sed -i '/PermitRootLogin/c\PermitRootLogin no'  /etc/ssh/sshd_config
 
read -p "设置历史命令保存条数：" E
read -p "设置账户自动注销时间：" F
sed -i '/^HISTSIZE/c\HISTSIZE='$E'' /etc/profile
sed -i '/^HISTSIZE/a\TMOUT='$F'' /etc/profile
 
echo "已设置只允许wheel组的用户可以使用su命令切换到root用户！"
sed -i '/pam_wheel.so use_uid/c\auth            required        pam_wheel.so use_uid ' /etc/pam.d/su
n=`cat /etc/login.defs | grep SU_WHEEL_ONLY | wc -l`
if [ $n -eq 0 ];then
echo SU_WHEEL_ONLY yes >> /etc/login.defs
fi
 
echo "即将对系统中的账户进行检查...."
echo "系统中有登录权限的用户有："
awk -F: '($7=="/bin/bash"){print $1}' /etc/passwd
echo "********************************************"
echo "系统中UID=0的用户有："
awk -F: '($3=="0"){print $1}' /etc/passwd
echo "********************************************"
N=`awk -F: '($2==""){print $1}' /etc/shadow|wc -l`
echo "系统中空密码用户有：$N"
if [ $N -eq 0 ];then
 echo "恭喜你，系统中无空密码用户！！"
 echo "********************************************"
else
 i=1
 while [ $N -gt 0 ]
 do
    None=`awk -F: '($2==""){print $1}' /etc/shadow|awk 'NR=='$i'{print}'`
    echo "------------------------"
    echo $None
    echo "必须为空用户设置密码！！"
    passwd $None
    let N--
 done
 M=`awk -F: '($2==""){print $1}' /etc/shadow|wc -l`
 if [ $M -eq 0 ];then
  echo "恭喜，系统中已经没有空密码用户了！"
 else
echo "系统中还存在空密码用户：$M"
 fi
fi
 
echo "即将对系统中重要文件进行锁定，锁定后将无法添加删除用户和组"
read -p "警告：此脚本运行后将无法添加删除用户和组！！确定输入Y，取消输入N；Y/N：" i
case $i in
      [Y,y])
            chattr +i /etc/passwd
            chattr +i /etc/shadow
            chattr +i /etc/group
            chattr +i /etc/gshadow
            echo "锁定成功！"
;;
      [N,n])
            chattr -i /etc/passwd
            chattr -i /etc/shadow
            chattr -i /etc/group
            chattr -i /etc/gshadow
            echo "取消锁定成功！！"
;;
       *)
            echo "请输入Y/y or  N/n"
esac

建立日志服务器
日志服务器的好处在于，每个工作服务器将自己的日志信息发送给日志服务器进行集中管理，即使有人入侵了服务器并将自己的登录信息悄悄删除，但由于日志信息实时与日志服务器同步，保证了日志的完整性。以备工作人员根据日志服务器信息对服务器安全进行评测。



客户端的配置：

打开 /etc/rsyslog.conf 配置文件

你想把哪种类型的日志文件发送给服务端，你就把他原来的对应的目录改成： @192.168.10.20



如果你想吧所有的日志文件都发送给服务器的话，你可以在文件最后加上： *.*  @@192.168.10.20:514



然后重启rsyslog服务： systemctl  restart  rsyslog

服务器端的配置：

打开 /etc/rsyslog.conf 配置文件，将这里的注释给去掉



然后重启rsyslog服务：systemctl  restart  rsyslog

开启防火墙： firewall-cmd  --add-port=514/tcp

这样客户端的相应的日志文件就会保存在服务器端的相应的文件中。



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

### CentOS7 系统安全加固实施方案介绍

```yml

2015年09月23日 12:43:48 童年的天空 阅读数：11733
CentOS7.0系统安全加固手册

 

目录

 

一、用户帐号和环境……………………………………………………………………………………. 2

二、系统访问认证和授权……………………………………………………………………………… 3

三、核心调整……………………………………………………………………………………………… 4

四、需要关闭的一些服务……………………………………………………………………………… 5

五、SSH安全配置……………………………………………………………………………………….. 5

六、封堵openssl的Heartbleed漏洞…………………………………………………………………. 6

七、开启防火墙策略……………………………………………………………………………………. 6

八、启用系统审计服务…………………………………………………………………………………. 8

九、部署完整性检查工具软件………………………………………………………………………. 10

十、部署系统监控环境……………………………………………………………………………….. 11

 

以下安全设置均是在CentOS7.0_x64环境下minimal安装进行的验证。

一、用户帐号和环境
 	检查项	注释:
1	清除了operator、lp、shutdown、halt、games、gopher 帐号
删除的用户组有： lp、uucp、games、dip

其它系统伪帐号均处于锁定SHELL登录的状态

 

 
2	验证是否有账号存在空口令的情况:
awk -F:   ‘($2 == “”) { print $1 }’ /etc/shadow

 

 
3	检查除了root以外是否还有其它账号的UID为0:
awk -F:   ‘($3 == 0) { print $1 }’ /etc/passwd

 

任何UID为0的账号在系统上都具有超级用户权限.
4	检查root用户的$PATH中是否有’.’或者所有用户/组用户可写的目录	超级用户的$PATH设置中如果存在这些目录可能会导致超级用户误执行一个特洛伊木马
5	用户的home目录许可权限设置为700	用户home目录的许可权限限制不严可能会导致恶意用户读/修改/删除其它用户的数据或取得其它用户的系统权限
6	是否有用户的点文件是所有用户可读写的:
for dir   in \

`awk -F:   ‘($3 >= 500) { print $6 }’ /etc/passwd`

do

for file   in $dir/.[A-Za-z0-9]*

do

if [ -f   $file ]; then

chmod o-w   $file

fi

done

done

 

Unix/Linux下通常以”.”开头的文件是用户的配置文件,如果存在所有用户可读/写的配置文件可能会使恶意用户能读/写其它用户的数据或取得其它用户的系统权限
7	为用户设置合适的缺省umask值:
cd /etc

for file   in profile csh.login csh.cshrc bashrc

do

if [   `grep -c umask $file` -eq 0 ];

then

echo   “umask 022″ >> $file

fi

chown   root:root $file

chmod 444   $file

done

 

为用户设置缺省的umask值有助于防止用户建立所有用户可写的文件而危及用户的数据.
8	设备系统口令策略：修改/etc/login.defs文件
将PASS_MIN_LEN最小密码长度设置为12位。

 
 	 	 
10	限制能够su为root 的用户：#vi /etc/pam.d/su
在文件头部添加下面这样的一行

auth           required        pam_wheel.so use_uid

这样，只有wheel组的用户可以su到root
操作样例：

#usermod   -G10 test 将test用户加入到wheel组

11	修改别名文件/etc/aliases：#vi /etc/aliases
注释掉不要的   #games: root #ingres: root #system: root #toor: root #uucp: root #manager:   root #dumper: root #operator: root #decode: root #root: marc

修改后执行/usr/bin/newaliases

 
 	 	 
13	修改帐户TMOUT值，设置自动注销时间
vi /etc/profile

增加TMOUT=600

无操作600秒后自动退出
14	设置Bash保留历史命令的条数
#vi /etc/profile

修改HISTSIZE=5

即只保留最新执行的5条命令
 	 	 
16	防止IP   SPOOF：
#vi /etc/host.conf 添加：nospoof on

不允许服务器对IP地址进行欺骗
17	使用日志服务器：
#vi /etc/rsyslog.conf 照以下样式修改

*.info;mail.none;authpriv.none;cron.none    @192.168.10.199

 

这里只是作为参考，需要根据实际决定怎么配置参数
 

 

二、系统访问认证和授权
 	检查项	注释:
1	限制   at/cron给授权的用户:
cd /etc/

rm -f   cron.deny at.deny

echo root   >cron.allow

echo root   >at.allow

chown   root:root cron.allow at.allow

chmod 400   cron.allow at.allow

 

Cron.allow和at.allow文件列出了允许允许crontab和at命令的用户名单, 在多数系统上通常只有系统管理员才需要运行这些命令
5	Crontab文件限制访问权限:
chown   root:root /etc/crontab

chmod 400   /etc/crontab

chown -R   root:root /var/spool/cron

chmod -R   go-rwx /var/spool/cron

chown -R   root:root /etc/cron.*

chmod -R   go-rwx /etc/cron.*

 

系统的crontab文件应该只能被cron守护进程(它以超级用户身份运行)来访问,一个普通用户可以修改crontab文件会导致他可以以超级用户身份执行任意程序
6	建立恰当的警告banner:
echo   “Authorized uses only. All activity may be \

monitored   and reported.” >>/etc/motd

chown   root:root /etc/motd

chmod 644   /etc/motd

echo   “Authorized uses only. All activity may be \

monitored   and reported.” >> /etc/issue

echo   “Authorized uses only. All activity may be \

monitored   and reported.” >> /etc/issue.net

改变登录banner可以隐藏操作系统类型和版本号和其它系统信息,这些信息可以会对攻击者有用.
7	限制root登录到系统控制台:
cat   <<END_FILE >/etc/securetty

tty1

tty2

tty3

tty4

tty5

tty6

END_FILE

chown   root:root /etc/securetty

chmod 400   /etc/securetty

 

通常应该以普通用户身份访问系统,然后通过其它授权机制(比如su命令和sudo)来获得更高权限,这样做至少可以对登录事件进行跟踪
8	设置守护进程掩码
vi /etc/rc.d/init.d/functions

设置为 umask 022

系统缺省的umask 值应该设定为022以避免守护进程创建所有用户可写的文件
 

 

三、核心调整
 	设置项	注释:
1	禁止core   dump:
cat <<END_ENTRIES   >>/etc/security/limits.conf

* soft core 0

* hard core 0

END_ENTRIES

允许core   dump会耗费大量的磁盘空间.
2	chown root:root /etc/sysctl.conf
chmod 600 /etc/sysctl.conf

log_martians将进行ip假冒的ip包记录到/var/log/messages
其它核心参数使用CentOS默认值。

 

四、需要关闭的一些服务
 	设置项	注释:
1	关闭Mail   Server
chkconfig postfix off

多数Unix/Linux系统运行Sendmail作为邮件服务器, 而该软件历史上出现过较多安全漏洞,如无必要,禁止该服务
 

五、SSH安全配置
 	设置项	注释:
1	配置空闲登出的超时间隔:
ClientAliveInterval 300

ClientAliveCountMax 0

Vi /etc/ssh/sshd_config
 

2	禁用   .rhosts 文件
IgnoreRhosts yes

Vi /etc/ssh/sshd_config
 

3	禁用基于主机的认证
HostbasedAuthentication no

Vi /etc/ssh/sshd_config
 

4	禁止   root 帐号通过 SSH   登录
PermitRootLogin no

Vi /etc/ssh/sshd_config
 

5	用警告的   Banner
Banner /etc/issue

Vi /etc/ssh/sshd_config
 

6	iptables防火墙处理 SSH 端口 # 64906
-A INPUT -s 192.168.1.0/24 -m state –state NEW   -p tcp –dport 64906 -j ACCEPT

-A INPUT -s 202.54.1.5/29 -m state –state NEW -p   tcp –dport 64906 -j ACCEPT

这里仅作为参考，需根据实际需要调整参数
7	修改 SSH   端口和限制 IP 绑定：
Port 64906

 

安装selinux管理命令

yum -y install policycoreutils-python

修改   port contexts（关键），需要对context进行修改

semanage port -a -t ssh_port_t -p tcp 64906

semanage port -l | grep ssh      —-查看当前SElinux 允许的ssh端口

Vi /etc/ssh/sshd_config
仅作为参考，需根据实际需要调整参数。

 

8	禁用空密码：
PermitEmptyPasswords no

禁止帐号使用空密码进行远程登录SSH
9	记录日志：
LogLevel    INFO

确保在   sshd_config 中将日志级别   LogLevel 设置为   INFO 或者   DEBUG，可通过 logwatch or
logcheck 来阅读日志。

10	重启SSH
systemctl restart sshd.service

重启ssh
 

 

 

六、封堵openssl的Heartbleed漏洞
 

检测方法：在服务器上运行以下命令确认openssl版本

# openssl version

OpenSSL 1.0.1e-fips 11 Feb 2013

以上版本的openssl存在Heartbleed bug，需要有针对性的打补丁。

升及补丁：

#yum -y install openssl

验证：

# openssl version -a

OpenSSL 1.0.1e-fips 11 Feb 2013

built on: Thu Jun  5 12:49:27 UTC 2014

以上built on 的时间是2014.6.5号，说明已经修复了该漏洞。

注：如果能够临时联网安装以上补丁，在操作上会比较简单一些。如果无法联网，则有两种处理办法：首选从安装光盘拷贝独立的rpm安装文件并更新；另一个办法是提前下载最新版本的openssl源码，编译并安装。

 

 

七、开启防火墙策略
在CentOS7.0中默认使用firewall代替了iptables service。虽然继续保留了iptables命令，但已经仅是名称相同而已。除非手动删除firewall，再安装iptables，否则不能继续使用以前的iptables配置方法。以下介绍的是firewall配置方法：

#cd /usr/lib/firewalld/services   //该目录中存放的是定义好的网络服务和端口参数，只用于参考，不能修改。这个目录中只定义了一部分通用网络服务。在该目录中没有定义的网络服务，也不必再增加相关xml定义，后续通过管理命令可以直接增加。
#cd /etc/firewalld/services/                  //从上面目录中将需要使用的服务的xml文件拷至这个目录中，如果端口有变化则可以修改文件中的数值。
 

# Check firewall state.
firewall-cmd --state
# Check active zones.
firewall-cmd --get-active-zones
# Check current active services.
firewall-cmd --get-service
# Check services that will be active after next reload.
firewall-cmd --get-service --permanent
 

查看firewall当前的配置信息，最后一个命令是查看写入配置文件的信息。
# # Set permanent and reload the runtime config.
# firewall-cmd --permanent --zone=public --add-service=http
# firewall-cmd --reload
# firewall-cmd --permanent --zone=public --list-services
打开HTTP服务端口并写入配置文件
从配置文件中重载至运行环境中。

# firewall-cmd --permanent --zone=public --remove-service=https
# firewall-cmd --reload
从已有配置中删除一个服务端口
# firewall-cmd --permanent --zone=public --add-port=8080-8081/tcp
# firewall-cmd --reload
# firewall-cmd --zone=public --list-ports
8080-8081/tcp
# firewall-cmd --permanent --zone=public --list-ports
8080-8081/tcp
#
# firewall-cmd --permanent --zone=public --remove-port=8080-8081/tcp
# firewall-cmd --reload
打开或关闭一段TCP端口的方法，同理如果使用了其它非通用端口，那么也可以这么操作。
# firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" \
    source address="192.168.0.4/24" service name="http" accept"
# firewall-cmd --permanent --zone=public --remove-rich-rule="rule family="ipv4" \
    source address="192.168.0.4/24" service name="http" accept"
The following command allows you to open/close   HTTP access to a specific IP address.
 	 
 

 

八、启用系统审计服务
审计内容包括：系统调用、文件访问、用户登录等。编辑/etc/audit/audit.rules,在文中添加如下内容：

 

-w /var/log/audit/ -k LOG_audit

-w /etc/audit/ -p wa -k CFG_audit

-w /etc/sysconfig/auditd -p wa -k CFG_auditd.conf

-w /etc/libaudit.conf -p wa -k CFG_libaudit.conf

-w /etc/audisp/ -p wa -k CFG_audisp

-w /etc/cups/ -p wa -k CFG_cups

-w /etc/init.d/cups -p wa -k CFG_initd_cups

-w /etc/netlabel.rules -p wa -k CFG_netlabel.rules

-w /etc/selinux/mls/ -p wa -k CFG_MAC_policy

-w /usr/share/selinux/mls/ -p wa -k CFG_MAC_policy

-w /etc/selinux/semanage.conf -p wa -k CFG_MAC_policy

-w /usr/sbin/stunnel -p x

-w /etc/security/rbac-self-test.conf -p wa -k CFG_RBAC_self_test

-w /etc/aide.conf -p wa -k CFG_aide.conf

-w /etc/cron.allow -p wa -k CFG_cron.allow

-w /etc/cron.deny -p wa -k CFG_cron.deny

-w /etc/cron.d/ -p wa -k CFG_cron.d

-w /etc/cron.daily/ -p wa -k CFG_cron.daily

-w /etc/cron.hourly/ -p wa -k CFG_cron.hourly

-w /etc/cron.monthly/ -p wa -k CFG_cron.monthly

-w /etc/cron.weekly/ -p wa -k CFG_cron.weekly

-w /etc/crontab -p wa -k CFG_crontab

-w /var/spool/cron/root -k CFG_crontab_root

-w /etc/group -p wa -k CFG_group

-w /etc/passwd -p wa -k CFG_passwd

-w /etc/gshadow -k CFG_gshadow

-w /etc/shadow -k CFG_shadow

-w /etc/security/opasswd -k CFG_opasswd

-w /etc/login.defs -p wa -k CFG_login.defs

-w /etc/securetty -p wa -k CFG_securetty

-w /var/log/faillog -p wa -k LOG_faillog

-w /var/log/lastlog -p wa -k LOG_lastlog

-w /var/log/tallylog -p wa -k LOG_tallylog

-w /etc/hosts -p wa -k CFG_hosts

-w /etc/sysconfig/network-scripts/ -p wa -k CFG_network

-w /etc/inittab -p wa -k CFG_inittab

-w /etc/rc.d/init.d/ -p wa -k CFG_initscripts

-w /etc/ld.so.conf -p wa -k CFG_ld.so.conf

-w /etc/localtime -p wa -k CFG_localtime

-w /etc/sysctl.conf -p wa -k CFG_sysctl.conf

-w /etc/modprobe.conf -p wa -k CFG_modprobe.conf

-w /etc/pam.d/ -p wa -k CFG_pam

-w /etc/security/limits.conf -p wa -k CFG_pam

-w /etc/security/pam_env.conf -p wa -k CFG_pam

-w /etc/security/namespace.conf -p wa -k CFG_pam

-w /etc/security/namespace.init -p wa -k CFG_pam

-w /etc/aliases -p wa -k CFG_aliases

-w /etc/postfix/ -p wa -k CFG_postfix

-w /etc/ssh/sshd_config -k CFG_sshd_config

-w /etc/vsftpd.ftpusers -k CFG_vsftpd.ftpusers

-a exit,always -F arch=b32 -S sethostname

-w /etc/issue -p wa -k CFG_issue

-w /etc/issue.net -p wa -k CFG_issue.net

重启audit服务

#service auditd  restart

 

 

九、部署完整性检查工具软件
AIDE(Advanced Intrusion Detection Environment,高级入侵检测环境)是个入侵检测工具，主要用途是检查文档的完整性。

AIDE能够构造一个指定文档的数据库，他使用aide.conf作为其配置文档。AIDE数据库能够保存文档的各种属性，包括：权限(permission)、索引节点序号(inode number)、所属用户(user)、所属用户组(group)、文档大小、最后修改时间(mtime)、创建时间(ctime)、最后访问时间(atime)、增加的大小连同连接数。AIDE还能够使用下列算法：sha1、md5、rmd160、tiger，以密文形式建立每个文档的校验码或散列号。

在系统安装完毕，要连接到网络上之前，系统管理员应该建立新系统的AIDE数据库。这第一个AIDE数据库是系统的一个快照和以后系统升级的准绳。数据库应该包含这些信息：关键的系统二进制可执行程式、动态连接库、头文档连同其他总是保持不变的文档。这个数据库不应该保存那些经常变动的文档信息，例如：日志文档、邮件、/proc文档系统、用户起始目录连同临时目录

安装方法：

#yum -y install aide

注：如果主机不能联网安装AIDE，那么也可以从安装光盘拷贝至目标主机。

 

检验系统文件完整性的要求：

因为AIDE可执行程序的二进制文档本身可能被修改了或数据库也被修改了。因此，应该把AIDE的数据库放到安全的地方，而且进行检查时要使用确保没有被修改过的程序，最好是事先为AIDE执行程序生成一份MD5信息。再次使用AIDE可执行程序时，需要先验证该程序没有被篡改过。

 

配置说明：

序号	参数	注释
1	/etc/aide.conf	配置文件
2	database	Aide读取文档数据库的位置，默认为/var/lib/aide，默认文件名为aide.db.gz
3	database_out	Aide生成文档数据库的存放位置，默认为/var/lib/aide，默认文件名为aide.db.new.gz
 	database_new	在使用aide   –compare命令时，需要在aide.conf中事先设置好database_new并指向需要比较的库文件
4	report_url	/var/log/aide，入侵检测报告的存放位置
5	其它参数继续使用默认值即可。
 

 

建立、更新样本库：   

1）执行初始化，建立第一份样本库

# aide –init

# cd /var/lib/aide/

# mv aide.db.new.gz aide.db.gz   //替换旧的样本库

2）更新到样本库

#aide –update

# cd /var/lib/aide/

# mv aide.db.new.gz aide.db.gz   //替换旧的样本库

 

执行aide入侵检测：

1）查看入侵检测报告

#aide –check

报告的详细程度可以通过-V选项来调控，级别为0-255，-V0 最简略，-V255 最详细。

或

#aide –compare

这个命令要求在配置文件中已经同时指定好了新、旧两个库文件。

2）保存入侵检测报告（将检查结果保存到其他文件）

aide –check –report=file：/tmp/aide-report-20120426.txt

3）定期执行入侵检测，并发送报告

# crontab -e

45 17 * * * /usr/sbin/aide -C -V4 | /bin/mail -s ”AIDE REPORT $（date +%Y%m%d）” abcdefg#163.com

或

45 23 * * * aide -C >> /var/log/aide/’date +%Y%m%d’_aide.log

 

记录aide可执行文件的md5 checksum：

#md5sum /usr/sbin/aide

 

 

十、部署系统监控环境
该段落因为需要安装或更新较多的依赖包，所以目前仅作为参考。

为了在将来合适的时候，可以支持通过一台集中的监控主机全面监控主机系统和网络设备的运行状态、网络流量等重要数据，可以在安全加固主机的系统中预先安装和预留了系统监控软件nagios和cacti在被监控主机中需要使用的软件支撑环境。

由于以下软件在安装过程中需要使用源码编译的方式，由此而引发需要安装GCC和OPENSSL-DEVEL。而为了安装GCC和OPENSSL-DEVEL而引发的依赖包的安装和更新大约有20个左右。这就违返了安全加固主机要保持最小可用系统的设计原则，所以该部分监控软件支撑环境的部署工作不作为默认设置，但仍然通过下文给出了部署参考，以用于系统运行运维过程中需要部署全局性监控系统时使用。

 

1）安装net-snmp服务

#yum -y install net-snmp

#chkconfig snmpd off     —将该服务设置为默认关闭，这里只是为以后部署cacti先预置一个支撑环境

 

如果不能联网安装，则可以使用安装光盘，并安装以下几个rpm包：

lm_sensors  ， net-snmp  ,  net-snmp-libs  ,   net-snmp-utils

 

2）安装nagios-plugin和nrpe

 

a. 增加用户&设定密码

# useradd nagios

# passwd nagios

b. 安装Nagios 插件

# tar zxvf nagios-plugins-2.0.3.tar.gz

# cd nagios-plugins-2.0.3

# ./configure –prefix=/usr/local/nagios

# make && make install

这一步完成后会在/usr/local/nagios/下生成三个目录include、libexec和share。

修改目录权限

# chown nagios.nagios /usr/local/nagios

# chown -R nagios.nagios /usr/local/nagios/libexec

c. 安装NRPE

# tar zxvf nrpe-2.15.tar.gz

# cd nrpe-2.15

# ./configure

# make all

接下来安装NPRE插件，daemon和示例配置文件。

c.1 安装check_nrpe 这个插件

# make install-plugin

监控机需要安装check_nrpe 这个插件，被监控机并不需要，在这里安装它只是为了测试目的。

c.2 安装deamon

# make install-daemon

c.3 安装配置文件

# make install-daemon-config

现在再查看nagios 目录就会发现有5个目录了

```
### 

```yml



```

### 转载-六招轻松搞定你的CentOS系统安全加固

```yml
转载
六招轻松搞定你的CentOS系统安全加固
cjp198820090人评论5893人阅读2014-07-21 13:46:11
Redhat是目前企业中用的最多的一类Linux，而目前针对Redhat攻击的黑客也越来越多了。我们要如何为这类服务器做好安全加固工作呢？ 

一.  账户安全



1.1 锁定系统中多余的自建帐号



检查方法:

执行命令

#cat /etc/passwd
#cat /etc/shadow
查看账户、口令文件，与系统管理员确认不必要的账号。对于一些保留的系统伪帐户如：bin, sys，adm，uucp，lp, nuucp，hpdb, www, daemon等可根据需要锁定登陆。



备份方法：

#cp -p /etc/passwd /etc/passwd_bak
#cp -p /etc/shadow /etc/shadow_bak
加固方法:

使用命令passwd -l <用户名>锁定不必要的账号。

使用命令passwd -u <用户名>解锁需要恢复的账号。

wKiom1PMmN6iNd8oAAQxO_Ba0gA889.jpg

 



风险:   需要与管理员确认此项操作不会影响到业务系统的登录



1.2设置系统口令策略



检查方法：

使用命令

#cat /etc/login.defs|grep PASS查看密码策略设置
备份方法：

cp -p /etc/login.defs /etc/login.defs_bak


加固方法：

#vi /etc/login.defs修改配置文件
PASS_MAX_DAYS   90        #新建用户的密码最长使用天数
PASS_MIN_DAYS   0         #新建用户的密码最短使用天数
PASS_WARN_AGE   7         #新建用户的密码到期提前提醒天数
PASS_MIN_LEN    9         #最小密码长度9
wKiom1PMmYDgaFffAAGbt_O3IIE402.jpg

 

风险：无可见风险



1.3禁用root之外的超级用户



检查方法：

#cat /etc/passwd 查看口令文件，口令文件格式如下：
login_name：password：user_ID：group_ID：comment：home_dir：command


login_name：用户名

password：加密后的用户密码

user_ID：用户ID，（1 ~ 6000）   若用户ID=0，则该用户拥有超级用户的权限。查看此处是否有多个ID=0。

group_ID：用户组ID

comment：用户全名或其它注释信息

home_dir：用户根目录

command：用户登录后的执行命令



备份方法：

#cp -p /etc/passwd /etc/passwd_bak
加固方法：



使用命令passwd -l <用户名>锁定不必要的超级账户。

使用命令passwd -u <用户名>解锁需要恢复的超级账户。

风险：需要与管理员确认此超级用户的用途。



1.4 限制能够su为root的用户



检查方法：

#cat /etc/pam.d/su,查看是否有auth required /lib/security/pam_wheel.so这样的配置条目
备份方法：
#cp -p /etc/pam.d /etc/pam.d_bak


加固方法：

#vi /etc/pam.d/su
在头部添加：
auth required /lib/security/pam_wheel.so group=wheel
这样，只有wheel组的用户可以su到root
#usermod -G10 test 将test用户加入到wheel组
wKioL1PMo8Cj5bBBAAGlp95PCWc908.jpg



风险：需要PAM包的支持；对pam文件的修改应仔细检查，一旦出现错误会导致无法登陆；和管理员确认哪些用户需要su。



当系统验证出现问题时，首先应当检查/var/log/messages或者/var/log/secure中的输出信息，根据这些信息判断用户账号的有效

 性。如果是因为PAM验证故障，而引起root也无法登录，只能使用single user或者rescue模式进行排错。



1.5  检查shadow中空口令帐号



检查方法：

#awk -F: '($2 == "") { print $1 }' /etc/shadow
备份方法：cp -p /etc/shadow /etc/shadow_bak
加固方法：对空口令账号进行锁定，或要求增加密码

wKiom1PMot_gFq-GAAA52K7nyv4906.jpg 



风险：要确认空口令账户是否和应用关联，增加密码是否会引起应用无法连接。



二、最小化服务



2.1 停止或禁用与承载业务无关的服务

检查方法：
#who –r或runlevel    查看当前init级别
#chkconfig --list     查看所有服务的状态


备份方法：记录需要关闭服务的名称

加固方法：

#chkconfig --level <服务名> on|off|reset    设置服务在个init级别下开机是否启动 



wKiom1PMo2KQrT2UAAJFp1xqexY257.jpg



风险：某些应用需要特定服务，需要与管理员确认。



三、数据访问控制



3.1 设置合理的初始文件权限

检查方法：
#cat /etc/profile    查看umask的值
备份方法：
#cp -p /etc/profile /etc/profile_bak
加固方法：
#vi /etc/profile
umask=027


风险：会修改新建文件的默认权限，如果该服务器是WEB应用，则此项谨慎修改。



四、网络访问控制



4.1 使用SSH进行管理



检查方法：

#ps –aef | grep sshd    查看有无此服务


备份方法：



加固方法：



使用命令开启ssh服务

#service sshd start
风险：改变管理员的使用习惯



4.2  设置访问控制策略限制能够管理本机的IP地址



检查方法：

#cat /etc/ssh/sshd_config  查看有无AllowUsers的语句
备份方法：

#cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config_bak


加固方法：

#vi /etc/ssh/sshd_config，添加以下语句
AllowUsers  *@10.138.*.*     此句意为：仅允许10.138.0.0/16网段所有用户通过ssh访
问



保存后重启ssh服务

#service sshd restart


风险：需要和管理员确认能够管理的IP段



4.3 禁止root用户远程登陆



检查方法：

#cat /etc/ssh/sshd_config  查看PermitRootLogin是否为no


备份方法：

#cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config_bak


加固方法：

#vi /etc/ssh/sshd_config
PermitRootLogin no


保存后重启ssh服务

service sshd restart
 wKiom1PMqMnBKW4mAAA8ekDUcoU189.jpg



风险：root用户无法直接远程登录，需要用普通账号登陆后su



4.4 限定信任主机



检查方法：

#cat /etc/hosts.equiv 查看其中的主机
#cat /$HOME/.rhosts   查看其中的主机
备份方法：

#cp -p /etc/hosts.equiv /etc/hosts.equiv_bak
#cp -p /$HOME/.rhosts /$HOME/.rhosts_bak
加固方法：

#vi /etc/hosts.equiv 删除其中不必要的主机
#vi /$HOME/.rhosts   删除其中不必要的主机
风险：在多机互备的环境中，需要保留其他主机的IP可信任。



4.5  屏蔽登录banner信息



检查方法：

#cat /etc/ssh/sshd_config    查看文件中是否存在Banner字段，或banner字段为NONE
#cat /etc/motd               查看文件内容，该处内容将作为banner信息显示给登录用户。


备份方法：

#cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config_bak
#cp -p /etc/motd /etc/motd_bak


加固方法：

#vi /etc/ssh/sshd_config  
banner NONE
#vi /etc/motd

删除全部内容或更新成自己想要添加的内容



风险：无可见风险



4.6 防止误使用Ctrl+Alt+Del重启系统



检查方法：

#cat /etc/inittab|grep ctrlaltdel     查看输入行是否被注释


备份方法：

#cp -p /etc/inittab /etc/inittab_bak
加固方法：

#vi /etc/inittab


在行开头添加注释符号“#”

#ca::ctrlaltdel:/sbin/shutdown -t3 -r now
 wKiom1PMpPqzQbzSAAAxCmyVwvg204.jpg



风险：无可见风险





五、用户鉴别



5.1  设置帐户锁定登录失败锁定次数、锁定时间



检查方法：

#cat /etc/pam.d/system-auth   查看有无auth required pam_tally.so条目的设置
备份方法：

#cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth_bak
加固方法：

#vi /etc/pam.d/system-auth
auth required pam_tally.so onerr=fail deny=6 unlock_time=300  设置为密码连续错误6次锁定，锁定时间300秒


解锁用户 faillog  -u  <用户名>  -r



风险：需要PAM包的支持；对pam文件的修改应仔细检查，一旦出现错误会导致无法登陆；



当系统验证出现问题时，首先应当检查/var/log/messages或者/var/log/secure中的输出信息，根据这些信息判断用户账号的有效

 性。



5.2 修改帐户TMOUT值，设置自动注销时间



检查方法：

#cat /etc/profile    查看有无TMOUT的设置


备份方法：

#cp -p /etc/profile /etc/profile_bak


加固方法：

#vi /etc/profile


增加

TMOUT=600    无操作600秒后自动退出
风险：无可见风险



5.3 Grub/Lilo密码



检查方法：

#cat /etc/grub.conf|grep password    查看grub是否设置密码
#cat /etc/lilo.conf|grep password    查看lilo是否设置密码


备份方法：

#cp -p /etc/grub.conf /etc/grub.conf_bak
#cp -p /etc/lilo.conf /etc/lilo.conf_bak


加固方法：为grub或lilo设置密码



风险：etc/grub.conf通常会链接到/boot/grub/grub.conf



5.4 限制FTP登录



检查方法：

#cat /etc/ftpusers    确认是否包含用户名，这些用户名不允许登录FTP服务


备份方法：

#cp -p /etc/ftpusers /etc/ftpusers_bak
加固方法：

#vi /etc/ftpusers    添加行，每行包含一个用户名，添加的用户将被禁止登录FTP服务


风险：无可见风险



5.5 设置Bash保留历史命令的条数



检查方法：

#cat /etc/profile|grep HISTSIZE=
#cat /etc/profile|grep HISTFILESIZE=    查看保留历史命令的条数
备份方法：

#cp -p /etc/profile /etc/profile_bak
加固方法：

#vi /etc/profile
修改HISTSIZE=5和HISTFILESIZE=5即保留最新执行的5条命令
 wKiom1PMqJni9hpMAAAmfmsc010589.jpg 



风险：无可见风险



六、审计策略



6.1 配置系统日志策略配置文件

检查方法：

#ps –aef | grep syslog   确认syslog是否启用
#cat /etc/syslog.conf     查看syslogd的配置，并确认日志文件是否存在


系统日志（默认）/var/log/messages

cron日志（默认）/var/log/cron

安全日志（默认）/var/log/secure



备份方法：

#cp -p /etc/syslog.conf
 

wKioL1PMqY7ABD28AAHHDuI2SS8572.jpg



6.2 为审计产生的数据分配合理的存储空间和存储时间



检查方法

#cat /etc/logrotate.conf    查看系统轮询配置，有无
# rotate log files weekly
weekly
# keep 4 weeks worth of backlogs
rotate 4  的配置
备份方法：

#cp -p /etc/logrotate.conf /etc/logrotate.conf_bak


加固方法：

#vi /etc/logrotate.d/syslog



增加

rotate 4     日志文件保存个数为4，当第5个产生后，删除最早的日志
size 100k    每个日志的大小


加固后应类似如下内容：

/var/log/syslog/*_log {
 missingok
 notifempty
 size 100k # log files will be rotated when they grow bigger that 100k.
 rotate 5  # will keep the logs for 5 weeks.
 compress  # log files will be compressed.
 sharedscripts
 postrotate
 /etc/init.d/syslog condrestart >/dev/null 2>1 || true
 endscript
 }
 

wKiom1PMqEyDsiZ1AAFyz75OjBk439.jpg



 



风险：无可见风险



本文章转载于：http://www.centoscn.com/CentosSecurity/CentosSafe/2014/0318/2616.html

```
### linux服务器安全加固shell脚本

```yml

linux服务器安全加固shell脚本
2013年10月17日 02:39:01 god_7z1 阅读数：1252

#!/bin/sh
    
# desc: setup linux system security
# author:coralzd
# powered by www.xiaohuai.com
# version 0.1.2 written by 2011.05.03
#account setup
    
passwd -l xfs
passwd -l news
passwd -l nscd
passwd -l dbus
passwd -l vcsa
passwd -l games
passwd -l nobody
passwd -l avahi
passwd -l haldaemon
passwd -l gopher
passwd -l ftp
passwd -l mailnull
passwd -l pcap
passwd -l mail
passwd -l shutdown
passwd -l halt
passwd -l uucp
passwd -l operator
passwd -l sync
passwd -l adm
passwd -l lp
    
# chattr /etc/passwd /etc/shadow
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/group
chattr +i /etc/gshadow
# add continue input failure 3 ,passwd unlock time 5 minite
sed -i 's#auth        required      pam_env.so#auth        required      pam_env.so\nauth       required       pam_tally.so  onerr=fail deny=3 unlock_time=300\nauth           required     /lib/security/$ISA/pam_tally.so onerr=fail deny=3 unlock_time=300#' /etc/pam.d/system-auth
# system timeout 5 minite auto logout
echo "TMOUT=300" >>/etc/profile
    
# will system save history command list to 10
sed -i "s/HISTSIZE=1000/HISTSIZE=10/" /etc/profile
    
# enable /etc/profile go!
source /etc/profile
    
# add syncookie enable /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
    
sysctl -p # exec sysctl.conf enable
# optimizer sshd_config
    
sed -i "s/#MaxAuthTries 6/MaxAuthTries 6/" /etc/ssh/sshd_config
sed -i  "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
    
# limit chmod important commands
chmod 700 /bin/ping
chmod 700 /usr/bin/finger
chmod 700 /usr/bin/who
chmod 700 /usr/bin/w
chmod 700 /usr/bin/locate
chmod 700 /usr/bin/whereis
chmod 700 /sbin/ifconfig
chmod 700 /usr/bin/pico
chmod 700 /bin/vi
chmod 700 /usr/bin/which
chmod 700 /usr/bin/gcc
chmod 700 /usr/bin/make
chmod 700 /bin/rpm
    
# history security
    
chattr +a /root/.bash_history
chattr +i /root/.bash_history
    
# write important command md5
cat > list << "EOF" &&
/bin/ping
/bin/finger
/usr/bin/who
/usr/bin/w
/usr/bin/locate
/usr/bin/whereis
/sbin/ifconfig
/bin/pico
/bin/vi
/usr/bin/vim
/usr/bin/which
/usr/bin/gcc
/usr/bin/make
/bin/rpm
EOF
    
for i in `cat list`
do
   if [ ! -x $i ];then
   echo "$i not found,no md5sum!"
  else
   md5sum $i >> /var/log/`hostname`.log
  fi
done
rm -f list

此shell脚本已经大量应用在某大型媒体网站体系中，关于脚本实现的加固内容，大家一看脚本就基本上能明白了，如果还不明白的话，那就GOOGLE+BAIDU吧！ 如果还不知道的话，就问此脚本的作者吧！！哈哈
\

```

### shell_脚本_linux_安全加固

```yml
shell_脚本_linux_安全加固
2016年06月05日 20:42:36 ProjectDer 阅读数：3928
关于Linux系统安全加固的具体实现脚本及基线检查规范，以供主机维护人员参考学习。

其中以下脚本主要实现的功能包括：

*加固项包括：密码长度、session超时时间、删除不用的帐号和组、限制root用户直接telnet或rlogin、ssh

*检查是否存在除root之外UID为0的用户、确保root用户的系统路径中不包含父目录，在非必要的情况下，不应包含组权限为777的目录

*检查操作系统Linux用户umask设置、检查重要目录和文件的权限、禁止除root之外的用户su操作、查找系统中任何人都有写权限的目录

*查找系统中没有属主的文件、查找系统中的隐藏文件、判断日志与审计是否合规、登录超时设置、禁用不必要的服务

*linux 安全加固适用于redhat、centos5.8至6.2

具体内容如下，请结合自身业务需求进行系统级加固：

#1、---------------------------------------------------------------------
echo "删除不用的帐号和组"

echo "delete unused users and grups"

for i in lp sync shutdown halt news uucp operator games gopher

do

    echo "will delete user $i"

     userdel $i

    echo "user $i have delete"

done

for i in lp sync shutdown halt news uucp operator games gopher

do

    echo "will delete group $i"

    groupdel $i

    echo "group $i have delete"

done

date=`date +%F`

#2、-----------------------------------------------
#section1 密码要求密码长度大于8,口令90天过期/etc/login.defs

#-----------------------------------------------

#---------------------------------------------------------------------

echo "cp /etc/login.defs to /etc/login.defs.bak_%date"

echo "#-------------------------------------"

cp /etc/login.defs /etc/login.defs.bak_$date

#echo "检查密码的配置"

echo "Check the configure for user's password."

echo "#-------------------------------------"

for i in PASS_MAX_DAYS PASS_MIN_LEN PASS_MIN_DAYS PASS_WARN_AGE

do

    cat /etc/login.defs |grep $i|grep -v \#

done

#set password min length 8

echo "#-------------------------------------"

echo "Set user's password min length is 8"

sed  -i '/PASS_MIN_LEN/s/5/8/g' /etc/login.defs

echo "#-------------------------------------"

#set password max day 90

#echo "set password expired 90 day"

#sed  -i '/PASS_MAX_DAYS/s/99999/90/g' /etc/login.defs

#3、---------------------------------------------------------------------
echo "#检查是否存在空口令"

echo "Check if there have user without password!"

echo "#-------------------------------------"

awk -F: '($2 == "") { print $1 }' /etc/shadow

#4、-----------------------------------------------
#section2 限制root用户直接telnet或rlogin，ssh无效

######建议在/etc/securetty文件中配置：CONSOLE = /dev/tty01

#---------------------------------------------------------------------

#帐号与口令-检查是否存在除root之外UID为0的用户

#echo "#检查系统中是否存在其它id为0的用户"

echo "Check if the system have other user's id is 0"

echo "#-------------------------------------"

mesg=`awk -F: '($3 == 0) { print $1 }' /etc/passwd|grep -v root`

if [ -z $mesg ]

then

echo "There don't have other user uid=0"

else

echo

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo "$mesg uid=0"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

fi

#5、-----------------------------------------------------------


echo "#确保root用户的系统路径中不包含父目录，在非必要的情况下，不应包含组权限为777的目录"

echo "check the Path set for root,make sure the path for root dont have father directory and 777 rights"

echo "#-------------------------------------"

echo $PATH | egrep '(^|:)(\.|:|$)'

find `echo $PATH | tr ':' ' '` -type d −perm−002−o−perm−020 -ls

#6、---------------------------------------------------------------------
echo "#检查操作系统Linux远程连接"

echo "Check if system have remote connection seting"

echo "#-------------------------------------"

find  / -name  .netrc

find  / -name  .rhosts

echo "检查操作系统Linux用户umask设置"

echo "Check the system users umask setting"

echo "#-------------------------------------"

for i in /etc/profile /etc/csh.login /etc/csh.cshrc /etc/bashrc

do

grep -H umask $i|grep -v "#"

done

###################设置umask为027

#7、---------------------------------------------------------------------
#echo "#检查重要目录和文件的权限"

##echo "Check the important files and directory rights"

echo "#-------------------------------------"

for i in /etc /etc/rc.d/init.d /tmp /etc/inetd.conf /etc/passwd /etc/shadow /etc/group /etc/security /etc/services /etc/rc*.d

do

ls  -ld $i

done

echo -n "Please check if the output is ok ? yes or no :"

read i

case $i in

y|yes)

break

;;

n|no)

echo "Please recheck the output!"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

continue

;;

*)

echo "please input yes or no"

;;

esac

#8、-----------------------------------------------------------
#echo "#配置rc.d下脚本的权限"

echo "Configure the scripts right(750) in rc.d directory"

echo "#-------------------------------------"

chmod -R 750 /etc/rc.d/init.d/*

chmod 755 /bin/su 改了之后只能root su，没有了s位别的用户无法成功su

chmod 664 /var/log/wtmp

#chattr +a /var/log/messages

#9、-----------------------------------------------------------
echo "#查找系统中存在的SUID和SGID程序"

echo "Find the files have suid or Sgid"

echo "#-------------------------------------"

for PART in `grep -v ^# /etc/fstab | awk '($6 != "0") {print $2 }'`; do

find $PART −perm−04000−o−perm−02000 -type f -xdev -print |xargs ls  -ld

done

echo -n "Please check if the output is ok ? yes or no :"

read i

case $i in

y|yes)

break

;;

n|no)

echo "Please recheck the output!"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

continue

;;

*)

echo "please input yes or no"

;;

esac

#10、----------------------------------------------------------
echo "#查找系统中任何人都有写权限的目录"

echo "Find the directory everyone have the write right"

echo "#-------------------------------------"

for PART in `awk '($3 == "ext2" || $3 == "ext3") \

{ print $2 }' /etc/fstab`; do

find $PART -xdev -type d −perm−0002−a!−perm−1000 -print |xargs ls  -ld

done

echo -n "Please check if the output is ok ? yes or no :"

read i

case $i in

y|yes)

break

;;

n|no)

echo "Please recheck the output!"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

continue

;;

*)

echo "please input yes or no"

;;

esac

#11、----------------------------------------------------------
#echo "#查找系统中任何人都有写权限的文件"

echo "Find the files everyone have write right"

echo "#-------------------------------------"

for PART in `grep -v ^# /etc/fstab | awk '($6 != "0") {print $2 }'`; do

find $PART -xdev -type f −perm−0002−a!−perm−1000 -print |xargs ls -ld

done

echo -n "Please check if the output is ok ? yes or no :"

read i

case $i in

y|yes)

break

;;

n|no)

echo "Please recheck the output!"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

continue

;;

*)

echo "please input yes or no"

;;

esac

#12、----------------------------------------------------------
echo "#查找系统中没有属主的文件"

echo "Find no owner or no group files in system"

echo "#-------------------------------------"

for PART in `grep -v ^# /etc/fstab |grep -v swap| awk '($6 != "0") {print $2 }'`; do

find $PART -nouser -o -nogroup |grep  -v "vmware"|grep -v "dev"|xargs ls  -ld

done

echo -n "Please check if the output is ok ? yes or no :"

read i

case $i in

y|yes)

break

;;

n|no)

echo "Please recheck the output!"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

continue

;;

*)

echo "please input yes or no"

;;

esac

#13、----------------------------------------------------------
###echo "#查找系统中的隐藏文件"

##echo " Find the hiding file in system"

##echo "#-------------------------------------"

###linux执行报错\排除/dev”目录下的那些文件

####find  / -name "..∗"−o"…∗"−o".xx"−o".mail" -print -xdev

## #find  / -name "…*" -print -xdev | cat -v

##find  /  −name".∗"−o−name"…∗"−o−name".xx"−o−name".mail" -xdev

##echo -n "If you have check all the output files if correct yes or no ? :"

##read i

## case $i in

## y|yes)

## break

## ;;

## n|no)

## echo "Please recheck the output!"

## echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

## continue

## ;;

## *)

## echo "please input yes or no"

## ;;

## esac

##

#14、---------------------------------------------------------------------
echo "#判断日志与审计是否合规"

echo "Judge if the syslog audition if follow the rules"

echo "#-------------------------------------"

autmesg=`cat /etc/syslog.conf |egrep ^authpriv`

if [ ! -n "$autmesg" ]

then

echo "there don't have authpriv set in /etc/syslog.conf"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo -n "If you have know this y or n ?"

read i

case $i in

y|yes)

break

;;

n|no)

echo "there don't have authpriv set in /etc/syslog.conf"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

continue

;;

*)

echo "please input yes or no"

;;

esac

else

# echo "日志与审计合规"

echo "syslog audition follow the rules"

fi

#15、---------------------------------------------------------------------
echo "#关闭linux core dump"

echo "Turn off the system core dump"

echo "#-------------------------------------"

mesg1=`grep "* soft core 0" /etc/security/limits.conf`

mesg2=`grep "* hard core 0" /etc/security/limits.conf`

if [ ! -n "$mesg1" -o ! -n "$mesg2" ]

then

cp /etc/security/limits.conf /etc/security/limits.conf_$date

if [ ! -n "$mesg1" ]

then

echo "* soft core 0" >> /etc/security/limits.conf

fi

if [ ! -n "$mesg2" ]

then

echo "* hard core 0" >> /etc/security/limits.conf

fi

fi

#修改login文件使limits限制生效

cp /etc/pam.d/login /etc/pam.d/login_$date

echo "session required /lib/security/pam_limits.so" >> /etc/pam.d/login

#16、---------------------------------------------------------------------
#登录超时设置

#检查/etc/pam.d/system-auth文件是否存在account required /lib/security/pam_tally.so deny=的相关设置

#建议设置为auth required pam_tally.so onerr=fail deny=6 unlock_time=300

#17、---------------------------------------------------------------------
#su命令使用,对su命令使用进行限制设置

#检查/etc/pam.d/su文件设置

#文件中包含

#auth sufficient /lib/security/pam_rootok.so debug

#auth required /lib/security/pam_wheel.so group=isd

#20、---------------------------------------------------------------------
echo "#登录超时自动退出"

echo "set session time out terminal "

echo "#-------------------------------------"

tmout=`grep -i TMOUT /etc/profile`

if [ ! -n "$tmout" ]

then

echo

echo -n "do you want to set login timeout to 300s? [yes]:"

read i

case $i in

y|yes)

cp /etc/profile /etc/profile_$date

echo "export TMOUT=300" >> /etc/profile

. /etc/profile

;;

n|no)

break

;;

*)

echo "please input yes or no"

;;

esac

else

mesg=`echo $tmout |awk -F"=" '{print $2}'`

if [ "$mesg" -ne 300 ]

then

echo "The login session timeout is $mesg now will change to 300 seconds"

cp /etc/profile /etc/profile_$date

echo "export TMOUT=300" >> /etc/profile

. /etc/profile

fi

fi

sed  -i 's/HISTSIZE=1000/HISTSIZE=100/g' /etc/profile

#21、---------------------------------------------------------------------
echo "#禁用telnet启用ssh"

echo "Stop telnet and start up sshd"

echo "#-------------------------------------"

mesg1=`lsof -i:23`

mesg2=`lsof -i:22`

if [ ! -n "$mesg2" ]

then

service start sshd

chkconfig sshd on

mesg2=`lsof -i:22`

fi

if [ ! -n "$mesg1" -a ! -n "$mesg2" ]

then

echo

echo "Will Deactive telnet"

chkconfig krb5-telnet off

chkconfig ekrb5-telnet off

fi

#22、---------------------------------------------------------------------
#echo "#设置终端超时，使系统10分钟后自动退出不活动的Shell"

#echo "#-------------------------------------"

#mesg=`grep "export TMOUT=600" /etc/profile`

#if [ -z $mesg ]

#then

#echo "export TMOUT=600" >>/etc/profile

#. /etc/profile

#fi

#23、---------------------------------------------------------------------
echo "#禁用不必要的服务"

echo "Stop unuseing services"

echo "#-------------------------------------"

list="avahi-daemon bluetooth cups firstboot hplip ip6tables iptables iscsi iscsid isdn kudzu pcscd rhnsd rhsmcertd rpcgssd rpcidmapd sendmail smartd  yum-updatesd netfs portmap autofs nfslock nfs"

for i in $list

do

chkconfig $i off

service $i stop

done

echo "change kernel parameter for network secure"

cp  /etc/sysctl.conf /etc/sysctl.conf.$date

#echo "net.ipv4.icmp_echo_ignore_all = 1">>/etc/sysctl.conf

sysctl -a |grep arp_filter|sed -e 's/\=\ 0/\=\ 1/g' >>/etc/sysctl.conf

sysctl -a |grep accept_redirects|sed -e 's/\=\ 1/\=\ 0/g' >>/etc/sysctl.conf

sysctl -a |grep send_redirects|sed -e 's/\=\ 1/\=\ 0/g' >>/etc/sysctl.conf

sysctl -a |grep log_martians |sed -e 's/\=\ 0/\=\ 1/g'>>/etc/sysctl.conf

sysctl -p

#24、---------------------------------------------------------------------
echo "设置热键"

#ctrl+alt+del

if [ -d  /etc/init ]

then

sed  -i 's/^[^#]/#&/g' /etc/control-alt-delete.conf

else

sed -i 's/^ca::/#&/g' /etc/inittab

fi

#25、---------------------------------------------------------------------
echo "demo:禁止除了db2inst1的用户su到root"

usermod -G wheel db2inst1

sed -i '/pam_wheel.so use_uid/s/^#//g' /etc/pam.d/su

echo "SU_WHEEL_ONLY yes">>/etc/login.defs

http://www.jianshu.com/p/850ac59fae41

```
### 

```yml



```

### 鸟哥的Linux私房菜读书笔记--用户的特殊shell与PAM模块

```yml
鸟哥的Linux私房菜读书笔记--用户的特殊shell与PAM模块
2018年10月15日 16:44:24 小顽固哥 阅读数：269
 版权声明：本文属博主原创，转载请联系QQ528055624 https://blog.csdn.net/qq_41825534/article/details/83050345
问题：我们能否建立一个仅能使用的mail server相关邮件服务的账号，而该账号并不能登入Linux主机

1、特殊的shell、/sbin/nologin

由于系统账号不需要登入，我们就给这个无法登入的合法shell。所谓的无法登入是指这个使用者无法使用bash或其它shell来登入系统。如果我想让某个具有/sbin/nologin的使用者知道，他们不能登入主机时，可以建立/etc/nologin.txt这个文件，并且说明不能登入的原因，下次用户登陆的时候就会显示登录失败的原因。

2、PAM模块简介

在过去，我们对使用者进行认证的时候，要求用户输入账号密码，然后通过自行撰写的程序判断账号密码是否正确。由此，可以使用不同的机制来判断账号密码，导致一部主机上有多种认证系统，造成账号密码可能不同步的验证问题。因此有了PAM 机制。PAM是一套应用程序编程接口（Application Programming Interface，API）它提供了一连串的验证机制，只要使用者将验证阶段的需求告知PAM，PAM就能回报使用者验证的结果。由于PAM是一套验证机制，有可以提供给其他程序呼叫引用，因此无论什么程序，都可以使用PAM来进行验证。PAM是一个独立的API存在，只要任何程序有需求的时候就可以向PAM发出验证要求的通知。PAM用来验证的数据成为模块，每个模块的功能都不太相同 ，例如passwd的pam_cracklib.so模块的功能，它能够判断密码是否在字典里面，并汇报给密码修改程序，此时就可以了解你的密码强度了。所以当你有任何需要判断是否在字典当中的密码字符串时，就可以使用pam_cracklib.so模块的功能，并根据验证的回报结果来撰写你的程序。

3、PAM模块语法设定

呼叫PAM的流程：

（1） 用户开始执行 /usr/bin/passwd 这支程序，并输入密码；
（2）passwd 呼叫 PAM 模块进行验证；
（3） PAM 模块会到 /etc/pam.d/ 找寻与程序 (passwd) 同名的配置文件；
（4） 依据 /etc/pam.d/passwd 内的设定，引用相关的 PAM 模块逐步进行验证分析；
（5）将验证结果 (成功、失败以及其他讯息) 回传给 passwd 这支程序；
（6） passwd 这支程序会根据 PAM 回传的结果决定下一个动作 (重新输入新密码或者通过验证！)

由上可以看出，重点其实是/etc/pam.d里面的配置文件，以及配置文件呼叫的PAM模块进行的验证。

/etc/pam.d/passwd配置文件内容：

以上出现include这个关键词，其代表的是请呼叫后面的文件来这个类别的认证，所以上述每一行都要重复呼叫/etc/pam.d/system-auth这个文件来进行验证。

<1>第一个字段：验证类别（type）

（1）auth：是 authentication (认证) 的缩写，所以这种类别主要用来检验使用者的身份验证，这种类别通常是需要密码来检验的， 所以后续接的模块是用来检验用户的身份。
（2）account：account (账号) 则大部分是在进行 authorization (授权)，这种类别则主要在检验使用者是否具有正确的权限，举例来说，当你使用一个过期的密码来登入时，当然就无法正确的登入了。
（3）session：session 是会议期间的意思，所以 session 管理的就是使用者在这次登入 (或使用这个指令) 期间，PAM 所给予的环境设定。这个类别通常用在记录用户登入与注销时的信息！例如，如果你常常使用 su 或者是 sudo 指令的话， 那么应该可以在 /var/log/secure 里面发现很多关于 pam 的说明，而且记载的数据是『session open, session close』的信息！
（4）password：password 就是密码嘛！所以这种类别主要在提供验证的修订工作，举例来说，就是修改/变更密码啦！

这四个验证的类型通常是有顺序的，不过也有例外。 原因是，(1)我们总是得要先验证身份 (auth) 后， (2)系统才能够藉由用户的身份给予适当的授权与权限设定 (account)，而且(3)登入与注销期间的环境才需要设定， 也才需要记录登入与注销的信息 (session)。如果在运作期间需要密码修订时，(4)才给予 password 的类别。

<2>第二字段：验证的控制企标（control flag）

四种控制方式：

（1） required：此验证若成功则带有 success (成功) 的标志，若失败则带有 failure 的标志，但不论成功或失败都会继续后续的验证流程。 由于后续的验证流程可以继续进行，因此相当有利于资料的登录 (log) ，这也是 PAM 最常使用 required 的原因。
（2）requisite：若验证失败则立刻回报原程序 failure 的标志，并终止后续的验证流程。若验证成功则带有 success 的标志并继续后续的验证流程。 这个项目与 required 最大的差异，就在于失败的时候还要不要继续验证下去？由于 requisite 是失败就终止， 因此失败时所产生的 PAM 信息就无法透过后续的模块来记录了。
（3）sufficient：若验证成功则立刻回传 success 给原程序，并终止后续的验证流程；若验证失败则带有 failure 标志并继续
后续的验证流程。 这玩意儿与 requisits 刚好相反！
（4）optional：这个模块控件目大多是在显示讯息而已，并不是用在验证方面的。


控制旗标所造成的回报流程
4、常用模块简介

模块信息：

· /etc/pam.d/*：每个程序个别的 PAM 配置文件；
· /lib64/security/*：PAM 模块文件的实际放置目录；
· /etc/security/*：其他 PAM 环境的配置文件；
· /usr/share/doc/pam-*/：详细的 PAM 说明文件。
常见模块：

· pam_securetty.so：
限制系统管理员 (root) 只能够从安全的 (secure) 终端机登入；那什么是终端机？例如 tty1, tty2 等就是传统的终端机装置名称。安全的终端机设定写在 /etc/securetty 这个文件中。你可以查阅一下该文件， 就知道为什么 root 可以从 tty1~tty7 登入，但却无法透过 telnet 登入 Linux 主机了！

· pam_nologin.so：
这个模块可以限制一般用户是否能够登入主机之用。当 /etc/nologin 这个文件存在时，则所有一般使用者均无法再登入系统了！若 /etc/nologin 存在，则一般使用者在登入时， 在他们的终端机上会将该文件的内容显示出来！所以，正常的情况下，这个文件应该是不能存在系统中的。 但这个模块对 root 以及已经登入系统中的一般账号并没有影响。 (注意这与 /etc/nologin.txt 并不相同)

· pam_selinux.so：
SELinux 是个针对程序来进行细部管理权限的功能，SELinux 这玩意儿我们会在第十六章的时候再来详细谈论。由于 SELinux 会影响到用户执行程序的权限，因此我们利用 PAM 模块，将 SELinux 暂时关闭，等到验证通过后， 再予以启动！

· pam_console.so：
当系统出现某些问题，或者是某些时刻你需要使用特殊的终端接口 (例如 RS232 之类的终端联机设备) 登入主机时， 这个模块可以帮助处理一些文件权限的问题，让使用者可以透过特殊终端接口 (console) 顺利的登入系统。

· pam_loginuid.so：
我们知道系统账号与一般账号的 UID 是不同的！一般账号 UID 均大于 1000 才合理。 因此，为了验证
使用者的 UID 真的是我们所需要的数值，可以使用这个模块来进行规范！

· pam_env.so：
用来设定环境变量的一个模块，如果你有需要额外的环境变量设定，可以参考 /etc/security/pam_env.conf 这个文件的详细说明。

· pam_unix.so：
这是个很复杂且重要的模块，这个模块可以用在验证阶段的认证功能，可以用在授权阶段的账号许可证管理， 可以用在会议阶段的登录文件记录等，甚至也可以用在密码更新阶段的检验！非常丰富的功能！ 这个模块在早期使用得相当频繁喔！

· pam_pwquality.so：
可以用来检验密码的强度！包括密码是否在字典中，密码输入几次都失败就断掉此次联机等功能，都是这模块提供的！ 最早之前其实使用的是 pam_cracklib.so 这个模块，后来改成 pam_pwquality.so 这个模块，但此模块完全兼容于 pam_cracklib.so， 同时提供了 /etc/security/pwquality.conf 这个文件可以额外指定默认值！比较容易处理修改！

· pam_limits.so：
还记得我们在第十章谈到的 ulimit 吗？ 其实那就是这个模块提供的能力！还有更多细部的设定可以考：/etc/security/limits.conf 内的说明。

 login 的 PAM 验证机制流程：
（1） 验证阶段 (auth)：首先，(a)会先经过 pam_securetty.so 判断，如果使用者是 root 时，则会参考 /etc/securetty 的设定； 接下来(b)经过 pam_env.so 设定额外的环境变量；再(c)透过 pam_unix.so 检验密码，若通过则回报 login 程序；若不通过则(d)继续往下以 pam_succeed_if.so 判断 UID 是否大于 1000 ，若小于 1000 则回报失败，否则再往下 (e)以 pam_deny.so 拒绝联机。
（2） 授权阶段 (account)：(a)先以 pam_nologin.so 判断 /etc/nologin 是否存在，若存在则不许一般使用者登入；(b)接下来以 pam_unix.so 及 pam_localuser.so 进行账号管理，再以 (c) pam_succeed_if.so 判断 UID 是否小于 1000 ，若小于 1000 则不记录登录信息。(d)最后以 pam_permit.so 允许该账号登入。
（3）密码阶段 (password)：(a)先以 pam_pwquality.so 设定密码仅能尝试错误 3 次；(b)接下来以 pam_unix.so 透
过 sha512, shadow 等功能进行密码检验，若通过则回报 login 程序，若不通过则 (c)以 pam_deny.so 拒绝登入。
（4）会议阶段 (session)：(a)先以 pam_selinux.so 暂时关闭 SELinux；(b)使用 pam_limits.so 设定好用户能够操作的系统资源； (c)登入成功后开始记录相关信息在登录文件中； (d)以 pam_loginuid.so 规范不同的 UID 权限；(e)开启 pam_selinux.so 的功能。

例题：
为什么 root 无法以 telnet 直接登入系统，但是却能够使用 ssh 直接登入？
答：一般来说， telnet 会引用 login 的 PAM 模块，而 login 的验证阶段会有 /etc/securetty 的限制！ 由于远程联机属于 pts/n (n 为数字) 的动态终端机接口装置名称，并没有写入到 /etc/securetty ， 因此 root 无法以 telnet 登入远程主机。至于 ssh 使用的是 /etc/pam.d/sshd 这个模块， 你可以查阅一下该模块，由于该模块的验证阶段并没有加入 pam_securetty ，因此就没有/etc/securetty 的限制！故可以从远程直接联机到服务器端。

5、其他相关文件

/etc/securetty 会影响到 root 可登入的安全终端机， /etc/nologin 会影响到一般使用者是否能够登入的功能之外，我们也知道 PAM 相关的配置文件在 /etc/pam.d ， 说明文件在/usr/share/doc/pam-(版本) ，模块实际在 /lib64/security/ 。相关的 PAM 文件主要都在 /etc/security 这个目录内

<1>limits.conf
我们在第十章谈到的 ulimit 功能中， 除了修改使用者的 ~/.bashrc 配置文件之外，其实系统管理员可以统一藉由 PAM 来管理的！ 那就是 /etc/security/limits.conf 这个文件的设定。这个文件的设定很简单，你可以自行参考一下该文件内容。 我们这里仅作个简单的介绍：
范例一：vbird1 这个用户只能建立 100MB 的文件，且大于 90MB 会警告
[root@study ~]# vim /etc/security/limits.conf
vbird1    soft          fsize         90000
vbird1   hard          fsize       100000
#账号  限制依据  限制项目   限制值
# 第一字段为账号，或者是群组！若为群组则前面需要加上 @ ，例如 @projecta
# 第二字段为限制的依据，是严格(hard)，还是仅为警告(soft)；
# 第三字段为相关限制，此例中限制文件容量，
# 第四字段为限制的值，在此例中单位为 KB。
[vbird1@study ~]$ ulimit -a
....(前面省略)....
file size (blocks, -f) 90000
....(后面省略)....
[vbird1@study ~]$ dd if=/dev/zero of=test bs=1M count=110
File size limit exceeded
[vbird1@study ~]$ ll --block-size=K test
-rw-rw-r--. 1 vbird1 vbird1 90000K Jul 22 01:33 test
# 果然有限制到了
范例二：限制 pro1 这个群组，每次仅能有一个用户登入系统 (maxlogins)
[root@study ~]# vim /etc/security/limits.conf
@pro1 hard maxlogins 1
# 如果要使用群组功能的话，这个功能似乎对初始群组才有效喔！而如果你尝试多个 pro1 的登入时，
# 第二个以后就无法登入了。而且在 /var/log/secure 文件中还会出现如下的信息：
# pam_limits(login:session): Too many logins (max 1) for pro1
这个文件挺有趣的，而且是设定完成就生效了

<2> /var/log/secure, /var/log/messages
如果发生任何无法登入或者是产生一些你无法预期的错误时，由于 PAM 模块都会将数据记载在/var/log/secure 当中，所以发生了问题请务必到该文件内去查询一下问题点！举例来说， 我们在 limits.conf 的介绍内的范例二，就有谈到多重登入的错误可以到 /var/log/secure 内查阅了。

```
### 

```yml



```

### Linux 下修改或者重命名用户名称或者UID/GID

```yml
Linux 下修改或者重命名用户名称或者UID/GID
96  全栈运维 
2016.12.23 17:53* 字数 278 阅读 3274评论 0喜欢 4
摘要
在Linux操作系统下怎么样用命令行去修改用户的名称（也就是重命名），或者UID/GID
切记不要手动用vi之类的文本编辑器去修改 /etc/passwd 文件

修改用户名称
Usage:

usermod -l login-name old-name
修改用户的名称 old-name 改成 login-name，别的都没有改变。其实我们也应该考虑是否把用户的HOME目录也改成新的用户。

另外这里有个问题需要注意

如果出现如下报错

root@pts/0 $ usermod -l newjames james
usermod: user James is currently used by process 12345
说明有用james用户运行的程序，需要把相关的程序停掉之后再执行上面的命令

Examples:

## add user 'james' for test
root@pts/0 $ useradd james

## check original id
root@pts/0 $ id james
uid=1007(james) gid=1008(james) 组=1008(james)

## check HOME directory
root@pts/0 $ ls -ld /home/james/
drwx------ 2 james james 4096 12月 23 11:46 /home/james/

## try to change or rename and verify
root@pts/0 $ usermod -l newjames james

root@pts/0 $ id james
id: james: no such user

root@pts/0 $ id newjames
uid=1007(newjames) gid=1008(james) 组=1008(james)


## check HOME folder
root@pts/0 $ ls -ld /home/james/
drwx------ 2 newjames james 4096 12月 23 11:46 /home/james/

root@pts/0 $ ls -ld /home/newjames
ls: 无法访问/home/newjames: 没有那个文件或目录
Dev-web-solr [~] 2016-12-23 11:47:22
root@pts/0 $
从上面可以看出，变化只仅仅是username，UID/GUID/HOME目录都没有改变

修改UID/GID相对很简单，结合上面的例子。继续如下：

修改UID
Usage:

usermod -u NEW-UID username
Examples:

## original UID is 1007
root@pts/0 $ id newjames
uid=1007(newjames) gid=1008(james) 组=1008(james)

## change 1007 to 2007
root@pts/0 $ usermod -u 2007 newjames

## modified to 2007
root@pts/0 $ id newjames
uid=2007(newjames) gid=1008(james) 组=1008(james)
修改GID/group-name
Usage:

groupmod -g NEW-GID groupname
Examples:

## james to newjames, but james's group is still 'james'
root@pts/0 $ groupmod -g 2007 newjames
groupmod：“newjames”组不存在

root@pts/0 $ id newjames
uid=2007(newjames) gid=1008(james) 组=1008(james)

root@pts/0 $ groupmod -g 2007 james

## try to rename group
root@pts/0 $ groupmod --help
用法：groupmod [选项] 组

选项:
  -g, --gid GID                 将组 ID 改为 GID
  -h, --help                    显示此帮助信息并推出
  -n, --new-name NEW_GROUP      改名为 NEW_GROUP
  -o, --non-unique              允许使用重复的 GID
  -p, --password PASSWORD   将密码更改为(加密过的) PASSWORD
  -R, --root CHROOT_DIR         chroot 到的目录


root@pts/0 $ groupmod -n newjamesgroup james


## find that group was renamed
root@pts/0 $ id newjames
uid=2007(newjames) gid=1008(newjamesgroup) 组=1008(newjamesgroup)


## try to change GID
root@pts/0 $ groupmod -g 2007 james

root@pts/0 $ id newjames
uid=2007(newjames) gid= 2007(newjamesgroup) 组= 2007(newjamesgroup)
修改用户HOME显示
最后我们来考虑下前面说过的rename用户名称之后，HOME家目录的显示没有改变。

Usage:

usermod -d /home/new-user -m new-user
Examples:

root@pts/0 $ ls -ld /home/james
drwx------ 2 newjames 1008 4096 12月 23 11:46 /home/james

root@pts/0 $ ls -ld /home/newjames
ls: 无法访问/home/newjames: 没有那个文件或目录

## change HOME folder
root@pts/0 $ usermod -d /home/newjames -m newjames

root@pts/0 $ ls -ld /home/newjames
drwx------ 2 newjames 1008 4096 12月 23 11:46 /home/newjames

root@pts/0 $ ls -ld /home/james
ls: 无法访问/home/james: 没有那个文件或目录
root@pts/0 $

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

### 

```yml


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

### 

```yml


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

### 

```yml


```