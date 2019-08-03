#!/bin/sh
# File    :   v8_load_tag_push.sh
# Time    :   2019/07/05 11:46:18
# Author  :   wangyuming 
# Version :   0.1
# License :   (C)Copyright 2018-2019, MIT
# Desc    :   centos7.6下执行通过，ubuntu失败

cur_date=`date +%Y%m%d`
harborurl='192.168.113.38/v8/'
vertify_file_integrity(){
    for filename in ${ALL_FILES[*]}
    do
        exists="$(ls | grep $filename)"
        commond_error_exit "$filename not found"
    done
}
ommond_error_exit(){
    if [ $? -ne 0 ]; then
        echo $@
        exit 1
    fi
}
exists_image_file(){
    file=$1
    if [ "${file##*.}"x = "tar"x ]||[ "${file##*.}"x = "gz"x ];then
        return 0
    fi
    return 1
}
install(){
    dir=$(ls -l |awk '/^d/ {print $NF}')
    for f in $dir
    do
        cd $f
        echo "--------install ${f} package--------"
        #bash autoload.sh
        # if [ $? -ne 0 ]; then
            # echo "${f} error"
        # else
            # echo "${f} success"
        # fi
        load_tag_push 2>&1 | tee -a  $(dirname "$PWD")/load_push.log
        cd ..
    done
    echo "--------install end!--------"
}
load_tag_push(){
    for suf in `ls`
    do
        exists_image_file "$suf"
        if [ $? -eq 0 ]; then
            # 安装镜像
            docker load -i "$suf" > /dev/null
            if [ $? -eq 0 ]; then
                echo "Scene loaded successfully ${suf}"
                #bash run.sh
            else
                echo "Images ${suf} failed to load"
            fi
            # tag镜像
            docker tag $f ${harborurl}$f:$cur_date > /dev/null
            if [ $? -eq 0 ]; then
                echo "Scene taged successfully ${harborurl}$f:$cur_date"
                #bash run.sh
            else
                echo "Images ${harborurl}$f:$cur_date failed to tag"
            fi
            # 推送镜像
            docker push ${harborurl}$f:$cur_date > /dev/null
            if [ $? -eq 0 ]; then
                echo "Scene pushed successfully ${harborurl}$f:$cur_date"
                #bash run.sh
            else
                echo "Images ${harborurl}$f:$cur_date failed to push"
            fi
            # 删除镜像
            docker rmi --force `docker images | grep ${harborurl} | awk '{print $3}'`
            if [ $? -eq 0 ]; then
                echo "Scene rmied successfully ${harborurl}$f:$cur_date"
                #bash run.sh
            else
                echo "Images ${harborurl}$f:$cur_date failed to rmi"
            fi
            exit 0
            break
        fi
    done
    echo "*.tar.gz or *.tar was not found"
    exit 1
}
vertify_file_integrity
install
