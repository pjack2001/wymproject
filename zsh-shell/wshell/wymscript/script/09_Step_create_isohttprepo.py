#!/usr/bin/python
# -*- coding: UTF-8 -*-

import  os

# 配置光盘源
#mkdir -p /opt/cdrom
#mount -t iso9660 -o loop /oracle/CentOS-7-x86_64-DVD-1804.iso /opt/cdrom/

# 打印当前路径
print '========== 当前目录：',os.getcwd() #获取当前工作目录路径

# 设置光盘挂载文件路径
softwaredir = os.getcwd() + '/cdrom'
print '========== 光盘挂载路径:',softwaredir

## 使用离线yum源安装httpd
def install_httpd():
    os.system("yum install -y httpd")
    os.system("systemctl start httpd.service")
    os.system("systemctl stop firewalld.service")

print '========== 使用离线yum源安装httpd =========='
install_httpd()


# 配置光盘挂载目录
def install_isorepo():
    os.system("mkdir -p /var/www/html/centos/7/os/x86_64/")
    os.system("mount -t iso9660 -o loop /oracle/CentOS-7-x86_64-DVD-1804.iso /var/www/html/centos/7/os/x86_64/")
    print('========== 挂载光盘 ==========')

install_isorepo()

# 打印光盘挂载目录
softwaredir = os.getcwd() + '/cdrom'

# 构建离线光盘yum源
# Please input the path which had mounte
# d the CD:/opt/cdrom
# Please input the local yum repository name:localiso

def create_yum_isohttprepo():
    os.system("sh create_isohttprepo.sh")
    print '========== 创建光盘yum源 =========='

create_yum_isohttprepo()

## 使用离线光盘yum源测试安装
def install_tree():
    os.system("yum install -y tree")

print '========== 使用光盘yum源测试安装tree =========='
install_tree()

## 删除
def remove_tree():
    os.system("yum remove -y tree")

print '========== 测试完成，删除tree =========='
remove_tree()