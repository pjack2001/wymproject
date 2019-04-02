#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@File    :   06_Step_prepare.py
@Time    :   2019/03/27 22:19:40
@Author  :   wangyuming 
@Version :   0.1
@License :   (C)Copyright 2018-2019, MIT
@Desc    :   None
'''

import subprocess
import sys
import os


def main():
    try:
        subprocess.call(["systemctl disable firewalld.service "], shell=True)
        subprocess.call(["systemctl stop firewalld.service "], shell=True)
        subprocess.call(["systemctl disable firewalld.service "], shell=True)
        subprocess.call([
            "sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config"
        ],
                        shell=True)
        subprocess.call([
            "sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config"
        ],
                        shell=True)
        subprocess.call(["setenforce 0"], shell=True)

        #subprocess.call([""], shell=True)
        sys.exit(0)
    except Exception as e:
        print(e)
        sys.exit(1)


if __name__ == '__main__':
    main()

print '****** 环境准备 ******'