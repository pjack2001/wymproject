#!/usr/bin/python
# -*- coding: UTF-8 -*-

import  os

# 卸载
# remove是只卸载软件，保留配置文件和数据文件，erase是卸载软件并删除其相关的文件。

def remove_wget():
    os.system("yum remove -y wget vim tree net-tools ntp")
    print '卸载wget vim tree net-tools ntp'

remove_wget()

def remove_ansible():
    os.system("yum remove -y ansible")
    print '卸载ansible'

remove_ansible()

## 卸载docker-ce-18.06.1.ce
def remove_docker():
    os.system("yum remove -y docker-ce-18.06.1.ce")
    print '卸载docker-ce-18.06.1.ce'

remove_docker()