#!/usr/bin/python
# -*- coding: UTF-8 -*-

import  os

# shell命令 - 安装createrepo

# 打印当前路径
print os.getcwd() #获取当前工作目录路径

## 使用离线yum源安装
def install_wget():
    os.system("yum install -y wget vim tree net-tools ntp")

print '========== 使用离线yum源安装wget vim tree net-tools ntp'
install_wget()

## 使用离线yum源安装ansible
def install_ansible():
    os.system("yum install -y ansible")
    os.system("ansible --version")    

print '========== 使用离线yum源安装ansible'
install_ansible()

## 使用离线yum源安装docker-ce-18.06.1.ce
def install_docker():
    os.system("yum install -y docker-ce-18.06.1.ce")

print '========== 使用离线yum源安装docker-ce-18.06.1.ce'
install_docker()
