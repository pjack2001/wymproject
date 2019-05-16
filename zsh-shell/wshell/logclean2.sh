#!/bin/sh
# File    :   logclean.sh
# Time    :   2019/03/30 11:56:12
# Author  :   wang yuming 
# Version :   0.1
# License :   (C)Copyright 2018-2019, MIT
# Desc    :   上传到日志文件的目录下，执行，即可筛选多个2019-03开头的日志文件，结果保存在log.txt文件下

#筛选条件：OUTID，NAME，时间，OPFARE=0，输入的扣款金额

#grep -B 50 'OPFARE' 2019-03-*|grep -E '输入的扣款金额|OUTID|NAME'|awk '/输入的扣款金额|OPFARE/{print $1 $2 $9 $10}'|cut -d , -f 1,5,12,14,19,21,22 > log2.txt

#grep -B 50 'OPFARE\"\:0' 2019-03-*|grep -E '输入的扣款金额|OPFARE\"\:0|NAME'|awk '/输入的扣款金额|OPFARE/{print $1 $2 $9 $10}'|cut -d , -f 1,5,12,14,19,21,22 > log2.txt

#grep -B 50 'OPFARE\"\:0' 2019-03-*|grep -E '输入的扣款金额|OPFARE\"\:0|NAME'|awk '/输入的扣款金额|OPFARE/{print $1 $2 $9 $10}'|cut -d : -f 1,2,3,9,17,18,19,20,24,25,26,27,28|cut -d , -f 1,2,3,5,7,9,10 > log2.txt

grep -B 50 'OPFARE\"\:0' 2019-03-*|grep -E '输入的扣款金额|OPFARE\"\:0|NAME'|cut -d":" -f 1,2,3,4,6,13,14,20,21,22,23,27,28,29,30,31,32,33|awk '{print $1 $2 $5 $8}'|cut -d"," -f 1,2,4,8,10 > log2.txt
