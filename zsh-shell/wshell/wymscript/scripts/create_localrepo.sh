#!/bin/sh
# File    :   create_localrepo.sh
# Time    :   2019/03/27 17:40:44
# Author  :   wang yuming 
# Version :   0.1
# License :   (C)Copyright 2018-2019, MIT
# Desc    :   用于创建rpm包本地yum源

Is_Yum_Avaliable=`which yum`
if [[ Is_Yum_Available == "" ]]; then
	echo -e "Info: Please make sure yum command is available"
	exit 1
fi

#/opt/wokishell/software
cd ../software  # 当前位置跳到安装包位置
#echo -e $(pwd)
#上级目录设置为变量
RPMPath=$(dirname $(readlink -f $0))
echo -e "rpm包目录："$RPMPath
read -p "请输入本地rpm包路径:" CDPath
if [ -z "$CDPath" ];then
    CDPath=$RPMPath #"/opt/wokishell/software"
fi
#if [[ ! -d $CDPath ]]; then
#	echo -e "Info: The path is not a directory"
#	exit 1
#fi

echo -n -e "\e[1;31m****** 本地rpm包路径:\e[0m"
echo $CDPath

# 使用createrepo生成符合要求的yum仓库
createrepo $CDPath
 
#localrepo
read -p "请输入本地rpm包源名称:默认localrepo" name
if [ -z "$name" ];then
    name="localrepo"
fi

repoName="$name".repo
repoPath="/etc/yum.repos.d/${name}.repo"
 
if [[ -f $repoPath ]]; then
	echo -e "Info: 文件 $repoPath 已经存在"
	exit 1
fi
touch $repoPath
chmod 644 $repoPath
echo "[localrepos]" >> $repoPath
echo "name=$name" >> $repoPath
echo "baseurl=file://$CDPath" >> $repoPath
echo "enabled=1" >> $repoPath
echo "gpgcheck=0" >> $repoPath
 
yum clean all
yum makecache

echo -e $(yum repolist)
echo -e "\e[1;31m****** 本地rpm包YUM源安装成功 ******\e[0m"