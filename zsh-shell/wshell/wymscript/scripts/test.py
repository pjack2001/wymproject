#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import os
# 打印当前路径
print '****** 当前目录：', os.getcwd()  #获取当前工作目录路径

# 设置光盘挂载文件路径
softwaredir = os.getcwd() + '/cdrom'
print '****** 光盘挂载路径:', softwaredir


os.mkdir(softwaredir)
    print('****** 挂载光盘 ******')

os.system(
        "yum install -y %s --downloadonly --downloaddir=%s" %
        (software, savedir)), ' ******'