# shadowsocks服务器和客户端配置

## 相关资料
老左博客-VPS相关知识
http://www.laozuo.org/
老左常用国内/国外VPS推荐
http://www.laozuo.org/myvps
申请谷歌云教程，可免费使用一年
https://blog.csdn.net/MrPrefect/article/details/81947369
https://segmentfault.com/a/1190000012884188
免费使用没有中国，地址随便，信用卡设置正确即可，会从信用卡扣1$，过几天自动退回
https://cloud.google.com/?hl=zh-cn
谷歌云
实例公网IP：35.241.90.67
wym密码
root设置同上


## google云


谷歌云GCP开启ROOT密码登录
步骤：
1: 登录服务器，切换到root用户，命令：sudo su
2: 修改ssh配置文件，命令: vim /etc/ssh/sshd_config
修改下面两个参数把no改为yes
PermitRootLogin no
PasswordAuthentication no
3: 重启ssh服务使修改生效，命令：/etc/init.d/ssh restart
centos命令：systemctl restart sshd ，老版用service sshd restart
4: 给root账户添加密码，命令：passwd root
输入命令后会让你设置密码，输入两次要设置的密码
此时，就完成了设置，即可通过root账号和你设置的密码登录服务器
$ ssh root@35.241.90.67

## 安装bbr加速
然后返回 VM实例 - 点击 在浏览器打开ssh - 然后 输入以下命令
1. sudo -i  
2. wget -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/YankeeBBR/master/bbr.sh && bash bbr.sh install
3. 如果出现蓝屏 选择 NO
4. 需要重启 输入 y，关闭 重新打开一个ssh
5. sudo -i
bash bbr.sh start

## 安装服务器端
https://www.zhulou.net/post/170.html
安装shadowsocksR
推荐俩个脚本 这是第一个
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh && chmod +x shadowsocksR.sh
./shadowsocksR.sh 2>&1 | tee shadowsocksR.log
完成后会要求输入 密码 - 端口号 然后剩下的回车就好 这里我输入的密码是 123456 端口是 455
推荐第二个脚本 这俩个脚本 任选一个安装即可
wget -N --no-check-certificate https://softs.fun/Bash/ssrmu.sh && chmod +x ssrmu.sh && bash ssrmu.sh
然后按照提示操作
使用说明
运行脚本，我们使用这个命令打开SSR多用户管理面板
bash ssrmu.sh
# 还有一个 运行参数，是用于所有用户流量清零的
bash ssrmu.sh clearall
# 不过不需要管这个，可以通过脚本自动化的设置 crontab 定时运行脚本
文件位置
安装目录：/usr/local/shadowsocksr
配置文件：/usr/local/shadowsocksr/user-config.json
数据文件：/usr/local/shadowsocksr/mudb.json
注意：ShadowsocksR服务端不会实时的把流量数据写入 数据库文件，所以脚本读取流量信息也不是实时的！

SSR   链接 : ssr://MzUuMjQxLjkwLjY3OjIzMzA6YXV0aF9hZXMxMjhfbWQ1OmFlcy0xMjgtY3RyOnBsYWluOllTRTJOVFF4TWpN
SSR 二维码 : http://doub.pw/qr/qr.php?text=ssr://MzUuMjQxLjkwLjY3OjIzMzA6YXV0aF9hZXMxMjhfbWQ1OmFlcy0xMjgtY3RyOnBsYWluOllTRTJOVFF4TWpN
  提示:
在浏览器中，打开二维码链接，就可以看到二维码图片。
协议和混淆后面的[ _compatible ]，指的是 兼容原版协议/混淆。

## 安装 ss 客户端
shadowsocks安装时是不分客户端还是服务器端的, 只不过安装后有两个脚本一个是ss-local代表以客户端模式工作，一个是ss-server代表以服务器端模式工作


### CentOS 7 安装使用Shadowsocks客户端
```

CentOS 7 安装使用Shadowsocks客户端

2018.01.30 19:50 字数 222 阅读 19648评论 4喜欢 17
实验背景、由于安装k8s使用官方源需要使用代理，故在CentOS7配置代理、进行科学上网

安装Shadowsocks客户端
安装epel源、安装pip包管理
sudo yum -y install epel-release

sudo yum -y install python-pip

安装Shadowsocks客户端
sudo pip install shadowsocks

配置Shadowsocks连接
新建配置文件、默认不存在
sudo mkdir /etc/shadowsocks
sudo vi /etc/shadowsocks/shadowsocks.json

{
"server":"35.241.90.67",
"server_port":2330,
"local_address": "127.0.0.1",
"local_port":1080,
"password":"d2b022067467135e",
"timeout":300,
"method":"aes-256-cfb",
"fast_open": false,
"workers": 5
}

添加配置信息：前提是需要有ss服务器的地址、端口等信息
{
    "server":"35.241.90.67",  # Shadowsocks服务器地址
    "server_port":1035,  # Shadowsocks服务器端口
    "local_address": "127.0.0.1", # 本地IP
    "local_port":1080,  # 本地端口
    "password":"password", # Shadowsocks连接密码
    "timeout":300,  # 等待超时时间
    "method":"aes-256-cfb",  # 加密方式
    "fast_open": false,  # true或false。开启fast_open以降低延迟，但要求Linux内核在3.7+
    "workers": 1  #工作线程数
}

配置自启动
新建启动脚本文件，
注意：
如果安装 shadowsocks-2.8.2，sudo pip install shadowsocks，那么 /usr/bin/目录下会有sslocal或ssserver
如果安装shadowsocks-libev，安装完成后，会有 ss-local, ss-manager, ss-nat, ss-redir, ss-server, ss-tunnel 命令可用 
如果1080端口被占用，检查$ systemctl status shadowsocks-libev-local，关闭它

用来测试，实际使用建立下面的自启动文件
#启动
ssserver -c /etc/shadowsocks.json -d start
#停止
ssserver -c /etc/shadowsocks.json -d stop
#重启
ssserver -c /etc/shadowsocks.json -d restart

#查看是否成功启动
ps -ef | grep shad

vi /etc/systemd/system/shadowsocks.service，内容如下：

[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
#ExecStart=/usr/bin/ss-local -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target

启动Shadowsocks服务

systemctl enable shadowsocks.service
systemctl start shadowsocks.service
systemctl status shadowsocks.service


验证Shadowsocks客户端服务是否正常运行
curl --socks5 127.0.0.1:1080 http://httpbin.org/ip

Shadowsock客户端服务已正常运行，则结果如下：
{
  "origin": "x.x.x.x"       #你的Shadowsock服务器IP
}

安装配置privoxy
安装privoxy
yum install privoxy -y
systemctl enable privoxy
systemctl start privoxy
systemctl status privoxy

配置privoxy
修改配置文件
vi /etc/privoxy/config


listen-address 127.0.0.1:8118 # 8118 是默认端口，不用改，只是检查
forward-socks5t / 127.0.0.1:1080 . #去掉注释，转发到本地端口，注意最后有个点

设置http、https代理
# vi /etc/profile 在最后添加如下信息，注意，要把本地地址设置不需要代理

PROXY_HOST=127.0.0.1
export all_proxy=http://$PROXY_HOST:8118
export ftp_proxy=http://$PROXY_HOST:8118
export http_proxy=http://$PROXY_HOST:8118
export https_proxy=http://$PROXY_HOST:8118
#export no_proxy=localhost,192.168.102.0/24,127.0.0.1,172.16.0.0/24,172.0.0.0/16,192.168.0.0/24,10.0.0.0/24,172.20.0.0/24
#export no_proxy=localhost,172.17.0.0/16,192.168.102.0/24,127.0.0.1,10.0.2.0/24,172.20.0.0/24

# 重载环境变量
source /etc/profile

测试代理
[root@aniu-k8s ~]# curl -I www.google.com
HTTP/1.1 200 OK
Date: Fri, 26 Jan 2018 05:32:37 GMT
Expires: -1
Cache-Control: private, max-age=0
Content-Type: text/html; charset=ISO-8859-1
P3P: CP="This is not a P3P policy! See g.co/p3phelp for more info."
Server: gws
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
Set-Cookie: 1P_JAR=2018-01-26-05; expires=Sun, 25-Feb-2018 05:32:37 GMT; path=/; domain=.google.com
Set-Cookie: NID=122=PIiGck3gwvrrJSaiwkSKJ5UrfO4WtAO80T4yipOx4R4O0zcgOEdvsKRePWN1DFM66g8PPF4aouhY4JIs7tENdRm7H9hkq5xm4y1yNJ-sZzwVJCLY_OK37sfI5LnSBtb7; expires=Sat, 28-Jul-2018 05:32:37 GMT; path=/; domain=.google.com; HttpOnly
Transfer-Encoding: chunked
Accept-Ranges: none
Vary: Accept-Encoding
Proxy-Connection: keep-alive

取消使用代理
while read var; do unset $var; done < <(env | grep -i proxy | awk -F= '{print $1}')

参考链接：
http://blog.csdn.net/u012375924/article/details/78706910
https://www.zybuluo.com/ncepuwanghui/note/954160

firewalld防火墙

centos7用的firewalld，若不进行设置，可能会导致SS无法使用，如果是阿里云服务器，则可以在阿里云管理后台设置安全组；


# 开放端口
$ firewall-cmd --permanent --add-port=18381-18385/tcp 
# 修改规则后需要重启
$ firewall-cmd --reload 

```

### Ubuntu18.04 下 安装shadowsocks + privoxy 全局代理

```javascript
https://www.jianshu.com/p/e0b05cb7cd50

更新软件源
$ sudo apt update

安装 python-pip:
$ sudo apt install python-pip

安装 shadowsocks
$ sudo pip install shadowsocks

配置 shadowsocks
$ sudo gedit /etc/shadowsocks.json

{ 
    "server":"代理服务器ip”,
    "server_port":代理服务器端口,
    "password":"代理服务器访问密码”,  
    "local_address":"127.0.0.1”, 
    "local_port":1080, 
    "timeout":600, 
    "method":"aes-256-cfb" // 代理服务器访问数据加密方式，根据自己配置ss 服务端时的配置自行填写
}

启动 shadowsocks
$ sudo sslocal -c /etc/shadowsocks.json -d start



配置系统全局代理

安装GenPAC
$ sudo pip install genpac
$ pip install —-upgrade genpac

完成之后，下载gfwlist
$ genpac --pac-proxy "SOCKS5 127.0.0.1:1080" --gfwlist-proxy="SOCKS5 127.0.0.1:1080" --gfwlist-url=https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt --output="autoproxy.pac” 

genpac 的详细使用说明请见 Wiki。
找到下载下来的 autoproxy.pac文件，然后进入：设置—网络—网络代理，选择手动，URL 指向该文件路径即可，url 格式为：
file:///home/{user}/autoproxy.pac
({user}替换成自己的用户)

配置浏览器
此处以火狐为例：首选项——网络代理—— 设置，选择 “使用系统代理设置” 即可

这样，浏览器就能正常使用代理了。


但是，之所以搭架 ss，并不单只是为了上油管的。这次我也是为了下载 android 源码才装的 ubuntu，所以还没完，你会发现这个时候终端中的 curl 之类的指令并不能使用代理，所以接着往下看。（当然，可以根据自身需求决定是否往下看了，哈哈）

安装并配置 privoxy
安装 privoxy
$ sudo apt install privoxy 

配置privoxy
$ sudo gedit /etc/privoxy/config

打开文件找到4.1节 listen-address，
找到#listen-address 127.0.0.1:8118，取消注释

找到5.2节forward-socks4, forward-socks4a, forward-socks5 and forward-socks5t，
找到#forward-socks5t / 127.0.0.1:9050 .（后面的.很重要，不能舍弃，端口值可能和我的不一样，改成1080即可）


修改完之后，重启 privoxy：

$ sudo /etc/init.d/privoxy restart


再修改~/.bashrc
$ sudo gedit ~/.bashrc

打开文件后，加入：
export http_proxy="127.0.0.1:8118"
export https_proxy="127.0.0.1:8118"
export ftp_proxy="127.0.0.1:8118"

保存退出后，终端也就可以使用代理了，我们来试一下 curl：

有返回，则说明配置成功

为 Git 配置代理
最后，我还要配置一项：为 git 配置代理，否则 google / android 源码是同步不下来的，可以找份代码先验证一下：
$ git clone https://chromium.googlesource.com/external/webrtc

会报错：
正克隆到 'webrtc'… 
fatal: unable to access 'https://chromium.googlesource.com/external/webrtc/': 
Failed to connect to chromium.googlesource.com port 443: 连接超时

所以需先为 git 配置代理：
$ git config --global http.proxy 'socks5://127.0.0.1:1080' 
$ git config --global https.proxy 'socks5://127.0.0.1:1080'

配置好就能 正常clone了：


如果要关闭代理可使用一下命令：
$ git config --global --unset http.proxy
$ git config --global --unset https.proxy

配置 Shadowsocks privoxy 自启动
每次重启之后，都需要手动启动 ss 和 privoxy 比较麻烦，所以可以添加自启动。
由于ubuntu18.04不再使用initd管理系统，改用systemd。
systemd 默认读取 /etc/systemd/system 下的配置文件，该目录下的文件会链接/lib/systemd/system/下的文件。
rc-local.service就是我们需要配置的文件,先创建软连接：

ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service

该脚本内容为：

#  SPDX-License-Identifier: LGPL-2.1+
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

# This unit gets pulled automatically into multi-user.target by
# systemd-rc-local-generator if /etc/rc.local is executable.
[Unit]
Description=/etc/rc.local Compatibility
Documentation=man:systemd-rc-local-generator(8)
ConditionFileIsExecutable=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
RemainAfterExit=yes
GuessMainPID=no

一般正常的启动文件主要分成三部分

[Unit] 段: 启动顺序与依赖关系
[Service] 段: 启动行为,如何启动，启动类型
[Install] 段: 定义如何安装这个配置文件，即怎样做到开机启动

很明显上面的脚本中少了 Install段，也就没有定义如何做到开机启动，配置无法生效。所以在该文件中加上：

[Install]
WantedBy=multi-user.target
Alias=rc-local.service

然后创建/etc/rc.local文件

touch /etc/rc.local
chmod 755 /etc/rc.local

然后编辑该文件，加入以下脚本：

#!/bin/bash
sudo sslocal -c /etc/shadowsocks.json -d start
sudo /etc/init.d/privoxy start

保存退出，执行reboot重启系统。

至此，整个全局代理的配置也就完毕了！以前没怎么写过博客，排版比较混乱，但也算是记录下来了，分享一下，希望能帮到大家。后续就是同步、编译android 源码了，到时候继续写。

参考：
https://www.jianshu.com/p/ee0c2237ceb6
https://my.oschina.net/yhcocacoder/blog/1790718

作者：fatto
链接：https://www.jianshu.com/p/e0b05cb7cd50
来源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。






```

### docker代理配置

```
创建目录
# mkdir /etc/systemd/system/docker.service.d

创建文件
# vim /etc/systemd/system/docker.service.d/http-proxy.conf
配置http-proxy.conf文件增加以下内容

[Service]
Environment="HTTP_PROXY=http://127.0.0.1:8118"
Environment="NO_PROXY=localhost,127.0.0.0/8,192.168.102.3:8001"

注意：一定要将私库地址添加到no_proxy里，否则，无法向私库里面push镜像。

daemon重新reload 并重启docker
# systemctl daemon-reload
# systemctl restart docker

检查变量是否加载
# systemctl show docker --property Environment



```

https://zzz.buzz/zh/gfw/2018/03/21/install-shadowsocks-client-on-centos-7/


### CentOS/RHEL 7 下安装 Shadowsocks 客户端
2018 年 3 月 21 日 （最近更新：2018 年 5 月 22 日）
安装 Shadowsocks
验证安装
常见问题
添加配置文件
启动 Shadowsocks 服务
检查 Shadowsocks 服务状态
在 CentOS 7 或 RHEL (Red Hat Enterprise Linux) 7 下安装 Shadowsocks 的客户端非常容易。由于在 COPR (Cool Other Package Repo) 中已经有打包好的 shadowsocks-libev，因此我们只需几条命令便能完成安装。
注：本文介绍的是 Shadowsocks 客户端在 CentOS/RHEL 7 上的配置方法，如需了解 Shadowsocks 服务端在 CentOS/RHEL 7 上的配置，请参阅 CentOS/RHEL 7 下安装 Shadowsocks 服务端。
安装 Shadowsocks
执行安装 Shadowsocks 的命令之前，我们需要先切换到 root 用户（直接以 root 身份登入；或是以普通用户登入，通过命令 sudo su - 切换为 root 用户)，或者使用普通用户，但在每条命令前加上 sudo。
另外，后续的配置也需要以 root 用户的身份进行。
具体安装 shadowsocks-libev 的命令如下：
cd /etc/yum.repos.d/
curl -O https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo
yum install -y shadowsocks-libev
安装完成后，会有 ss-local, ss-manager, ss-nat, ss-redir, ss-server, ss-tunnel 命令可用。
其中，作为客户端，我们需要的是 ss-local，不过后文中我们将通过服务文件启动 Shadowsocks，而不会直接与 ss-local 命令打交道。
注，如果安装报类似如下错误：
Error: Package: shadowsocks-libev-3.1.3-1.el7.centos.x86_64 (librehat-shadowsocks)
           Requires: libsodium >= 1.0.4
Error: Package: shadowsocks-libev-3.1.3-1.el7.centos.x86_64 (librehat-shadowsocks)
           Requires: mbedtls
说明系统没有启用 EPEL (Extra Packages for Entreprise Linux)。那么我们需要首先启用 EPEL，再安装 shadowsocks-libev：
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y shadowsocks-libev
验证安装
在继续后文的配置之前，我们先在命令行中执行一次 ss-local 命令，以确认 shadowsocks 及其依赖已正确安装。
如运行正常，则跳过常见问题，继续添加配置文件。
常见问题
执行 ss-local 报错：ss-local: error while loading shared libraries: libmbedcrypto.so.0: cannot open shared object file: No such file or directory:
使用 root 身份执行以下命令即可：
cd /usr/lib64
ln -s libmbedcrypto.so.1 libmbedcrypto.so.0
参考：error while loading shared libraries: libmbedcrypto.so.0 · Issue #1966 · shadowsocks/shadowsocks-libev
添加配置文件
COPR 里的 shadowsocks-libev 默认读取位于 /etc/shadowsocks-libev/config.json 的配置文件，我们可以根据需要参考以下配置文件进行修改：
{
 "server":"35.241.90.67",
 "server_port":2330,
 "local_address": "127.0.0.1",
 "local_port":1080,
 "password":"d2b022067467135e",
 "timeout":300,
 "method":"aes-256-cfb",
 "fast_open": false,
 "workers": 5
}
"server"： 必填，填入要连接的 shadowsocks 服务器域名或 IP。
"server_port"： 必填，填入服务器上 shadowsocks 所监听的端口。
"local_port"： 必填，填入本地 shadowsocks 客户端 SOCKS5 代理要监听的端口。
"password"： 必填，密码，需与 shadowsocks 服务器端配置一致。
"method"： 必填，加密方法，需与 shadowsocks 服务器端配置一致。
"mode"： 选填，默认 "tcp_only"。
shadowsocks 所要监听的协议，可填 "tcp_only", "udp_only" 和 "tcp_and_udp"。
填入 "tcp_and_udp" 相当于命令行上提供 -u 参数；填入 "udp_only" 相当于命令行上提供 -U 参数。
"timeout"： 选填，不活动连接的保持时间。
默认 60 秒，设置较长时间有助于保持 HTTP 长连接等。设置时间过长则会导致不必要地占用过多 shadowsocks 服务器资源。
对于配置客户端，完成以上几项配置就足够了。
如果想要变更默认的配置文件，或者提供其他命令行参数，我们可以修改 /etc/sysconfig/shadowsocks-libev：
# Configuration file
CONFFILE="/etc/shadowsocks-libev/config.json"
# Extra command line arguments
DAEMON_ARGS="-u"
其中 CONFFILE 指定了 shadowsocks-libev 所读取的配置文件；DAEMON_ARGS 则指定了额外的命令行参数，此处的 "-u" 表示启用 UDP 协议。
需要注意的是，命令行参数 DAEMON_ARGS 比配置文件 CONFFILE 中指定的选项优先级要更高一些。
启动 Shadowsocks 服务
有了 Shadowsocks 客户端的配置文件后，我们通过 systemd 启动 Shadowsocks 的客户端服务：
systemctl enable --now shadowsocks-libev-local
以上命令同时也会配置 Shadowsocks 客户端服务的开机自动启动。
至此，客户端所需要的所有配置就都已经完成了。
检查 Shadowsocks 服务状态
要确认 Shadowsocks 的服务运行状态及最新日志，我们可以执行命令：
systemctl status shadowsocks-libev-local
要查看 Shadowsocks 服务的全部日志，我们可以执行命令：
journalctl -u shadowsocks-libev-local
如果需要在路由器上配置 Shadowsocks 的客户端，则可以参考 在路由器上部署 shadowsocks。

ss -unl 可以查看到监听的端口
* 验证Shadowsocks客户端服务是否正常运行
curl --socks5 127.0.0.1:1080 http://httpbin.org/ip
* Shadowsock客户端服务已正常运行，则结果如下：
{
  "origin": "x.x.x.x"       #你的Shadowsock服务器IP
}
https://www.jianshu.com/p/48b3866b5e2a
安装Privoxy
上述安好了shadowsocks，但它是 socks5 代理，我门在 shell 里执行的命令，发起的网络请求现在还不支持 socks5 代理，只支持 http/https 代理。为了我门需要安装 privoxy 代理，它能把电脑上所有http请求转发给 shadowsocks
yum install privoxy -y
* 查看 vim /etc/privoxy/config 文件，
先搜索关键字 listen-address 找到 listen-address 127.0.0.1:8118 这一句，保证这一句没有注释，8118就是将来http代理要输入的端口。
然后搜索 forward-socks5t, 将 #forward-socks5t / 127.0.0.1:9050 .此句前面的注释去掉，
然后修改为forward-socks5t / 127.0.0.1:1080 .
意思是转发流量到本地的1080端口, 而1080端口是你的 ss 监听的端口。
启动privoxy
systemctl restart privoxy 
systemctl enable privoxy
转发配置
写在 profile 中
> vim /etc/profile
export http_proxy=http://127.0.0.1:8118
export https_proxy=http://127.0.0.1:8118
> source /etc/profile
在当前 session 执行
export http_proxy=http://127.0.0.1:8118
export https_proxy=http://127.0.0.1:8118
测试翻墙
curl www.google.com

参考
 
https://www.jianshu.com/p/824912d9afda
CentOS 7 安装使用Shadowsocks客户端
前半部分的客户端安装启动失败，代理可以用
