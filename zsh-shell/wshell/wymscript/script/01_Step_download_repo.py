#!/usr/bin/python
# -*- coding: UTF-8 -*-

# shell命令
#sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#sudo yum clean all && yum makecache

## 替换阿里源
import subprocess
import sys
import os
def main():
    try:
        subprocess.call(["ls -a /etc/yum.repos.d/"], shell=True)
        subprocess.call(["yum install wget -y;cd /etc/yum.repos.d/ && mkdir repo_bak && mv *.repo repo_bak/"], shell=True)
        subprocess.call(["wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo"], shell=True)
        subprocess.call(["wget -O /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo"], shell=True)
        subprocess.call(["wget -O /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"], shell=True)
        subprocess.call(["yum clean all && yum makecache && yum repolist"], shell=True)
        subprocess.call(["ls -a /etc/yum.repos.d/"], shell=True)
        #subprocess.call([""], shell=True)
        sys.exit(0)
    except Exception as e:
        print(e)
        sys.exit(1)
if __name__ == '__main__':
    main()

print '============== 替换YUM源完毕 ===================='