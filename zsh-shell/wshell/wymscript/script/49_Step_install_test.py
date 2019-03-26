#!/usr/bin/python
# -*- coding: UTF-8 -*-

import  os

# 测试安装和卸载
# remove是只卸载软件，保留配置文件和数据文件，erase是卸载软件并删除其相关的文件。

def install_tree():
    os.system("yum install -y tree")
    print '========== 安装tree =========='

install_tree()

def remove_tree():
    os.system("yum remove -y tree")
    print '========== 卸载tree =========='

remove_tree()