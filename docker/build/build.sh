#!/bin/bash
# set -x
echo "---------------------------------------------"
echo "1、打包的文件夹与镜像名保持一致"
echo "2、打包的文件夹中必须包含Dockerfile与jar包"
echo "3、Dockerfile中定义的jar包名称与提供的jar包名一致"
echo "---------------------------------------------"
image_name=$1
if [ "$image_name" == "" ]; then
    echo "Enter the wrapped image name:"
    read input
    if [ "$input" == "" ]; then
        echo "Mirror name cannot be empty"
        exit 1
    fi
    image_name=$input
fi
docker build -t $image_name $image_name
input="n"
echo "Need to export? (y/n) "
read input
if echo $input | grep -qi "y"; then
    bash export.sh $image_name $image_name/${image_name}.tar.gz
else
    exit 1
fi