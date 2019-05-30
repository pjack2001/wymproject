#!/bin/sh
# ./list_img_tags.sh tensorflow/tensorflow
repo_url=https://registry.hub.docker.com/v1/repositories
image_name=$1

curl -s ${repo_url}/${image_name}/tags | json_reformat | grep name | awk '{print $2}' | sed -e 's/"//g'
