
https://tech.cxthhhhh.com/linux/2018/11/29/original-one-click-network-reinstall-system-magic-modify-version-for-linux-windows-cn.html

[原创] 一键网络重装系统 - 魔改版（适用于Linux / Windows）
 2018-11-29  0条评论  93,927次阅读  40人点赞
简介
When we need to reinstall the VPS/cloud platform/Dedicated Servers operating system, it can usually be reinstalled through the service provider template and ISO mount.

Starting today, you will have a completely new way to install a clean operating system with one click of the network, without CD-ROM, without VNC/IPIM/KVM.

Both Linux and Windows can be installed in one click on the network, opening up a wonderful experience with a simple two-line command.

One-click Network Reinstall System – Magic Modify version, Forked from MoeClub Vicer, technical support and maintenance provided by Technical Blog | 技術博客, more features of the magic version are constantly increasing.

If you are from an English community, please click here.

当我们需要重装VPS/云平台/独立服务器操作系统时，通常可以通过服务商模板和ISO挂载的方式重新安装。

从今天开始，你将拥有了一个全新的方式，通过网络一键式重新安装纯净操作系统，无需CD-ROM,无需VNC/IPIM/KVM。

无论是Linux，还是Windows，都可以通过网络一键式完成安装，通过简单的两行命令开启美妙的体验。

一键网络重装系统 – 魔改版，从萌咖Vicer进行分支，由Technical Blog | 技術博客提供技术支持和维护，魔改版更多功能不断增加中。

现实需求
为什么我们需要重装纯净系统？

1. 服务商提供的系统模板可能会内置一些软件，甚至和我们即将安装的软件产生冲突，导致安装失败。

2. ISO挂载并不是所有服务商都提供的服务，一些IPIM/KVM传输速度过于缓慢，安装效率较差。

3. Linux/Windows在使用中可能遇到一些找不到问题的莫名错误。相信你一定深有体会！

你需要了解
1. 所有系统安装完毕的默认密码是[cxthhhhh.com]，为了防止暴力破解，你必须在安装完毕立刻修改默认密码！

2. 因硬件配置和网络环境不同，安装全程需要15-60分钟，请耐心等待。安装完成即可通过IP:22(Linux SSH)/IP:3389(Windows RDP)进行连接。

3. 为了稳定性和安全性，我建议所有网站管理员/开发者/公司使用最新的系统，同时我只为最新的系统提供技术支持。

4. 所有镜像托管于Open Disk CDN，你应该访问以下文章了解镜像，使用时应校对MD5和SHA1是否正确。

[原创] Windows系统DD磁盘(VHD)映像(添加驱动程序Virtio,Xen,Hyper)(独立服务器+全虚拟化支持)

5. 一些没有DHCP的VPS/云平台/独立服务器，安装后无法访问网络，你需要登陆VNC/IPIM/KVM后手动进行网卡IP配置。

6. 源码安全，并托管在Github：

https://github.com/MeowLove/Network-Reinstall-System-Modify

重装系统前环境需求
1. 当前已安装任意由GRUB or GRUB2引导Linux系统(RedHat/CentOS/Debian/Ubuntu/Etc.)

2. 安装重装系统的前提组件

①. RedHat/CentOS:
yum install -y xz openssl gawk file

②. Debian/Ubuntu:
apt-get install -y xz-utils openssl gawk file

让我们开始吧
1. 下载SHELL脚本（通过root用户运行）
wget --no-check-certificate -qO ~/Network-Reinstall-System-Modify.sh 'https://tech.cxthhhhh.com/tech-tools/Network-Reinstall-System-Modify/Network-Reinstall-System-Modify.sh' && chmod a+x ~/Network-Reinstall-System-Modify.sh

2. 安装系统（任选其一）
【安装Linux系统】

①. 一键网络重装纯净CentOS 7（推荐）
bash ~/Network-Reinstall-System-Modify.sh -CentOS_7

②. 一键网络重装纯净CentOS 6
bash ~/Network-Reinstall-System-Modify.sh -CentOS_6

③. 一键网络重装纯净Debian 9（推荐）
bash ~/Network-Reinstall-System-Modify.sh -Debian_9

④. 一键网络重装纯净Debian 8
bash ~/Network-Reinstall-System-Modify.sh -Debian_8

⑤. 一键网络重装纯净Debian 7
bash ~/Network-Reinstall-System-Modify.sh -Debian_7

⑥. 一键网络重装纯净Ubuntu 18.04（推荐）
bash ~/Network-Reinstall-System-Modify.sh -Ubuntu_18.04

⑦. 一键网络重装纯净Ubuntu 16.04
bash ~/Network-Reinstall-System-Modify.sh -Ubuntu_16.04

⑧. 一键网络重装纯净Ubuntu 14.04
bash ~/Network-Reinstall-System-Modify.sh -Ubuntu_14.04

【安装Windows系统】

*警告：你需要购买来自Microsoft或其合作伙伴正版系统授权并激活系统使用。继续安装即代表您知悉并已经购买正版授权。

①. 一键网络重装纯净Windows Server 2019（推荐）
bash ~/Network-Reinstall-System-Modify.sh -Windows_Server_2019

②. 一键网络重装纯净Windows Server 2016
bash ~/Network-Reinstall-System-Modify.sh -Windows_Server_2016

③. 一键网络重装纯净Windows Server 2012 R2
bash ~/Network-Reinstall-System-Modify.sh -Windows_Server_2012R2

④. 一键网络重装纯净Windows Server 2008 R2
bash ~/Network-Reinstall-System-Modify.sh -Windows_Server_2008R2

⑤. 一键网络重装纯净Windows 7 Vienna
bash ~/Network-Reinstall-System-Modify.sh -Windows_7_Vienna

⑥. 一键网络重装纯净Windows Server 2003
bash ~/Network-Reinstall-System-Modify.sh -Windows_Server_2003

【安装裸机系统部署平台】

*仅适用于高端用户，手动安装任意系统。可通过网络ISO或iPXE安装任意系统。(使用教程即将发布)

bash ~/Network-Reinstall-System-Modify.sh -CXT_Bare-metal_System_Deployment_Platform

[原创] 裸机系统部署平台：VNC自定义安装任何系统（适用于Linux / Windows）[一键网络重装系统 – 魔改版]

【安装DD系统】

*如果您不了解这意味着什么，请不要进行操作。%ULR%应该替换为您自己的映像地址。

bash ~/Network-Reinstall-System-Modify.sh -DD "%URL%"

恭喜，你已经完成了系统重装，享受当下的美好
当您执行完上面的2行命令，你的服务器将开始网络重装纯净系统。在完成安装前，您将无法进行连接管理。

因硬件配置和网络环境不同，安装全程需要15-60分钟，请耐心等待。安装完成即可通过IP:22(Linux SSH)/IP:3389(Windows RDP)进行连接。

[Technical Blog | 技術博客] 的联络方式：[Telegram 频道：My Share] [Telegram 组群：Technical Blog | 技術博客]

这篇文章发表在[CXT] Technical Blog | 技術博客，如果您需要转发分享，请注明出处。

[原创] 一键网络重装系统 – 魔改版（适用于Linux / Windows）


https://tech.cxthhhhh.com/linux/2018/07/31/original-network-one-click-reinstall-centos-7-official-pure-safe-efficient-cn.html


[原创] 一键网络重装CentOS 7 （官方，纯净，安全，高效）
 2018-07-31  1条评论  272,008次阅读  52人点赞
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


https://tech.cxthhhhh.com/linux/2018/08/12/original-a-complete-solution-for-new-servers-buy-installation-site-environment-configuration-network-and-system-optimization-full-backup-and-restore-migration-desktop-environment-tools-cn.html

[原创] 一套完整解决方案为新服务器（系统安装、建站环境配置、网络和系统优化、完整备份还原迁移、桌面环境、工具合集）
 2018-08-12  1条评论  169,003次阅读  43人点赞
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

