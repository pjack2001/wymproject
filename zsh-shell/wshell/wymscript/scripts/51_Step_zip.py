#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@File    :   51_Step_zip.py
@Time    :   2019/03/27 23:58:13
@Author  :   wangyuming 
@Version :   0.1
@License :   (C)Copyright 2018-2019, MIT
@Desc    :   None
'''

import os
import time

source = ['/opt/wokishell/scripts/', '/opt/wokishell/software/']

target_dir = '/opt/wokishell/backup'  #这是绝对路径
#target_dir = './backup'这个地方是相对路径
today = target_dir + time.strftime('%Y%m%d')

now = time.strftime('%H%M%S')
print '****** 准备 ******'
if not os.path.exists(today):
    os.mkdir(today)
    print 'Successfully created directory', today

target = today + os.sep + now + '.zip'

zip_command = "zip -qr '%s' %s" % (target, ' '.join(source))
if os.system(zip_command) == 0:
    print 'Successful backup to', target
else:
    print 'Backup FAILED'
