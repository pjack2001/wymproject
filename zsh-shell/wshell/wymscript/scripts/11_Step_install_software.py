#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@File    :   11_Step_install_software.py
@Time    :   2019/03/27 14:17:06
@Author  :   wangyuming 
@Version :   0.1
@License :   (C)Copyright 2018-2019, MIT
@Desc    :   None
'''

import os

# shell命令 - 安装createrepo

# 打印当前路径
print os.getcwd()  #获取当前工作目录路径


## 使用离线yum源安装
def install_wget():
    os.system("yum install -y ntp")


print '****** 使用离线yum源安装ntp'
install_wget()


## 使用离线yum源安装ansible
def install_ansible():
    os.system("yum install -y ansible")
    os.system("ansible --version")


print '****** 使用离线yum源安装ansible'
install_ansible()


## 使用离线yum源安装docker-ce-18.06.1.ce
def install_docker():
    os.system("yum install -y docker-ce-18.06.1.ce")


print '****** 使用离线yum源安装docker-ce-18.06.1.ce'
install_docker()
