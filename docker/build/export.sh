#!/bin/bash
# set -x
image_name=$1
file_name=$2
if [ "$image_name" == "" ]; then
    echo "请输入导出镜像名:"
    read input
    if [ "$input" == "" ]; then
        echo "镜像名不能为空"
        exit 1
    fi
    image_name=$input
fi
if [ "$file_name" == "" ]; then
    echo "请输入导出的文件名(如:image.tar.gz或path/image.tar.gz):"
    read input
    if [ "$input" == "" ]; then
        echo "导出的文件名不能为空"
        exit 1
    fi
    file_name=$input
fi
echo "准备导出${1}到${2}"
docker save $image_name | gzip -c > $file_name