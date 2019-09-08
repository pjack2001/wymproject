## keepalived+nginx



### 测试环境

```yml


集群:vagrant建立两个虚拟机
安装keepalived+nginx

VIP:172.17.8.244
Oracle1：172.17.8.241
Oracle2：172.17.8.242

两个web应用：nginx容器，80端口映射出来

127.0.0.1:8041
127.0.0.1:8042

公司的wlan分配IP192.168.157.118，根据实际情况修改IP
http://192.168.157.118:8041/
http://192.168.157.118:8042/


```



### keepalived

```yml


环境：vagrant建立两个centos虚拟机

MASTER节点：172.17.8.241
BACKUP节点：172.17.8.242


安装
源码安装、yum安装、docker镜像

keepalived配置，主从结构，浮动IP在master节点，
如果master节点失效，backup节点接管，master节点正常后会重新接管


$ tree /etc/keepalived/
/etc/keepalived/
|-- keepalived.conf
|-- nginx_check.sh



master节点：172.17.8.241

# vi /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
	router_id oracle1
    script_user root
	enable_script_security
}
vrrp_script chk_nginx {
	script "/etc/keepalived/nginx_check.sh"
	interval 2
	weight -20
}
vrrp_instance VI_1 {
	state MASTER
	interface eth1
	virtual_router_id 33
	mcast_src_ip 172.17.8.241
	priority 100
	nopreempt
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	track_script {
		chk_nginx
	}
	virtual_ipaddress {
		172.17.8.244
	}
}


backup节点：172.17.8.242

# vi /etc/keepalived/keepalived.conf

! Configuration File for keepalived
global_defs {
	router_id oracle2
    script_user root
	enable_script_security
}
vrrp_script chk_nginx {
	script "/etc/keepalived/nginx_check.sh"
	interval 2
	weight -20
}
vrrp_instance VI_1 {
	state BACKUP
	interface eth1
	virtual_router_id 33
	mcast_src_ip 172.17.8.242
	priority 90
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	track_script {
		chk_nginx
	}
	virtual_ipaddress {
		172.17.8.244
	}
}


两个节点都有：
# cat /etc/keepalived/nginx_check.sh
#!/bin/bash
#时间变量,用于记录时间
d=`date --date today +%y%m%d_%H:%M:%S`
#计算nginx进程数
A=`ps -C nginx --no-heading | wc -l`
#如果进程为0，则启动nginx，并且再次检测nginx进程数
#如果还为0，说明nginx无法启动，此时需要关闭keeppalived
if [ $A -eq 0 ];then
         /usr/local/nginx/sbin/nginx
         B=`ps -C nginx --no-heading|wc -l`
         if [ $B -eq 0 ];then
              echo "$d nginx down, keepalived will stop" >> /var/log/check_ngx.log
              systemctl stop keepalived
         fi
fi











```


### nginx


```yml

官方docker镜像
https://github.com/nginxinc/docker-nginx

[Nginx中文文档](http://www.nginx.cn/doc/index.html)

http://www.nginx.cn/doc/example/fullexample.html



制作docker镜像
https://hub.docker.com/_/nginx

goaccess可以实时监控日志



一、建立nginx源

vim /etc/yum.repos.d/nginx.repo

[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1

二、安装

yum -y install nginx




```



#### 

```yml

wlan分配IP192.168.157.118，根据实际情况修改IP

$ cat /etc/nginx/nginx.conf

worker_processes  1;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;


    sendfile        on;

    keepalive_timeout  65;

upstream myweb {
    server 192.168.157.118:8041 weight=1  fail_timeout=30s;
    server 192.168.157.118:8042 weight=1  fail_timeout=30s;
    }

    server {
        listen       80;
        server_name  localhost;
        charset utf-8;

        location / {
            root /usr/share/nginx/html;
            proxy_pass http://myweb;
            index  index.html index.htm;
        }

        #虚拟的二级目录demo,不需要真实的demo目录,http://172.17.8.241/demo/
        location /demo/ {
            alias /usr/share/nginx/html/;
            index  index.html index.htm;
        }

        #root指定，必须有真实的test目录，下面的nginx1和nginx2也同样
        location /test/ {
            root /usr/share/nginx/html;
            proxy_pass http://myweb;
            index  index.html index.htm;
        }

        location /nginx1/ {
            root /usr/share/nginx/html;
            proxy_pass http://192.168.157.118:8041;
            index  index.html index.htm;
        }

        location /nginx2/ {
            root /usr/share/nginx/html;
            proxy_pass http://192.168.157.118:8042;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

    }

}

```






#### Nginx（一）------简介与安装
```yml

https://www.cnblogs.com/ysocean/p/9384877.html

　　说到 Nginx ，可能大家最先想到的就是其负载均衡以及反向代理的功能。没错，这也是当前使用 Nginx 最频繁的两个功能，但是 Nginx 可不仅仅只有这两个功能，其作用还是挺大的，本系列博客就来慢慢解开 Nginx 神秘的面纱。

回到顶部
1、Nginx 的简介
　　Nginx 是由俄罗斯人 Igor Sysoev 设计开发的，开发工作从2002 年开始，第一次公开发布在 2004 年 10 月 4 日。

　　官方网站为：http://nginx.org/ 。它是一款免费开源的高性能 HTTP 代理服务器及反向代理服务器（Reverse Proxy）产品，同时它还可以提供 IMAP/POP3 邮件代理服务等功能。它高并发性能很好，官方测试能够支撑 5 万的并发量；运行时内存和 CPU 占用率低，配置简单，容易上手，而且运行非常稳定。

回到顶部
2、Nginx 的常用功能
　　其实 Nginx 的功能特别多，这里我只介绍几个常用的功能，具体的大家可以参考官网介绍。

　　①、反向代理

　　这是 Nginx 服务器作为 WEB 服务器的主要功能之一，客户端向服务器发送请求时，会首先经过 Nginx 服务器，由服务器将请求分发到相应的 WEB 服务器。正向代理是代理客户端，而反向代理则是代理服务器，Nginx 在提供反向代理服务方面，通过使用正则表达式进行相关配置，采取不同的转发策略，配置相当灵活，而且在配置后端转发请求时，完全不用关心网络环境如何，可以指定任意的IP地址和端口号，或其他类型的连接、请求等。

　　②、负载均衡

　　这也是 Nginx 最常用的功能之一，负载均衡，一方面是将单一的重负载分担到多个网络节点上做并行处理，每个节点处理结束后将结果汇总返回给用户，这样可以大幅度提高网络系统的处理能力；另一方面将大量的前端并发请求或数据流量分担到多个后端网络节点分别处理，这样可以有效减少前端用户等待相应的时间。而 Nginx 负载均衡都是属于后一方面，主要是对大量前端访问或流量进行分流，已保证前端用户访问效率，并可以减少后端服务器处理压力。

　　③、Web 缓存

　　在很多优秀的网站中，Nginx 可以作为前置缓存服务器，它被用于缓存前端请求，从而提高 Web服务器的性能。Nginx 会对用户已经访问过的内容在服务器本地建立副本，这样在一段时间内再次访问该数据，就不需要通过 Nginx 服务器向后端发出请求。减轻网络拥堵，减小数据传输延时，提高用户访问速度。

回到顶部
3、Nginx 安装
　　关于 Nginx 的安装，分为在 Windows 平台和 Linux 平台安装，Windows 版本的 Nginx 服务器在效率上要比 Linux 版本的 Nginx 服务器差一些，而且实际使用的一般都是 Linux 平台的 Nginx 服务器。所以后期我们介绍时也会以 Linux 版本的为主。

①、下载地址
　　Nginx 下载地址：http://nginx.org/en/download.html

　开发版本主要用于 Nginx 软件项目的研发，稳定版本说明可以作为 Web 服务器投入商业应用。这里我们选择当前稳定版本：nginx-1.14.0

下面对这个目录下的主要文件夹进行介绍：

　　1、conf 目录：存放 Nginx 的主要配置文件，很多功能实现都是通过配置该目录下的 nginx.conf 文件，后面我们会详细介绍。

　　2、docs 目录：存放 Nginx 服务器的主要文档资料，包括 Nginx 服务器的 LICENSE、OpenSSL 的 LICENSE 、PCRE 的 LICENSE 以及 zlib 的 LICENSE ，还包括本版本的 Nginx服务器升级的版本变更说明，以及 README 文档。

　　3、html 目录：存放了两个后缀名为 .html 的静态网页文件，这两个文件与 Nginx 服务器的运行相关。

　　4、logs 目录：存放 Nginx 服务器运行的日志文件。

　　5、nginx.exe：启动 Nginx 服务器的exe文件，如果 conf 目录下的 nginx.conf 文件配置正确的话，通过该文件即可启动 Nginx 服务器。

②、Windows 版本安装


③、Linux 版本安装
　　选择的 Linux 系统为 CentOS6.8。

　　一、安装 nginx 环境

1 yum install gcc-c++
2 yum install -y pcre pcre-devel
3 yum install -y zlib zlib-devel
4 yum install -y openssl openssl-devel
　　对于 gcc，因为安装nginx需要先将官网下载的源码进行编译，编译依赖gcc环境，如果没有gcc环境的话，需要安装gcc。

　　对于 pcre，prce(Perl Compatible Regular Expressions)是一个Perl库，包括 perl 兼容的正则表达式库。nginx的http模块使用pcre来解析正则表达式，所以需要在linux上安装pcre库。

　　对于 zlib，zlib库提供了很多种压缩和解压缩的方式，nginx使用zlib对http包的内容进行gzip，所以需要在linux上安装zlib库。

　　对于 openssl，OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及SSL协议，并提供丰富的应用程序供测试或其它目的使用。nginx不仅支持http协议，还支持https（即在ssl协议上传输http），所以需要在linux安装openssl库。

　　二、编译安装

　　首先将下载的 nginx-1.14.0.tar.gz 文件复制到 Linux 系统中，然后解压：

1 tar -zxvf nginx-1.14.0.tar.gz
　　接着进入到解压之后的目录，进行编译安装。

1 ./configure --prefix=/usr/local/nginx
2 make
3 make install
　　注意：指定 /usr/local/nginx 为nginx 服务安装的目录。

　　三、启动 nginx

　　进入到 /usr/local/nginx 目录，文件目录显示如下：


启动 nginx
# /usr/sbin/nginx


ps -ef | grep nginx


　　四、关闭 nginx

　　有两种方式：

　　方式1：快速停止

# /usr/sbin/nginx -s stop
　　此方式相当于先查出nginx进程id再使用kill命令强制杀掉进程。不太友好。

　　方式2：平缓停止

# /usr/sbin/nginx -s quit
　　此方式是指允许 nginx 服务将当前正在处理的网络请求处理完成，但不在接收新的请求，之后关闭连接，停止工作。

　　五、重启 nginx

　　方式1：先停止再启动

# /usr/sbin/nginx -s quit
# /usr/sbin/nginx
　　相当于先执行停止命令再执行启动命令。

　　方式2：重新加载配置文件

# /usr/sbin/nginx -s reload
　　通常我们使用nginx修改最多的便是其配置文件 nginx.conf。修改之后想要让配置文件生效而不用重启 nginx，便可以使用此命令。



　　六、检测配置文件语法是否正确

　　方式1：通过如下命令，指定需要检查的配置文件

# /usr/sbin/nginx -t -c  /etc/nginx/nginx.conf

　　方式2：通过如下命令，不加 -c 参数，默认检测nginx.conf 配置文件。

# /usr/sbin/nginx -t 



```

#### Nginx（二）------nginx.conf 配置文件

```yml
https://www.cnblogs.com/ysocean/p/9384880.html
　　上一篇博客我们将 nginx 安装在 /usr/local/nginx 目录下，其默认的配置文件都放在这个目录的 conf 目录下，而主配置文件 nginx.conf 也在其中，后续对 nginx 的使用基本上都是对此配置文件进行相应的修改，所以本篇博客我们先大致介绍一下该配置文件的结构。

1、nginx.conf 的主体结构
# cat nginx.conf

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}


　# 开头的表示注释内容，我们去掉所有以 # 开头的段落，精简之后的内容如下：

worker_processes  1;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;


    sendfile        on;

    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

    }

}

根据上述文件，我们可以很明显的将 nginx.conf 配置文件分为三部分：


2、全局块
　　从配置文件开始到 events 块之间的内容，主要会设置一些影响nginx 服务器整体运行的配置指令，主要包括配置运行 Nginx 服务器的用户（组）、允许生成的 worker process 数，进程 PID 存放路径、日志存放路径和类型以及配置文件的引入等。

　　比如上面第一行配置的：

worker_processes  1;
　　这是 Nginx 服务器并发处理服务的关键配置，worker_processes 值越大，可以支持的并发处理量也越多，但是会受到硬件、软件等设备的制约，这个后面会详细介绍。

回到顶部
3、events 块
　　比如上面的配置：

events {
    worker_connections  1024;
}
　　events 块涉及的指令主要影响 Nginx 服务器与用户的网络连接，常用的设置包括是否开启对多 work process 下的网络连接进行序列化，是否允许同时接收多个网络连接，选取哪种事件驱动模型来处理连接请求，每个 word process 可以同时支持的最大连接数等。

　　上述例子就表示每个 work process 支持的最大连接数为 1024.

　　这部分的配置对 Nginx 的性能影响较大，在实际中应该灵活配置。

回到顶部
4、http 块

http {
    include       mime.types;
    default_type  application/octet-stream;


    sendfile        on;

    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

    }

}

　　这算是 Nginx 服务器配置中最频繁的部分，代理、缓存和日志定义等绝大多数功能和第三方模块的配置都在这里。

　　需要注意的是：http 块也可以包括 http全局块、server 块。

①、http 全局块
　　http全局块配置的指令包括文件引入、MIME-TYPE 定义、日志自定义、连接超时时间、单链接请求数上限等。

②、server 块
　　这块和虚拟主机有密切关系，虚拟主机从用户角度看，和一台独立的硬件主机是完全一样的，该技术的产生是为了节省互联网服务器硬件成本。后面会详细介绍虚拟主机的概念。

　　每个 http 块可以包括多个 server 块，而每个 server 块就相当于一个虚拟主机。

　　而每个 server 块也分为全局 server 块，以及可以同时包含多个 locaton 块。

　　1、全局 server 块

　　最常见的配置是本虚拟机主机的监听配置和本虚拟主机的名称或IP配置。

　　2、location 块

　　一个 server 块可以配置多个 location 块。

　　这块的主要作用是基于 Nginx  服务器接收到的请求字符串（例如 server_name/uri-string），对虚拟主机名称（也可以是IP别名）之外的字符串（例如 前面的 /uri-string）进行匹配，对特定的请求进行处理。地址定向、数据缓存和应答控制等功能，还有许多第三方模块的配置也在这里进行。








```



#### Nginx（三）------nginx 反向代理

```yml
https://www.cnblogs.com/ysocean/p/9392908.html

　　Nginx 服务器的反向代理服务是其最常用的重要功能，由反向代理服务也可以衍生出很多与此相关的 Nginx 服务器重要功能，比如后面会介绍的负载均衡。本篇博客我们会先介绍 Nginx 的反向代理，当然在了解反向代理之前，我们需要先知道什么是代理以及什么是正向代理。

回到顶部
1、代理
　　在Java设计模式中，代理模式是这样定义的：给某个对象提供一个代理对象，并由代理对象控制原对象的引用。

　　可能大家不太明白这句话，在举一个现实生活中的例子：比如我们要买一间二手房，虽然我们可以自己去找房源，但是这太花费时间精力了，而且房屋质量检测以及房屋过户等一系列手续也都得我们去办，再说现在这个社会，等我们找到房源，说不定房子都已经涨价了，那么怎么办呢？最简单快捷的方法就是找二手房中介公司（为什么？别人那里房源多啊），于是我们就委托中介公司来给我找合适的房子，以及后续的质量检测过户等操作，我们只需要选好自己想要的房子，然后交钱就行了。

　　代理简单来说，就是如果我们想做什么，但又不想直接去做，那么这时候就找另外一个人帮我们去做。那么这个例子里面的中介公司就是给我们做代理服务的，我们委托中介公司帮我们找房子。

　　Nginx 主要能够代理如下几种协议，其中用到的最多的就是做Http代理服务器。

　　

回到顶部
2、正向代理
　　弄清楚什么是代理了，那么什么又是正向代理呢？

　　这里我再举一个例子：大家都知道，现在国内是访问不了 Google的，那么怎么才能访问 Google呢？我们又想，美国人不是能访问 Google吗（这不废话，Google就是美国的），如果我们电脑的对外公网 IP 地址能变成美国的 IP 地址，那不就可以访问 Google了。你很聪明，VPN 就是这样产生的。我们在访问 Google 时，先连上 VPN 服务器将我们的 IP 地址变成美国的 IP 地址，然后就可以顺利的访问了。

　　这里的 VPN 就是做正向代理的。正向代理服务器位于客户端和服务器之间，为了向服务器获取数据，客户端要向代理服务器发送一个请求，并指定目标服务器，代理服务器将目标服务器返回的数据转交给客户端。这里客户端是要进行一些正向代理的设置的。

　　PS：这里介绍一下什么是 VPN，VPN 通俗的讲就是一种中转服务，当我们电脑接入 VPN 后，我们对外 IP 地址就会变成 VPN 服务器的 公网 IP，我们请求或接受任何数据都会通过这个VPN 服务器然后传入到我们本机。这样做有什么好处呢？比如 VPN 游戏加速方面的原理，我们要玩网通区的 LOL，但是本机接入的是电信的宽带，玩网通区的会比较卡，这时候就利用 VPN 将电信网络变为网通网络，然后在玩网通区的LOL就不会卡了（注意：VPN 是不能增加带宽的，不要以为不卡了是因为网速提升了）。

　　可能听到这里大家还是很抽象，没关系，和下面的反向代理对比理解就简单了。

回到顶部
3、反向代理
　　反向代理和正向代理的区别就是：正向代理代理客户端，反向代理代理服务器。

　　反向代理，其实客户端对代理是无感知的，因为客户端不需要任何配置就可以访问，我们只需要将请求发送到反向代理服务器，由反向代理服务器去选择目标服务器获取数据后，在返回给客户端，此时反向代理服务器和目标服务器对外就是一个服务器，暴露的是代理服务器地址，隐藏了真实服务器IP地址。

　　下面我们通过两张图来对比正向代理和方向代理：

　　

 

　　

　　理解这两种代理的关键在于代理服务器所代理的对象是什么，正向代理代理的是客户端，我们需要在客户端进行一些代理的设置。而反向代理代理的是服务器，作为客户端的我们是无法感知到服务器的真实存在的。

　　总结起来还是一句话：正向代理代理客户端，反向代理代理服务器。

回到顶部
4、Nginx 反向代理
　　范例：使用 nginx 反向代理 www.123.com 直接跳转到127.0.0.1:8080

　　①、启动一个 tomcat，浏览器地址栏输入 127.0.0.1:8080，出现如下界面

　　②、通过修改本地 host 文件，将 www.123.com 映射到 127.0.0.1

127.0.0.1 www.123.com
　　将上面代码添加到 Windows 的host 文件中，该文件位置在：

 　　

　　配置完成之后，我们便可以通过 www.123.com:8080 访问到第一步出现的 Tomcat初始界面。

　　那么如何只需要输入 www.123.com 便可以跳转到 Tomcat初始界面呢？便用到 nginx的反向代理。

　　③、在 nginx.conf 配置文件中增加如下配置：

server {
        listen       80;
        server_name  www.123.com;

        location / {
            proxy_pass http://127.0.0.1:8080;
            index  index.html index.htm index.jsp;
        }
    }

　　如上配置，我们监听80端口，访问域名为www.123.com，不加端口号时默认为80端口，故访问该域名时会跳转到127.0.0.1:8080路径上。

　　我们在浏览器端输入 www.123.com 结果如下：

　　

　　④、总结

　　其实这里更贴切的说是通过nginx代理端口，原先访问的是8080端口，通过nginx代理之后，通过80端口就可以访问了。

回到顶部
5、Nginx 反向代理相关指令介绍
①、listen
　　该指令用于配置网络监听。主要有如下三种配置语法结构：

　　一、配置监听的IP地址

listen address[:port] [default_server] [setfib=number] [backlog=number] [rcvbuf=size] [sndbuf=size] [deferred]
    [accept_filter=filter] [bind] [ssl];

　　二、配置监听端口

listen port[default_server] [setfib=number] [backlog=number] [rcvbuf=size] [sndbuf=size] [accept_filter=filter] 
    [deferred] [bind] [ipv6only=on|off] [ssl];

　三、配置 UNIX Domain Socket

listen unix:path [default_server]  [backlog=number] [rcvbuf=size] [sndbuf=size] [accept_filter=filter] 
    [deferred] [bind] [ssl];

　　上面的配置看似比较复杂，其实使用起来是比较简单的：

1 listen *:80 | *:8080 #监听所有80端口和8080端口
2 listen  IP_address:port   #监听指定的地址和端口号
3 listen  IP_address     #监听指定ip地址所有端口
4 listen port     #监听该端口的所有IP连接

　　下面分别解释每个选项的具体含义：

　　1、address:IP地址，如果是 IPV6地址，需要使用中括号[] 括起来，比如[fe80::1]等。

　　2、port:端口号，如果只定义了IP地址，没有定义端口号，那么就使用80端口。

　　3、path:socket文件路径，如 var/run/nginx.sock等。

　　4、default_server:标识符，将此虚拟主机设置为 address:port 的默认主机。（在 nginx-0.8.21 之前使用的是 default 指令）

　　5、 setfib=number:Nginx-0.8.44 中使用这个变量监听 socket 关联路由表，目前只对 FreeBSD 起作用，不常用。

　　6、backlog=number:设置监听函数listen()最多允许多少网络连接同时处于挂起状态，在 FreeBSD 中默认为 -1,其他平台默认为511.

　　7、rcvbuf=size:设置监听socket接收缓存区大小。

　　8、sndbuf=size:设置监听socket发送缓存区大小。

　　9、deferred:标识符，将accept()设置为Deferred模式。

　　10、accept_filter=filter:设置监听端口对所有请求进行过滤，被过滤的内容不能被接收和处理，本指令只在 FreeBSD 和 NetBSD 5.0+ 平台下有效。filter 可以设置为 dataready 或 httpready 。

　　11、bind:标识符，使用独立的bind() 处理此address:port，一般情况下，对于端口相同而IP地址不同的多个连接，Nginx 服务器将只使用一个监听指令，并使用 bind() 处理端口相同的所有连接。

　　12、ssl:标识符，设置会话连接使用 SSL模式进行，此标识符和Nginx服务器提供的 HTTPS 服务有关。

②、server_name
　　该指令用于虚拟主机的配置。通常分为以下两种：

　　1、基于名称的虚拟主机配置

　　语法格式如下：

server_name   name ...;
　　一、对于name 来说，可以只有一个名称，也可以有多个名称，中间用空格隔开。而每个名字由两段或者三段组成，每段之间用“.”隔开。

server_name 123.com www.123.com
　　二、可以使用通配符“*”，但通配符只能用在由三段字符组成的首段或者尾端，或者由两端字符组成的尾端。

server_name *.123.com www.123.*
　　三、还可以使用正则表达式，用“~”作为正则表达式字符串的开始标记。

server_name ~^www\d+\.123\.com$;
　　该表达式“~”表示匹配正则表达式，以www开头（“^”表示开头），紧跟着一个0~9之间的数字，在紧跟“.123.co”，最后跟着“m”($表示结尾)

　　以上匹配的顺序优先级如下：

1 ①、准确匹配 server_name
2 ②、通配符在开始时匹配 server_name 成功
3 ③、通配符在结尾时匹配 server_name 成功
4 ④、正则表达式匹配 server_name 成功
　　2、基于 IP 地址的虚拟主机配置

　　语法结构和基于域名匹配一样，而且不需要考虑通配符和正则表达式的问题。

server_name 192.168.1.1
③、location
　　该指令用于匹配 URL。

　　语法如下：

1 location [ = | ~ | ~* | ^~] uri {
2 
3 }
　　1、= ：用于不含正则表达式的 uri 前，要求请求字符串与 uri 严格匹配，如果匹配成功，就停止继续向下搜索并立即处理该请求。

　　2、~：用于表示 uri 包含正则表达式，并且区分大小写。

　　3、~*：用于表示 uri 包含正则表达式，并且不区分大小写。

　　4、^~：用于不含正则表达式的 uri 前，要求 Nginx 服务器找到标识 uri 和请求字符串匹配度最高的 location 后，立即使用此 location 处理请求，而不再使用 location 块中的正则 uri 和请求字符串做匹配。

　　注意：如果 uri 包含正则表达式，则必须要有 ~ 或者 ~* 标识。

④、proxy_pass
　　该指令用于设置被代理服务器的地址。可以是主机名称、IP地址加端口号的形式。

　　语法结构如下：

proxy_pass URL;
　　URL 为被代理服务器的地址，可以包含传输协议、主机名称或IP地址加端口号，URI等。

proxy_pass  http://www.123.com/uri;
⑤、index
　　该指令用于设置网站的默认首页。

　　语法为：

index  filename ...;
　　后面的文件名称可以有多个，中间用空格隔开。

index  index.html index.jsp;
　　通常该指令有两个作用：第一个是用户在请求访问网站时，请求地址可以不写首页名称；第二个是可以对一个请求，根据请求内容而设置不同的首页。

参考文档：苗泽老师的《Nginx高性能Web服务器详解》







```




#### Nginx（四）------nginx 负载均衡

```yml
https://www.cnblogs.com/ysocean/p/9392912.html


　　在上一篇博客我们介绍了 Nginx 一个很重要的功能——代理，包括正向代理和反向代理。这两个代理的核心区别是：正向代理代理的是客户端，而反向代理代理的是服务器。其中我们又重点介绍了反向代理，以及如何通过 Nginx 来实现反向代理。那么了解了Nginx的反向代理之后，我们要通过Nginx的反向代理实现另一个重要功能——负载均衡。

回到顶部
1、负载均衡的由来
　　早期的系统架构，基本上都是如下形式的：

　　

 

　　客户端发送多个请求到服务器，服务器处理请求，有一些可能要与数据库进行交互，服务器处理完毕后，再将结果返回给客户端。

　　这种架构模式对于早期的系统相对单一，并发请求相对较少的情况下是比较适合的，成本也低。但是随着信息数量的不断增长，访问量和数据量的飞速增长，以及系统业务的复杂度增加，这种架构会造成服务器相应客户端的请求日益缓慢，并发量特别大的时候，还容易造成服务器直接崩溃。很明显这是由于服务器性能的瓶颈造成的问题，那么如何解决这种情况呢？

　　我们首先想到的可能是升级服务器的配置，比如提高CPU执行频率，加大内存等提高机器的物理性能来解决此问题，但是我们知道摩尔定律的日益失效，硬件的性能提升已经不能满足日益提升的需求了。最明显的一个例子，天猫双十一当天，某个热销商品的瞬时访问量是极其庞大的，那么类似上面的系统架构，将机器都增加到现有的顶级物理配置，都是不能够满足需求的。那么怎么办呢？

　　上面的分析我们去掉了增加服务器物理配置来解决问题的办法，也就是说纵向解决问题的办法行不通了，那么横向增加服务器的数量呢？这时候集群的概念产生了，单个服务器解决不了，我们增加服务器的数量，然后将请求分发到各个服务器上，将原先请求集中到单个服务器上的情况改为将请求分发到多个服务器上，将负载分发到不同的服务器，也就是我们所说的负载均衡。

　　

 

　　负载均衡完美的解决了单个服务器硬件性能瓶颈的问题，但是随着而来的如何实现负载均衡呢？客户端怎么知道要将请求发送到那个服务器去处理呢？

回到顶部
2、Nginx实现负载均衡
　　Nginx 服务器是介于客户端和服务器之间的中介，通过上一篇博客讲解的反向代理的功能，客户端发送的请求先经过 Nginx ，然后通过 Nginx 将请求根据相应的规则分发到相应的服务器。

　　

　　主要配置指令为上一讲的 pass_proxy 指令以及 upstream 指令。负载均衡主要通过专门的硬件设备或者软件算法实现。通过硬件设备实现的负载均衡效果好、效率高、性能稳定，但是成本较高。而通过软件实现的负载均衡主要依赖于均衡算法的选择和程序的健壮性。均衡算法又主要分为两大类：

　　静态负载均衡算法：主要包括轮询算法、基于比率的加权轮询算法或者基于优先级的加权轮询算法。

　　动态负载均衡算法：主要包括基于任务量的最少连接优化算法、基于性能的最快响应优先算法、预测算法及动态性能分配算法等。

　　静态负载均衡算法在一般网络环境下也能表现的比较好，动态负载均衡算法更加适用于复杂的网络环境。

　　例子：

①、普通轮询算法
　　这是Nginx 默认的轮询算法。

例子：两台相同的Tomcat服务器，通过 localhost:8080 访问Tomcat1，通过 localhost:8081访问Tomcat2，现在我们要输入 localhost 这个地址，可以在这两个Tomcat服务器之间进行交替访问。
　　一、分别修改两个Tomcat服务器的端口为8080和8081。然后再修改Tomcat的首页，使得访问这两个页面时能够区分。如下：

　　修改端口号文件为 server.xml ：

　　

　　修改首页的路径为：webapps/ROOT/index.jsp

　　

　　修改完成之后，分别启动这两个Tomcat服务器，然后分别输入相应的地址端口号：

　　输入地址：localhost:8081

　　

 

 　　输入地址：localhost:8080

　　

 　　二、修改 nginx 的配置文件 nginx.conf 

upstream OrdinaryPolling {
    server 127.0.0.1:8080;
    server 127.0.0.1:8081;
    }
    server {
        listen       80;
        server_name  localhost;

        location / {
            proxy_pass http://OrdinaryPolling;
            index  index.html index.htm index.jsp;
        
        }
    }

②、基于比例加权轮询
　　上述两台Tomcat服务器基本上是交替进行访问的。但是这里我们有个需求：

　　由于Tomcat1服务器的配置更高点，我们希望该服务器接受更多的请求，而 Tomcat2 服务器配置低，希望其处理相对较少的请求。

　　那么这时候就用到了加权轮询机制了。

　　nginx.conf 配置文件如下：

upstream OrdinaryPolling {
    server 127.0.0.1:8080 weight=5;
    server 127.0.0.1:8081 weight=2;
    }
    server {
        listen       80;
        server_name  localhost;

        location / {
            proxy_pass http://OrdinaryPolling;
            index  index.html index.htm index.jsp;
        
        }
    }


　　其实对比上面不加权的轮询方式，这里在 upstream 指令中多了一个 weight 指令。该指令用于配置前面请求处理的权重，默认值为 1。

　　也就是说：第一种不加权的普通轮询，其实其加权值 weight 都为 1。

　　下面我们看页面相应结果：

　　

 

 　　明显 8080 端口号出现的次数更多，试验的次数越多越接近我们配置的比例。

③、基于IP路由负载
　　我们知道一个请求在经过一个服务器处理时，服务器会保存相关的会话信息，比如session，但是该请求如果第一个服务器没处理完，通过nginx轮询到第二个服务器上，那么这个服务器是没有会话信息的。

　　最典型的一个例子：用户第一次进入一个系统是需要进行登录身份验证的，首先将请求跳转到Tomcat1服务器进行处理，登录信息是保存在Tomcat1 上的，这时候需要进行别的操作，那么可能会将请求轮询到第二个Tomcat2上，那么由于Tomcat2 没有保存会话信息，会以为该用户没有登录，然后继续登录一次，如果有多个服务器，每次第一次访问都要进行登录，这显然是很影响用户体验的。

　　这里产生的一个问题也就是集群环境下的 session 共享，如何解决这个问题？

　　通常由两种方法：

　　1、第一种方法是选择一个中间件，将登录信息保存在一个中间件上，这个中间件可以为 Redis 这样的数据库。那么第一次登录，我们将session 信息保存在 Redis 中，跳转到第二个服务器时，我们可以先去Redis上查询是否有登录信息，如果有，就能直接进行登录之后的操作了，而不用进行重复登录。

　　2、第二种方法是根据客户端的IP地址划分，每次都将同一个 IP 地址发送的请求都分发到同一个 Tomcat 服务器，那么也不会存在 session 共享的问题。

　　而 nginx 的基于 IP 路由负载的机制就是上诉第二种形式。大概配置如下：


upstream OrdinaryPolling {
    ip_hash;
    server 127.0.0.1:8080 weight=5;
    server 127.0.0.1:8081 weight=2;
    }
    server {
        listen       80;
        server_name  localhost;

        location / {
            proxy_pass http://OrdinaryPolling;
            index  index.html index.htm index.jsp;
        
        }
    }

　　注意：我们在 upstream 指令块中增加了 ip_hash 指令。该指令就是告诉 nginx 服务器，同一个 IP 地址客户端发送的请求都将分发到同一个 Tomcat 服务器进行处理。

④、基于服务器响应时间负载分配
　　根据服务器处理请求的时间来进行负载，处理请求越快，也就是响应时间越短的优先分配。

upstream OrdinaryPolling {
    server 127.0.0.1:8080 weight=5;
    server 127.0.0.1:8081 weight=2;
    fair;
    }
    server {
        listen       80;
        server_name  localhost;

        location / {
            proxy_pass http://OrdinaryPolling;
            index  index.html index.htm index.jsp;
        
        }
    }

　　通过增加了 fair 指令。

⑤、对不同域名实现负载均衡
 　　通过配合location 指令块我们还可以实现对不同域名实现负载均衡。

upstream wordbackend {
    server 127.0.0.1:8080;
    server 127.0.0.1:8081;
    }

    upstream pptbackend {
    server 127.0.0.1:8082;
    server 127.0.0.1:8083;
    }

    server {
        listen       80;
        server_name  localhost;

        location /word/ {
            proxy_pass http://wordbackend;
            index  index.html index.htm index.jsp;
        
        }
    location /ppt/ {
            proxy_pass http://pptbackend;
            index  index.html index.htm index.jsp;
        
        }
    }




nginx支持的负载均衡调度算法方式如下：

weight轮询（默认）：接收到的请求按照顺序逐一分配到不同的后端服务器，即使在使用过程中，某一台后端服务器宕机，nginx会自动将该服务器剔除出队列，请求受理情况不会受到任何影响。 这种方式下，可以给不同的后端服务器设置一个权重值（weight），用于调整不同的服务器上请求的分配率；权重数据越大，被分配到请求的几率越大；该权重值，主要是针对实际工作环境中不同的后端服务器硬件配置进行调整的。

ip_hash：每个请求按照发起客户端的ip的hash结果进行匹配，这样的算法下一个固定ip地址的客户端总会访问到同一个后端服务器，这也在一定程度上解决了集群部署环境下session共享的问题。

fair：智能调整调度算法，动态的根据后端服务器的请求处理到响应的时间进行均衡分配，响应时间短处理效率高的服务器分配到请求的概率高，响应时间长处理效率低的服务器分配到的请求少；结合了前两者的优点的一种调度算法。但是需要注意的是nginx默认不支持fair算法，如果要使用这种调度算法，请安装upstream_fair模块

url_hash：按照访问的url的hash结果分配请求，每个请求的url会指向后端固定的某个服务器，可以在nginx作为静态服务器的情况下提高缓存效率。同样要注意nginx默认不支持这种调度算法，要使用的话需要安装nginx的hash软件包







```




#### 常用nginx rewrite重定向-跳转实例:

```yml


 

1，将www.myweb.com/connect 跳转到connect.myweb.com

rewrite ^/connect$ http://connect.myweb.com permanent;

rewrite ^/connect/(.*)$ http://connect.myweb.com/$1 permanent;

 

2，将connect.myweb.com 301跳转到www.myweb.com/connect/ 

if ($host = "connect.myweb.com"){

rewrite ^/(.*)$ http://www.myweb.com/connect/$1 permanent;

    }

 

3，myweb.com 跳转到www.myweb.com

if ($host != 'www.myweb.com' ) { 

rewrite ^/(.*)$ http://www.myweb.com/$1 permanent; 

    }

 

4，www.myweb.com/category/123.html 跳转为 category/?cd=123

rewrite "/category/(.*).html$" /category/?cd=$1 last;

 

5，www.myweb.com/admin/ 下跳转为www.myweb.com/admin/index.php?s=

if (!-e $request_filename){

rewrite ^/admin/(.*)$ /admin/index.php?s=/$1 last;

    }

 

6，在后面添加/index.php?s=

if (!-e $request_filename){

    rewrite ^/(.*)$ /index.php?s=/$1 last;

    }

 

7，www.myweb.com/xinwen/123.html  等xinwen下面数字+html的链接跳转为404

rewrite ^/xinwen/([0-9]+)\.html$ /404.html last;

 

8，http://www.myweb.com/news/radaier.html 301跳转 http://www.myweb.com/strategy/

rewrite ^/news/radaier.html http://www.myweb.com/strategy/ permanent;

 

9，重定向 链接为404页面

rewrite http://www.myweb.com/123/456.php /404.html last;

 

10, 禁止htaccess

location ~//.ht {

         deny all;

     }

 

11, 可以禁止/data/下多级目录下.log.txt等请求;

location ~ ^/data {

     deny all;

     }

 

12, 禁止单个文件

location ~ /www/log/123.log {

      deny all;

     }

 

13, http://www.myweb.com/news/activies/2014-08-26/123.html 跳转为 http://www.myweb.com/news/activies/123.html

 

rewrite ^/news/activies/2014\-([0-9]+)\-([0-9]+)/(.*)$ http://www.myweb.com/news/activies/$3 permanent;

 

14，nginx多条件重定向rewrite

如果需要打开带有play的链接就跳转到play，不过/admin/play这个不能跳转

        if ($request_filename ~ (.*)/play){ set $payvar '1';}
        if ($request_filename ~ (.*)/admin){ set $payvar '0';}
        if ($payvar ~ '1'){
                rewrite ^/ http://play.myweb.com/ break;
        }

 

15，http://www.myweb.com/?gid=6 跳转为http://www.myweb.com/123.html

 if ($request_uri ~ "/\?gid\=6"){return  http://www.myweb.com/123.html;}

 

正则表达式匹配，其中：

* ~ 为区分大小写匹配

* ~* 为不区分大小写匹配

* !~和!~*分别为区分大小写不匹配及不区分大小写不匹配

文件及目录匹配，其中：

* -f和!-f用来判断是否存在文件

* -d和!-d用来判断是否存在目录

* -e和!-e用来判断是否存在文件或目录

* -x和!-x用来判断文件是否可执行

flag标记有：

* last 相当于Apache里的[L]标记，表示完成rewrite

* break 终止匹配, 不再匹配后面的规则

* redirect 返回302临时重定向 地址栏会显示跳转后的地址

* permanent 返回301永久重定向 地址栏会显示跳转后的地址

```




#### 

```yml



```




#### 

```yml



```



#### 

```yml



```




#### 

```yml



```




### 

```yml



```


### 

```yml
https://blog.csdn.net/u012453843/article/details/69668663


nginx和keepalived实现nginx高可用
2017年04月09日 00:19:43 在京奋斗者 阅读数：5839
 版权声明：本文为博主原创文章，未经博主允许不得转载。	https://blog.csdn.net/u012453843/article/details/69668663
        首先介绍一下Keepalived，它是一个高性能的服务器高可用或热备解决方案，Keepalived主要来防止服务器单点故障的发生问题，可以通过其与Nginx的配合实现web服务端的高可用。

        Keepalived以VRRP协议为实现基础，用VRRP协议来实现高可用性（HA）.VRRP (Virtual Router Redundancy Protocol)协议是用于实现路由器冗余的协议，VRRP协议将两台或多台路由器设备虚拟成一个设备，对外提供虚拟路由器IP（一个或多个），如下图所示：

       这张图的意思是，我们使用keepalived来管理两台设备的Nginx，并虚拟出一个IP，我们现在两台装有Nginx的设备分别是192.168.156.11和192.168.156.12，那么我们可以虚拟出一个192.168.156.xx的IP，外界请求直接访问虚拟IP而不是真正的Nginx，让虚拟IP去访问提供服务的Nginx（注意：高可用是指同一时间提供服务的只有一台设备，提供服务的设备挂掉之后，备份服务器便开始提供服务），然后再由Nginx去访问tomcat。

         

     我们拿两台虚拟机来搭建nginx高可用环境，这两台设备分别是192.168.156.11（主机名是nginx1）和192.168.156.12（主机名是nginx2）。

     如果是最小化安装的两台虚拟机，在搭建环境前需要做如下准备操作：

1.给虚拟机配置静态IP并要能上网，大家可以参考：http://blog.csdn.net/u012453843/article/details/52839105这篇博客进行学习

2.安装vim命令，使用命令：yum install vim-enhanced

3.安装gcc，使用命令：yum install make cmake gcc gcc-c++

4.安装依赖，如下所示。

yum install pcre  
yum install pcre-devel  
yum install zlib  
yum install zlib-devel
      做完了以上准备操作，我们可以安装nginx了，关于nginx的安装，大家可以参考：http://blog.csdn.net/u012453843/article/details/69396434这篇博客进行学习。
     下面我们在192.168.156.11和192.168.156.12两台设备上都安装下keepalived。大家可以到http://download.csdn.net/detail/u012453843/9808913这个地址下载keepalived-1.2.18.tar.gz。



下面我们便使用keepalived来实现nginx的高可用
1、我们需要修改下/etc/keepalived/keepalived.conf文件，首先修改192.168.156.11上的这个文件，修改后的配置内容如下

! Configuration File for keepalived
 
global_defs {
   router_id nginx1
}
 
vrrp_script chk_nginx {
   script "/etc/keepalived/nginx_check.sh"
   interval 2
   weight -20
}
 
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 11
    mcast_src_ip 192.168.156.11
    priority 100
    nopreempt
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
       chk_nginx
    }
    virtual_ipaddress {
        192.168.156.110
    }
}
      下面我们来具体学习下配置的意思，首先global_defs当中配置的是主机名，我的192.168.156.11的主机名是nginx1，因此这里配置的router_id的值是nginx1。
global_defs {
   router_id nginx1
}
      接着看下面这段配置，这段配置的意思是，每隔2秒中去执行/etc/keepalived/nginx_check.sh脚本一次，这项检查从开始便一直进行，interval表示间隔时间，weight -20的意思是，脚本执行成功后把192.168.156.11这个节点的优先级降低20。
vrrp_script chk_nginx {
   script "/etc/keepalived/nginx_check.sh"
   interval 2
   weight -20
}
      接着看下面这段配置，state MASTER表示该节点角色定义为MASTER，interface eth0是指虚拟机的网卡是eth0。virtual_router_id 11这项配置非常重要，两个节点的这项配置的值必须一样，否则会出现乱七八糟的问题，这里我把virtual_router_id的值设置为11是取自192.168.156.11的最后两位数字。mcast_src_ip 192.168.156.11这项配置是指定当前节点的真实IP。priority 100的意思是优先级，这里暂且设置为100，当然也可以是其它值。优先级在keepalived实现高可用方面起着至关重要的作用，keepalived服务器就是根据优先级来选择当前提供服务的设备的，192.168.156.11刚开始设置的优先级是100,192.168.156.12刚开始设置的优先级是90，这样keepalived一开始去检查优先级，发现192.168.156.11这台设备的优先级高，于是便让该设备对外提供服务，当192.168.156.11这台设备的nginx挂掉后，由于nginx_check.sh脚本每两秒执行一次，发现192.168.156.11这个节点没有nginx进程后便尝试进行重新启动nginx，如果重新启动还是不行的话，就杀掉所有的keepalived进程，并告诉keepalived服务器192.168.156.11这个节点的nginx挂掉了同时会把这个节点的优先级减20，从而优先级变为了80，这样下次keepalived来检查优先级发现192.168.156.12这个节点的优先级比较高（90），于是便让192.168.156.12这个节点对外提供服务，同理，这个节点发生故障的话，也会再去让另外一个节点来提供服务，这就实现了高可用。
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 11
    mcast_src_ip 192.168.156.11
    priority 100
    nopreempt
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
       chk_nginx
    }
    virtual_ipaddress {
        192.168.156.110
    }
} 
    那么怎么查看虚拟机的网卡是什么呢？我们使用命令ip a来查看，如下图所示，可以看到192.168.156.11这台虚拟机的网卡是eth0。而且现在可以看到这台设备只有一个IP地址，等一会儿配置好之后，会有虚拟IP的信息。


       下面我们来看如下配置，这段配置两个节点要一样，表明它们属于一个组，keepalived会同一组中去做检查并保持高可用。

authentication {
        auth_type PASS
        auth_pass 1111
    }
       下面再看这段配置，这段配置中的"chk_nginx"与我们在上面定义的定时执行脚本配置（vrrp_script chk_nginx）的名称要一样。
track_script {
       chk_nginx
    }
      下面再来看下面这段配置，这段配置的意思是对外提供的虚拟IP，这里可以是一个也可以是多个。
virtual_ipaddress {
        192.168.156.110
    }
       看完了配置文件，我们再来看下定时检查nginx的脚本文件nginx_check.sh（需要确保脚本格式是unix格式，方法是vim进入编辑模式，然后输入:set ff并按回车即可看到格式）。，如下所示（注意：wc -l的"l"是小写的L而不是1）。
#!/bin/sh
A=`ps -C nginx --no-header |wc -l`
if [ $A -eq 0 ];then
	/usr/local/nginx/sbin/nginx
	sleep 2
	if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
		killall keepalived
	fi
fi
      我们来学习下这个脚本的意思，下面这行的意思是，使用ps -C nginx --no-header |wc -l命令去检查当前nginx的进程数量并把查询到的进程数量赋值给变量A。
A=`ps -C nginx --no-header |wc -l`
     下面这行脚本的意思是，如果查询到的nginx的进程数量是0的话，就执行if条件里的内容。
if [ $A -eq 0 ];then
     下面这行代码的意思是由于检查到当前没有nginx进程，因此尝试去启动nginx。
/usr/local/nginx/sbin/nginx
     下面这行脚本的意思是启动nginx之后休眠2秒。
sleep 2
      下面这段脚本的医生说是如果nginx的进程数还是0的话，就认为nginx已经挂掉了，需要杀掉这个节点上所有的keepalived进程。
if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
		killall keepalived
	fi
      两个文件所在的目录是/etc/keepalived，如下所示。
[root@nginx1 keepalived]# pwd
/etc/keepalived
[root@nginx1 keepalived]# ll
总用量 8
-rw-r--r--. 1 root root 554 4月   9 01:51 keepalived.conf
-rw-r--r--. 1 root root 180 4月   9 03:30 nginx_check.sh
[root@nginx1 keepalived]# 
      以上便是192.168.156.11节点上的配置文件和脚本的内容。我们在192.168.156.12这个节点上也需要有这两个文件，192.168.156.12这个节点上keepalived.conf文件的内容如下：注意virtual_router_id的值要与192.168.156.11这个节点配置的值要一致。

! Configuration File for keepalived
 
global_defs {
   router_id nginx2
}
 
vrrp_script chk_nginx {
   script "/etc/keepalived/nginx_check.sh"
   interval 2
   weight -20
}
 
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 11
    mcast_src_ip 192.168.156.12
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
       chk_nginx
    }
    virtual_ipaddress {
        192.168.156.110
    }
}
      nginx_check.sh脚本文件在两个节点上内容一样，192.168.156.12节点上两个文件目录与192.168.156.11一样，如下所示。
[root@nginx2 keepalived]# pwd
/etc/keepalived
[root@nginx2 keepalived]# ll
总用量 8
-rw-r--r--. 1 root root 553 4月   9 02:35 keepalived.conf
-rw-r--r--. 1 root root 180 4月   9 02:41 nginx_check.sh
[root@nginx2 keepalived]# 
       由于目前nginx_check.sh脚本只有读权限，因此我们需要把两个节点上这个文件的权限放开，如下图所示。


       上面做好了铺垫之后，我们现在启动nginx，不过在启动nginx之前要保持两个节点nginx.conf配置一致，我们就都采用最原始的配置吧。如下所示。

#user  nobody;
worker_processes  1;
 
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
 
#pid        logs/nginx.pid;
 
 
events {
    worker_connections  1024;
}
 
 
http {
    include       mime.types;
    default_type  application/octet-stream;
 
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
 
    #access_log  logs/access.log  main;
 
    sendfile        on;
    #tcp_nopush     on;
 
    #keepalive_timeout  0;
    keepalive_timeout  65;
 
    #gzip  on;
 
    server {
        listen       80;
        server_name  localhost;
 
        #charset koi8-r;
 
        #access_log  logs/host.access.log  main;
 
        location / {
            root   html;
            index  index.html index.htm;
        }
 
        #error_page  404              /404.html;
 
        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
 
        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}
 
        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}
 
        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }
 
 
    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;
 
    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
 
 
    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;
 
    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;
 
    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;
 
    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;
 
    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
 
}
      为了能够区分欢迎页是哪个节点的欢迎页，我们修改下欢迎页的信息，如下图所示。


     下面我们来重新启动启动两个节点的nginx，如下所示。

[root@nginx1 html]# /usr/local/nginx/sbin/nginx -s reload
[root@nginx1 html]# 

[root@nginx2 html]# /usr/local/nginx/sbin/nginx -s reload
[root@nginx2 html]#
       启动nginx之后，我们首先直接访问192.168.156.11的nginx首页，如下图所示。


        下面我们再直接访问192.168.156.12的nginx首页，如下图所示



        下面我们启动两个节点上的keepalived，如下图所示。



       启动keepalived之后，我们可以在两个节点上看到共同的虚拟IP192.168.156.110，如下图所示，我们发现在两个节点上都看到了虚拟IP192.168.156.110，这是不合理的，正确情况应该是只在Master角色的节点上有虚拟IP。



       造成上图这种情况的原因是防火墙，为了避免因防火墙引起的各种问题，我们把两个节点的防火墙都关闭，而且可以设置开机也不启动防火墙，关闭防火墙的命令是：service iptables stop，设置不让防火墙开机重启的命令是chkconfig iptables off。关闭防火墙之后，我们再在两个节点查看IP信息，如下图所示，可以看到主节点192.168.156.11上有虚拟IP的信息，而备节点192.168.156.12上没有虚拟IP。这样才是正确的。


       这时我们便可以通过使用虚拟IP：192.168.156.110来访问nginx了，如下图所示，可以看到我们这时访问到的是192.168.156.11这台设备上的nginx。之所以会看到这台设备上的nginx是因为我们给这台设备keepalived赋予的优先级是100，而另一台设备192.168.156.12上keepalived赋予的优先级是90，显然192.168.156.11的优先级要高于192.168.156.12，因此keepalived服务器会选择192.168.156.11这个节点上的nginx对外提供服务。



       既然要达到高可用的目的，我们便来测试一下假如我们把192.168.156.11上的keepalived服务关掉之后，看keepalived服务器会不会自动帮我们切换到另一个节点192.168.156.12让其对外提供服务。

[root@nginx1 keepalived]# service keepalived stop
停止 keepalived：                                          [确定]
[root@nginx1 keepalived]# 
       关闭192.168.156.11的keepalived服务之后，我们再刷新http://192.168.156.110/，等一小会儿便可以看到提供nginx服务的自动变为nginx12了（也就是192.168.156.12），如下图所示。

        等我们的192.168.156.11设备故障修复之后，我们重启keepalived，如下图所示。

[root@nginx1 keepalived]# service keepalived start
正在启动 keepalived：                                      [确定]
[root@nginx1 keepalived]# 
        这时我们再刷新http://192.168.156.110/就会看到如下图所示界面，可以看到这时提供nginx服务的又自动切换为192.168.156.11这个节点了。说明我们已经实现了高可用性。

        由于我们把keepalived配置成了服务，并且设置成了开机自启动，下面我们把两台设备都重启，重启的命令是reboot。

        重启后，我们使用命令service keepalived status查看keepalived是否自己启动了，而且我们在nginx_check.sh脚本中会自动开启nginx，如下所示，发现都自动开启了。

[root@nginx1 ~]# service keepalived status
keepalived (pid  1197) 正在运行...
[root@nginx1 ~]# ps -ef|grep nginx
root       1233      1  0 22:10 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nobody     1235   1233  0 22:10 ?        00:00:00 nginx: worker process      
root       1628   1524  0 22:12 pts/0    00:00:00 grep nginx
[root@nginx1 ~]# 
[root@nginx2 ~]# service keepalived status
keepalived (pid  1198) 正在运行...
[root@nginx2 ~]# ps -ef|grep nginx
root       1234      1  0 22:10 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nobody     1236   1234  0 22:10 ?        00:00:00 nginx: worker process      
root       1670   1531  0 22:12 pts/0    00:00:00 grep nginx
[root@nginx2 ~]#
       下面我还可以人为让nginx的配置文件出错，这样nginx_check.sh脚本文件在去尝试启动nginx时发现启动不成功，便会将keepalived也都杀掉。比如我们把192.168.156.11这台设备的nginx的配置文件人为修改出错，我们只需少写一个";"即可，如下图所示，我们把"worker_connections  1024"后面的那个";"去掉。


       下面我们重启192.168.156.11这台虚拟机，重启之后，我们查看keepalived的状态，发现keepalived已经被杀掉了，nginx也没启动。出现这种情况的原因是，当192.168.156.11启动后，keepalived会自动启动，启动会每隔2秒去执行nginx_check.sh脚本文件，该脚本文件通过检查nginx的进程数量是0，于是去尝试启动nginx，由于我们把nginx.conf文件人为修改错了，因此无法正常启动脚本，在尝试了无法启动nginx之后，脚本便把keepalived的所有进程都杀掉了，于是便会看到我们下面的结果。

[root@nginx1 ~]# service keepalived status
keepalived 已死，但是 subsys 被锁
[root@nginx1 ~]# ps -ef|grep nginx
root       1430   1398  0 22:27 pts/0    00:00:00 grep nginx
[root@nginx1 ~]#
        我们这时访问虚拟IP的话，便只能看到192.168.156.12对外提供nginx服务了，如下图所示。


       至此，我们使用keepalived搭建nginx高可用便搭建完了。需要说明的是，keepalived不仅可以用于nginx的高可用，还可以用于redis、mysql等等所有服务的高可用。
--------------------- 
作者：在京奋斗者 
来源：CSDN 
原文：https://blog.csdn.net/u012453843/article/details/69668663 
版权声明：本文为博主原创文章，转载请附上博文链接！


```


### 

```



```


### 

```



```