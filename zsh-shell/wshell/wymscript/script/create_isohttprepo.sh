
#!/bin/sh
#脚本--用于创建本地yum源
#mkdir -p /opt/cdrom
#mount -t iso9660 -o loop /oracle/CentOS-7-x86_64-DVD-1804.iso /opt/cdrom/
#set -xv
#exec 1>mylog 2>&1 #shell命令输出log

Is_Yum_Avaliable=`which yum`
if [[ Is_Yum_Available == "" ]]; then
	echo -e "Info: Please make sure yum command is available"
	exit 1
fi

# read -p "Please input the path which had mounted the CD:" CDPath
read -p "请输入光盘挂载路径:/var/www/html/centos/7/os/x86_64/" CDPath
if [ -z "$CDPath" ];then
    CDPath="/var/www/html/centos/7/os/x86_64/"
fi
#if [[ ! -d $CDPath ]]; then
#	echo -e "Info: The path is not a directory"
#	exit 1
#fi

#CDFile=`echo $CDPath | cut -d ' ' -f 1`


#read -p "Please input the local yum repository name:" name
read -p "请输入光盘yum源名称:localhttpd" name
if [ -z "$name" ];then
    name="localhttpd"
fi

# 限定网卡，需要改为变量
ipaddr=$(ifconfig eth1 |grep -o "[0-9.]\{7,\}" |head -n1)
echo -e "eth1网卡的IP地址：" $ipaddr

ver=$(rpm -q --qf %{version} centos-release;echo)
arch=$(rpm -q --qf %{arch} centos-release;echo)


repoName="$name".repo
repoPath="/etc/yum.repos.d/${name}.repo"

if [[ -f $repoPath ]]; then
	echo -e "Info: The file $repoPath already exist"
	exit 1
fi
touch $repoPath
chmod 644 $repoPath
echo "[localisorepos]" >> $repoPath
echo "name=$name" >> $repoPath
echo "baseurl=http://$ipaddr/centos/$ver/os/$arch" >> $repoPath
echo "gpgkey=http://$ipaddr/centos/$ver/os/x86_64/RPM-GPG-KEY-CentOS-$ver" >> $repoPath
echo "enabled=1" >> $repoPath
echo "gpgcheck=1" >> $repoPath

#http://$ipaddr/centos/7/os/x86_64/
#echo "baseurl=http://$ipaddr/centos/$releasever/os/$basearch"
#echo "gpgkey=http://$ipaddr/centos/$releasever/os/x86_64/RPM-GPG-KEY-CentOS-$releasever" 

yum clean all
yum makecache

echo -e $(yum repolist)
echo -e "\e[1;31m========== 本地网络YUM源安装成功 ==========\e[0m"

#This is red text?\e[1;31m 将颜色设置为红色
#?\e[0m 将颜色重新置回
#颜色码：重置=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，洋红=35，青色=36，白色=37


#另一种方法
#cat rhel7.repo.sh
##!/bin/bash

#cat > /etc/yum.repos.d/local.repo <<FOF
#[local]
#name=local
#baseurl=file:///media/cdrom
#gpgcheck=0
#enabled=1
#FOF

#mkdir -p /media/cdrom
#mount /dev/cdrom /media/cdrom
#echo "/dev/cdrom /media/cdrom iso9660 defaults 0 0" >> /etc/fstab

#yum clean all && yum makecache && echo "yum clean"

#写完脚本后记得赋予脚本执行权限：
#chmod 755 rhel7.repo.sh或者chmod +x rhel7.repo.sh

