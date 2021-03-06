## cloudboot

```yml

一键部署
环境依赖
centos 7
docker
安装步骤
从 GitHub 上获取最新的 docker 配置
git clone https://github.com/idcos/osinstall-deploy.git
cd osinstall-deploy
启动 mysql 容器（默认 root 密码是 0okm#IJN，第一次启动数据库请等待 1 分钟）
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD='0okm#IJN' \
    -v /data/mysql:/var/lib/mysql \
    -v $PWD/mysql:/docker-entrypoint-initdb.d \
    mysql:5.7
启动 cloudboot 容器（将 192.168.2.1 改成本机 IP 地址）
docker run --privileged -d --name=cloudboot --net=host -e IP=192.168.2.1 \
    -v $PWD/cloudboot/deploy/conf/cloudboot-server.conf:/etc/cloudboot-server/cloudboot-server.conf \
    -v $PWD/cloudboot/deploy/iso:/data/iso \
    registry.cn-hangzhou.aliyuncs.com/idcos/cloudboot
启动 cloudact2 容器
docker run --privileged -d --name=cloudact2 --net=host \
    -v $PWD/cloudact2/deploy/conf/cloud-act2.yaml:/usr/yunji/cloud-act2/etc/cloud-act2.yaml \
    -v $PWD/cloudact2/deploy/conf/cloud-act2-proxy.yaml:/usr/yunji/cloud-act2/etc/cloud-act2-proxy.yaml \
    -v $PWD/cloudact2/deploy/conf/salt-api.conf:/etc/salt/master.d/salt-api.conf \
    registry.cn-hangzhou.aliyuncs.com/idcos/cloudact2
导入 ISO 系统安装介质到对应目录（以 centos 7.6 为例，需要使用 DVD 全量镜像）
mkdir -p $PWD/cloudboot/deploy/iso/centos/7.6/os/x86_64/
mount -o loop /path/of/CentOS-7-x86_64-DVD-1810.iso /media
rsync -a /media/ $PWD/cloudboot/deploy/iso/centos/7.6/os/x86_64/
umount /media
通过浏览器访问本机 IP 即可（推荐使用最新的 Chrome 浏览器）


```
