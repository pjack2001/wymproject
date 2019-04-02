#!/bin/sh
# File    :   logclean.sh
# Time    :   2019/03/30 11:56:12
# Author  :   wangyuming 
# Version :   0.1
# License :   (C)Copyright 2018-2019, MIT
# Desc    :   上传到日志文件的目录下，执行，即可筛选多个2019-03开头的日志文件，结果保存在log.txt文件下

#先处理反扫的
grep -B 30 '支付业务处理成功' 2019-03*|grep -E '输入的扣款金额|支付业务处理成功'|awk '/输入的扣款金额|支付业务处理成功/{print $9 $10}'|cut -d , -f 12,15,14,18,19,21|cut -d, -f 1,2,3,4,5,6|awk '{if (NR%2==0){print $0} else {printf"%s ",$0}}'|awk '/反扫/{print $1$2}'|cut -d\" -f 1,4,16,17,20 >log.txt

#再处理正扫的
grep -B 30 '支付业务处理成功' 2019-03*|grep -E '输入的扣款金额|支付业务处理成功'|awk '/输入的扣款金额|支付业务处理成功/{print $9 $10}'|cut -d , -f 12,15,14,18,19,21|cut -d, -f 1,2,3,4,5,6|awk '{if (NR%2==0){print $0} else {printf"%s ",$0}}'|awk '/正扫/{print $1$2}'|cut -d\" -f 1,4,5,8,12 >>log.txt
