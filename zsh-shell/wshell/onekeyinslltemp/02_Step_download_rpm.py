#!/usr/bin/python
# -*- coding: UTF-8 -*-

import  os

# shell命令
# yum install -y ansible --downloadonly --downloaddir=ansible
# yum install -y createrepo --downloadonly --downloaddir=createrepo
# yum install -y --downloadonly --downloaddir=/oracle/rpmpackage/docker-ce docker-ce-18.06.1.ce

## 默认都在/opt目录下操作，路径/opt/wokishell/software
## 打印当前路径
print os.getcwd() #获取当前工作目录路径

savedir = os.getcwd() + '/software'
print '下载保存路径=',savedir

# 定义ansible需要yum离线缓存的list表
softwares = ['ansible','createrepo','docker-ce-18.06.1.ce','wget','vim','tree','net-tools','ntp','deltarpm','libxml2-python']
for software in softwares:
   print '当前下载 :', software
   print os.system("date") ## 使用os模块执行shell命令
   print '执行下载：', os.system("yum install -y %s --downloadonly --downloaddir=%s" % (software,savedir)) ## 使用%s拼接字符串 

print '============== 下载完毕 ===================='
