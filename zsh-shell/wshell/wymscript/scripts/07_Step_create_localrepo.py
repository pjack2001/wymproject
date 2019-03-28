#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@File    :   07_Step_create_localrepo.py
@Time    :   2019/03/27 14:16:34
@Author  :   wang yuming 
@Version :   0.1
@License :   (C)Copyright 2018-2019, MIT
@Desc    :   None
'''

import os

# shell命令 - 安装createrepo
# rpm -ivh deltarpm-3.6-3.el7.x86_64.rpm
# rpm -ivh python-deltarpm-3.6-3.el7.x86_64.rpm
# rpm -ivh libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm
# rpm -ivh createrepo-0.9.9-28.el7.noarch.rpm

# 打印当前路径
print '****** 当前目录：', os.getcwd()  #获取当前工作目录路径

# 设置下载rpm的文件路径
softwaredir = os.path.abspath(os.path.dirname(os.getcwd())) + '/software'
print '****** rpm包下载保存路径:', softwaredir


# rpm方式安装createrepo
def install_createrepo():
    os.system("rpm -ivh %s/deltarpm-3.6-3.el7.x86_64.rpm" % (softwaredir))
    os.system(
        "rpm -ivh %s/python-deltarpm-3.6-3.el7.x86_64.rpm" % (softwaredir))
    os.system("rpm -ivh %s/libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm" %
              (softwaredir))
    os.system("rpm -ivh %s/createrepo-0.9.9-28.el7.noarch.rpm" % (softwaredir))
    print('****** 安装createrepo ******')


install_createrepo()

# 构建离线本地rpm包yum源
print '****** 创建rpm包yum离线源 ****** '


def create_yum_localrepo():
    os.system("sh create_localrepo.sh")


create_yum_localrepo()

# 打印当前路径
print '****** 当前目录：', os.getcwd()  #获取当前工作目录路径

# 安装必备的软件vim net-tools

print '****** 安装必备的软件wget vim net-tools ******'


def install_vim():
    os.system("yum install -y wget vim net-tools zip unzip")


install_vim()

print '****** 使用本地yum源测试安装tree ******'


## 使用离线yum源测试安装
def install_tree():
    os.system("yum install -y tree")


install_tree()

print '****** 测试完成，删除tree ******'


## 删除
def remove_tree():
    os.system("yum remove -y tree")


remove_tree()

print '****** 列出YUM源文件 ******'
yumdirs = '/etc/yum.repos.d/'
dirs = os.listdir(yumdirs)
# 输出所有文件和文件夹
for file in dirs:
    print file
