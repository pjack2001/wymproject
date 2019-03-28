#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@File    :   08_Step_create_isorepo.py
@Time    :   2019/03/27 17:44:12
@Author  :   wang yuming 
@Version :   0.1
@License :   (C)Copyright 2018-2019, MIT
@Desc    :   None
'''

import os

# 配置光盘源
#mkdir -p /opt/cdrom
#mount -t iso9660 -o loop /oracle/CentOS-7-x86_64-DVD-1804.iso /opt/cdrom/

# 打印当前路径
print '****** 当前目录：', os.getcwd()  #获取当前工作目录路径
print '****** 上级目录：', os.path.abspath(os.path.dirname(os.getcwd()))

#打印光盘路径
isodir = os.path.abspath(os.path.dirname(
    os.getcwd())) + '/CentOS-7-x86_64-DVD-1804.iso'
print '****** iso光盘路径:', isodir

# 打印光盘挂载文件路径
cddir = os.path.abspath(os.path.dirname(os.getcwd())) + '/cdrom'

#建立cdrom目录
if not os.path.exists(cddir):
    os.makedirs(cddir)
    print 'Successfully created directory', cddir

print '****** 光盘挂载路径:', cddir
#挂载光盘
#mount -t iso9660 -o loop /opt/CentOS-7-x86_64-DVD-1804.iso /opt/cdrom/
os.system("mount -t iso9660 -o loop %s %s" % (isodir, cddir))

print('****** 挂载光盘 ******')

# 构建离线光盘yum源


def create_yum_isorepo():
    os.system("sh create_isorepo.sh")
    print '****** 创建光盘yum源 ******'


create_yum_isorepo()

## 使用离线光盘yum源测试安装
print '****** 使用光盘yum源测试安装tree ******'


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
