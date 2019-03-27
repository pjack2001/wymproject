#!/bin/sh
# File    :   create_isorepo.sh
# Time    :   2019/03/27 17:40:26
# Author  :   wang yuming 
# Version :   0.1
# License :   (C)Copyright 2018-2019, MIT
# Desc    :   用于创建光盘本地yum源

#mkdir -p /opt/cdrom
#mount -t iso9660 -o loop /opt/CentOS-7-x86_64-DVD-1804.iso /opt/cdrom/

Is_Yum_Avaliable=`which yum`
if [[ Is_Yum_Available == "" ]]; then
	echo -e "Info: Please make sure yum command is available"
	exit 1
fi

#/opt/cdrom 
cd ../cdrom  # 当前位置跳到cdrom位置
#上级目录设置为变量
CDROMPath=$(dirname $(readlink -f $0))
echo -e "光盘挂载目录："$CDROMPath
read -p "请输入光盘挂载路径:" CDPath
if [ -z "$CDPath" ];then
    CDPath=$CDROMPath #"/opt/cdrom"
fi
if [[ ! -d $CDPath ]]; then
	echo -e "Info: The path is not a directory"
	exit 1
fi
# CDFile=`echo $CDPath | cut -d ' ' -f 1`
# if [[ `lsblk -ls | grep $CDFile` == "" ]]; then
# 	echo -e "Info: The path is not corresponding to the block device"
# 	exit 1
# fi
# #光盘挂载路径可能有空格，不容于baseurl字段
# ln -s $CDPath $CDFile

#localiso 
read -p "请输入光盘yum源名称:默认localiso" name
if [ -z "$name" ];then
    name="localiso"
fi

repoName="$name".repo
repoPath="/etc/yum.repos.d/${name}.repo"
 
if [[ -f $repoPath ]]; then
	echo -e "Info: 文件 $repoPath 已经存在"
	exit 1
fi
touch $repoPath
chmod 644 $repoPath
echo "[localisorepos]" >> $repoPath
echo "name=$name" >> $repoPath
echo "baseurl=file://$CDPath" >> $repoPath
echo "enabled=1" >> $repoPath
echo "gpgcheck=0" >> $repoPath
 
yum clean all
yum makecache
 
echo -e $(yum repolist)
echo -e "\e[1;31m****** 本地光盘YUM源安装成功 ******\e[0m"


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

		                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         