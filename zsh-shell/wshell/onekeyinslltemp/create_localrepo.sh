
#!/bin/sh
#脚本--用于创建本地yum源

Is_Yum_Avaliable=`which yum`
if [[ Is_Yum_Available == "" ]]; then
	echo -e "Info: Please make sure yum command is available"
	exit 1
fi

#/opt/wokishell/software
# read -p "Please input the path which had mounted the CD:" CDPath
read -p "请输入本地rpm包路径:" CDPath
if [[ ! -d $CDPath ]]; then
	echo -e "Info: The path is not a directory"
	exit 1
fi

# 使用createrepo生成符合要求的yum仓库
createrepo $CDPath

#CDFile=`echo $CDPath | cut -d ' ' -f 1`
#if [[ `lsblk -ls | grep $CDFile` == "" ]]; then
#	echo -e "Info: The path is not corresponding to the block device"
#	exit 1
#fi

#光盘挂载路径可能有空格，不容于baseurl字段
#ln -s $CDPath $CDFile
 
#localrepo
#read -p "Please input the local yum repository name:" name
read -p "请输入本地rpm包源名称:" name
repoName="$name".repo
repoPath="/etc/yum.repos.d/${name}.repo"
 
if [[ -f $repoPath ]]; then
	echo -e "Info: The file $repoPath already exist"
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
 
echo -e "Info: The local yum repository create, Success"
