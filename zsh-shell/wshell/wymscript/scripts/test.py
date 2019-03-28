#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import os
# 打印当前路径
print '****** 当前目录：', os.getcwd()  #获取当前工作目录路径

# 设置光盘挂载文件路径
softwaredir = os.getcwd() + '/cdrom'
print '****** 光盘挂载路径:', softwaredir

if not os.path.exists(softwaredir):
    os.mkdir(softwaredir)
    print 'Successfully created directory', softwaredir

print('****** 列出目录下文件 ******')

#os.system("ls %s" % (softwaredir)), ' ******'
dirs = os.listdir(softwaredir)

# 输出所有文件和文件夹
for file in dirs:
    print file

pathkey = os.path.expanduser('~/.ssh/key')

print pathkey
