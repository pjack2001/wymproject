#常用docker应用版本配置




```yml

$ docker run -dit --name ubuntu1604 ubuntu:16.04

$ docker run -dit --name c761810 --privileged=true centos:7.6.1810 /usr/sbin/init

Docker 容器中运行 Docker 命令
$ docker run -dit --name c761810 --privileged=true -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker)r:/bin/docker centos:7.6.1810 /usr/sbin/init

$ docker rm -f 容器ID

# -*- mode: ruby -*-
# vi: set ft=ruby :
#
  Vagrant.configure("2") do |config|
    config.vm.box_check_update = false
    config.vm.provider 'virtualbox' do |vb|
     vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end  
    #config.vbguest.auto_update = false
  #config.vm.synced_folder ".", "/oracle", type: "nfs", nfs_udp: false
  #config.vm.synced_folder "./share_dir", "/vagrant", create: true, owner: "root", group: "root", mount_options: ["dmode=755","fmode=644"], type: "rsync"
    config.vm.synced_folder "/media/xh/f/linux/iSO/dockerimages", "/home/vagrant/images", type: "nfs", nfs_udp: false
    $num_instances = 1
    # curl https://discovery.etcd.io/new?size=3
    #i$etcd_cluster = "node1=http://172.17.8.101:2380"
    (1..$num_instances).each do |i|
      config.vm.define "kubeasz#{i}" do |node|
        node.vm.box = "centos7.6"
        node.vm.hostname = "kubeasz#{i}"
        ip = "172.17.8.#{i+160}"
        node.vm.network "private_network", ip: ip
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "6144"
          vb.cpus = 1
          vb.name = "kubeasz#{i}"
        end
    # node.vm.provision "shell", path: "install.sh", args: [i, ip, $etcd_cluster]
      end
    end

  config.vm.provision "shell", inline: <<-SHELL
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo setenforce 0
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    sudo sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
    sudo mkdir -p /etc/yum.repos.d/repobak
    sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak
    sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo
# sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo
    sudo yum clean all && yum makecache
    sudo yum install -y wget vim tree
#sudo yum list docker-ce --showduplicates
    sudo yum install -y docker-ce-18.09.2 #docker-ce-18.06.1.ce
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo mkdir -p /etc/docker
# https://registry.docker-cn.com https://hub-mirror.c.163.com https://al9ikvwc.mirror.aliyuncs.com
    sudo echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"]}' > /etc/docker/daemon.json
    #sudo echo -e '{"registry-mirrors": ["https://al9ikvwc.mirror.aliyuncs.com"],"insecure-registries": ["http://192.168.102.3:8001"]}' > /etc/docker/daemon.json
    #sudo curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo systemctl restart sshd
  SHELL

end


```



## 应用

```yml

$ docker pull mysql:5.7
$ docker pull wordpress:5.1.1

$ docker pull nextcloud:15.0.5-apache



20190319
$ docker images              
REPOSITORY                                          TAG                  IMAGE ID            CREATED             SIZE
centos                                              6.8                  82f3b5f3c58f        5 days ago          195MB
centos                                              6.10                 48650444e419        5 days ago          194MB
centos                                              7.4.1708             9f266d35e02c        5 days ago          197MB
centos                                              7.5.1804             cf49811e3cdb        5 days ago          200MB
centos                                              7.6.1810             f1cb7c7d58b7        5 days ago          202MB
mariadb                                             10.4                 9057231b8afe        8 days ago          379MB
adminer                                             4.7                  709d7ce11f75        10 days ago         83.2MB
tomcat                                              8.5.38-jre8-alpine   7ca9f2f54343        11 days ago         106MB
nginx                                               1.15.9-alpine        32a037976344        11 days ago         16.1MB
httpd                                               2.4.38-alpine        0c388cccfd04        12 days ago         124MB
alpine                                              3.9.2                5cb3aa00f899        12 days ago         5.53MB
registry.cn-hangzhou.aliyuncs.com/idcos/cloudboot   latest               a0d4b58e67d0        2 weeks ago         732MB
httpd                                               2.4.38               2d1e5208483c        2 weeks ago         132MB
nginx                                               1.15.9               881bd08c0b08        2 weeks ago         109MB
mysql                                               5.7.25               ee7cbd482336        2 weeks ago         372MB
osixia/keepalived                                   2.0.13               3fa9d2027f02        2 weeks ago         54.5MB
busybox                                             1.30.1               d8233ab899d4        4 weeks ago         1.2MB

20190313
$ docker images
REPOSITORY                              TAG                 IMAGE ID            CREATED             SIZE
nextcloud                               15.0.5-fpm-alpine   e1f87609133b        9 hours ago         320MB
nextcloud                               15.0.5-apache       ace08abb9937        9 hours ago         598MB
wordpress                               5.1.1               074afffecb75        32 hours ago        421MB
nginx                                   1.15.9-alpine       32a037976344        7 days ago          16.1MB
nginx                                   1.15.9              881bd08c0b08        10 days ago         109MB
mysql                                   5.7                 702fb0b7837f        4 months ago        372MB
mariadb                                 10.4                9057231b8afe        6 days ago          379MB
adminer                                 4.7                 709d7ce11f75        6 days ago          83.2MB
weaveworks/scope                        1.10.2              d9ece03f45e7        4 weeks ago         75.8MB
portainer/portainer                     1.20.2              19d07168491a        10 days ago         74.1MB
titpetric/netdata                       1.11                6142b5f2e30b        3 months ago        273MB



/home/m/wymdata/nextcloud/docker-compose.yml


```

### 

```yml

https://hub.docker.com/_/mysql

Example stack.yml for mysql:

# Use root/example as user/password credentials
version: '3.1'

services:

  db:
    image: mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080


```

### mariadb10.4 

```yml
https://hub.docker.com/_/mariadb?tab=description

Starting a MariaDB instance is simple:

$ docker run --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:tag

Using a custom MySQL configuration file
$ docker run --name some-mariadb -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:tag

Example stack.yml for mariadb:

# Use root/example as user/password credentials
version: '3.1'

services:

  db:
    image: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080

$ docker run --name some-mariadb -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:tag
The -v /my/own/datadir:/var/lib/mysql part of the command mounts the /my/own/datadir directory from the underlying host system as /var/lib/mysql inside the container, where MySQL by default will write its data files.








```



### nginx 20190313

```yml
https://hub.docker.com/_/nginx

复杂的配置
$ docker run --name my-custom-nginx-container -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx


Here is an example using docker-compose.yml:

web:
  image: nginx
  volumes:
   - ./mysite.template:/etc/nginx/conf.d/mysite.template
  ports:
   - "8080:80"
  environment:
   - NGINX_HOST=foobar.com
   - NGINX_PORT=80
  command: /bin/bash -c "envsubst < /etc/nginx/conf.d/mysite.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"


以只读模式运行nginx
要以只读模式运行nginx，您需要将Docker卷安装到nginx写入信息的每个位置。默认的nginx配置需要对/var/cache和的写访问权限/var/run。这可以通过运行nginx轻松完成，如下所示：

$ docker run -d -p 80:80 --read-only -v $(pwd)/nginx-cache:/var/cache/nginx -v $(pwd)/nginx-pid:/var/run nginx
如果您有更高级的配置需要nginx写入其他位置，只需向这些位置添加更多卷装入。

在调试模式下运行nginx
从版本1.9.8开始的图像带有nginx-debug二进制文件，在使用更高的日志级别时会生成详细输出。它可以与简单的CMD替换一起使用：

$ docker run --name my-nginx -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx nginx-debug -g 'daemon off;'
docker-compose.yml中的类似配置可能如下所示：

web:
  image: nginx
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf:ro
  command: [nginx-debug, '-g', 'daemon off;']



```

### 

```yml


```

### WordPress 20190313
```yml
https://hub.docker.com/_/wordpress

$ docker pull wordpress:5.1.1



$ docker run --name some-wordpress --link some-mysql:mysql -d wordpress
以下环境变量也适用于配置WordPress实例：

-e WORDPRESS_DB_HOST=...（默认为链接mysql容器的IP和端口）
-e WORDPRESS_DB_USER=... （默认为“root”）
-e WORDPRESS_DB_PASSWORD=...（默认为MYSQL_ROOT_PASSWORD链接mysql容器中环境变量的值）
-e WORDPRESS_DB_NAME=... （默认为“wordpress”）
-e WORDPRESS_TABLE_PREFIX=... （默认为“”，仅在需要覆盖wp-config.php中的默认表前缀时设置此项）
-e WORDPRESS_AUTH_KEY=...，-e WORDPRESS_SECURE_AUTH_KEY=...，-e WORDPRESS_LOGGED_IN_KEY=...，-e WORDPRESS_NONCE_KEY=...，-e WORDPRESS_AUTH_SALT=...，-e WORDPRESS_SECURE_AUTH_SALT=...，-e WORDPRESS_LOGGED_IN_SALT=...，-e WORDPRESS_NONCE_SALT=...（默认为唯一的随机SHA1s）
-e WORDPRESS_DEBUG=1（默认为禁用，非空值将使WP_DEBUG在wp-config.php）
-e WORDPRESS_CONFIG_EXTRA=...（默认为空，非空值将逐字嵌入wp-config.php- 特别适用于应用此图像默认不提供的额外配置值，例如WP_ALLOW_MULTISITE; 有关详细信息，请参阅docker-library / wordpress＃142）
如果WORDPRESS_DB_NAME给定的MySQL服务器上尚未存在指定的，则在启动wordpress容器时将自动创建，只要WORDPRESS_DB_USER指定的具有创建它的必要权限。

如果您希望能够在没有容器IP的情况下从主机访问实例，可以使用标准端口映射：

$ docker run --name some-wordpress --link some-mysql:mysql -p 8080:80 -d wordpress
然后，通过浏览器http://localhost:8080或http://host-ip:8080在浏览器中访问它。

如果您想使用外部数据库而不是链接mysql容器，请指定主机名和端口WORDPRESS_DB_HOST以及密码WORDPRESS_DB_PASSWORD和用户名WORDPRESS_DB_USER（如果不是root）：

$ docker run --name some-wordpress -e WORDPRESS_DB_HOST=10.1.2.3:3306 \
    -e WORDPRESS_DB_USER=... -e WORDPRESS_DB_PASSWORD=... -d wordpress
当在负责执行TLS终止的反向代理（例如NGINX）后面运行带有TLS的WordPress时，请确保正确设置X-Forwarded-Proto（请参阅上游文档中“通过SSL管理”中的“使用反向代理”）。不需要额外的环境变量或配置（如果指定了任何上述环境变量，此图像会自动添加注释的HTTP_X_FORWARDED_PROTO代码）。wp-config.php

如果您的数据库需要SSL，WordPress票证＃28625具有关于WordPress上游支持的相关详细信息。作为一种解决方法，可以将“安全数据库连接”插件提取到WordPress目录中，并添加该插件配置中描述的相应值wp-config.php。

Docker的秘密
作为通过环境变量传递敏感信息的替代方法，_FILE可以将其附加到先前列出的环境变量，从而使初始化脚本从容器中存在的文件加载这些变量的值。特别是，这可以用于从存储在/run/secrets/<secret_name>文件中的Docker机密加载密码。例如：

$ docker run --name some-wordpress -e WORDPRESS_DB_PASSWORD_FILE=/run/secrets/mysql-root ... -d wordpress:tag
目前，这是支持的WORDPRESS_DB_HOST，WORDPRESS_DB_USER，WORDPRESS_DB_PASSWORD，WORDPRESS_DB_NAME，WORDPRESS_AUTH_KEY，WORDPRESS_SECURE_AUTH_KEY，WORDPRESS_LOGGED_IN_KEY，WORDPRESS_NONCE_KEY，WORDPRESS_AUTH_SALT，WORDPRESS_SECURE_AUTH_SALT，WORDPRESS_LOGGED_IN_SALT，WORDPRESS_NONCE_SALT，WORDPRESS_TABLE_PREFIX，和WORDPRESS_DEBUG。

......通过docker stack deploy或docker-compose

实施例stack.yml为wordpress：

version: '3.1'

services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb

  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_RANDOM_ROOT_PASSWORD: '1'


包括预安装的主题/插件
将包含主题或插件的卷安装到正确的目录中; 然后通过wp-admin webui应用它们。确保为用户提供读/写/执行权限。

主题进入子目录 /var/www/html/wp-content/themes/
插件进入子目录 /var/www/html/wp-content/plugins/




```


### nextcloud  20190313

```yml
https://hub.docker.com/_/nextcloud

$ docker pull nextcloud:15.0.5-fpm-alpine


Base version - apache
This version will use the apache image and add a mariaDB container. The volumes are set to keep your data persistent. This setup provides no ssl encryption and is intended to run behind a proxy.

Make sure to set the variables MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD before you run this setup.

version: '2'

volumes:
  nextcloud:
  db:

services:
  db:
    image: mariadb
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud
    ports:
      - 8080:80
    links:
      - db
    volumes:
      - nextcloud:/var/www/html
    restart: always
Then run docker-compose up -d, now you can access Nextcloud at http://localhost:8080/ from your host system.

Base version - FPM
When using the FPM image you need another container that acts as web server on port 80 and proxies the requests to the Nextcloud container. In this example a simple nginx container is combined with the Nextcloud-fpm image and a MariaDB database container. The data is stored in docker volumes. The nginx container also need access to static files from your Nextcloud installation. It gets access to all the volumes mounted to Nextcloud via the volumes_from option.The configuration for nginx is stored in the configuration file nginx.conf, that is mounted into the container. An example can be found in the examples section here.

As this setup does not include encryption it should to be run behind a proxy.

Make sure to set the variables MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD before you run this setup.

version: '2'

volumes:
  nextcloud:
  db:

services:
  db:
    image: mariadb
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud:fpm
    links:
      - db
    volumes:
      - nextcloud:/var/www/html
    restart: always

  web:
    image: nginx
    ports:
      - 8080:80
    links:
      - app
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    volumes_from:
      - app
    restart: always
Then run docker-compose up -d, now you can access Nextcloud at http://localhost:8080/ from your host system.



```


### 

```yml


```

### Portainer

```yml



https://portainer.readthedocs.io/en/latest/deployment.html

$ docker volume create portainer_data
$ docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer


Deploy Portainer via docker-compose
You can use docker-compose to deploy Portainer.

Here is an example compose file:

version: '2'

services:
  portainer:
    image: portainer/portainer
    command: -H unix:///var/run/docker.sock
    restart: always
    ports:
      - 9000:9000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:

```

### 

```yml
OpenVAS image for Docker
mikesplain/openvas       9     889967897c49     7 weeks ago    6.39GB

Ubuntu上OpenVAS的Docker容器。默认情况下，最新映像包括OpenVAS Base以及运行OpenVAS所需的NVT和Certs。我们决定将9作为默认分支，因为8似乎在docker中有很多问题。我们建议您使用9，因为它更稳定。我们的Openvas9版本设计为较小的图像，内置较少的附加功能。请注意，OpenVAS 8不再构建，因为OpenVAS 9现在已成为标准配置。仍然可以从Docker集线器中提取映像，但是已经在此github中删除了源代码，这是已弃用的Docker映像的标准配置。

Openvas Version	Tag	Web UI Port
9	latest/9	443

用法
简单地运行：

# latest (9)
docker run -d -p 443:443 --name openvas mikesplain/openvas
# 9
docker run -d -p 443:443 --name openvas mikesplain/openvas:9

这将从docker注册表中获取容器并启动它。Openvas启动可能需要一些时间（扫描NVT和重建数据库时需要4-5分钟），所以请耐心等待。一旦你It seems like your OpenVAS-9 installation is OK.在日志中看到一个进程，web ui就可以了。去https://<machinename>

Username: admin
Password: admin

要检查进程的状态，请运行：

docker top openvas

在输出中，查找进程扫描证书数据。它包含一个百分比。

要在容器运行中运行bash：

docker exec -it openvas bash

指定DNS主机名
默认情况下，系统仅允许主机名“openvas”的连接。要允许使用自定义DNS名称进行访问，必须使用以下命令：

docker run -d -p 443:443 -e PUBLIC_HOSTNAME=myopenvas.example.org --name openvas mikesplain/openvas

OpenVAS Manager
要使用OpenVAS Manager，请将端口添加9390到docker run命令：

docker run -d -p 443:443 -p 9390:9390 --name openvas mikesplain/openvas

Volume Support
我们现在支持卷。只需将数据目录挂载到/var/lib/openvas/mgr/：

mkdir data
docker run -d -p 443:443 -v $(pwd)/data:/var/lib/openvas/mgr/ --name openvas mikesplain/openvas

请注意，您的本地目录必须在运行之前存在。

设置管理员密码
可以通过使用env变量在运行时指定密码来更改管理员密码OV_PASSWORD：

docker run -d -p 443:443 -e OV_PASSWORD=securepassword41 --name openvas mikesplain/openvas

更新NVT
有时您需要更新NVT。我们每周更新一次容器，但您可以通过插入容器并运行一些命令来更新容器：

docker exec -it openvas bash
## inside container
greenbone-nvt-sync
openvasmd --rebuild --progress
greenbone-certdata-sync
greenbone-scapdata-sync
openvasmd --update --verbose --progress

/etc/init.d/openvas-manager restart
/etc/init.d/openvas-scanner restart


Docker compose (experimental)

为简单起见，提供了docker-compose.yml文件，以及Nginx作为反向代理的配置，具有以下功能：

Nginx作为反向代理
从端口80（http）重定向到端口433（https）
来自Let's Encrypt的自动SSL证书
每天更新NVT的cron

To run:

Change "example.com" in the following files:
docker-compose.yml
conf/nginx.conf
conf/nginx_ssl.conf
Change the "OV_PASSWORD" enviromental variable in docker-compose.yml
Install the latest docker-compose
run docker-compose up -d

LDAP支持（实验性）
Openvas不支持完整的ldap集成，但仅支持每用户身份验证。LDAP_ADMIN_FILTER每当应用启动时，通过将ldap管理员用户（定义方）与openvas管理员用户同步，可以实现解决方法。要使用它，只需要指定所需的ldap env变量：

docker run -d -p 443:443 -p 9390:9390 --name openvas -e LDAP_HOST=your.ldap.host -e LDAP_BIND_DN=uid=binduid,dc=company,dc=com -e LDAP_BASE_DN=cn=accounts,dc=company,dc=com -e LDAP_AUTH_DN=uid=%s,cn=users,cn=accounts,dc=company,dc=com -e LDAP_ADMIN_FILTER=memberOf=cn=admins,cn=groups,cn=accounts,dc=company,dc=com -e LDAP_PASSWORD=password -e OV_PASSWORD=admin mikesplain/openvas

Email Support
要配置后缀的服务器，提供了以下ENV变量在运行时：OV_SMTP_HOSTNAME，OV_SMTP_PORT，OV_SMTP_USERNAME，OV_SMTP_KEY

docker run -d -p 443:443 -e OV_SMTP_HOSTNAME=smtp.example.com -e OV_SMTP_PORT=587 -e OV_SMTP_USERNAME=username@example.com -e OV_SMTP_KEY=g0bBl3de3Go0k --name openvas mikesplain/openvas

特约
我总是乐于接受拉动请求或问题。

谢谢
感谢hackertarget提供了很棒的教程：http：//hackertarget.com/install-openvas-7-ubuntu/ 感谢Serge Katzmann为OpenVAS 8做了一些很棒的工作：https：//github.com/sergekatzmann/openvas8-完成

```

### 

```yml


```

### 

```yml


```

