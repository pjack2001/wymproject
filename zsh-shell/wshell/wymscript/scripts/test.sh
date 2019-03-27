#!/bin/sh
# 在某些情况下会拿到错误结果
echo -e ""测试1""
echo -e $(dirname $0)

echo -e ""测试2""
echo -e $(pwd)

echo -e ""测试3""
echo -e $(dirname $(readlink -f $0))

echo -e ""测试4""
cd ../software  # 当前位置跳到脚本位置
echo -e $(pwd)

echo -e ""测试5""
echo -e $0

echo -e ""测试6""
path=$(dirname $(readlink -f $0))
echo -e $path