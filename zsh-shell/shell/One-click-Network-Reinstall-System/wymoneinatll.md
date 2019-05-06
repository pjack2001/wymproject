

# 使用说明

## 帮助



###


```yml




$ scp *.sh root@192.168.102.3:/home/y/linuxiso/httpd/iso/One-click-Network-Reinstall-System

$ scp CXT_Bare-metal_System_Deployment_Platform.vhd.gz root@192.168.102.3:/home/y/linuxiso/httpd/iso/One-click-Network-Reinstall-System


http://192.168.102.3/iso/One-click-Network-Reinstall-System/
可以打开即可


```



### 


```yml


```


### [经验] [修复Debian源和DD问题] 一键网络重装系统 - 魔改版


```yml
https://www.hostloc.com/thread-532519-1-1.html

基本方法

下载脚本
wget --no-check-certificate -qO ~/Network-Reinstall-System-Modify.sh 'https://tech.cxthhhhh.com/tech-tools/Network-Reinstall-System-Modify/Network-Reinstall-System-Modify.sh' && chmod a+x ~/Network-Reinstall-System-Modify.sh

00. 安装裸机系统部署平台
*仅适用于高端用户，手动安装任意系统。可通过网络ISO或iPXE安装任意系统。
bash ~/Network-Reinstall-System-Modify.sh -CXT_Bare-metal_System_Deployment_Platform

01. 安装DD系统
*如果您不了解这意味着什么，请不要进行操作。%ULR%应该替换为您自己的映像地址。
bash ~/Network-Reinstall-System-Modify.sh -DD "%URL%"

通用解决方案
①. 一键网络重装纯净CentOS 7（推荐）
bash ~/Network-Reinstall-System-Modify.sh -CentOS_7

③. 一键网络重装纯净Debian 9（推荐）
bash ~/Network-Reinstall-System-Modify.sh -Debian_9

⑥. 一键网络重装纯净Ubuntu 18.04（推荐）
bash ~/Network-Reinstall-System-Modify.sh -Ubuntu_18.04

⑨. 一键网络重装纯净Windows Server 2019（推荐）
bash ~/Network-Reinstall-System-Modify.sh -Windows_Server_2019

如何做和使用

If you are from an English community, please click here.
[Original] One-click Network Reinstall System - Magic Modify version (For Linux/Windows)
https://tech.cxthhhhh.com/linux/2018/11/27/original-one-click-network-reinstall-system-magic-modify-version-for-linux-windows-en.html

如果你来自于中文社区，请点击这里
[原创] 一键网络重装系统 - 魔改版（适用于Linux / Windows）
https://tech.cxthhhhh.com/linux/2018/11

```

### [原创] 一套完整解决方案为新服务器（系统安装、建站环境配置、网络和系统优化、完整备份还原迁移、桌面环境、工具合集）

```yml
https://tech.cxthhhhh.com/linux/2018/08/12/original-a-complete-solution-for-new-servers-buy-installation-site-environment-configuration-network-and-system-optimization-full-backup-and-restore-migration-desktop-environment-tools-cn.html

[原创] 一套完整解决方案为新服务器（系统安装、建站环境配置、网络和系统优化、完整备份还原迁移、桌面环境、工具合集）
 2018-08-12  1条评论  169,633次阅读  43人点赞
简介
Have you recently purchased or want to buy a new server and are ready to build a personal blog / corporate website. Then you are right, here is a set of solutions for you. (whether you are an enterprise operation or maintenance person or a personal webmaster)

This year, I have put a lot of effort into it, and my company is booming. This is very gratifying. But as a geek-born entrepreneur, it is one of my missions to not forget the original intention of bringing convenience to everyone. Thank you very much for your support.

Therefore, in my spare time, I have created some wheels and are committed to building a light and fast website construction solution for you. (Query article title, find it quickly)

If you are from an English community, please click here.

你最近是否购买了或者想购买新的服务器，准备构建个人博客 / 企业网站。那么你访问对了，这里是一套专门为你准备的一套解决方案。（无论你是企业运维人员还是个人站长）

这一年，我付诸了很多努力，我的公司蒸蒸日上，这是令人欣慰的。但是作为一个极客出身的企业家，不忘初衷的为大家带来便利将会是我的使命之一。非常感谢大家的支持。

因此，在闲暇之余我造了一些轮子，致力于为你构建一套轻便快捷的网站建设解决方案。（查询文章标题，快速寻找）

让我们开始
Step 1. 如何挑选可靠稳定的服务器
警告：不要在网站服务器费用支出上节省资金。网站服务器需要的是稳定和可靠。（如果你节省，你将会支付更多，甚至失去你的数据。）

推荐选择以下云平台服务商，他们将会给你非常棒的体验：
Google Cloud、Microsoft Azure Cloud、Amazon Web Services、SoftLayer Cloud、Alibaba Cloud。以及其他你的国家最好的云服务平台。

其次，如果资金不足，你可以选择以下推荐的VPS：
Vultr、Linode、DigitalOcean、Tencent Cloud。以及其他你的国家最好的VPS商家。

问：为什么推荐这些商家？
答：因为这些商家拥有多年运营经验，已经拥有大规模用户。同时，他们的平台均提供了快照或者恢复模式，方便我们服务的备份恢复和迁移。稳定的服务保护了我们的数据安全。除此之外，如果你的网站具有特定敏感信息，你需要选择无版权服务器，例如罗马尼亚等国家的服务器。

这里分享几个Shell服务器测试工具：

UnixBench一键跑分（由teddysun.com提供）
wget --no-check-certificate https://github.com/teddysun/across/raw/master/unixbench.sh && chmod +x unixbench.sh && ./unixbench.sh

测试服务器性能（由www.oldking.net提供）
curl -Lso- https://raw.githubusercontent.com/oooldking/script/master/superbench.sh | bash

仅测试服务器网络情况（由www.oldking.net提供）
wget https://raw.githubusercontent.com/oooldking/script/master/superspeed.sh && chmod +x superspeed.sh && ./superspeed.sh

Step 2. 如何挑选系统版本
警告：你应该选择最新的稳定版系统，无论是Linux还是Windows或者其他系统，并且安装最新安全补丁。（不要选择开发版）

RedHat/CentOS、Debian/Ubuntu、Windows Server都被使用于服务器上。
其中RedHat/CentOS和Windows Server通常更多在个人、企业和政府建站中使用。对于一些个人站长，他们会选择更简洁的Debian和Ubuntu系统。我推荐使用RedHat/CentOS系统。

问：在选择系统上，除了上面你讲的之外还有什么需要注意的？
答：你还应该根据公司项目的需求选择，例如一些政府软件要求运行于Windwos Server上，他们需要MSSQL或者NET.框架，他们拥有微软的整套服务提供支持，因此你必须选择Windwos Server。
同时，很多商业软件都是要求在RedHat/CentOS下使用，其他系统是不被支持的或者软件运行不稳定，因此你必须选择RedHat/CentOS。
如果你的资金足够，我建议你购买红帽企业服务支持或者微软服务支持。

[推荐系统] [原创] 一键网络重装最新CentOS 7 （官方，纯净，安全，高效）
[为什么推荐？这个系统纯净(避免了服务商的监控，例如Alibaba Cloud、Tencent Cloud等等)，并且针对不同机器之间的系统备份迁移做了优化。用于方便您后续的维护使用。](由tech.cxthhhhh.com提供)

有些服务器上系统默认分配磁盘较小，您需要手动扩容

[原创] 如何扩展Linux硬盘（LVM磁盘）

Step 3. 如何优化系统和网络
我提供的这套解决方案主要针对RedHat/CentOS。因此全部通过测试在最新CentOS7.X。

你需要开启Swap内存，防止物理内存不足导致错误。
同时你可以安装一些网络加速软件，例如BBR，LotServer等。

这里分享几个Shell优化工具：

1. 一键更换内核，安装LotServer网络优化，开启TCP Fast Open，设置2GB Swap内存。(由tech.cxthhhhh.com提供)
sudo curl -sSL https://raw.githubusercontent.com/MeowLove/AlibabaCloud-CentOS7-Pure-and-safe/master/download/LotServer/install.sh | sudo bash

2. 一键安装最新内核，并启用Google BBR协议。（由teddysun.com提供）
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh

Step 4. 如何配置服务器环境
警告：如果你购买的商业软件，他们公司要求您安装指定系统，例如Redhat，那么您必须按照软件说明文档来配置您的服务器环境。

网站环境配置，具有多种方案。收费的和免费的。你需要选择你所信任的软件。（我将更多推荐的是对中文语言支持友好且更新稳定有保障的建站环境管理软件）

付费方案（具有GUI）：

1. cPanel（当你搭建网站时）[具有Linux支持] [点击前往]
2. Plesk（当你搭建网站时）[具有Linux和Windows支持] [点击前往]
3. AMH（当你搭建网站时）[具有Linux支持] [点击前往]
4. SolusVM（当你搭建销售平台时）[具有Linux支持] [点击前往]
5. WHMCS（当你搭建销售平台时）[具有Linux支持] [点击前往]
6. Virtualizor（当你销售服务器时）[具有Linux支持] [点击前往]

免费方案（具有GUI）：
1. BT-宝塔（当你搭建网站时）[具有Linux和Windows支持] [点击前往]
2. UPUPW ANK（当你搭建网站时）[具有Windows支持] [点击前往]
3. AppNode（当你搭建网站时）[具有Linux支持] [点击前往]
4. VestaCP（当你搭建网站时）[具有Linux支持] [点击前往]
5. WDCP（当你搭建网站时）[具有Linux支持] [点击前往]
6. CyberPanel（当你搭建网站时）[具有Linux支持] [点击前往]
7. CentOS Web Panel（当你搭建网站时）[具有Linux支持] [点击前往]
8. ISPConfig（当你搭建网站时）[具有Linux支持] [点击前往]
9. Feathur（当你搭建网站时）[具有Linux支持] [点击前往]
10. Proxmox（当你销售服务器时）[具有Linux支持] [点击前往]

免费方案（没有GUI仅命令）：
1. LNMP（当你搭建网站时）[具有Linux支持] [点击前往]
2. LAMP（当你搭建网站时）[具有Linux支持] [点击前往]
3. Caddy Web（当你搭建网站时）[具有Linux和Windows支持] [点击前往]
4. OneinStack（当你搭建网站时）[具有Linux支持] [点击前往]

我通常使用LNMP和宝塔(aaPanel)，因此他们的一键安装脚本在这里。

宝塔（aaPanel）一键安装
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install.sh && sh install.sh

LNMP一键安装
wget http://soft.vpser.net/lnmp/lnmp1.5.tar.gz -cO lnmp1.5.tar.gz && tar zxf lnmp1.5.tar.gz && cd lnmp1.5 && ./install.sh lnmp

如果您需要一键安装Linux桌面环境和RDP远程连接
[原创] 一键安装桌面环境、RDP、Windows支持（For Linux）

Step 5. 对系统进行完整备份
警告：数据是无价且珍贵的，你必须经常备份。我的建议：至少一个月进行一次完整备份，一周进行一次增量备份或差异备份。

我提供了完整的一套备份还原方案，你可以尝试。

1. 备份系统
[原创] 整机备份/还原Linux系统(异机迁移、保护数据、环境迁移)

2. 还原系统
[原创] 恢复Linux系统（恢复备份，保护数据，服务器迁移）

注意：当你使用了我推荐的CentOS7时，允许您在不同服务器之间进行备份还原。如果使用其他系统，您则只能在同一台服务器上备份还原。

Step 6. 其他也许有助于您的工具
1. 查看系统版本
uname -a
cat /proc/version

2. 查看所有已安装内核版本
rpm -qa | grep kernel

3. 修改Linux的DNS
vim /etc/sysconfig/network-scripts/ifcfg-eth0
DNS1=1.1.1.1
DNS2=8.8.8.8

4. 一键安装KMS服务脚本（由teddysun.com提供）
wget --no-check-certificate https://github.com/teddysun/across/raw/master/kms.sh && chmod +x kms.sh && ./kms.sh

5. 一键安装FFMPEG（由www.ffmpegtoolkit.com提供）
yum install git wget -y && cd /opt && git clone https://github.com/hostsoft/ffmpegtoolkit.git ffmpegtoolkit && cd ffmpegtoolkit && sh latest.sh

6. 查询硬盘使用时长(主要针对独立服务器，VPS没意义)
yum install smartmontools -y
smartctl -A /dev/sda

7. Frp一键安装脚本（内网穿透利器）（由koolshare.cn的clang大佬提供）
wget --no-check-certificate https://raw.githubusercontent.com/clangcn/onekey-install-shell/master/frps/install-frps.sh -O ./install-frps.sh && chmod 700 ./install-frps.sh && ./install-frps.sh install

8. 一键安装Aria2+Ariang+Filemanager+H5ai管理脚本（由teduis.com提供）
wget --no-check-certificate https://raw.githubusercontent.com/Thnineer/Bash/master/aria2u.sh && chmod +x aria2u.sh && bash aria2u.sh

9. Online.net机器配置IPV6一键脚本（由Github用户jxzy199306提供）
sudo wget -O /etc/cxthhhhh.com/ipv6-dhclient-script.sh https://raw.githubusercontent.com/jxzy199306/ipv6_dhclient_online_net/master/ipv6_dhclient_online_net.sh && chmod +x /etc/cxthhhhh.com/ipv6-dhclient-script.sh && bash /etc/cxthhhhh.com/ipv6-dhclient-script.sh

10. 任意服务器配置IPV6教程（由tech.cxthhhhh.com提供）
[Original] 手动给任意服务器配置 IPV6

11. 一键重装纯净CentOS 7脚本 无需VNC、无需CD-ROM挂载（由tech.cxthhhhh.com提供）
[原创] 一键网络重装CentOS 7 （官方，纯净，安全，高效）

12. Debian/Ubuntu/CentOS 一键重装脚本（由moeclub.org提供）
[ Linux VPS ] Debian/Ubuntu/CentOS 网络安装/重装系统/纯净安装 一键脚本

13. 魔法喝奶工具（具有特定性，因此不提供解释，如果你不明白请不要使用）（由doub.io提供）
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh && chmod +x ssrmu.sh && bash ssrmu.sh

14. 安装Supervisor守护进程
pip install supervisor / yum install supervisor -y
yum install python-setuptools
easy_install supervisor

15. 一键清除Linux登陆信息和命令输入信息
echo > /var/log/wtmp
echo > /var/log/btmp
echo > /var/log/lastlog
history -c

16. 重建Grub2启动引导(请参照您的磁盘)
BIOS-Based 引导的机器
grub2-install device
grub2-mkconfig -o /boot/grub2/grub.cfg
UEFI-Based 引导的机器
yum reinstall grub2-efi shim
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

17. 修改Linux系统默认语言
localectl set-locale LANG=zh_CN.UTF8（中文）
localectl set-locale LANG=en_US.UTF-8（英文）

18. V-2射线一键安装 for CentOS7（具有特定性，因此不提供解释，如果你不明白请不要使用）（由Github用户233boy提供）
yum install curl git-core -y && git clone https://github.com/233boy/v2ray && cd v2ray && chmod +x install.sh && ./install.sh local

19. 一键安裝CpuLimit（由Github用户opsengine提供）
wget -O cpulimit.zip https://github.com/opsengine/cpulimit/archive/master.zip && unzip cpulimit.zip && cd cpulimit-master && make && cp src/cpulimit /usr/bin

20. 如何配置Swap页面文件（2GB虚拟内存）
dd if=/dev/zero of=/var/swap bs=1024 count=2097152
mkswap /var/swap
chmod 0644 /var/swap
swapon /var/swap
echo '/var/swap swap swap default 0 0' >> /etc/fstab

21. Linux下通过终端连接其他SSH服务器
ssh 用户名@IP
例如（ssh root@8.8.8.8）
输入远端用户的密码即可。

22. Linux VPS一键安装桌面环境和RDP远程桌面连接以及Windows支持（同时是一个可管理其它服务器的平台）
[原创] 一键安装桌面环境、RDP、Windows支持（For Linux）

23. 为宝塔配置IPV6网站支持/Nginx开启IPV6支持，搭建IPV6网站
[原创] Nginx设置IPV6监听及301重定向和启用SSL强制跳转

24. 将Windows Server重装到Linux Server(Win转Linux)(Win to Linux)
[解决方案] 如何将Windows Server（2003/2008/2012/2016/XP/7/8/10）重装到Linux Server（CentOS/Debian/Ubuntu）

享受美好的服务器生活
当您具有了上面的一整套解决方案，现在您可以游刃有余的畅游在Linux服务器上了。

[Technical Blog | 技術博客]的Telegram交流频道：https://t.me/me_share（TG讨论组群请关注TG频道置顶消息）

这篇文章发表在[CXT] Technical Blog | 技術博客，如果您需要转发分享，请注明出处。

[原创] 一套完整解决方案为新服务器（系统安装、建站环境配置、网络和系统优化、完整备份还原迁移、桌面环境、工具合集）

```


### 


```yml


```


### 


```yml


```



### [原创] 一键网络重装CentOS 7 （官方，纯净，安全，高效）


```yml

https://tech.cxthhhhh.com/linux/2018/07/31/original-network-one-click-reinstall-centos-7-official-pure-safe-efficient-cn.html

[原创] 一键网络重装CentOS 7 （官方，纯净，安全，高效）
 2018-07-31  1条评论  272,364次阅读  52人点赞
简介
You can reinstall your CentOS7 system with one click. (official, pure, safe, efficient)
No CD-ROM is required, No VNC is required, only one network is required. If you are looking for a solution like this, then try it.
This is my original article and the first official release in the world. Before that, almost no one released it, hoping to help more people.

Last year, I released a one-click optimization of the CentOS7 Linux Shell, which helped us clean up the system provided by the service provider. Protected our privacy and enhanced functionality. As of July 28, 2018, it has successfully helped 100,000+ customers to clean up their service provider’s system, and I’m very happy to help so many people.

Today I am bringing a more official, pure, safe and efficient CentOS system. The system template that does not require the service provider is directly from the official CentOS 7.

At the same time, the system has been specially optimized for server migration, which can achieve heterogeneous migration, which is not possible under normal circumstances.

If you are from an English community, please click here.

只需一键即可重新安装CentOS7系统。（官方，纯净，安全，高效）
无需CD-ROM，无需VNC，只需要一个网络。如果您正在寻找这样的解决方案，那就试试吧。
这是我原创的文章和世界上第一个正式版。在此之前，几乎没有人发布它，希望能帮助更多的人。

去年，我发布了CentOS7 Linux Shell的一键优化Shell，帮助我们清理服务提供商提供的系统。保护我们的隐私和增强功能。截至2018年7月28日，它已成功帮助100,000多名客户清理其服务提供商的系统，我很乐意帮助这么多人。

今天我带来了更加官方，纯粹，安全和高效的CentOS系统。不需要服务提供商的系统模板直接来自官方的CentOS 7。

同时，本系统针对服务器迁移做了特地优化，可以实现异机迁移，这在一般情况下这是不可能的。

目前的需求
我们可以肯定越来越多的人和家庭以及公司开始使用服务器（专用服务器或VPS）。
但是服务提供商提供的系统模板对我们来说并不令人满意。这是不纯的，不安全的，甚至预设了一些软件。许多商家都有内置的监控程序，甚至劫持我们的文件。这就是我们所了解的。

我们不希望看到这种情况，我们希望改进，就像人们的隐私应该受到更多保护一样。
所以我打开我的私人工具和方法。更新并发布。该文件托管在Open Disk CDN上。

如何使用和做
自动安装映像文件地址：https://opendisk.cxthhhhh.com/OperatingSystem/CentOS/CentOS_7.X_NetInstallation.vhd.gz

我提供两种方式供你采用。（任选其一）。

1. 进入恢复模式（推荐）或在常规模式下，查看要安装的磁盘。（以下命令需要修改到您自己的磁盘）

①如果你是VPS，你应该像这样运行
wget -qO- https://opendisk.cxthhhhh.com/OperatingSystem/CentOS/CentOS_7.X_NetInstallation.vhd.gz | gunzip -dc | dd of=/dev/vda
②如果你是一个专用服务器，你应该像这样运行
wget -qO- https://opendisk.cxthhhhh.com/OperatingSystem/CentOS/CentOS_7.X_NetInstallation.vhd.gz | gunzip -dc | dd of=/dev/sda

2. 在正常模式下执行以下命令
(你需要注意，下面命令中引号是”英文状态引号”。)

wget --no-check-certificate -qO ~/Network-Reinstall-System-Modify.sh 'https://tech.cxthhhhh.com/tech-tools/Network-Reinstall-System-Modify/Network-Reinstall-System-Modify.sh' && chmod a+x ~/Network-Reinstall-System-Modify.sh && bash ~/Network-Reinstall-System-Modify.sh -CentOS_7

您得明白
1. 它将帮助您重新安装最新的CentOS7.X系统。（正式，纯粹，安全，高效）
2. 执行后，您可能需要15-45分钟后才能通过IP:22进行连接。
3. 新安装的系统root密码为[cxthhhhh.com] 。
4. 系统首次启动后，请等待自动安装完成，系统将自动重启，然后才能使用。（安装过程中的手动干预可能会导致错误）
5. IPV4和IPV6是开启的，并通过DHCP获取网络信息。
6. 系统的DNS将被设置为1.1.1.1和8.8.8.8，用来保护您的隐私。
7. 系统使用官方CentOS镜像，将自动匹配yum信息。拒绝服务提供商劫持。
8. 登录信息标准化，易于管理。您需要在登录后修改它。
9. 完成测试，非常适合Azure，Google Cloud，Vultr，Online，Net，OVH，阿里云，腾讯云中的许多专用服务器和KVM服务器。欢迎您的反馈。
10. 对于手动分区版系统模板，默认分配磁盘大小为4.5G。所以你需要扩展磁盘如下（按照你的需求）。
[原创] 如何扩展Linux硬盘（LVM磁盘）
11. 当你使用我的解决方案，我想说，感谢您信任我。我非常感谢您。我很高兴可以帮助到你。如果您不信任我的解决方案，请关闭页面，信任这是平等的。我相信技术不分国家，欢迎一起讨论，共同研究最新技术。
12. 关于服务器的备份和还原，包括不同服务器之间的迁移，你应该了解这里。
[原创] 整机备份/还原Linux系统(异机迁移、保护数据、环境迁移)
13. 如果你需要安装桌面环境、远程桌面连接、以及Windows支持。请查看这里。
[原创] 一键安装桌面环境、RDP、Windows支持（For Linux）
14. 自动分区版将会把所有的硬盘剩余空间分配给（/）根分区，请注意，你只可以在全新的服务器上使用自动分区版，如果你有数据在服务器上，请使用手动分区版（根据需求手动挂载您的数据盘），这是为了防止自动分区版在安装时将您的数据盘格式化。
15. 如果你需要其他帮助，这里有一篇推荐文章。
[原创] 一套完整解决方案为新服务器（系统安装、建站环境配置、网络和系统优化、完整备份还原迁移、桌面环境、工具合集）
16. 在每次重装前，请保证你已经通过服务商面板重装过一次系统（CentOS/Debian/Ubuntu均可），不可以在已经DD安装过的系统上使用萌咖的自动脚本再次DD本系统，否则会报错，系统无法启动。手动DD不受此问题影响。
17. 在安装过程中，请勿手动进行操作，也许会导致错误。如果您在屏幕（VNC）上看到以下界面，代表正在安装系统，请耐心等待。
《[原创] 一键网络重装CentOS 7 （官方，纯净，安全，高效）》
18. 腾讯云中国版部分机器（腾讯云国际版机器测试没问题）和DigitalOcean机器请注意，如果安装完无法联网（SSH无法连接）。你应该进入VNC，修改网络配置，设置静态IP。（因为他们的服务商推送了错误的DHCP网关信息，所以自动获取的网络是无效的，无法访问网络。）
vim /etc/sysconfig/network-scripts/ifcfg-eth0
BOOTPROTO="static" #dhcp改为static
IPADDR=192.168.1.100 #静态IP
GATEWAY=192.168.1.255 #默认网关
NETMASK=255.255.255.0 #子网掩码
最后
reboot
本次重启等几分钟再连接，是为了防止影响自动分区，导致出现问题。

开始享受纯净的CentOS7
[Technical Blog | 技術博客]的Telegram交流频道：https://t.me/me_share（TG讨论组群请关注TG频道置顶消息）

这篇文章发表在[CXT] Technical Blog | 技術博客，如果您需要转发分享，请注明出处。

[原创] 网络一键重新安装CentOS 7（官方，纯，安全，高效）

```

### 


```yml


```


### 


```yml


```

### [Linux VPS] Debian / Ubuntu / CentOS网络安装/重装系统/纯净安装一键脚本


```yml
https://moeclub.org/2018/04/03/603/?spm=24.4

[Linux VPS] Debian / Ubuntu / CentOS网络安装/重装系统/纯净安装一键脚本
博主： Haibara  发布时间：2018年04月03日  3609次浏览   133条评论  41902字数  分类：技术
 首页 正文  

背景：
适用于由GRUB引导的CentOS的，Ubuntu的，Debian的系统。使用官方发行版去掉模板预装的软件。同时也可以解决内核版本与软件不兼容的问题。只要有root权限，还你一个纯净的系统。
相关文章：
[Linux VPS] Debian（Ubuntu）网络安装/重装系统一键脚本 [Linux VPS] CentOS网络安装/重装系统一键脚本纯净安装 [Linux Shell]通用无限制在Linux VPS上一键全自动dd安装视窗
注意：
全自动安装默认root密码：Vicer，安装完成后请立即更改密码。
能够全自动重装于Debian / Ubuntu / CentOS的等系统。
同时提供DD安装镜像功能，例如：全自动无救援DD安装视窗系统
全自动安装CentOS时默认提供VNC功能，可使用VNC Viewer查看进度，
VNC端口为1或者5901，可自行尝试连接。（成功后VNC功能会消失。）
目前CentOS系统只支持任意版本重装为CentOS 6.x及以下版本。
特别注意：OpenVZ构架不适用。
更新：
[2018年11月12日]
修复了一写错误逻辑。
[2018年10月31日]
增加--loader参数。（用于定制镜像）
[2018年8月10日]
修复一些错误。增加-i 参数（用于指定网卡）
[2018年6月9日]
支持自定义远程桌面端口并打开相关防火墙端口（默认为3389）。自动扩展系统盘空间为整个硬盘。增加-rdp 参数（用于更换RDP端口，并强制打开该端口防火墙）
[2018年4月17日]
修复对grub.conf的抓取识别的问题。
[2018年4月6日]
优化正则表达式。丢弃对grep -P的依赖。
[2018年4月3日]
合并于Debian / Ubuntu / CentOS的/ DD安装镜像功能。使用最少依赖原则。优化部分流程。修复一些已知BUG。
依赖包：

#二进制文件    Debian/Ubuntu    RedHat/CentOS
iconv         [libc-bin]       [glibc-common]
xz            [xz-utils]       [xz]
awk           [gawk]           [gawk]
sed           [sed]            [sed]
file          [file]           [file]
grep          [grep]           [grep]
openssl       [openssl]        [openssl]
cpio          [cpio]           [cpio]
gzip          [gzip]           [gzip]
cat,cut..     [coreutils]      [coreutils]

确保安装了所需软件：

#Debian/Ubuntu:
apt-get install -y xz-utils openssl gawk file

#RedHat/CentOS:
yum install -y xz openssl gawk file
如果出现了错误，请运行：

#Debian/Ubuntu:
apt-get update

#RedHat/CentOS:
yum update
快速使用示例：

bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 8 -v 64 -a
下载及说明：

wget --no-check-certificate -qO InstallNET.sh 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh' && chmod a+x InstallNET.sh

Usage:
        bash InstallNET.sh      -d/--debian [dist-name]
                                -u/--ubuntu [dist-name]
                                -c/--centos [dist-version]
                                -v/--ver [32/i386|64/amd64]
                                --ip-addr/--ip-gate/--ip-mask
                                -apt/-yum/--mirror
                                -dd/--image
                                -a/-m

# dist-name: 发行版本代号
# dist-version: 发行版本号
# -apt/-yum/--mirror : 使用定义镜像
# -a/-m : 询问是否能进入VNC自行操作. -a 为不提示(一般用于全自动安装), -m 为提示.
使用示例：

#使用默认镜像全自动安装
bash InstallNET.sh -d 8 -v 64 -a

#使用自定义镜像全自动安装
bash InstallNET.sh -c 6.9 -v 64 -a --mirror 'http://mirror.centos.org/centos'


# 以下示例中,将X.X.X.X替换为自己的网络参数.
# --ip-addr :IP Address/IP地址
# --ip-gate :Gateway   /网关
# --ip-mask :Netmask   /子网掩码

#使用自定义镜像自定义网络参数全自动安装
#bash InstallNET.sh -u 16.04 -v 64 -a --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x --mirror 'http://archive.ubuntu.com/ubuntu'

#使用自定义网络参数全自动dd方式安装
#bash InstallNET.sh --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x -dd 'https://moeclub.org/onedrive/IMAGE/Windows/win7emb_x86.tar.gz'

#使用自定义网络参数全自动dd方式安装存储在谷歌网盘中的镜像(调用文件ID的方式)
#bash InstallNET.sh --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x -dd "https://image.moeclub.org/GoogleDrive/1cqVl2wSGx92UTdhOxU9pW3wJgmvZMT_J"

#使用自定义网络参数全自动dd方式安装存储在谷歌网盘中的镜像
#bash InstallNET.sh --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x -dd "https://image.moeclub.org/GoogleDrive/1cqVl2wSGx92UTdhOxU9pW3wJgmvZMT_J"

#国内推荐使用USTC源
#--mirror 'http://mirrors.ustc.edu.cn/debian/'
一些可用镜像地址：

# 推荐使用带有 /GoogleDrive/ 链接, 速度更快.
# 当然也可以使用自己GoogleDrive中储存的镜像,使用方式:
  https://image.moeclub.org/GoogleDrive/

# win7emb_x86.tar.gz:
  https://image.moeclub.org/GoogleDrive/1srhylymTjYS-Ky8uLw4R6LCWfAo1F3s7 
  https://moeclub.org/onedrive/IMAGE/Windows/win7emb_x86.tar.gz

# win8.1emb_x64.tar.gz:
  https://image.moeclub.org/GoogleDrive/1cqVl2wSGx92UTdhOxU9pW3wJgmvZMT_J
  https://moeclub.org/onedrive/IMAGE/Windows/win8.1emb_x64.tar.gz

# win10ltsc_x64.tar.gz:
  https://image.moeclub.org/GoogleDrive/1OVA3t-ZI2arkM4E4gKvofcBN9aoVdneh
  https://moeclub.org/onedrive/IMAGE/Windows/win10ltsc_x64.tar.gz
一些提示：
特别注意：
萌咖提供的dd安装镜像远程登陆账号为：Administrator 远程登陆密码为：Vicer仅 修改了主机名，可放心使用。（建议自己制作。）
在DD安装系统镜像时：
在你的机器上全新安装，如果你有VNC，可以看到全部过程。在dd安装镜像的过程中，不会走进度条（进度条一直显示为0％）。完成后将会自动重启。分区界面标题一般显示为：“ 启动分区器 ” 使用谷歌网盘中储存的镜像：[无限制大小]获取谷歌网盘文件临时直接下载链接
在全自动安装CentOS的时：
如果看到“ 开始图形安装 ”或者类似表达，则表示正在安装。正常情况下只需要耐心等待安装完成即可。如果需要查看进度，使用VNC Viewer（或者其他VNC连接工具）连接提示中的IP地址：端口进行连接。（端口一般为1或者5901）
预览：

#!/bin/bash

## It can reinstall Debian, Ubuntu, CentOS system with network.
## Suitable for using by GRUB.
## Default root password: Vicer
## Blog: https://moeclub.org
## Written By Vicer

export tmpVER=''
export tmpDIST=''
export tmpURL=''
export tmpWORD=''
export tmpMirror=''
export tmpSSL=''
export tmpINS=''
export tmpFW=''
export ipAddr=''
export ipMask=''
export ipGate=''
export linuxdists=''
export ddMode='0'
export setNet='0'
export setRDP='0'
export isMirror='0'
export FindDists='0'
export loaderMode='0'
export SpikCheckDIST='0'
export UNKNOWHW='0'
export UNVER='6.4'

while [[ $# -ge 1 ]]; do
  case $1 in
    -v|--ver)
      shift
      tmpVER="$1"
      shift
      ;;
    -d|--debian)
      shift
      linuxdists='debian'
      tmpDIST="$1"
      shift
      ;;
    -u|--ubuntu)
      shift
      linuxdists='ubuntu'
      tmpDIST="$1"
      shift
      ;;
    -c|--centos)
      shift
      linuxdists='centos'
      tmpDIST="$1"
      shift
      ;;
    -dd|--image)
      shift
      ddMode='1'
      tmpURL="$1"
      shift
      ;;
    -p|--password)
      shift
      tmpWORD="$1"
      shift
      ;;
    -i|--interface)
      shift
      interface="$1"
      shift
      ;;
    --ip-addr)
      shift
      ipAddr="$1"
      shift
      ;;
    --ip-mask)
      shift
      ipMask="$1"
      shift
      ;;
    --ip-gate)
      shift
      ipGate="$1"
      shift
      ;;
    --loader)
      shift
      loaderMode='1'
      ;;
    --prefer)
      shift
      tmpPrefer="$1"
      shift
      ;;
    -a|--auto)
      shift
      tmpINS='auto'
      ;;
    -m|--manual)
      shift
      tmpINS='manual'
      ;;
    -apt|-yum|--mirror)
      shift
      isMirror='1'
      tmpMirror="$1"
      shift
      ;;
    -rdp)
      shift
      setRDP='1'
      WinRemote="$1"
      shift
      ;;
    -ssl)
      shift
      tmpSSL="$1"
      shift
      ;;
    --firmware)
      shift
      tmpFW='1'
      ;;
    *)
      if [[ "$1" != 'error' ]]; then echo -ne "\nInvaild option: '$1'\n\n"; fi
      echo -ne " Usage:\n\tbash DebianNET.sh\t-d/--debian [\033[33m\033[04mdists-name\033[0m]\n\t\t\t\t-u/--ubuntu [\033[04mdists-name\033[0m]\n\t\t\t\t-c/--centos [\033[33m\033[04mdists-verison\033[0m]\n\t\t\t\t-v/--ver [32/\033[33m\033[04mi386\033[0m|64/amd64]\n\t\t\t\t--ip-addr/--ip-gate/--ip-mask\n\t\t\t\t-apt/-yum/--mirror\n\t\t\t\t-dd/--image\n\t\t\t\t-a/--auto\n\t\t\t\t-m/--manual\n"
      exit 1;
      ;;
    esac
  done

[[ "$EUID" -ne '0' ]] && echo "Error:This script must be run as root!" && exit 1;

function CheckDependence(){
FullDependence='0';
for BIN_DEP in `echo "$1" |sed 's/,/\n/g'`
  do
    if [[ -n "$BIN_DEP" ]]; then
      Founded='0';
      for BIN_PATH in `echo "$PATH" |sed 's/:/\n/g'`
        do
          ls $BIN_PATH/$BIN_DEP >/dev/null 2>&1;
          if [ $? == '0' ]; then
            Founded='1';
            break;
          fi
        done
      if [ "$Founded" == '1' ]; then
        echo -en "[\033[32mok\033[0m]\t";
      else
        FullDependence='1';
        echo -en "[\033[31mNot Install\033[0m]";
      fi
      echo -en "\t$BIN_DEP\n";
    fi
  done
if [ "$FullDependence" == '1' ]; then
  echo -ne "\n\033[31mError! \033[0mPlease use '\033[33mapt-get\033[0m' or '\033[33myum\033[0m' install it.\n\n\n"
  exit 1;
fi
}

if [[ -z "$linuxdists" ]]; then
  linuxdists='debian';
fi

clear && echo -e "\n\033[36m# Check Dependence\033[0m\n"

if [[ "$ddMode" == '1' ]]; then
  CheckDependence iconv;
  linuxdists='debian';
  tmpDIST='jessie';
  tmpVER='amd64';
  tmpINS='auto';
fi

if [[ "$linuxdists" == 'debian' ]] || [[ "$linuxdists" == 'ubuntu' ]]; then
  CheckDependence wget,awk,grep,sed,cut,cat,cpio,gzip,find,dirname,basename;
elif [[ "$linuxdists" == 'centos' ]]; then
  CheckDependence wget,awk,grep,sed,cut,cat,cpio,gzip,find,dirname,basename,file,xz;
fi

if [[ -n "$tmpWORD" ]]; then
  CheckDependence openssl;
fi

if [[ "$loaderMode" == "0" ]]; then
  [[ -f '/boot/grub/grub.cfg' ]] && GRUBOLD='0' && GRUBDIR='/boot/grub' && GRUBFILE='grub.cfg';
  [[ -z "$GRUBDIR" ]] && [[ -f '/boot/grub2/grub.cfg' ]] && GRUBOLD='0' && GRUBDIR='/boot/grub2' && GRUBFILE='grub.cfg';
  [[ -z "$GRUBDIR" ]] && [[ -f '/boot/grub/grub.conf' ]] && GRUBOLD='1' && GRUBDIR='/boot/grub' && GRUBFILE='grub.conf';
  [ -z "$GRUBDIR" -o -z "$GRUBFILE" ] && echo -ne "Error! \nNot Found grub path.\n" && exit 1;
else
  tmpINS='auto'
fi

if [[ "$isMirror" == '1' ]]; then
  if [[ -n "$tmpMirror" ]]; then
    TMPMirrorHost="$(echo -n "$tmpMirror" |grep -Eo '.*\.(\w+)')";
    echo "$TMPMirrorHost" |grep -q '://';
    if [[ $? == '0' ]]; then
      MirrorHost="$(echo "$TMPMirrorHost" |awk -F'://' '{print $2}')";
    else
      echo -en "\n\033[31mInvaild Mirror! \033[0m\n";
      [[ "$linuxdists" == 'debian' ]] && echo -en "\033[33mexample:\033[0m http://deb.debian.org/debian\n\n";
      [[ "$linuxdists" == 'ubuntu' ]] && echo -en "\033[33mexample:\033[0m http://archive.ubuntu.com/ubuntu\n\n";
      [[ "$linuxdists" == 'centos' ]] && echo -en "\033[33mexample:\033[0m http://mirror.centos.org/centos\n\n";
      exit 1
    fi
    if [[ -n "$MirrorHost" ]]; then
      MirrorFolder="$(echo -n "$tmpMirror" |awk -F''${MirrorHost}'' '{print $2}' |sed 's/\/$//g')";
      if [[ -z "$MirrorFolder" ]]; then
        [[ "$linuxdists" == 'debian' ]] && MirrorFolder='/debian';
        [[ "$linuxdists" == 'ubuntu' ]] && MirrorFolder='/ubuntu';
        [[ "$linuxdists" == 'centos' ]] && MirrorFolder='/centos';
      fi
      DISTMirror="${MirrorHost}${MirrorFolder}";
    fi
  fi
fi

if [[ -z "$DISTMirror" ]]; then
  [[ "$linuxdists" == 'debian' ]] && MirrorHost='deb.debian.org' && MirrorFolder='/debian' && DISTMirror="${MirrorHost}${MirrorFolder}";
  [[ "$linuxdists" == 'ubuntu' ]] && MirrorHost='archive.ubuntu.com' && MirrorFolder='/ubuntu' && DISTMirror="${MirrorHost}${MirrorFolder}";
  [[ "$linuxdists" == 'centos' ]] && DISTMirror='vault.centos.org';
fi

if [[ -n "$tmpVER" ]]; then
  tmpVER="$(echo "$tmpVER" |sed -r 's/(.*)/\L\1/')";
  if  [[ "$tmpVER" == '32' ]] || [[ "$tmpVER" == 'i386' ]] || [[ "$tmpVER" == 'x86' ]]; then
    VER='i386';
  fi
  if  [[ "$tmpVER" == '64' ]] || [[ "$tmpVER" == 'amd64' ]] || [[ "$tmpVER" == 'x86_64' ]] || [[ "$tmpVER" == 'x64' ]]; then
    if [[ "$linuxdists" == 'debian' ]] || [[ "$linuxdists" == 'ubuntu' ]]; then
      VER='amd64';
    elif [[ "$linuxdists" == 'centos' ]]; then
      VER='x86_64';
    fi
  fi
fi

if [[ -z "$VER" ]]; then
  VER='i386';
fi

if [[ -n "$tmpPrefer" ]]; then
  PreferOption="$(echo "$tmpPrefer" |sed 's/[[:space:]]*//g')"
fi

if [[ -z "$PreferOption" ]]; then
  PreferOption='current';
fi

if [[ -z "$tmpDIST" ]]; then
  [[ "$linuxdists" == 'debian' ]] && DIST='jessie';
  [[ "$linuxdists" == 'ubuntu' ]] && DIST='xenial';
  [[ "$linuxdists" == 'centos' ]] && DIST='6.8';
fi

if [[ -z "$DIST" ]]; then
  if [[ "$linuxdists" == 'debian' ]]; then
    SpikCheckDIST='0'
    DIST="$(echo "$tmpDIST" |sed -r 's/(.*)/\L\1/')";
    echo "$DIST" |grep -q '[0-9]';
    [[ $? -eq '0' ]] && {
      isDigital="$(echo "$DIST" |grep -o '[\.0-9]\{1,\}' |sed -n '1h;1!H;$g;s/\n//g;$p' |cut -d'.' -f1)";
      [[ -n $isDigital ]] && {
        [[ "$isDigital" == '7' ]] && DIST='wheezy';
        [[ "$isDigital" == '8' ]] && DIST='jessie';
        [[ "$isDigital" == '9' ]] && DIST='stretch';
        [[ "$isDigital" == '10' ]] && DIST='buster';
      }
    }
  fi
  if [[ "$linuxdists" == 'ubuntu' ]]; then
    SpikCheckDIST='0'
    DIST="$(echo "$tmpDIST" |sed -r 's/(.*)/\L\1/')";
    echo "$DIST" |grep -q '[0-9]';
    [[ $? -eq '0' ]] && {
      isDigital="$(echo "$DIST" |grep -o '[\.0-9]\{1,\}' |sed -n '1h;1!H;$g;s/\n//g;$p')";
      [[ -n $isDigital ]] && {
        [[ "$isDigital" == '12.04' ]] && DIST='precise';
        [[ "$isDigital" == '14.04' ]] && DIST='trusty';
        [[ "$isDigital" == '16.04' ]] && DIST='xenial';
        [[ "$isDigital" == '18.04' ]] && DIST='bionic';
      }
    }
  fi
  if [[ "$linuxdists" == 'centos' ]]; then
    SpikCheckDIST='1'
    DISTCheck="$(echo "$tmpDIST" |grep -o '[\.0-9]\{1,\}')";
    ListDIST="$(wget --no-check-certificate -qO- "http://$DISTMirror/dir_sizes" |cut -f2 |grep '^[0-9]')"
    DIST="$(echo "$ListDIST" |grep "^$DISTCheck" |head -n1)"
    [[ -z "$DIST" ]] && {
      echo -ne '\nThe dists version not found in this mirror, Please check it! \n\n'
      bash $0 error;
      exit 1;
    }
    wget --no-check-certificate -qO- "http://$DISTMirror/$DIST/os/$VER/.treeinfo" |grep -q 'general';
    [[ $? != '0' ]] && {
      wget --no-check-certificate -qO- "http://$DISTMirror/centos/$DIST/os/$VER/.treeinfo" |grep -q 'general';
      [[ $? == '0' ]] && {
        DISTMirror="${DISTMirror}/${linuxdists}"
      } || {
        echo -ne "\nThe version not found in this mirror, Please change mirror try again! \n\n";
        exit 1;
      }
    }

  fi
fi

if [[ "$SpikCheckDIST" == '0' ]]; then
  DistsList="$(wget --no-check-certificate -qO- "http://$DISTMirror/dists/" |grep -o 'href=.*/"' |cut -d'"' -f2 |sed '/-\|old\|Debian\|experimental\|stable\|test\|sid\|devel/d' |grep '^[^/]' |sed -n '1h;1!H;$g;s/\n//g;s/\//\;/g;$p')";
  for CheckDEB in `echo "$DistsList" |sed 's/;/\n/g'`
    do
      [[ "$CheckDEB" == "$DIST" ]] && FindDists='1';
      [[ "$FindDists" == '1' ]] && break;
    done
  [[ "$FindDists" == '0' ]] && {
    echo -ne '\nThe dists version not found, Please check it! \n\n'
    bash $0 error;
    exit 1;
  }
fi

[[ "$ddMode" == '1' ]] && {
  export SSL_SUPPORT='https://moeclub.org/get-wget_udeb_amd64';
  if [[ -n "$tmpURL" ]]; then
    DDURL="$tmpURL"
    echo "$DDURL" |grep -q '^http://\|^ftp://\|^https://';
    [[ $? -ne '0' ]] && echo 'Please input vaild URL,Only support http://, ftp:// and https:// !' && exit 1;
    [[ -n "$tmpSSL" ]] && SSL_SUPPORT="$tmpSSL";
  else
    echo 'Please input vaild image URL! ';
    exit 1;
  fi
}

[[ -n "$tmpINS" ]] && {
  [[ "$tmpINS" == 'auto' ]] && inVNC='n';
  [[ "$tmpINS" == 'manual' ]] && inVNC='y';
}

[ -n "$ipAddr" ] && [ -n "$ipMask" ] && [ -n "$ipGate" ] && setNet='1';
[[ -n "$tmpWORD" ]] && myPASSWORD="$(openssl passwd -1 "$tmpWORD")";
[[ -z "$myPASSWORD" ]] && myPASSWORD='$1$0shYGfBd$8v189JOozDO1jPqPO645e1';
[[ -n "$tmpFW" ]] && INCFW="$tmpFW";
[[ -z "$INCFW" ]] && INCFW='0';

if [[ -n "$interface" ]]; then
  IFETH="$interface"
else
  if [[ "$linuxdists" == 'centos' ]]; then
    IFETH="link"
  else
    IFETH="auto"
  fi
fi

clear && echo -e "\n\033[36m# Install\033[0m\n"

ASKVNC(){
  inVNC='y';
  [[ "$ddMode" == '0' ]] && {
    echo -ne "\033[34mCan you login VNC?\033[0m\e[33m[\e[32my\e[33m/n]\e[0m "
    read tmpinVNC
    [[ -n "$inVNCtmp" ]] && inVNC="$tmpinVNC"
  }
  [ "$inVNC" == 'y' -o "$inVNC" == 'Y' ] && inVNC='y';
  [ "$inVNC" == 'n' -o "$inVNC" == 'N' ] && inVNC='n';
}

[ "$inVNC" == 'y' -o "$inVNC" == 'n' ] || ASKVNC;
[[ "$linuxdists" == 'debian' ]] && LinuxName='Debian';
[[ "$linuxdists" == 'ubuntu' ]] && LinuxName='Ubuntu';
[[ "$linuxdists" == 'centos' ]] && LinuxName='CentOS';
[[ "$ddMode" == '0' ]] && { 
  [[ "$inVNC" == 'y' ]] && echo -e "\033[34mManual Mode\033[0m insatll \033[33m$LinuxName\033[0m [\033[33m$DIST\033[0m] [\033[33m$VER\033[0m] in VNC. "
  [[ "$inVNC" == 'n' ]] && echo -e "\033[34mAuto Mode\033[0m insatll \033[33m$LinuxName\033[0m [\033[33m$DIST\033[0m] [\033[33m$VER\033[0m]. "
}
[[ "$ddMode" == '1' ]] && {
  echo -ne "\033[34mAuto Mode\033[0m insatll \033[33mWindows\033[0m\n[\033[33m$DDURL\033[0m]\n"
}

if [[ "$linuxdists" == 'centos' ]]; then
  if [[ "$DIST" != "$UNVER" ]]; then
    awk 'BEGIN{print '${UNVER}'-'${DIST}'}' |grep -q '^-'
    if [ $? != '0' ]; then
      UNKNOWHW='1';
      echo -en "\033[33mThe version lower then \033[31m$UNVER\033[33m may not support in auto mode! \033[0m\n";
      if [[ "$inVNC" == 'n' ]]; then
        echo -en "\033[35mYou can connect VNC with \033[32mPublic IP\033[35m and port \033[32m1\033[35m/\033[32m5901\033[35m in vnc viewer.\033[0m\n"
        read -n 1 -p "Press Enter to continue..." INP
        [[ "$INP" != '' ]] && echo -ne '\b \n\n';
      fi
    fi
    awk 'BEGIN{print '${UNVER}'-'${DIST}'+0.59}' |grep -q '^-'
    if [ $? == '0' ]; then
      echo -en "\n\033[31mThe version higher then \033[33m6.9 \033[31mis not support in current! \033[0m\n\n"
      exit 1;
    fi
  fi
fi

echo -e "\n[\033[33m$LinuxName\033[0m] [\033[33m$DIST\033[0m] [\033[33m$VER\033[0m] Downloading..."

[[ -z "$DISTMirror" ]] && echo -ne "\033[31mError! \033[0mInvaild mirror! \n" && exit 1

if [[ "$linuxdists" == 'debian' ]] || [[ "$linuxdists" == 'ubuntu' ]]; then
wget --no-check-certificate -qO '/boot/initrd.img' "http://$DISTMirror/dists/$DIST/main/installer-$VER/$PreferOption/images/netboot/$linuxdists-installer/$VER/initrd.gz"
[[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'initrd.img' for \033[33m$linuxdists\033[0m failed! \n" && exit 1
wget --no-check-certificate -qO '/boot/vmlinuz' "http://$DISTMirror/dists/$DIST/main/installer-$VER/$PreferOption/images/netboot/$linuxdists-installer/$VER/linux"
[[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'vmlinuz' for \033[33m$linuxdists\033[0m failed! \n" && exit 1
elif [[ "$linuxdists" == 'centos' ]]; then
wget --no-check-certificate -qO '/boot/initrd.img' "http://$DISTMirror/$DIST/os/$VER/isolinux/initrd.img"
[[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'initrd.img' for \033[33m$linuxdists\033[0m failed! \n" && exit 1
wget --no-check-certificate -qO '/boot/vmlinuz' "http://$DISTMirror/$DIST/os/$VER/isolinux/vmlinuz"
[[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'vmlinuz' for \033[33m$linuxdists\033[0m failed! \n" && exit 1
fi
if [[ "$linuxdists" == 'debian' ]]; then
  if [[ "$INCFW" == '1' ]]; then
    wget --no-check-certificate -qO '/boot/firmware.cpio.gz' "http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/$DIST/current/firmware.cpio.gz"
    [[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'firmware' for \033[33m$linuxdists\033[0m failed! \n" && exit 1
  fi
  if [[ "$ddMode" == '1' ]]; then
    vKernel_udeb=$(wget --no-check-certificate -qO- "http://$DISTMirror/dists/$DIST/main/installer-$VER/$PreferOption/images/udeb.list" |grep '^acpi-modules' |head -n1 |grep -o '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}-[0-9]\{1,2\}' |head -n1)
    [[ -z "vKernel_udeb" ]] && vKernel_udeb="3.16.0-4"
  fi
fi

[[ "$setNet" == '1' ]] && {
  IPv4="$ipAddr";
  MASK="$ipMask";
  GATE="$ipGate";
} || {
  DEFAULTNET="$(ip route show |grep -o 'default via [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.*' |head -n1 |sed 's/proto.*\|onlink.*//g' |awk '{print $NF}')";
  [[ -n "$DEFAULTNET" ]] && IPSUB="$(ip addr |grep ''${DEFAULTNET}'' |grep 'global' |grep 'brd' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}/[0-9]\{1,2\}')";
  IPv4="$(echo -n "$IPSUB" |cut -d'/' -f1)";
  NETSUB="$(echo -n "$IPSUB" |grep -o '/[0-9]\{1,2\}')";
  GATE="$(ip route show |grep -o 'default via [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}')";
  [[ -n "$NETSUB" ]] && MASK="$(echo -n '128.0.0.0/1,192.0.0.0/2,224.0.0.0/3,240.0.0.0/4,248.0.0.0/5,252.0.0.0/6,254.0.0.0/7,255.0.0.0/8,255.128.0.0/9,255.192.0.0/10,255.224.0.0/11,255.240.0.0/12,255.248.0.0/13,255.252.0.0/14,255.254.0.0/15,255.255.0.0/16,255.255.128.0/17,255.255.192.0/18,255.255.224.0/19,255.255.240.0/20,255.255.248.0/21,255.255.252.0/22,255.255.254.0/23,255.255.255.0/24,255.255.255.128/25,255.255.255.192/26,255.255.255.224/27,255.255.255.240/28,255.255.255.248/29,255.255.255.252/30,255.255.255.254/31,255.255.255.255/32' |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'${NETSUB}'' |cut -d'/' -f1)";
}

[[ -n "$GATE" ]] && [[ -n "$MASK" ]] && [[ -n "$IPv4" ]] || {
echo "Not found \`ip command\`, It will use \`route command\`."
ipNum() {
  local IFS='.';
  read ip1 ip2 ip3 ip4 <<<"$1";
  echo $((ip1*(1<<24)+ip2*(1<<16)+ip3*(1<<8)+ip4));
}

SelectMax(){
ii=0;
for IPITEM in `route -n |awk -v OUT=$1 '{print $OUT}' |grep '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'`
  do
    NumTMP="$(ipNum $IPITEM)";
    eval "arrayNum[$ii]='$NumTMP,$IPITEM'";
    ii=$[$ii+1];
  done
echo ${arrayNum[@]} |sed 's/\s/\n/g' |sort -n -k 1 -t ',' |tail -n1 |cut -d',' -f2;
}

[[ -z $IPv4 ]] && IPv4="$(ifconfig |grep 'Bcast' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' |head -n1)";
[[ -z $GATE ]] && GATE="$(SelectMax 2)";
[[ -z $MASK ]] && MASK="$(SelectMax 3)";

[[ -n "$GATE" ]] && [[ -n "$MASK" ]] && [[ -n "$IPv4" ]] || {
  echo "Error! Not configure network. ";
  exit 1;
}
}

[[ "$setNet" != '1' ]] && [[ -f '/etc/network/interfaces' ]] && {
  [[ -z "$(sed -n '/iface.*inet static/p' /etc/network/interfaces)" ]] && AutoNet='1' || AutoNet='0';
  [[ -d /etc/network/interfaces.d ]] && {
    ICFGN="$(find /etc/network/interfaces.d -name '*.cfg' |wc -l)" || ICFGN='0';
    [[ "$ICFGN" -ne '0' ]] && {
      for NetCFG in `ls -1 /etc/network/interfaces.d/*.cfg`
        do 
          [[ -z "$(cat $NetCFG | sed -n '/iface.*inet static/p')" ]] && AutoNet='1' || AutoNet='0';
          [[ "$AutoNet" -eq '0' ]] && break;
        done
    }
  }
}

[[ "$setNet" != '1' ]] && [[ -d '/etc/sysconfig/network-scripts' ]] && {
  ICFGN="$(find /etc/sysconfig/network-scripts -name 'ifcfg-*' |grep -v 'lo'|wc -l)" || ICFGN='0';
  [[ "$ICFGN" -ne '0' ]] && {
    for NetCFG in `ls -1 /etc/sysconfig/network-scripts/ifcfg-* |grep -v 'lo$' |grep -v ':[0-9]\{1,\}'`
      do 
        [[ -n "$(cat $NetCFG | sed -n '/BOOTPROTO.*[dD][hH][cC][pP]/p')" ]] && AutoNet='1' || {
          AutoNet='0' && . $NetCFG;
          [[ -n $NETMASK ]] && MASK="$NETMASK";
          [[ -n $GATEWAY ]] && GATE="$GATEWAY";
        }
        [[ "$AutoNet" -eq '0' ]] && break;
      done
  }
}

if [[ "$loaderMode" == "0" ]]; then
  [[ ! -f $GRUBDIR/$GRUBFILE ]] && echo "Error! Not Found $GRUBFILE. " && exit 1;

  [[ ! -f $GRUBDIR/$GRUBFILE.old ]] && [[ -f $GRUBDIR/$GRUBFILE.bak ]] && mv -f $GRUBDIR/$GRUBFILE.bak $GRUBDIR/$GRUBFILE.old;
  mv -f $GRUBDIR/$GRUBFILE $GRUBDIR/$GRUBFILE.bak;
  [[ -f $GRUBDIR/$GRUBFILE.old ]] && cat $GRUBDIR/$GRUBFILE.old >$GRUBDIR/$GRUBFILE || cat $GRUBDIR/$GRUBFILE.bak >$GRUBDIR/$GRUBFILE;
else
  GRUBOLD='2'
fi

[[ "$GRUBOLD" == '0' ]] && {
  READGRUB='/tmp/grub.read'
  cat $GRUBDIR/$GRUBFILE |sed -n '1h;1!H;$g;s/\n/%%%%%%%/g;$p' |grep -om 1 'menuentry\ [^{]*{[^}]*}%%%%%%%' |sed 's/%%%%%%%/\n/g' >$READGRUB
  LoadNum="$(cat $READGRUB |grep -c 'menuentry ')"
  if [[ "$LoadNum" -eq '1' ]]; then
    cat $READGRUB |sed '/^$/d' >/tmp/grub.new;
  elif [[ "$LoadNum" -gt '1' ]]; then
    CFG0="$(awk '/menuentry /{print NR}' $READGRUB|head -n 1)";
    CFG2="$(awk '/menuentry /{print NR}' $READGRUB|head -n 2 |tail -n 1)";
    CFG1="";
    for tmpCFG in `awk '/}/{print NR}' $READGRUB`
      do
        [ "$tmpCFG" -gt "$CFG0" -a "$tmpCFG" -lt "$CFG2" ] && CFG1="$tmpCFG";
      done
    [[ -z "$CFG1" ]] && {
      echo "Error! read $GRUBFILE. ";
      exit 1;
    }

    sed -n "$CFG0,$CFG1"p $READGRUB >/tmp/grub.new;
    [[ -f /tmp/grub.new ]] && [[ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ]] || {
      echo -ne "\033[31mError! \033[0mNot configure $GRUBFILE. \n";
      exit 1;
    }
  fi
  [ ! -f /tmp/grub.new ] && echo "Error! $GRUBFILE. " && exit 1;
  sed -i "/menuentry.*/c\menuentry\ \'Install OS \[$DIST\ $VER\]\'\ --class debian\ --class\ gnu-linux\ --class\ gnu\ --class\ os\ \{" /tmp/grub.new
  sed -i "/echo.*Loading/d" /tmp/grub.new;
  INSERTGRUB="$(awk '/menuentry /{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
}

[[ "$GRUBOLD" == '1' ]] && {
  CFG0="$(awk '/title[\ ]|title[\t]/{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)";
  CFG1="$(awk '/title[\ ]|title[\t]/{print NR}' $GRUBDIR/$GRUBFILE|head -n 2 |tail -n 1)";
  [[ -n $CFG0 ]] && [ -z $CFG1 -o $CFG1 == $CFG0 ] && sed -n "$CFG0,$"p $GRUBDIR/$GRUBFILE >/tmp/grub.new;
  [[ -n $CFG0 ]] && [ -z $CFG1 -o $CFG1 != $CFG0 ] && sed -n "$CFG0,$[$CFG1-1]"p $GRUBDIR/$GRUBFILE >/tmp/grub.new;
  [[ ! -f /tmp/grub.new ]] && echo "Error! configure append $GRUBFILE. " && exit 1;
  sed -i "/title.*/c\title\ \'Install OS \[$DIST\ $VER\]\'" /tmp/grub.new;
  sed -i '/^#/d' /tmp/grub.new;
  INSERTGRUB="$(awk '/title[\ ]|title[\t]/{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
}

if [[ "$loaderMode" == "0" ]]; then
[[ -n "$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $2}' |tail -n 1 |grep '^/boot/')" ]] && Type='InBoot' || Type='NoBoot';

LinuxKernel="$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $1}' |head -n 1)";
[[ -z "$LinuxKernel" ]] && echo "Error! read grub config! " && exit 1;
LinuxIMG="$(grep 'initrd.*/' /tmp/grub.new |awk '{print $1}' |tail -n 1)";
[ -z "$LinuxIMG" ] && sed -i "/$LinuxKernel.*\//a\\\tinitrd\ \/" /tmp/grub.new && LinuxIMG='initrd';

if [[ "$linuxdists" == 'debian' ]] || [[ "$linuxdists" == 'ubuntu' ]]; then
  BOOT_OPTION="auto=true hostname=$linuxdists domain= -- quiet"
elif [[ "$linuxdists" == 'centos' ]]; then
  BOOT_OPTION="ks=file://ks.cfg ksdevice=$IFETH"
fi

[[ "$Type" == 'InBoot' ]] && {
  sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/boot\/vmlinuz $BOOT_OPTION" /tmp/grub.new;
  sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/boot\/initrd.img" /tmp/grub.new;
}

[[ "$Type" == 'NoBoot' ]] && {
  sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/vmlinuz $BOOT_OPTION" /tmp/grub.new;
  sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/initrd.img" /tmp/grub.new;
}

sed -i '$a\\n' /tmp/grub.new;
fi

[[ "$inVNC" == 'n' ]] && {
GRUBPATCH='0';

if [[ "$loaderMode" == "0" ]]; then
[ -f '/etc/network/interfaces' -o -d '/etc/sysconfig/network-scripts' ] || {
  echo "Error, Not found interfaces config.";
  exit 1;
}

sed -i ''${INSERTGRUB}'i\\n' $GRUBDIR/$GRUBFILE;
sed -i ''${INSERTGRUB}'r /tmp/grub.new' $GRUBDIR/$GRUBFILE;
[[ -f  $GRUBDIR/grubenv ]] && sed -i 's/saved_entry/#saved_entry/g' $GRUBDIR/grubenv;
fi

[[ -d /tmp/boot ]] && rm -rf /tmp/boot;
mkdir -p /tmp/boot;
cd /tmp/boot;
if [[ "$linuxdists" == 'debian' ]] || [[ "$linuxdists" == 'ubuntu' ]]; then
  COMPTYPE="gzip";
elif [[ "$linuxdists" == 'centos' ]]; then
  COMPTYPE="$(file /boot/initrd.img |grep -o ':.*compressed data' |cut -d' ' -f2 |sed -r 's/(.*)/\L\1/' |head -n1)"
  [[ -z "$COMPTYPE" ]] && echo "Detect compressed type fail." && exit 1;
fi
CompDected='0'
for ListCOMP in `echo -en 'gzip\nlzma\nxz'`
  do
    if [[ "$COMPTYPE" == "$ListCOMP" ]]; then
      CompDected='1'
      if [[ "$COMPTYPE" == 'gzip' ]]; then
        NewIMG="initrd.img.gz"
      else
        NewIMG="initrd.img.$COMPTYPE"
      fi
      mv -f "/boot/initrd.img" "/tmp/$NewIMG"
      break;
    fi
  done
[[ "$CompDected" != '1' ]] && echo "Detect compressed type not support." && exit 1;
[[ "$COMPTYPE" == 'lzma' ]] && UNCOMP='xz --format=lzma --decompress';
[[ "$COMPTYPE" == 'xz' ]] && UNCOMP='xz --decompress';
[[ "$COMPTYPE" == 'gzip' ]] && UNCOMP='gzip -d';

$UNCOMP < /tmp/$NewIMG | cpio --extract --verbose --make-directories --no-absolute-filenames >>/dev/null 2>&1

if [[ "$linuxdists" == 'debian' ]] || [[ "$linuxdists" == 'ubuntu' ]]; then
cat >/tmp/boot/preseed.cfg<>/dev/null 2>&1
}

[[ "$ddMode" == '1' ]] && {
WinNoDHCP(){
  echo -ne "for\0040\0057f\0040\0042tokens\00753\0052\0042\0040\0045\0045i\0040in\0040\0050\0047netsh\0040interface\0040show\0040interface\0040\0136\0174more\0040\00533\0040\0136\0174findstr\0040\0057I\0040\0057R\0040\0042本地\0056\0052\0040以太\0056\0052\0040Local\0056\0052\0040Ethernet\0042\0047\0051\0040do\0040\0050set\0040EthName\0075\0045\0045j\0051\r\nnetsh\0040\0055c\0040interface\0040ip\0040set\0040address\0040name\0075\0042\0045EthName\0045\0042\0040source\0075static\0040address\0075$IPv4\0040mask\0075$MASK\0040gateway\0075$GATE\r\nnetsh\0040\0055c\0040interface\0040ip\0040add\0040dnsservers\0040name\0075\0042\0045EthName\0045\0042\0040address\00758\00568\00568\00568\0040index\00751\0040validate\0075no\r\n\r\n" >>'/tmp/boot/net.tmp';
}
WinRDP(){
  echo -ne "netsh\0040firewall\0040set\0040portopening\0040protocol\0075ALL\0040port\0075$WinRemote\0040name\0075RDP\0040mode\0075ENABLE\0040scope\0075ALL\0040profile\0075ALL\r\nnetsh\0040firewall\0040set\0040portopening\0040protocol\0075ALL\0040port\0075$WinRemote\0040name\0075RDP\0040mode\0075ENABLE\0040scope\0075ALL\0040profile\0075CURRENT\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Network\0134NewNetworkWindowOff\0042\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0042\0040\0057v\0040fDenyTSConnections\0040\0057t\0040reg\0137dword\0040\0057d\00400\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0134Wds\0134rdpwd\0134Tds\0134tcp\0042\0040\0057v\0040PortNumber\0040\0057t\0040reg\0137dword\0040\0057d\0040$WinRemote\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0134WinStations\0134RDP\0055Tcp\0042\0040\0057v\0040PortNumber\0040\0057t\0040reg\0137dword\0040\0057d\0040$WinRemote\0040\0057f\r\nreg\0040add\0040\0042HKLM\0134SYSTEM\0134CurrentControlSet\0134Control\0134Terminal\0040Server\0134WinStations\0134RDP\0055Tcp\0042\0040\0057v\0040UserAuthentication\0040\0057t\0040reg\0137dword\0040\0057d\00400\0040\0057f\r\nFOR\0040\0057F\0040\0042tokens\00752\0040delims\0075\0072\0042\0040\0045\0045i\0040in\0040\0050\0047SC\0040QUERYEX\0040TermService\0040\0136\0174FINDSTR\0040\0057I\0040\0042PID\0042\0047\0051\0040do\0040TASKKILL\0040\0057F\0040\0057PID\0040\0045\0045i\r\nFOR\0040\0057F\0040\0042tokens\00752\0040delims\0075\0072\0042\0040\0045\0045i\0040in\0040\0050\0047SC\0040QUERYEX\0040UmRdpService\0040\0136\0174FINDSTR\0040\0057I\0040\0042PID\0042\0047\0051\0040do\0040TASKKILL\0040\0057F\0040\0057PID\0040\0045\0045i\r\nSC\0040START\0040TermService\r\n\r\n" >>'/tmp/boot/net.tmp';
}
  echo -ne "\0100ECHO\0040OFF\r\n\r\ncd\0056\0076\0045WINDIR\0045\0134GetAdmin\r\nif\0040exist\0040\0045WINDIR\0045\0134GetAdmin\0040\0050del\0040\0057f\0040\0057q\0040\0042\0045WINDIR\0045\0134GetAdmin\0042\0051\0040else\0040\0050\r\necho\0040CreateObject\0136\0050\0042Shell\0056Application\0042\0136\0051\0056ShellExecute\0040\0042\0045\0176s0\0042\0054\0040\0042\0045\0052\0042\0054\0040\0042\0042\0054\0040\0042runas\0042\0054\00401\0040\0076\0076\0040\0042\0045temp\0045\0134Admin\0056vbs\0042\r\n\0042\0045temp\0045\0134Admin\0056vbs\0042\r\ndel\0040\0057f\0040\0057q\0040\0042\0045temp\0045\0134Admin\0056vbs\0042\r\nexit\0040\0057b\00402\0051\r\n\r\n" >'/tmp/boot/net.tmp';
  [[ "$setNet" == '1' ]] && WinNoDHCP;
  [[ "$setNet" == '0' ]] && [[ "$AutoNet" == '0' ]] && WinNoDHCP;
  [[ "$setRDP" == '1' ]] && [[ -n "$WinRemote" ]] && WinRDP
  echo -ne "ECHO\0040SELECT\0040VOLUME\0075\0045\0045SystemDrive\0045\0045\0040\0076\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\nECHO\0040EXTEND\0040\0076\0076\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\nSTART\0040/WAIT\0040DISKPART\0040\0057S\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\nDEL\0040\0057f\0040\0057q\0040\0042\0045SystemDrive\0045\0134diskpart\0056extend\0042\r\n\r\n" >>'/tmp/boot/net.tmp';
  echo -ne "cd\0040\0057d\0040\0042\0045ProgramData\0045\0057Microsoft\0057Windows\0057Start\0040Menu\0057Programs\0057Startup\0042\r\ndel\0040\0057f\0040\0057q\0040net\0056bat\r\n\r\n\r\n" >>'/tmp/boot/net.tmp';
  iconv -f 'UTF-8' -t 'GBK' '/tmp/boot/net.tmp' -o '/tmp/boot/net.bat'
  rm -rf '/tmp/boot/net.tmp'
  echo "$DDURL" |grep -q '^https://'
  [[ $? -eq '0' ]] && {
    echo -ne '\nAdd ssl support...\n'
    [[ -n $SSL_SUPPORT ]] && {
      wget --no-check-certificate -qO- "$SSL_SUPPORT" |tar -x
      [[ ! -f  /tmp/boot/usr/bin/wget ]] && echo 'Error! SSL_SUPPORT.' && exit 1;
      sed -i 's/wget\ -qO-/\/usr\/bin\/wget\ --no-check-certificate\ --retry-connrefused\ --tries=7\ --continue\ -qO-/g' /tmp/boot/preseed.cfg
      [[ $? -eq '0' ]] && echo -ne 'Success! \n\n'
    } || {
    echo -ne 'Not ssl support package! \n\n';
    exit 1;
    }
  }
}

[[ "$ddMode" == '0' ]] && {
  sed -i '/anna-install/d' /tmp/boot/preseed.cfg
  sed -i 's/wget.*\/sbin\/reboot\;\ //g' /tmp/boot/preseed.cfg
}

elif [[ "$linuxdists" == 'centos' ]]; then
cat >/tmp/boot/ks.cfg< /boot/initrd.img;
rm -rf /tmp/boot;
}

[[ "$inVNC" == 'y' ]] && {
  sed -i '$i\\n' $GRUBDIR/$GRUBFILE
  sed -i '$r /tmp/grub.new' $GRUBDIR/$GRUBFILE
  echo -e "\n\033[33m\033[04mIt will reboot! \nPlease look at VNC! \nSelect\033[0m\033[32m Install OS [$DIST $VER] \033[33m\033[4mto install system.\033[04m\n\n\033[31m\033[04mThere is some information for you.\nDO NOT CLOSE THE WINDOW! \033[0m\n"
  echo -e "\033[35mIPv4\t\tNETMASK\t\tGATEWAY\033[0m"
  echo -e "\033[36m\033[04m$IPv4\033[0m\t\033[36m\033[04m$MASK\033[0m\t\033[36m\033[04m$GATE\033[0m\n\n"

  read -n 1 -p "Press Enter to reboot..." INP
  [[ "$INP" != '' ]] && echo -ne '\b \n\n';
}

chown root:root $GRUBDIR/$GRUBFILE
chmod 444 $GRUBDIR/$GRUBFILE

if [[ "$loaderMode" == "0" ]]; then
  sleep 3 && reboot >/dev/null 2>&1
else
  rm -rf "$HOME/loader"
  mkdir -p "$HOME/loader"
  cp -rf "/boot/initrd.img" "$HOME/loader/initrd.img"
  cp -rf "/boot/vmlinuz" "$HOME/loader/vmlinuz"
  [[ -f "/boot/initrd.img" ]] && rm -rf "/boot/initrd.img"
  [[ -f "/boot/vmlinuz" ]] && rm -rf "/boot/vmlinuz"
  echo && ls -AR1 "$HOME/loader"
fi



声明：
形式各种翻译的转载或需注明作者及。本文地址。
使用该脚本造成的任何直接损失或间接损失，萌咖不负任何责任。

 最后修改：2019年03月11日12:30 PM

```


### 


```yml


```


### 


```yml


```


### [Linux VPS] CentOS网络安装/重装系统一键脚本纯净安装


```yml
https://moeclub.org/2018/03/26/597/?spm=72.8

[Linux VPS] CentOS网络安装/重装系统一键脚本纯净安装
博主： Haibara  发布时间：2018年03月26日  1208次浏览   27条评论  20436字数  分类：技术
 首页 正文  

背景：
适用于由GRUB引导的CentOS的，Ubuntu的，Debian的系统。使用官方发行版去掉模板预装的软件。同时也可以解决内核版本与软件不兼容的问题。只要有root权限，还你一个纯净的系统。
相关文章：
[Linux VPS] Debian（Ubuntu）网络安装/重装系统一键脚本
注意：
全自动安装默认root密码：Vicer，安装完成后请立即更改密码。
全自动安装时默认提供VNC功能，可使用VNC Viewer查看进度，
VNC端口为1或者5901，可自行尝试连接。（成功后VNC功能会消失。）
目前只支持CentOS 6.9及以下版本（5.x，6.x）。
特别注意：OpenVZ构架不适用。
更新：
[2018年4月3日]
功能合并： [Linux VPS] Debian / Ubuntu / CentOS网络安装/重装系统/纯净安装一键脚本
[二零一八年三月三十零日]
优化GRUB检测测逻辑。添加组件依赖检测。修复存在多网卡的问题。修复一些已知BUG。
需要：
1. Debian/Ubuntu/CentOS系统（由GRUB引导）; 2. wget用来下载文件，获取公网IP; 3. ip获取网关，掩码等; 4. sed awk grep处理文本流; 5. openssl创建root用户密码; 6. xz-utils重新打包镜像。

确保安装了所需软件：

#Debian/Ubuntu:
apt-get install -y xz-utils openssl gawk coreutils file

#RedHat/CentOS:
yum install -y xz openssl gawk coreutils file
如果出现了错误，请运行：

#Debian/Ubuntu:
apt-get update

#RedHat/CentOS:
yum update
一键下载及使用：

wget --no-check-certificate -qO CentOSNET.sh 'https://moeclub.org/attachment/LinuxShell/CentOSNET.sh' && chmod a+x CentOSNET.sh

Usage:
        bash CentOSNET.sh       -c/--centos [dist-version]
                                -v/--ver [32/i386|64/amd64]
                                --ip-addr/--ip-gate/--ip-mask
                                -yum/--mirror
                                -a/-m
全自动安装：

#使用默认镜像全自动安装
bash CentOSNET.sh -c 6.8 -v 64 -a

#使用自定义镜像全自动安装
bash CentOSNET.sh -c 6.9 -v 64 -a --mirror 'http://mirror.centos.org/centos'

#使用自定义镜像自定义网络参数全自动安装
#bash CentOSNET.sh -c 6.9 -v 64 -a --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x --mirror 'http://mirror.centos.org/centos'

一些提示：
如果看到“ 开始图形安装 ”或者类似表达，则表示正在安装。正常情况下只需要耐心等待安装完成即可。如果需要查看进度，使用VNC Viewer（或者其他VNC连接工具）连接提示中的IP地址：端口进行连接。（端口一般为1或者5901）
预览：

#!/bin/bash

export tmpVER=''
export tmpDIST=''
export tmpWORD=''
export tmpMirror=''
export tmpINS=''
export ipAddr=''
export ipMask=''
export ipGate=''
export linuxdists=''
export setNet='0'
export isMirror='0'
export UNKNOWHW='0'
export UNVER='6.4'

while [[ $# -ge 1 ]]; do
  case $1 in
    -v|--ver)
      shift
      tmpVER="$1"
      shift
      ;;
    -c|--centos)
      shift
      linuxdists='centos'
      tmpDIST="$1"
      shift
      ;;
    -p|--password)
      shift
      tmpWORD="$1"
      shift
      ;;
    --ip-addr)
      shift
      ipAddr="$1"
      shift
      ;;
    --ip-mask)
      shift
      ipMask="$1"
      shift
      ;;
    --ip-gate)
      shift
      ipGate="$1"
      shift
      ;;
    -a|--auto)
      shift
      tmpINS='auto'
      ;;
    -m|--manual)
      shift
      tmpINS='manual'
      ;;
    -yum|--mirror)
      shift
      isMirror='1'
      tmpMirror="$1"
      shift
      ;;
    *)
      echo -ne " Usage:\n\tbash DebianNET.sh\t-c/--centos [\033[33m\033[04mdists-verison\033[0m]\n\t\t\t\t-v/--ver [32/\033[33m\033[04mi386\033[0m|64/amd64]\n\t\t\t\t--ip-addr/--ip-gate/--ip-mask\n\t\t\t\t-apt/--mirror\n\t\t\t\t-dd/--image\n\t\t\t\t-a/--auto\n\t\t\t\t-m/--manual\n"
      exit 1;
      ;;
    esac
  done

[[ "$EUID" -ne '0' ]] && echo "Error:This script must be run as root!" && exit 1;

function CheckDependence(){
FullDependence='0';
for BIN_DEP in `echo "$1" |sed 's/,/\n/g'`
  do
    if [[ -n "$BIN_DEP" ]]; then
      Founded='0';
      for BIN_PATH in `echo "$PATH" |sed 's/:/\n/g'`
        do
          ls $BIN_PATH/$BIN_DEP >/dev/null 2>&1;
          if [ $? == '0' ]; then
            Founded='1';
            break;
          fi
        done
      if [ "$Founded" == '1' ]; then
        echo -en "$BIN_DEP\t\t[\033[32mok\033[0m]\n";
      else
        FullDependence='1';
        echo -en "$BIN_DEP\t\t[\033[31mfail\033[0m]\n";
      fi
    fi
  done
if [ "$FullDependence" == '1' ]; then
  exit 1;
fi
}

clear && echo -e "\n\033[36m# Check Dependence\033[0m\n"
CheckDependence wget,awk,xz,openssl,grep,dirname,file,cut,cat,cpio,gzip

[[ -f '/boot/grub/grub.cfg' ]] && GRUBOLD='0' && GRUBDIR='/boot/grub' && GRUBFILE='grub.cfg';
[[ -z "$GRUBDIR" ]] && [[ -f '/boot/grub2/grub.cfg' ]] && GRUBOLD='0' && GRUBDIR='/boot/grub2' && GRUBFILE='grub.cfg';
[[ -z "$GRUBDIR" ]] && [[ -f '/boot/grub/grub.conf' ]] && GRUBOLD='1' && GRUBDIR='/boot/grub' && GRUBFILE='grub.conf';
[ -z "$GRUBDIR" -o -z "$GRUBFILE" ] && echo -ne "Error! \nNot Found grub path.\n" && exit 1;

[[ -n "$tmpVER" ]] && {
  [ "$tmpVER" == '32' -o "$tmpVER" == 'i386' ] && VER='i386';
  [ "$tmpVER" == '64' -o "$tmpVER" == 'amd64' ] && VER='x86_64';
}
[[ -z "$VER" ]] && VER='i386';

[[ -z "$linuxdists" ]] && linuxdists='centos';

[[ "$isMirror" == '1' ]] && [[ -n "$tmpMirror" ]] && {
  echo "$tmpMirror" |grep -q '^http://';
  [[ $? == '0' ]] && {
    TMPMirror="$(echo "$tmpMirror" |awk -F'://' '{print $2}')";
  } || {
    echo -en "\n\033[31mInvaild Mirror! \033[0m\n\033[33mexample:\033[0m http://mirror.centos.org/centos\n\n";
    exit 1
  }
  [[ -n "$TMPMirror" ]] && {
    echo "$TMPMirror" |grep -q '/$';
    [[ $? == '0' ]] && {
      CentOSMirror="$(dirname "$TMPMirror.centos")";
    } || {
      CentOSMirror="$TMPMirror";
    }
  } || {
    bash $0 error;
    exit 1
  }
} || {
  CentOSMirror='vault.centos.org';
}

[[ -z "$tmpDIST" ]] && {
  [[ "$linuxdists" == 'centos' ]] && tmpDIST='6.4';
}

[[ -z "$DIST" ]] && {
  DISTCheck="$(echo "$tmpDIST" |grep -o '[.0-9]\{1,\}')";
  ListDIST="$(wget --no-check-certificate -qO- "http://$CentOSMirror/dir_sizes" |cut -f2 |grep '^[0-9]')"
  DIST="$(echo "$ListDIST" |grep "^$DISTCheck")"
  [[ -z "$DIST" ]] && {
    echo -ne '\nThe dists version not found, Please check it! \n\n'
    bash $0 error;
    exit 1;
  }
  wget --no-check-certificate -qO- "http://$CentOSMirror/$DIST/os/$VER/.treeinfo" |grep -q 'general';
  [[ $? != '0' ]] && {
    echo -ne "\nThe version not found in this mirror, Please change mirror try again! \n\n";
    exit 1;
  }
}

[[ -n "$tmpINS" ]] && {
  [[ "$tmpINS" == 'auto' ]] && inVNC='n';
  [[ "$tmpINS" == 'manual' ]] && inVNC='y';
}

[ -n "$ipAddr" ] && [ -n "$ipMask" ] && [ -n "$ipGate" ] && setNet='1';
[[ -n "$tmpWORD" ]] && myPASSWORD="$(openssl passwd -1 "$tmpWORD")";
[[ -z "$myPASSWORD" ]] && myPASSWORD='$1$0shYGfBd$8v189JOozDO1jPqPO645e1';
[[ -z "$INCFW" ]] && INCFW='0';

clear && echo -e "\n\033[36m# Install\033[0m\n"

ASKVNC(){
  inVNC='y';
  [[ "$ddMode" == '0' ]] && {
    echo -ne "\033[34mCan you login VNC?\033[0m\e[33m[\e[32my\e[33m/n]\e[0m "
    read tmpinVNC
    [[ -n "$inVNCtmp" ]] && inVNC="$tmpinVNC"
  }
  [ "$inVNC" == 'y' -o "$inVNC" == 'Y' ] && inVNC='y';
  [ "$inVNC" == 'n' -o "$inVNC" == 'N' ] && inVNC='n';
}

[ "$inVNC" == 'y' -o "$inVNC" == 'n' ] || ASKVNC;
[[ "$linuxdists" == 'centos' ]] && LinuxName='CentOS';
[[ "$inVNC" == 'y' ]] && VNC_WARN='1' && echo -e "\033[34mManual Mode\033[0m insatll \033[33m$LinuxName\033[0m [\033[33m$DIST\033[0m] [\033[33m$VER\033[0m] in VNC. "
[[ "$inVNC" == 'n' ]] && VNC_WARN='0' && echo -e "\033[34mAuto Mode\033[0m insatll \033[33m$LinuxName\033[0m [\033[33m$DIST\033[0m] [\033[33m$VER\033[0m]. "

if [[ "$DIST" != "$UNVER" ]]; then
  awk 'BEGIN{print '${UNVER}'-'${DIST}'}' |grep -q '^-'
  if [ $? != '0' ]; then
    UNKNOWHW='1';
    echo -en "\033[33mThe version lower then \033[31m$UNVER\033[33m may not support in auto mode! \033[0m\n";
    if [[ "$inVNC" == 'n' ]]; then
      echo -en "\033[35mYou can connect VNC with \033[32mPublic IP\033[35m and port \033[32m1\033[35m/\033[32m5901\033[35m in vnc viewer.\033[0m\n"
      read -n 1 -p "Press Enter to continue..." INP
      [[ "$INP" != '' ]] && echo -ne '\b \n\n';
    fi
  fi
  awk 'BEGIN{print '${UNVER}'-'${DIST}'+0.59}' |grep -q '^-'
  if [ $? == '0' ]; then
    echo -en "\n\033[31mThe version higher then \033[33m6.9 \033[31mis not support in current! \033[0m\n\n"
    exit 1;
  fi
fi

echo -e "\n[\033[33m$LinuxName\033[0m] [\033[33m$DIST\033[0m] [\033[33m$VER\033[0m] Downloading..."
[[ -z "$CentOSMirror" ]] && echo -ne "\033[31mError! \033[0mGet debian mirror fail! \n" && exit 1
wget --no-check-certificate -qO '/boot/initrd.img' "http://$CentOSMirror/$DIST/os/$VER/isolinux/initrd.img"
[[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'initrd.img' failed! \n" && exit 1
wget --no-check-certificate -qO '/boot/vmlinuz' "http://$CentOSMirror/$DIST/os/$VER/isolinux/vmlinuz"
[[ $? -ne '0' ]] && echo -ne "\033[31mError! \033[0mDownload 'vmlinux' failed! \n" && exit 1

[[ "$setNet" == '1' ]] && {
  IPv4="$ipAddr";
  MASK="$ipMask";
  GATE="$ipGate";
} || {
  DEFAULTNET="$(ip route show |grep -o 'default via [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.*' |head -n1 |sed 's/proto.*\|onlink.*//g' |awk '{print $NF}')";
  [[ -n "$DEFAULTNET" ]] && IPSUB="$(ip addr |grep ''${DEFAULTNET}'' |grep 'global' |grep 'brd' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}/[0-9]\{1,2\}')";
  IPv4="$(echo -n "$IPSUB" |cut -d'/' -f1)";
  NETSUB="$(echo -n "$IPSUB" |grep -o '/[0-9]\{1,2\}')";
  GATE="$(ip route show |grep -o 'default via [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}')";
  [[ -n "$NETSUB" ]] && MASK="$(echo -n '128.0.0.0/1,192.0.0.0/2,224.0.0.0/3,240.0.0.0/4,248.0.0.0/5,252.0.0.0/6,254.0.0.0/7,255.0.0.0/8,255.128.0.0/9,255.192.0.0/10,255.224.0.0/11,255.240.0.0/12,255.248.0.0/13,255.252.0.0/14,255.254.0.0/15,255.255.0.0/16,255.255.128.0/17,255.255.192.0/18,255.255.224.0/19,255.255.240.0/20,255.255.248.0/21,255.255.252.0/22,255.255.254.0/23,255.255.255.0/24,255.255.255.128/25,255.255.255.192/26,255.255.255.224/27,255.255.255.240/28,255.255.255.248/29,255.255.255.252/30,255.255.255.254/31,255.255.255.255/32' |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'${NETSUB}'' |cut -d'/' -f1)";
}

[[ -n "$GATE" ]] && [[ -n "$MASK" ]] && [[ -n "$IPv4" ]] || {
echo "Not found \`ip command\`, It will use \`route command\`."
ipNum() {
  local IFS='.';
  read ip1 ip2 ip3 ip4 <<<"$1";
  echo $((ip1*(1<<24)+ip2*(1<<16)+ip3*(1<<8)+ip4));
}

SelectMax(){
ii=0;
for IPITEM in `route -n |awk -v OUT=$1 '{print $OUT}' |grep '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'`
  do
    NumTMP="$(ipNum $IPITEM)";
    eval "arrayNum[$ii]='$NumTMP,$IPITEM'";
    ii=$[$ii+1];
  done
echo ${arrayNum[@]} |sed 's/\s/\n/g' |sort -n -k 1 -t ',' |tail -n1 |cut -d',' -f2;
}

[[ -z $IPv4 ]] && IPv4="$(ifconfig |grep 'Bcast' |head -n1 |grep -o '[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}' |head -n1)";
[[ -z $GATE ]] && GATE="$(SelectMax 2)";
[[ -z $MASK ]] && MASK="$(SelectMax 3)";

[[ -n "$GATE" ]] && [[ -n "$MASK" ]] && [[ -n "$IPv4" ]] || {
  echo "Error! Not configure network. ";
  exit 1;
}
}

[[ "$setNet" != '1' ]] && [[ -f '/etc/network/interfaces' ]] && {
  [[ -z "$(sed -n '/iface.*inet static/p' /etc/network/interfaces)" ]] && AutoNet='1' || AutoNet='0';
  [[ -d /etc/network/interfaces.d ]] && {
    ICFGN="$(find /etc/network/interfaces.d -name '*.cfg' |wc -l)" || ICFGN='0';
    [[ "$ICFGN" -ne '0' ]] && {
      for NetCFG in `ls -1 /etc/network/interfaces.d/*.cfg`
        do 
          [[ -z "$(cat $NetCFG | sed -n '/iface.*inet static/p')" ]] && AutoNet='1' || AutoNet='0';
          [[ "$AutoNet" -eq '0' ]] && break;
        done
    }
  }
}

[[ "$setNet" != '1' ]] && [[ -d '/etc/sysconfig/network-scripts' ]] && {
  ICFGN="$(find /etc/sysconfig/network-scripts -name 'ifcfg-*' |grep -v 'lo'|wc -l)" || ICFGN='0';
  [[ "$ICFGN" -ne '0' ]] && {
    for NetCFG in `ls -1 /etc/sysconfig/network-scripts/ifcfg-* |grep -v 'lo$' |grep -v ':[0-9]\{1,\}'`
      do 
        [[ -n "$(cat $NetCFG | sed -n '/BOOTPROTO.*[dD][hH][cC][pP]/p')" ]] && AutoNet='1' || {
          AutoNet='0' && . $NetCFG;
          [[ -n $NETMASK ]] && MASK="$NETMASK";
          [[ -n $GATEWAY ]] && GATE="$GATEWAY";
        }
        [[ "$AutoNet" -eq '0' ]] && break;
      done
  }
}

[[ ! -f $GRUBDIR/$GRUBFILE ]] && echo "Error! Not Found $GRUBFILE. " && exit 1;

[[ ! -f $GRUBDIR/$GRUBFILE.old ]] && [[ -f $GRUBDIR/$GRUBFILE.bak ]] && mv -f $GRUBDIR/$GRUBFILE.bak $GRUBDIR/$GRUBFILE.old;
mv -f $GRUBDIR/$GRUBFILE $GRUBDIR/$GRUBFILE.bak;
[[ -f $GRUBDIR/$GRUBFILE.old ]] && cat $GRUBDIR/$GRUBFILE.old >$GRUBDIR/$GRUBFILE || cat $GRUBDIR/$GRUBFILE.bak >$GRUBDIR/$GRUBFILE;

[[ "$GRUBOLD" == '0' ]] && {
  READGRUB='/tmp/grub.read'
  cat $GRUBDIR/$GRUBFILE |sed -n '1h;1!H;$g;s/\n/+++/g;$p' |grep -oPm 1 'menuentry\ .*\{.*\}\+\+\+' |sed 's/\+\+\+/\n/g' >$READGRUB
  LoadNum="$(cat $READGRUB |grep -c 'menuentry ')"
  if [[ "$LoadNum" -eq '1' ]]; then
    cat $READGRUB |sed '/^$/d' >/tmp/grub.new;
  elif [[ "$LoadNum" -gt '1' ]]; then
    CFG0="$(awk '/menuentry /{print NR}' $READGRUB|head -n 1)";
    CFG2="$(awk '/menuentry /{print NR}' $READGRUB|head -n 2 |tail -n 1)";
    CFG1="";
    for tmpCFG in `awk '/}/{print NR}' $READGRUB`
      do
        [ "$tmpCFG" -gt "$CFG0" -a "$tmpCFG" -lt "$CFG2" ] && CFG1="$tmpCFG";
      done
    [[ -z "$CFG1" ]] && {
      echo "Error! read $GRUBFILE. ";
      exit 1;
    }

    sed -n "$CFG0,$CFG1"p $READGRUB >/tmp/grub.new;
    [[ -f /tmp/grub.new ]] && [[ "$(grep -c '{' /tmp/grub.new)" -eq "$(grep -c '}' /tmp/grub.new)" ]] || {
      echo -ne "\033[31mError! \033[0mNot configure $GRUBFILE. \n";
      exit 1;
    }
  fi
  [ ! -f /tmp/grub.new ] && echo "Error! $GRUBFILE. " && exit 1;
  sed -i "/menuentry.*/c\menuentry\ \'Install OS \[$DIST\ $VER\]\'\ --class debian\ --class\ gnu-linux\ --class\ gnu\ --class\ os\ \{" /tmp/grub.new
  sed -i "/echo.*Loading/d" /tmp/grub.new;
}

[[ "$GRUBOLD" == '1' ]] && {
  CFG0="$(awk '/title /{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)";
  CFG1="$(awk '/title /{print NR}' $GRUBDIR/$GRUBFILE|head -n 2 |tail -n 1)";
  [[ -n $CFG0 ]] && [ -z $CFG1 -o $CFG1 == $CFG0 ] && sed -n "$CFG0,$"p $GRUBDIR/$GRUBFILE >/tmp/grub.new;
  [[ -n $CFG0 ]] && [ -z $CFG1 -o $CFG1 != $CFG0 ] && sed -n "$CFG0,$CFG1"p $GRUBDIR/$GRUBFILE >/tmp/grub.new;
  [[ ! -f /tmp/grub.new ]] && echo "Error! configure append $GRUBFILE. " && exit 1;
  sed -i "/title.*/c\title\ \'Install OS \[$DIST\ $VER\]\'" /tmp/grub.new;
  sed -i '/^#/d' /tmp/grub.new;
}

[[ -n "$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $2}' |tail -n 1 |grep '^/boot/')" ]] && Type='InBoot' || Type='NoBoot';

LinuxKernel="$(grep 'linux.*/\|kernel.*/' /tmp/grub.new |awk '{print $1}' |head -n 1)";
[[ -z "$LinuxKernel" ]] && echo "Error! read grub config! " && exit 1;
LinuxIMG="$(grep 'initrd.*/' /tmp/grub.new |awk '{print $1}' |tail -n 1)";
[ -z "$LinuxIMG" ] && sed -i "/$LinuxKernel.*\//a\\\tinitrd\ \/" /tmp/grub.new && LinuxIMG='initrd';

[[ "$Type" == 'InBoot' ]] && {
  sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/boot\/vmlinuz ks=file:\/\/ks.cfg ksdevice=link" /tmp/grub.new;
  sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/boot\/initrd.img" /tmp/grub.new;
}

[[ "$Type" == 'NoBoot' ]] && {
  sed -i "/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/vmlinuz ks=file:\/\/ks.cfg ksdevice=link" /tmp/grub.new;
  sed -i "/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/initrd.img" /tmp/grub.new;
}

sed -i '$a\\n' /tmp/grub.new;

[[ "$inVNC" == 'n' ]] && {
GRUBPATCH='0';

[ -f '/etc/network/interfaces' -o -d '/etc/sysconfig/network-scripts' ] || {
  echo "Error, Not found interfaces config.";
  exit 1;
}

INSERTGRUB="$(awk '/menuentry /{print NR}' $GRUBDIR/$GRUBFILE|head -n 1)"
sed -i ''${INSERTGRUB}'i\\n' $GRUBDIR/$GRUBFILE;
sed -i ''${INSERTGRUB}'r /tmp/grub.new' $GRUBDIR/$GRUBFILE;
[[ -f  $GRUBDIR/grubenv ]] && sed -i 's/saved_entry/#saved_entry/g' $GRUBDIR/grubenv;

[[ -d /boot/tmp ]] && rm -rf /boot/tmp;
mkdir -p /boot/tmp;
cd /boot/tmp;
COMPTYPE="$(file /boot/initrd.img |grep -o ':.*compressed data' |cut -d' ' -f2 |sed -r 's/(.*)/\L\1/' |head -n1)"
[[ -z "$COMPTYPE" ]] && echo "Detect compressed type fail." && exit 1;
CompDected='0'
for ListCOMP in `echo -en 'lzma\nxz\ngzip'`
  do
    if [[ "$COMPTYPE" == "$ListCOMP" ]]; then
      CompDected='1'
      if [[ "$COMPTYPE" == 'gzip' ]]; then
        NewIMG="initrd.img.gz"
      else
        NewIMG="initrd.img.$COMPTYPE"
      fi
      mv -f "/boot/initrd.img" "/boot/$NewIMG"
      break;
    fi
  done
[[ "$CompDected" != '1' ]] && echo "Detect compressed type not support." && exit 1;
[[ "$COMPTYPE" == 'lzma' ]] && UNCOMP='xz --format=lzma --decompress';
[[ "$COMPTYPE" == 'xz' ]] && UNCOMP='xz --decompress';
[[ "$COMPTYPE" == 'gzip' ]] && UNCOMP='gzip -d';

$UNCOMP < ../$NewIMG | cpio --extract --verbose --make-directories --no-absolute-filenames >>/dev/null 2>&1
cat >/boot/tmp/ks.cfg< ../initrd.img;
rm -rf /boot/tmp;
}

[[ "$inVNC" == 'y' ]] && {
  sed -i '$i\\n' $GRUBDIR/$GRUBFILE
  sed -i '$r /tmp/grub.new' $GRUBDIR/$GRUBFILE
  echo -e "\n\033[33m\033[04mIt will reboot! \nPlease look at VNC! \nSelect\033[0m\033[32m Install OS [$DIST $VER] \033[33m\033[4mto install system.\033[04m\n\n\033[31m\033[04mThere is some information for you.\nDO NOT CLOSE THE WINDOW! \033[0m\n"
  echo -e "\033[35mIPv4\t\tNETMASK\t\tGATEWAY\033[0m"
  echo -e "\033[36m\033[04m$IPv4\033[0m\t\033[36m\033[04m$MASK\033[0m\t\033[36m\033[04m$GATE\033[0m\n\n"

  read -n 1 -p "Press Enter to reboot..." INP
  [[ "$INP" != '' ]] && echo -ne '\b \n\n';
}

chown root:root $GRUBDIR/$GRUBFILE
chmod 444 $GRUBDIR/$GRUBFILE

sleep 3 && reboot >/dev/null 2>&1


 最后修改：2019年02月19日12:32 PM

```


###


```yml


```


### [Linux VPS] Debian（Ubuntu）网络安装/重装系统一键脚本


```yml

https://moeclub.org/2017/03/25/82/?spm=59.5

[Linux VPS] Debian（Ubuntu）网络安装/重装系统一键脚本
博主： Haibara  发布时间：2017年03月25日  2551次浏览   220条评论  29638字数  分类：技术

博主： Haibara  发布时间：2017年03月25日  2551次浏览   220条评论  29638字数  分类：技术
 首页 正文  

背景：
适用于由GRUB引导的CentOS的，Ubuntu的，Debian的系统。使用官方发行版去掉模板预装的软件。同时也可以解决内核版本与软件不兼容的问题。只要有root权限，还你一个纯净的系统。
相关文章：
[Linux VPS] CentOS网络安装/重装系统一键脚本纯净安装
注意：
全自动安装默认root密码：Vicer，安装完成后请立即更改密码。请使用passwd root命令更改密码。 特别注意：OpenVZ构架不适用。
更新：
[2018年4月3日]
功能合并： [Linux VPS] Debian / Ubuntu / CentOS网络安装/重装系统/纯净安装一键脚本
[二零一八年三月三十零日]
优化GRUB检测测逻辑。添加组件依赖检测。修复一些已知BUG。
[2018年3月25日]
优化判断逻辑。增加手动指定网络参数选项，可有效避免自动获取网络参数无效造成无法直接联网的问题。
[2017年11月25日]
重新规范参数-d/ -u。
[2017年11月22日]
增加自动DD安装的Windows功能，点击查看详情。
[2017年8月6日]
增加支持重装为Ubuntu的系统- 安装Ubuntu的时，使用必须版本代号。 如有必要，请使用--mirror自行更换软件源。使用方法示例：
自动以安装模式Ubuntu 16.04 64位为例：

bash DebianNET.sh -u xenial -v 64 -a
[2017年7月5日]
修复在独服上安装的一些由硬盘引起的问题。在修复CentOS6上判断网卡出错的问题。
[2017年6月25日]
适配了由较老GRUB引导版本的CentOS6等系统- 。 去除-cn参数，此参数作用不大。 添加-apt/--mirror参数，用于指定源（需完整的镜像源地址）。 用法示例：

--mirror 'http://ftp.riken.jp/Linux/debian/debian/'
--mirror 'http://mirrors.ustc.edu.cn/debian/'
[2017年6月24日]
由公网探测IP地址，改为本机探测IP地址。适配更加广泛。
[2017年6月23日]
修复Debian9不能使用根登陆的问题。对于移除移除route命令的依赖，使用ip命令并计算子网掩码。使用修复ls命令时的一个错误警告。增加-cn参数，使国内机器下载所需资源更加迅速。
[二零一七年六月二十零日]
对增加Debian9的请立即获取iTunes，支持全自动化安装。未做大量测试，有问题请反馈。
[2017年6月9日]
请立即获取iTunes添加从CentOS7运行全自动化安装Debian。请立即获取iTunes理论上由grub2引导的系统- （CentOS6由grub引导，故不支持）。优化判断逻辑，删除	-t参数。添加-a参数（全自动化安装）状语从句：-m参数（从VNC模式安装）
[2017年6月5日]
修复全自动安装Debian8会出现卡住和不能使用根密码登陆的问题。
[2017年6月4日]
增加全自动方式安装，实现在无救援模式，无VNC的情况下安装Debian的。已经在AWS Lightsail（Ubuntu），DigitalOcean，UltraVPS.eu通过测试。默认root密码：Vicer，安装完成后请立即更改密码。使用passwd root命令更改密码。
[2017年3月28日]
增加了一个之参数选项;此参数用于手动指定机器的虚拟化类型。一般情况下不需要指定此参数。
[2017年3月25日]
修复了一些已知问题。
需要：
1. Debian/Ubuntu/CentOS系统（由GRUB引导）; 2. wget用来下载文件，获取公网IP; 3. ip获取网关，掩码等; 4. sed awk grep处理文本流; 5. VNC安装系统（此项为可选）。

确保安装了所需软件：

#Debian/Ubuntu:
apt-get install -y gawk sed grep

#RedHat/CentOS:
yum install -y gawk sed grep
如果出现了错误，请运行：

#Debian/Ubuntu:
apt-get update

#RedHat/CentOS:
yum update
一键下载及使用：

wget --no-check-certificate -qO DebianNET.sh 'https://moeclub.org/attachment/LinuxShell/DebianNET.sh' && chmod a+x DebianNET.sh

Usage:
        bash DebianNET.sh       -d/--debian [dist-name]
                                -u/--ubuntu [dist-name]
                                -v/--ver [32/i386|64/amd64]
                                --ip-addr/--ip-gate/--ip-mask
                                -apt/--mirror
                                -dd/--image
                                -a/-m
全自动/非全自动示例：
全自动安装：

bash DebianNET.sh -d wheezy -v i386 -a
VNC手动安装：

bash DebianNET.sh -d wheezy -v i386 -m
全自动安装（指定网络参数）：

# 将X.X.X.X替换为自己的网络参数.
# --ip-addr :IP Address/IP地址
# --ip-gate :Gateway   /网关
# --ip-mask :Netmask   /子网掩码
#bash DebianNET.sh -d wheezy -v i386 -a --ip-addr X.X.X.X --ip-mask X.X.X.X --ip-gate X.X.X.X
使用示例：
【默认】安装Debian 7 x32：
bash DebianNET.sh -d wheezy -v i386
bash DebianNET.sh -d 7 -v 32
安装Debian 8 x64：
bash DebianNET.sh -d jessie -v amd64
bash DebianNET.sh -d 8 -v 64
安装Debian 9 x64：
bash DebianNET.sh -d stretch -v amd64
bash DebianNET.sh -d 9 -v 64
安装Ubuntu 14.04 x64：
bash DebianNET.sh -u trusty -v 64
安装Ubuntu 16.04 x64：
bash DebianNET.sh -u xenial -v 64
安装Ubuntu 18.04 x64：
bash DebianNET.sh -u bionic -v 64
【默认】预览：
InstallOS
完整代码：
＃！/斌/庆典

export tmpVER =''
export tmpDIST =''
export tmpURL =''
export tmpWORD =''
export tmpMirror =''
export tmpSSL =''
export tmpINS =''
export tmpFW =''
export ipAddr =''
export ipMask =''
export ipGate =''
export linuxdists =''
export ddMode ='0'
export setNet ='0'
export isMirror ='0'
export FindDists ='0'

而[[$＃-ge 1]]; 做
  案件1美元
    -v | --ver）
      转移
      tmpVER = “$ 1”
      转移
      ;;
    -d | --debian）
      转移
      linuxdists = '的Debian'
      tmpDIST = “$ 1”
      转移
      ;;
    -u | --ubuntu）
      转移
      linuxdists = '的ubuntu'
      tmpDIST = “$ 1”
      转移
      ;;
    -dd | --image）
      转移
      ddMode = '1'
      tmpURL = “$ 1”
      转移
      ;;
    -p | --password）
      转移
      tmpWORD = “$ 1”
      转移
      ;;
    --ip-地址）
      转移
      IPADDR = “$ 1”
      转移
      ;;
    --ip面罩）
      转移
      ipMask = “$ 1”
      转移
      ;;
    --ip栅）
      转移
      ipGate = “$ 1”
      转移
      ;;
    -a | --auto）
      转移
      tmpINS = '自动'
      ;;
    -m |  - 手动）
      转移
      tmpINS = '手动'
      ;;
    -apt | --mirror）
      转移
      isMirror = '1'
      tmpMirror = “$ 1”
      转移
      ;;
    -ssl）
      转移
      tmpSSL = “$ 1”
      转移
      ;;
    - 固件）
      转移
      tmpFW = '1'
      ;;
    *）
      echo -ne“用法：\ n \ t \ n \ n \ nDebianNET.sh \ td /  -  debian [\ 033 [33m \ 033 [04mdists-name \ 033 [0m] \ n \ t \ t \ t \ tu /  -  ubuntu [ \ 033 [04mdists-name \ 033 [0m] \ n \ t \ t \ t \ tv /  -  ver [32 / \ 033 [33m \ 033 [04mi386 \ 033 [0m | 64 / amd64] \ n \ t \吨\吨\吨 -  IP-ADDR /  -  IP-栅/  -  IP-掩模\ n \吨\吨\吨\叔易于/  - 镜\ n \吨\吨\吨\叔DD /  - 图片\ n \吨\吨\吨\ TA /  - 自动\ n \吨\吨\吨\ TM /  - 手册\ n”个
      1号出口;
      ;;
    ESAC
  DONE

[[“$ EUID”-ne'0']] && echo“错误：此脚本必须以root身份运行！” &&退出1;

function CheckDependence（）{
FullDependence = '0';
对于“echo”$ 1“中的BIN_DEP”| sed's /，/ \ n / g'`
  做
    if [[-n“$ BIN_DEP”]]; 然后
      成立= '0';
      对于'echo'$ PATH中的BIN_PATH“| sed's /：/ \ n / g'`
        做
          ls $ BIN_PATH / $ BIN_DEP> / dev / null 2>＆1;
          如果[$？=='0']; 然后
            成立= '1';
            打破;
          科幻
        DONE
      如果[“$ Founded”=='1']; 然后
        echo -en“$ BIN_DEP \ t \ t [\ 033 [32mok \ 033 [0m] \ n”;
      其他
        FullDependence = '1';
        echo -en“$ BIN_DEP \ t \ t [\ 033 [31mfail \ 033 [0m] \ n”;
      科幻
    科幻
  DONE
if [“$ FullDependence”=='1']; 然后
  1号出口;
科幻
}

清除&& echo -e“\ n \ 033 [36m #Check Dependence \ 033 [0m \ n”
CheckDependence wget，awk，grep，sed，cut，cat，cpio，gzip

[“$ ddMode”=='1'] && {
CheckDependence iconv
}

[[-f'/ boot/grub/grub.cfg']] && GRUBOLD ='0'&& GRUBDIR ='/ boot / grub'&& GRUBFILE ='grub.cfg';
[[-z“$ GRUBDIR”]] && [[-f'/ boot/grub2/grub.cfg']] && GRUBOLD ='0'&& GRUBDIR ='/ boot / grub2'&& GRUBFILE ='grub.cfg' ;
[[-z“$ GRUBDIR”]] && [[-f'/ boot/grub/grub.conf']] && GRUBOLD ='1'&& GRUBDIR ='/ boot / grub'&& GRUBFILE ='grub.conf' ;
[-z“$ GRUBDIR”-o -z“$ GRUBFILE”] && echo -ne“错误！\ n找不到grub路径。\ n”&&退出1;

[[-n“$ tmpVER”]] && {
  [“$ tmpVER”=='32'-o“$ tmpVER”=='i386'] && VER ='i386';
  [“$ tmpVER”=='64'-o“$ tmpVER”=='amd64'] && VER ='amd64';
}
[[-z“$ VER”]] && VER ='i386';

[[-z“$ linuxdists”]] && linuxdists ='debian';

[[“$ isMirror”=='1']] && [[-n“$ tmpMirror”]] && {
  tmpDebianMirror =“$（echo -n”$ tmpMirror“| grep -Eo'。* \。（\ w +）'）”;
  echo -n“$ tmpDebianMirror”| grep -q'：//';
  [[$？-eq'0']] && {
    DebianMirror =“$（echo -n”$ tmpDebianMirror“| awk -F'：//''{print $ 2}'）”;
  } || {
    DebianMirror =“$（echo -n”$ tmpDebianMirror“）”;
  }
} || {
  [[“$ linuxdists”=='debian']] && DebianMirror ='httpredir.debian.org';
  [[“$ linuxdists”=='ubuntu']] && DebianMirror ='archive.ubuntu.com';
}

[[-z“$ DebianMirrorDirectory”]] && [[-n“$ DebianMirror”]] && [[-n“$ tmpMirror”]] && {
  DebianMirrorDirectory =“$（echo -n”$ tmpMirror“| awk -F''$ {DebianMirror}'''{print $ 2}'| sed's / \ / $ // g'）”;
}

[[-n“$ DebianMirror”]] && {
  [[“$ DebianMirrorDirectory”=='/']] && {
    [[“$ linuxdists”=='debian']] && DebianMirrorDirectory ='/ debian';
    [[“$ linuxdists”=='ubuntu']] && DebianMirrorDirectory ='/ ubuntu';
  }
  [[-z“$ DebianMirrorDirectory”]] && {
    [[“$ linuxdists”=='debian']] && DebianMirrorDirectory ='/ debian';
    [[“$ linuxdists”=='ubuntu']] && DebianMirrorDirectory ='/ ubuntu';
  }
}

[[-z“$ tmpDIST”]] && {
  [[“$ linuxdists”=='debian']] && DIST ='wheezy';
  [[“$ linuxdists”=='ubuntu']] && DIST ='trusty';
}

[[-z“$ DIST”]] && {
  DIST =“$（echo”$ tmpDIST“| sed -r's /（。*）/ \ L \ 1 /'）”;
  echo“$ DIST”| grep -q'[0-9]';
  [[$？-eq'0']] && {
    isDigital =“$（echo”$ DIST“| grep -o'[0-9 \。] \ {1，\}'| sed -n'1h; 1！H; $ g; s / \ n // g ; $ p'| cut -d'。' -  f1）“;
    [[-n $ isDigital]] && {
      [[“$ isDigital”=='7']] && DIST ='wheezy';
      [[“$ isDigital”=='8']] && DIST ='jessie';
      [[“$ isDigital”=='9']] && DIST ='stretch';
      [[“$ isDigital”=='10']] && DIST ='buster';
    }
  }
}

[[“$ ddMode”=='1']] && {
  [[-n“$ tmpURL”]] && {
    linuxdists = '的Debian';
    DIST = '杰西';
    VER = 'AMD64';
    tmpINS = '自动';
    DDURL = “$ tmpURL”
    echo“$ DDURL”| grep -q'^ http：// \ | ^ ftp：// \ | ^ https：//';
    [[$？-ne'0']] && echo'请输入vaild URL，仅支持http：//，ftp：//和https：//！' &&退出1;
    [[-n“$ tmpSSL”]] && SSL_SUPPORT =“$ tmpSSL”;
    [[-z“$ SSL_SUPPORT”]] && SSL_SUPPORT ='https：//moeclub.org/get-wget_udeb_amd64';
  } || {
    echo'请输入vaild URL！“;
    1号出口;
  }
}

DistsList =“$（wget --no-check-certificate -qO-”http：// $ DebianMirror $ DebianMirrorDirectory / dists /“| grep -o'href =。* /”'| cut -d'“' -  f2 | sed'/  -  \ | old \ | Debian \ | experimental \ | stable \ | test \ | sid \ | devel / d'| grep'^ [^ /]'| sed -n'1h; 1！H; $克; S / \ n //克; S / \ // \; /克; $ p'）“;
对于CheckEB中的`echo“$ DistsList”| sed's /; / \ n / g'`
  做
    [[“$ CheckDEB”==“$ DIST”]] && FindDists ='1';
    [[“$ FindDists”=='1']] && break;
  DONE
[[“$ FindDists”=='0']] && {
  echo -ne'\ n未找到dists版本，请检查它！\ n \ n”
  bash $ 0错误;
  1号出口;
}

[[-n“$ tmpINS”]] && {
  [[“$ tmpINS”=='auto']] && inVNC ='n';
  [[“$ tmpINS”=='manual']] && inVNC ='y';
}

[-n“$ ipAddr”] && [-n“$ ipMask”] && [-n“$ ipGate”] && setNet ='1';
[[-n“$ tmpWORD”]] && myPASSWORD =“$ tmpWORD”;
[[-n“$ tmpFW”]] && INCFW =“$ tmpFW”;
[[-z“$ myPASSWORD”]] && myPASSWORD ='Vicer';
[[-z“$ INCFW”]] && INCFW ='0';

clear && echo -e“\ n \ 033 [36m＃Install \ 033 [0m \ n”

ASKVNC（）{
  inVNC = 'Y';
  [[“$ ddMode”=='0']] && {
    echo -ne“\ 033 [34m你能登录VNC吗？\ 033 [0m \ e [33m [\ e [32my \ e [33m / n] \ e [0m”
    读tmpinVNC
    [[-n“$ tmpinVNC”]] && inVNCtmp =“$ tmpinVNC”
  }
  [“$ inVNCtmp”=='y'-o“$ inVNCtmp”=='Y'] && inVNC ='y';
  [“$ inVNCtmp”=='n'-o“$ inVNCtmp”=='N'] && inVNC ='n';
}

[“$ inVNC”=='y'-o“$ inVNC”=='n'] || ASKVNC;
[[“$ linuxdists”=='debian']] && LinuxName ='Debian';
[[“$ linuxdists”=='ubuntu']] && LinuxName ='Ubuntu';
[[“$ ddMode”=='0']] && { 
  [[“$ inVNC”=='y']] && echo -e“\ 033 [34mManual Mode \ 033 [0m insatll \ 033 [33m $ LinuxName \ 033 [0m [\ 033 [33m $ DIST \ 033 [0m] [\ 033 [VNC中33m $ VER \ 033 [0m]。“
  [[“$ inVNC”=='n']] && echo -e“\ 033 [34mAuto Mode \ 033 [0m insatll \ 033 [33m $ LinuxName \ 033 [0m [\ 033 [33m $ DIST \ 033 [0m] [\ 033 [33m $ VER \ 033 [0m]。“
}
[[“$ ddMode”=='1']] && {
  echo -ne“\ 033 [34mAuto Mode \ 033 [0m insatll \ 033 [33mWindows \ 033 [0m \ n [\ 033 [33m $ DDURL \ 033 [0m] \ n”
}

echo -e“\ n [\ 033 [33m $ LinuxName \ 033 [0m] [\ 033 [33m $ DIST \ 033 [0m] [\ 033 [33m $ VER \ 033 [0m]正在下载...”
[[-z“$ DebianMirror”]] && echo -ne“\ 033 [31mError！\ 033 [0mGet debian mirror fail！\ n”&& exit 1
[[-z“$ DebianMirrorDirectory”]] && echo -ne“\ 033 [31mError！\ 033 [0mGet debian mirror directory fail！\ n”&& exit 1
wget --no-check-certificate -qO'/boot/initrd.gz'“http：// $ DebianMirror $ DebianMirrorDirectory / dists / $ DIST / main / installer- $ VER / current / images / netboot / $ linuxdists-installer /$VER/initrd.gz”
[[$？-ne'0']] && echo -ne“\ 033 [31mError！\ 033 [0mDownload'initrd.gz'失败！\ n”&&退出1
wget --no-check-certificate -qO'/ boot / linux'“http：// $ DebianMirror $ DebianMirrorDirectory / dists / $ DIST / main / installer- $ VER / current / images / netboot / $ linuxdists-installer / $ VER / LINUX”
[[$？-ne'0']] && echo -ne“\ 033 [31mError！\ 033 [0mDownload'linux'失败！\ n”&&退出1
[[“$ INCFW”=='1']] && [[“$ linuxdists”=='debian']] && {
  wget --no-check-certificate -qO'/ boot/firmware.cpio.gz'“http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/$DIST/current/firmware.cpio。 GZ”
  [[$？-ne'0']] && echo -ne“\ 033 [31mError！\ 033 [0mDownload'firmware'失败！\ n”&&退出1
}

[[“$ setNet”=='1']] && {
  IPv4的= “$ IPADDR”;
  MASK = “$ ipMask”;
  GATE = “$ ipGate”;
} || {
  DEFAULTNET =“$（ip route show | grep -o'默认通过[0-9] \ {1,3 \}。[0-9] \ {1,3 \}。[0-9] \ {1， 3 \}。[0-9] \ {1,3 \}。*'| head -n1 | sed's / proto。* \ | onlink。* // g'| awk'{print $ NF}'） “;
  [[-n“$ DEFAULTNET”]] && IPSUB =“$（ip addr | grep''$ {DEFAULTNET}''| grep'global'| grep'brd'| head -n1 | grep -o'[0- 9] \ {1,3 \}。[0-9] \ {1,3 \}。[0-9] \ {1,3 \}。[0-9] \ {1,3 \} / [ 0-9] \ {1,2 \}'）“;
  IPv4 =“$（echo -n”$ IPSUB“| cut -d'/' -  f1）”;
  NETSUB =“$（echo -n”$ IPSUB“| grep -o'/ [0-9] \ {1,2 \}'）”;
  GATE =“$（ip route show | grep -o'默认通过[0-9] \ {1,3 \}。[0-9] \ {1,3 \}。[0-9] \ {1， 3 \}。[0-9] \ {1,3 \}'| head -n1 | grep -o'[0-9] \ {1,3 \}。[0-9] \ {1,3 \ } [0-9] \ {1,3 \} [0-9] \ {1,3 \}'）“。;
  [[-n“$ NETSUB”]] && MASK =“$（echo -n'128.0.0.0/1,192.0.0.0/2,224.0.0.0/3,240.0.0.0/4,248.0.0.0/5,252.0.0.0/6,254.0.0.0/7,255.0。 0.0 / 8,255.128.0.0 / 9,255.192.0.0 / 10,255.224.0.0 / 11,255.240.0.0 / 12,255.248.0.0 / 13,255.252.0.0 / 14,255.254.0.0 / 15,255.255.0.0 / 16,255.255.128.0 / 17,255.255.192.0 / 18,255.255.224.0 / 19,255.255.240.0 / 20,255.255.248.0 / 21,255.255.252.0 / 22,255.255.254.0 / 23,255.255.255.0 / 24,255.255.255.128 / 25,255.255.255.192 / 26,255.255.255.224 / 27,255.255.255.240 / 28,255.255.255.248 / 29,255.255.255.252 / 30,255.255.255.254 / 31,255.255.255.255 / 32' | grep -o'[0-9] \ {1,3 \}。[0-9] \ {1,3 \}。[0-9] \ {1,3 \}。[0-9] \ {1,3 \}'$ {NETSUB}''| cut -d'/' -  f1）“;
}

[[-n“$ GATE”]] && [[-n“$ MASK”]] && [[-n“$ IPv4”]] || {
echo“not found \`ip command \`，它将使用\`route command \`。”
ipNum（）{
  local IFS ='。';
  read ip1 ip2 ip3 ip4 <<<“$ 1”;
  echo $（（ip1 *（1 << 24）+ ip2 *（1 << 16）+ ip3 *（1 << 8）+ ip4））;
}

SelectMax（）{
II = 0;
对于`route -n | awk -v OUT = $ 1'{print $ OUT}'| grep'[0-9] \ {1,3 \}。[0-9] \ {1,3 \}中的IPITEM。 [0-9] \ {1,3 \}。[0-9] \ {1,3 \}'`
  做
    NumTMP =“$（ipNum $ IPITEM）”;
    eval“arrayNum [$ ii] ='$ NumTMP，$ IPITEM'”;
    II = $ [$ II + 1];
  DONE
echo $ {arrayNum [@]} | sed's / \ s / \ n / g'| sort -n -k 1 -t'，'| tail -n1 | cut -d'，' -  f2;
}

[[-z $ IPv4]] && IPv4 =“$（ifconfig | grep'Bcast'| head -n1 | grep -o'[0-9] \ {1,3 \}。[0-9] \ {1 ，3 \}。[0-9] \ {1,3 \}。[0-9] \ {1,3 \}'| head -n1）“;
[[-z $ GATE]] && GATE =“$（SelectMax 2）”;
[[-z $ MASK]] && MASK =“$（SelectMax 3）”;

[[-n“$ GATE”]] && [[-n“$ MASK”]] && [[-n“$ IPv4”]] || {
  echo“错误！不配置网络。”;
  1号出口;
}
}

[[“$ setNet”！='1']] && [[-f'/ etc / network / interfaces']] && {
  [[-z“$（sed -n'/ iface.*inet static / p'/ etc / network / interfaces）”]] && AutoNet ='1'|| AutoNet的= '0';
  [[-d /etc/network/interfaces.d]] && {
    ICFGN =“$（查找/etc/network/interfaces.d -name'* .cfg'| wc -l）”|| ICFGN = '0';
    [[“$ ICFGN”-ne'0']] && {
      对于NetCFG中的`ls -1 /etc/network/interfaces.d / * .cfg`
        做 
          [[-z“$（cat $ NetCFG | sed -n'/ iface.*inet static / p'）”]] && AutoNet ='1'|| AutoNet的= '0';
          [[“$ AutoNet”-eq'0']] && break;
        DONE
    }
  }
}

[[“$ setNet”！='1']] && [[-d'/ etc / sysconfig / network-scripts']] && {
  ICFGN =“$（查找/ etc / sysconfig / network-scripts -name'ifcfg- *'| grep -v'lo'| wc -l）”|| ICFGN = '0';
  [[“$ ICFGN”-ne'0']] && {
    对于NetCFG中的`ls -1 / etc / sysconfig / network-scripts / ifcfg- * | grep -v'lo $'| grep -v'：[0-9] \ {1，\}'`
      做 
        [[-n“$（cat $ NetCFG | sed -n'/ BOOTPROTO.* [dD] [hH] [cC] [pP] / p'）”]] && AutoNet ='1'|| {
          AutoNet ='0'&&。$ netcfg中;
          [[-n $ NETMASK]] && MASK =“$ NETMASK”;
          [[-n $ GATEWAY]] && GATE =“$ GATEWAY”;
        }
        [[“$ AutoNet”-eq'0']] && break;
      DONE
  }
}

[[！-f $ GRUBDIR / $ GRUBFILE]] && echo“错误！未找到$ GRUBFILE。”&&退出1;

[[！-f $ GRUBDIR / $ GRUBFILE.old]] && [[-f $ GRUBDIR / $ GRUBFILE.bak]] && mv -f $ GRUBDIR / $ GRUBFILE.bak $ GRUBDIR / $ GRUBFILE.old;
mv -f $ GRUBDIR / $ GRUBFILE $ GRUBDIR / $ GRUBFILE.bak;
[[-f $ GRUBDIR / $ GRUBFILE.old]] && cat $ GRUBDIR / $ GRUBFILE.old> $ GRUBDIR / $ GRUBFILE || cat $ GRUBDIR / $ GRUBFILE.bak> $ GRUBDIR / $ GRUBFILE;

[[“$ GRUBOLD”=='0']] && {
  READGRUB = '/ TMP / grub.read'
  cat $ GRUBDIR / $ GRUBFILE | sed -n'1h; 1！H; $ g; s / \ n / +++ / g; $ p'| grep -oPm 1'menuentry \。* \ {。* \} \ + \ + \ +'| sed's / \ + \ + \ + / \ n / g'> $ READGRUB
  LoadNum =“$（cat $ READGRUB | grep -c'menuentry'）”
  if [[“$ LoadNum”-eq'1']]; 然后
    cat $ READGRUB | sed'/ ^ $ / d'> /tmp/grub.new;
  elif [[“$ LoadNum”-gt'1']]; 然后
    CFG0 =“$（awk'/ menuentry / {print NR}'$ READGRUB | head -n 1）”;
    CFG2 =“$（awk'/ menuentry / {print NR}'$ READGRUB | head -n 2 | tail -n 1）”;
    CFG1 = “”;
    对于'awk'/} / {print NR}'$ READGRUB`中的tmpCFG
      做
        [“$ tmpCFG”-gt“$ CFG0”-a“$ tmpCFG”-lt“$ CFG2”] && CFG1 =“$ tmpCFG”;
      DONE
    [[-z“$ CFG1”]] && {
      echo“错误！读取$ GRUBFILE。”;
      1号出口;
    }

    sed -n“$ CFG0，$ CFG1”p $ READGRUB> /tmp/grub.new;
    [[-f /tmp/grub.new]] && [[“$（grep -c'{'/ tmp / grub.new）” -  eq“$（grep -c'}'/ tmp / grub.new） “]] || {
      echo -ne“\ 033 [31mError！\ 033 [0mNot configure $ GRUBFILE。\ n”;
      1号出口;
    }
  科幻
  [！-f /tmp/grub.new] && echo“错误！$ GRUBFILE。”&&退出1;
  sed -i“/ menuentry。* / c \ menuentry \ \'安装OS \ [$ DIST \ $ VER \] \'\ --class debian \ --class \ gnu-linux \ --class \ gnu \  - class \ os \ \ {“/ tmp / grub.new
  sed -i“/echo.*Loading/d”/tmp/grub.new;
}

[[“$ GRUBOLD”=='1']] && {
  CFG0 =“$（awk'/ title / {print NR}'$ GRUBDIR / $ GRUBFILE | head -n 1）”;
  CFG1 =“$（awk'/ title / {print NR}'$ GRUBDIR / $ GRUBFILE | head -n 2 | tail -n 1）”;
  [[-n $ CFG0]] && [-z $ CFG1 -o $ CFG1 == $ CFG0] && sed -n“$ CFG0，$”p $ GRUBDIR / $ GRUBFILE> /tmp/grub.new;
  [[-n $ CFG0]] && [-z $ CFG1 -o $ CFG1！= $ CFG0] && sed -n“$ CFG0，$ CFG1”p $ GRUBDIR / $ GRUBFILE> /tmp/grub.new;
  [[！-f /tmp/grub.new]] && echo“错误！配置附加$ GRUBFILE。”&&退出1;
  sed -i“/ title。* / c \ title \ \''安装OS \ [$ DIST \ $ VER \] \'”/ tmp / grub.new;
  sed -i'/ ^＃/ d'/ tmp / grub.new;
}

[[-n“$（grep'linux。* / \ | kernel。* /'/ tmp / grub.new | awk'{print $ 2}'| tail -n 1 | grep'^ / boot /'）”] ] && Type ='InBoot'|| 类型= 'NOBOOT';

LinuxKernel =“$（grep'linux。* / \ | kernel。* /'/ tmp / grub.new | awk'{print $ 1}'| head -n 1）”;
[[-z“$ LinuxKernel”]] && echo“错误！读取grub config！”&&退出1;
LinuxIMG =“$（grep'initrd。* /'/ tmp / grub.new | awk'{print $ 1}'| tail -n 1）”;
[-z“$ LinuxIMG”] && sed -i“/ $ LinuxKernel。* \ // a \\\ tinitrd \ \ /”/tmp/grub.new&&LinuxIMG ='initrd';

[[“$ Type”=='InBoot']] && {
  sed -i“/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/boot\/linux auto = true hostname = $ linuxdists domain =  -  quiet”/tmp/grub.new;
  sed -i“/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/boot\/initrd.gz”/tmp/grub.new;
}

[[“$ Type”=='NoBoot']] && {
  sed -i“/$LinuxKernel.*\//c\\\t$LinuxKernel\\t\/linux auto = true hostname = $ linuxdists domain =  -  quiet”/tmp/grub.new;
  sed -i“/$LinuxIMG.*\//c\\\t$LinuxIMG\\t\/initrd.gz”/tmp/grub.new;
}

sed -i'$ a \\ n'/tmp/grub.new;

[[“$ inVNC”=='n']] && {
GRUBPATCH = '0';

[-f'/ etc / network / interfaces'-o -d'/ etc / sysconfig / network-scripts'] || {
  echo“错误，未找到接口配置。”;
  1号出口;
}

INSERTGRUB =“$（awk'/ menuentry / {print NR}'$ GRUBDIR / $ GRUBFILE | head -n 1）”
sed -i''$ {INSERTGRUB}'i \\ n'$ GRUBDIR / $ GRUBFILE;
sed -i''$ {INSERTGRUB}'r /tmp/grub.new'$ GRUBDIR / $ GRUBFILE;
[[-f $ GRUBDIR / grubenv]] && sed -i's / saved_entry /＃saved_entry / g'$ GRUBDIR / grubenv;

[[-d / boot / tmp]] && rm -rf / boot / tmp;
mkdir -p / boot / tmp;
cd / boot / tmp;
gzip -d <../initrd.gz | cpio --extract --verbose --make-directories --no-absolute-filenames >> / dev / null 2>＆1

cat> /boot/tmp/preseed.cfg <'/boot/tmp/net.tmp';
}
WinNoDHCP（）{
  echo -ne“@回声OFF \ r \ NCD \ 056 \ 076 \ 045windir \ 045 \ GetAdmin \ r \ n如果\ 040exist \ 040 \ 045windir \ 045 \ GetAdmin \ 040 \ 050del \ 040 \ 057f \ 040 \ 057q \ 040 \ 042 \ 045windir \ 045 \ GetAdmin \ 042 \ 051 \ 040else \ 040 \ 050 \ r \尼哥\ 040CreateObject ^ \ 050 \ 042Shell \ 056Application \ 042 ^ \ 051 \ 056ShellExecute \ 040 \ 042 \ 045〜S0 \ 042 \ 054 \ 040 \ 042 \ 045 \ 052 \ 042 \ 054 \ 040 \ 042 \ 042 \ 054 \ 040 \ 042runas \ 042 \ 054 \ 040 \ 061 \ 040 \ 076 \ 076 \ 040 \ 042 \ 045temp \ 045 \管理员\ 056vbs \ 042 \ r \ n \ 042 \ 045temp \ 045 \管理员\ 056vbs \ 042 \ r \ NdeI位\ 040 \ 057f \ 040 \ 057q \ 040 \ 042 \ 045temp \ 045 \管理员\ 056vbs \ 042 \ r \ n退出\ 040 \ 057b \ 040 \ 062 \ 051 \ r \ n对于\ 040 \ 057f \ 040 \ 042tokens = \ 063 \ 052 \ 042 \ 040 \ 045 \ 045i \ 040in \ 040 \ 050 \ 047netsh \ 040interface \ 040show \ 040interface \ 040 ^ |更多\ 040 + 3 \ 040 ^ | FINDSTR \ 040 \ 057R \ 040 \ 042 \ u672c \ u5730 \ 056 \ 052 \ 040 \ u4ee5 \ u592a \ 056 \ 052 \ 040Local \ 056 \ 052 \ 040Ethernet \ 042 \ 047 \ 051 \ 040do \ 040 \ 050set \ 040EthName = \ 045 \ 045j \ 051 \ r \ nnetsh \ 040-C \ 040interface \ 040ip \ 040set \ 040address \ 040name =\ 042 \ 045EthName \ 045 \ 042 \ 040source =静态\ 040address = $的IPv4 \ 040mask = $ MASK \ 040gateway = $ GATE \ r \ nnetsh \ 040-C \ 040interface \ 040ip \ 040add \ 040dnsservers \ 040name = \ 042 \ 045EthName \ 045 \ 042 \ 040address = \ 070 \ 056 \ 070 \ 056 \ 070 \ 056 \ 070 \ 040index = 1 \ 040validate =无\ r \ nnetsh \ 040-C \ 040interface \ 040ip \ 040add \ 040dnsservers \ 040name = \ 042 \ 045EthName \ 045 \ 042 \ 040address = \ 070 \ 056 \ 070 \ 056 \ 064 \ 056 \ 064 \ 040index = 2 \ 040validate =无\ r \ NCD \ 040 \ 057d \ 040 \ 042 \ 045ProgramData \ 045 \ 057Microsoft \ 057Windows \ 057Start \ 040Menu \ 057Programs \ 057Startup \ 042 \ r \ ndel \ 040 \ 057f \ 040 \ 057q \ 040net \ 056bat \ r \ n \ r \ n“>'/ boot / tmp / net.tmp';
}
  [[“$ setNet”=='1']] && WinNoDHCP;
  [[“$ setNet”=='0']] && {
    [[“$ AutoNet”-eq'1']] && WinDHCP;
    [[“$ AutoNet”-eq'0']] && WinNoDHCP;
  }
  iconv -f'UTF-8'-t'GBK''/ boot / tmp / net.tmp'-o'/ boot / tmp / net.bat'
  rm -rf'/ boot / tmp / net.tmp'
  echo“$ DDURL”| grep -q'^ https：//'
  [[$？-eq'0']] && {
    echo -ne'\ n添加ssl支持... \ n'
    [[-n $ SSL_SUPPORT]] && {
      wget --no-check-certificate -qO-“$ SSL_SUPPORT”| tar -x
      [[！-f / boot / tmp / usr / bin / wget]] && echo'错误！SSL_SUPPORT“。&&退出1;
      sed -i's / wget \ -qO  -  / \ / usr \ / bin \ / wget \ --no-check-certificate \ --retry-connrefused \ --tries = 7 \ --continue \ -qO- / g'/boot/tmp/preseed.cfg
      [[$？-eq'0']] && echo -ne'成功！\ n \ n”
    } || {
    echo -ne'不是ssl支持包！\ n \ n';
    1号出口;
    }
  }
}

[[“$ ddMode”=='0']] && {
  sed -i'/ anna-install / d'/ boot / tmp / preseed.cfg
  sed -i's / wget。* \ / sbin \ / reboot \; \ // g'/ boot / tmp / preseed.cfg
}
[[“$ INCFW”=='1']] && [[“$ linuxdists”=='debian']] && [[-f'/ boot/firmware.cpio.gz']] && {
  gzip -d <../firmware.cpio.gz | cpio --extract --verbose --make-directories --no-absolute-filenames >> / dev / null 2>＆1
}
rm -rf ../initrd.gz;
找 。| cpio -H newc --create --verbose | gzip -9> ../initrd.gz;
rm -rf / boot / tmp;
}

[[“$ inVNC”=='y']] && {
  sed -i'$ i \\ n'$ GRUBDIR / $ GRUBFILE
  sed -i'$ r /tmp/grub.new'$ GRUBDIR / $ GRUBFILE
  echo -e“\ n \ 033 [33m \ 033 [04m它会重启！\ n请看看VNC！\ n选择\ 033 [0m \ 033 [32m安装操作系统[$ DIST $ VER] \ 033 [33m \ 033 [4mto install]系统。\ 033 [04m \ n \ n \ 033 [31m \ 033 [04m]有一些信息可供你使用。\ n关闭窗口！\ 033 [0m \ n“
  echo -e“\ 033 [35mIPv4 \ t \ tNETMASK \ t \ tGATEWAY \ 033 [0m”
  echo -e“\ 033 [36m \ 033 [04m $ IPv4 \ 033 [0m \ t \ 033 [36m \ 033] [04m $ MASK \ 033 [0m \ t \ 033 [36m \ 033] [04m $ GATE \ 033 [0m] \ n \ n”

  读-n 1 -p“按Enter重启...”INP
  [[“$ INP”！='']] && echo -ne'\ b \ n \ n';
}

chown root：root $ GRUBDIR / $ GRUBFILE
chmod 444 $ GRUBDIR / $ GRUBFILE

sleep 3 && reboot> / dev / null 2>＆1

注意事项： 在安装Ubuntu的时，可能会遇到： Getting the time form a network time server... 界面进度条很长时间不会动，可以等待它超时或者更换别的版本。该问题是Ubuntu的系统的问题。

 最后修改：2019年02月19日12:32 PM

```


###


```yml


```


### [解决方案]如何将Windows Server（2003/2008 / 2012/2016 / XP / 7/8/10）重装到Linux服务器（CentOS / Debian / Ubuntu）


```yml

https://tech.cxthhhhh.com/windows/2018/09/01/solution-how-to-reinstall-windows-server-2003-2008-2012-2016-xp-7-8-10-to-linux-server-centos-debian-ubuntu-other-cn.html

[解决方案]如何将Windows Server（2003/2008 / 2012/2016 / XP / 7/8/10）重装到Linux服务器（CentOS / Debian / Ubuntu）
 2018年9月1日  0条评论  73758次阅读  3个人点赞
简介
有时，我们无法在服务提供商的控制面板中将Windwos Server服务器重新安装为L​​inux服务器。

我们尝试发送支持票，服务提供商告诉我们由于许可证价格的差异而不支持替换。我们只能找到一种手动解决方法。

今天，我将演示四种方法来帮助您在服务器上成功安装Windows Linux。我在阿里云和一些KVM机器上进行了测试。如果您正在寻找这样的解决方案，请来试试吧。

如果您来自英语社区，请单击此处。

有时候，我们的无法在服务商的控制面板将Windwos Server服务器重装为Linux Server。

我们尝试发送支持票据，服务商告诉我们因为授权价格差异，不支持更换。我们只能想办法手动解决。

今天，我将演示通过四种方式，来帮助你成功的在服务器上将Windows安装为Linux。我在阿里巴巴云，以及一些KVM机器中完成测试。如果你正在寻找这样的方案，赶快来试试吧。

准备工作
一台装有Windows的服务器/具有互联网接入/有控制台（VNC / KVM）操作权限/或者具有恢复模式

请注意，以下四种方案均通过测试，因此绝大部分的机器都可以通过以下四种方式进行操作。（你应该测试哪一种方案适合你）

让我们开始
1.解决方案一（通过服务商提供的恢复模式）：
①。首先在服务商面板选择并进入恢复模式

你将会收到一个包含有SSH / RDP连接信息的提示/邮件，通过这些信息，你可以访问到恢复模式，用来管理和操作你的服务器。
（解决方案一主要针对收到SSH连接信息的恢复模式，如果收到的是RDP信息，请查看解决方案二/解决方案三/解决方案四）

②。检查磁盘信息

查看你想安装到的磁盘，输入以下命令。（你的磁盘可能是以下名称VDA / VDB / SDA / SDB /等等，请修改下面命令中的VDA为您的磁盘）
fdisk -l

③。执行以下的DD系统命令，进行一键安装最新的系统（你需要使用你自己的DD镜像，我提供了一个最新的CentOS7.X镜像）

wget -qO- https://opendisk.cxthhhhh.com/OperatingSystem/CentOS/CentOS_7.X_NetInstall_AutoPartition.vhd.gz | gunzip -dc | dd of=/dev/vda

④。执行完毕重启计算机，等待15-45分钟，通过IP：22进行SSH连接（上述CentOS7安装后的默认密码为cxthhhhh.com）。

*提示信息：这里有两个DD安装系统的教程来源，你可以参考（文件托管于Open Disk CDN）。
[原创]一键网络重装CentOS 7（官方，纯净，安全，高效）
[Linux VPS] Debian / Ubuntu / CentOS网络安装/重装系统/纯净安装一键脚本

2.解决方案二（通过官方提供的Debian-Installer Loader中转安装Linux）
①。在Windows系统中下载Debian-Installer Loader硬盘安装器（文件托管于Open Disk CDN）

Debian-Installer硬盘安装器下载：https://opendisk.cxthhhhh.com/OperatingSystem/Debian/Debian-install-Windows.exe

②。通过Debian-Installer Loader安装Debian系统（按照程序提示，这是Debian官方提供的方案）

以下是安装预览图片（独立服务器的话，你需要去主板设置关闭安全启动安全启动）

“[解决方案]如何将Windows Server（2003/2008 / 2012/2016 / XP / 7/8/10）重装到Linux服务器（CentOS / Debian / Ubuntu）”

③。通过VNC / KVM界面开机选择安装的Debian，进行一步步的手动安装操作（无需SSH，请在VNC / SSH下操作）。

④。等待的Debian安装完毕，启动Debian的。

（你已经完成的Debian的安装，但是的Windows系统也同时存在硬盘上，所以建议再次通过DD方式重新安装的Linux系统，使得所有磁盘空间可用）

3.解决方案三（通过UNetbootin安装方案）
①。在Windows系统中下载UNetbootin安装器（文件托管于Open Disk CDN）

UNetbootin下载：https://opendisk.cxthhhhh.com/Software/UNetbootin/UNetbootin-Windows-661.exe

②。通过UNetbootin安装的Linux发行版系统（我将使用的CentOS来演示操作）

以下是安装预览图片（独立服务器的话，你需要去主板设置关闭安全启动安全启动）

“[解决方案]如何将Windows Server（2003/2008 / 2012/2016 / XP / 7/8/10）重装到Linux服务器（CentOS / Debian / Ubuntu）”

*提示信息：你也可以选择一个你已经下载好的任意的Linux发行版ISO光盘镜像进行安装（第一步选择ISO镜像即可，不使用在线安装）

③。通过VNC / KVM界面开机选择启动UNetbootin引导，进行一步步的手动安装的Linux的操作即可（无需SSH，请在VNC / SSH下操作）。

④。手动安装完毕，重启计算机，你的视窗系统就成功的安装到了Linux操作系统。

（任选）如果不放心，你可以在当前已经安装好的Linux下再次通过第一种解决方案DD安装新的纯净Linux系统。
（已经有Grub引导了，此时你也手动安装其他Linux发行版）

4.解决方案四（通过Deepin引导方案）：
①。在Windows系统中下载Deepin操作系统和Deepin硬盘安装器（文件托管于Open Disk CDN）

Deepin系统下载：https://opendisk.cxthhhhh.com/OperatingSystem/Deepin/deepin-15.7-amd64.iso
Deepin硬盘安装器下载：https://opendisk.cxthhhhh.com/OperatingSystem/Deepin/deepin-system-installer.exe

②。通过deepin硬盘安装器安装Deepin系统（将安装器和ISO镜像放在同一个目录下）

以下是安装预览图片（独立服务器的话，你需要去主板设置关闭安全启动安全启动）

“[解决方案]如何将Windows Server（2003/2008 / 2012/2016 / XP / 7/8/10）重装到Linux服务器（CentOS / Debian / Ubuntu）”

③。通过VNC / KVM界面开机选择安装Deepin，进行一步步的手动安装操作（无需SSH，请在VNC / SSH下操作）。

④。等待Deepin安装完毕，启动Deepin，然后在Deepin下通过第一种解决方案DD安装新的Linux的系统

（任选）如果不放心，你可以在当前已经安装好的Linux下再次通过第一种解决方案DD安装新的纯净Linux系统。
（已经有Grub引导了，此时你也手动安装其他Linux发行版）

非常棒，现在你已经掌握四种方案成功的将的Windows重装为Linux的
参考文献：

DebianInstaller / Loader - Debian Wiki
你们要的运转的Linux
从视窗到Linux的
[技术博客| 技术博客]的Telegram交流频道：https：//t.me/me_share(TG讨论组群请关注TG频道置顶消息）

这篇文章发表在[CXT]技术博客| 技术博客，如果您需要转发分享，请注明出处。

[解决方案]如何将Windows Server（2003/2008 / 2012/2016 / XP / 7/8/10）重装到Linux服务器（CentOS / Debian / Ubuntu）

```


###


```yml


```


###


```yml


```

