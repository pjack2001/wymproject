#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@File    :   09_Step_create_isohttprepo.py
@Time    :   2019/03/27 14:16:56
@Author  :   wang yuming 
@Version :   0.1
@License :   (C)Copyright 2018-2019, MIT
@Desc    :   配置光盘作为网络源，必须可以安装httpd
'''

import os

#mkdir -p /opt/cdrom
#mount -t iso9660 -o loop /opt/CentOS-7-x86_64-DVD-1804.iso /opt/cdrom/

# 打印当前路径
print '****** 当前目录：', os.getcwd()  #获取当前工作目录路径
print '****** 上级目录：', os.path.abspath(os.path.dirname(os.getcwd()))

#打印光盘路径
isodir = os.path.abspath(os.path.dirname(
    os.getcwd())) + '/CentOS-7-x86_64-DVD-1804.iso'
print '****** iso光盘路径:', isodir

# 打印光盘挂载文件路径
cddir = os.path.abspath(os.path.dirname(os.getcwd())) + '/cdrom'


## 使用离线yum源安装httpd
def install_httpd():
    os.system("yum install -y httpd")
    os.system("systemctl start httpd.service")
    os.system("systemctl stop firewalld.service")


print '****** 使用离线yum源安装httpd ******'
install_httpd()

# 打印光盘挂载http路径
httpdir = '/var/www/html/centos/7/os/x86_64/'

#建立httpdir目录
if not os.path.exists(httpdir):
    os.makedirs(httpdir)
    print 'Successfully created directory', httpdir

print '****** 光盘挂载路径:', httpdir

# 挂载光盘
os.system("mount -t iso9660 -o loop %s %s" % (isodir, httpdir))

print('****** 挂载光盘 ******')

# 构建离线光盘yum源


def create_yum_isohttprepo():
    os.system("sh create_isohttprepo.sh")
    print '****** 创建光盘网络yum源 ******'


create_yum_isohttprepo()

## 使用离线光盘yum源测试安装
print '****** 使用光盘网络yum源测试安装tree ******'


def install_tree():
    os.system("yum install -y tree")


install_tree()

## 删除
print '****** 测试完成，删除tree ******'


def remove_tree():
    os.system("yum remove -y tree")


remove_tree()

print '****** 列出YUM源文件 ******'
yumdirs = '/etc/yum.repos.d/'
dirs = os.listdir(yumdirs)
# 输出所有文件和文件夹
for file in dirs:
    print file
