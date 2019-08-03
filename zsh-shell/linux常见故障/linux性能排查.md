## linux性能排查



## 

```yml
技巧：
一、使用top命令查看负载，在top下按“1”查看CPU核心数量，shift+"p"按cpu使用率大小排序，shift+"m"按内存使用率高低排序；


```


## 常用命令

```yml



```


## 

```yml



```

## linux服务器性能查看
```yml
https://blog.csdn.net/achenyuan/article/details/78974729

linux服务器性能查看
                                                                                                                        2018年01月04日 20:04:02                     陈袁                     阅读数 12278                                     
                                    
1.1 cpu性能查看
1、查看物理cpu个数：
cat /proc/cpuinfo |grep "physical id"|sort|uniq|wc -l
2、查看每个物理cpu中的core个数：
cat /proc/cpuinfo |grep "cpu cores"|wc -l
3、逻辑cpu的个数：
cat /proc/cpuinfo |grep "processor"|wc -l
物理cpu个数*核数=逻辑cpu个数（不支持超线程技术的情况下）
1.2 内存查看
1、查看内存使用情况：
#free -m
             total       used       free     shared    buffers     cached
Mem:          3949       2519       1430          0        189       1619
-/+ buffers/cache:        710       3239
Swap:         3576          0       3576
 
total：内存总数
used：已经使用的内存数
free：空闲内存数
shared：多个进程共享的内存总额
- buffers/cache：(已用)的内存数，即used-buffers-cached
+ buffers/cache：(可用)的内存数，即free+buffers+cached
 
Buffer Cache用于针对磁盘块的读写；
Page Cache用于针对文件inode的读写，这些Cache能有效地缩短I/O系统调用的时间。
 
 
对操作系统来说free/used是系统可用/占用的内存；
对应用程序来说-/+ buffers/cache是可用/占用内存,因为buffers/cache很快就会被使用。
我们工作时候应该从应用角度来看。
1.3 硬盘查看
1、查看硬盘及分区信息：
fdisk -l
2、查看文件系统的磁盘空间占用情况：
df -h
3、查看硬盘的I/O性能（每隔一秒显示一次，显示5次）：
iostat -x 1 5
iostat是含在套装systat中的,可以用yum -y install systat来安装。
常关注的参数：
如%util接近100%,说明产生的I/O请求太多，I/O系统已经满负荷，该磁盘可能存在瓶颈。
如idle小于70%，I/O的压力就比较大了，说明读取进程中有较多的wait。
4、查看linux系统中某目录的大小：
du -sh /root
如发现某个分区空间接近用完，可以进入该分区的挂载点，用以下命令找出占用空间最多的文件或目录，然后按照从大到小的顺序，找出系统中占用最多空间的前10个文件或目录：
du -cksh *|sort -rn|head -n 10
1.4 查看平均负载
有时候系统响应很慢，但又找不到原因，这时就要查看平均负载了，看它是否有大量的进程在排队等待。
load average:平均负载
平均负载(load average)是指系统的运行队列的平均利用率，也可以认为是可运行进程的平均数。
以路况为例， 单核CPU、单车道 情况如下：
0.00-1.00 之间的数字表示此时路况非常良好，没有拥堵，车辆可以毫无阻碍地通过。
1.00 表示道路还算正常，但有可能会恶化并造成拥堵。此时系统已经没有多余的资源了，管理员需要进行优化。
1.00-*** 表示路况不太好了，如果到达2.00表示有桥上车辆一倍数目的车辆正在等待。这种情况你必须进行检查了。
多核CPU - 多车道 情况如下：
多核CPU的话，满负荷状态的数字为 "1.00 * CPU核数"，即双核CPU为2.00，四核CPU为4.00。 
 
一般的进程需要消耗CPU、内存、磁盘I/O、网络I/O等资源，在这种情况下，平均负载就不是单独指的CPU使用情况。即内存、磁盘、网络等因素也可以影响系统的平均负载值。 
在单核处理器中，平均负载值为1或者小于1的时候，系统处理进程会非常轻松，即负载很低。当达到3的时候，就会显得很忙，达到5或者8的时候就不能很好的处理进程了（其中5和8目前还是个争议的阈值，为了保守起见，建议选择低的）。
查看load average 数据
下面几个命令都可以看到 load average
# top 
# uptime 
# w
截图如下：
 
top 命令的
 
uptime 命令的
w 命令的
 
这里的 load average 的三个值分别指系统在最后 1/5/15分钟 的平均负载值。
根据经验：我们应该把重点放在5/15分钟的平均负载，因为1分钟的平均负载太频繁，一瞬间的高并发就会导致该值的大幅度改变。

1.5 vmstat命令来判断系统是否繁忙
还可以结合vmstat命令来判断系统是否繁忙，其中：
procs
r：等待运行的进程数。
b：处在非中断睡眠状态的进程数。
w：被交换出去的可运行的进程数。
 
memeory
swpd：虚拟内存使用情况，单位为KB。
free：空闲的内存，单位为KB。
buff：被用来作为缓存的内存数，单位为KB。
 
swap
si：从磁盘交换到内存的交换页数量，单位为KB。
so：从内存交换到磁盘的交换页数量，单位为KB。
 
io
bi：发送到块设备的块数，单位为KB。
bo：从块设备接受的块数，单位为KB。
 
system
in：每秒的中断数，包括时钟中断。
cs：每秒的环境切换次数。
 
cpu
按cpu的总使用百分比来显示。
us：cpu使用时间。
sy：cpu系统使用时间。
id：闲置时间。

1.6Linux下可使用 nethogs 工具查看进程流量
1.7其他参数
查看内核版本号：
uname -a
 
简化命令：uname -r
 
查看系统是32位还是64位的：
file /sbin/init
 
查看发行版：
cat /etc/issue
或lsb_release -a
 
查看系统已载入的相关模块：
lsmod
 
查看pci设置：
lspci



2.1.3 系统性能分析工具
1.常用系统命令
Vmstat、sar、iostat、netstat、free、ps、top等
2.常用组合方式
vmstat、sar、iostat检测是否是CPU瓶颈
free、vmstat检测是否是内存瓶颈
iostat检测是否是磁盘I/O瓶颈
netstat检测是否是网络带宽瓶颈
2.1.4 Linux性能评估与优化
系统整体性能评估（uptime命令）
uptime
16:38:00 up 118 days, 3:01, 5 users,load average: 1.22, 1.02, 0.91
注意：
load average三值大小一般不能大于系统CPU的个数。
系统有8个CPU,如load average三值长期大于8，说明CPU很繁忙，负载很高，可能会影响系统性能。
但偶尔大于8，一般不会影响系统性能。
如load average输出值小于CPU个数，则表示CPU有空闲时间片，比如本例中的输出，CPU是非常空闲的
2.2.1 CPU性能评估
1.利用vmstat命令监控系统CPU
显示系统各种资源之间相关性能简要信息，主要看CPU负载情况。
下面是vmstat命令在某个系统的输出结果：
[root@node1 ~]#vmstat 2 3
 
procs
 ———–memory———- —swap– —–io—- –system– —–cpu——
 
r  b swpd freebuff  cache si so bi bo incs us sy idwa st
 
0  0 0 162240 8304 67032 0 0 13 21 1007 23 0 1 98 0 0
 
0  0 0 162240 8304 67032 0 0 1 0 1010 20 0 1 100 0 0
 
0  0 0 162240 8304 67032 0 0 1 1 1009 18 0 1 99 0 0
Procs
r--运行和等待cpu时间片的进程数，这个值如果长期大于系统CPU的个数，说明CPU不足，需要增加CPU
b--在等待资源的进程数，比如正在等待I/O、或者内存交换等。
CPU
us
用户进程消耗的CPU 时间百分比。
us的值比较高时，说明用户进程消耗的cpu时间多，但是如果长期大于50%，就需要考虑优化程序或算法。
sy
内核进程消耗的CPU时间百分比。Sy的值较高时，说明内核消耗的CPU资源很多。
根据经验，us+sy的参考值为80%，如果us+sy大于 80%说明可能存在CPU资源不足。
2.利用sar命令监控系统CPU
sar对系统每方面进行单独统计，但会增加系统开销，不过开销可以评估，对系统的统计结果不会有很大影响。
下面是sar命令对某个系统的CPU统计输出：
[root@webserver ~]# sar -u 3 5
 
Linux
 2.6.9-42.ELsmp (webserver) 11/28/2008_i686_
 (8 CPU)
 
11:41:24
 AM CPU %user %nice%system
 %iowait %steal %idle
 
11:41:27
 AM all 0.88 0.00 0.29 0.00 0.00 98.83
 
11:41:30
 AM all 0.13 0.00 0.17 0.21 0.00 99.50
 
11:41:33
 AM all 0.04 0.00 0.04 0.00 0.00 99.92
 
11:41:36
 AM all 90.08 0.00 0.13 0.16 0.00 9.63
 
11:41:39
 AM all 0.38 0.00 0.17 0.04 0.00 99.41
 
Average:
 all 0.34 0.00 0.16 0.05 0.00 99.45
输出解释如下：
%user列显示了用户进程消耗的CPU 时间百分比。
%nice列显示了运行正常进程所消耗的CPU 时间百分比。
%system列显示了系统进程消耗的CPU时间百分比。
%iowait列显示了IO等待所占用的CPU时间百分比
%steal列显示了在内存相对紧张的环境下pagein强制对不同的页面进行的steal操作 。
%idle列显示了CPU处在空闲状态的时间百分比。
问题
你是否遇到过系统CPU整体利用率不高，而应用缓慢的现象？
在一个多CPU的系统中，如果程序使用了单线程，会出现这么一个现象，CPU的整体使用率不高，但是系统应用却响应缓慢，这可能是由于程序使用单线程的原因，单线程只使用一个CPU，导致这个CPU占用率为100%，无法处理其它请求，而其它的CPU却闲置，这就导致了整体CPU使用率不高，而应用缓慢现象的发生。
2.3.1 内存性能评估
1.利用free指令监控内存
free是监控Linux内存使用状况最常用的指令，看下面的一个输出：
[root@webserver ~]# free -m
 
total
 used freeshared
 buffers cached
 
Mem:
 8111 7185 926 0 243 6299
 
 -/+
 buffers/cache:
 643 7468
 
Swap:
 8189 0 8189
经验公式：
应用程序可用内存/系统物理内存>70%，表示系统内存资源非常充足，不影响系统性能;
应用程序可用内存/系统物理内存<20%，表示系统内存资源紧缺，需要增加系统内存;
20%<应用程序可用内存/系统物理内存<70%，表示系统内存资源基本能满足应用需求，暂时不影响系统性能
2.利用vmstat命令监控内存
[root@node1
 ~]#
 vmstat 2 3
 
procs
 ———–memory———- —swap– —–io—- –system– —–cpu——
 
r b swpd freebuff cache si so bi bo incs us sy idwa st
 
0 0 0 162240 8304 67032 0 0 13 21 1007 23 0 1 98 0 0
 
0 0 0 162240 8304 67032 0 0 1 0 1010 20 0 1 100 0 0
 
0 0 0 162240 8304 67032 0 0 1 1 1009 18 0 1 99 0 0
memory
swpd--切换到内存交换区的内存数量（k为单位)。如swpd值偶尔非0，不影响系统性能
free--当前空闲的物理内存数量（k为单位）
buff--buffers cache的内存数量，一般对块设备的读写才需要缓冲
cache--page cached的内存数量
一般作为文件系统cached，频繁访问的文件都会被cached，如cache值较大，说明cached的文件数较多，如果此时IO中bi比较小，说明文件系统效率比较好。
swap
si--由磁盘调入内存，也就是内存进入内存交换区的数量。
so--由内存调入磁盘，也就是内存交换区进入内存的数量。
si、so的值长期不为0，表示系统内存不足。需增加系统内存。
2.4.1磁盘I/O性能评估
1.磁盘存储基础
频繁访问的文件或数据尽可能用内存读写代替直接磁盘I/O，效率高千倍。
将经常进行读写的文件与长期不变的文件独立出来，分别放置到不同的磁盘设备上。
对于写操作频繁的数据，可以考虑使用裸设备代替文件系统。
裸设备优点：
数据可直接读写，不需经过操作系统级缓存，节省内存资源，避免内存资源争用;
避免文件系统级维护开销，如文件系统需维护超级块、I-node等;
避免了操作系统cache预读功能，减少了I/O请求
使用裸设备的缺点是：
数据管理、空间管理不灵活，需要很专业的人来操作。
2.利用iostat评估磁盘性能
[root@webserver ~]# iostat -d 2 3
 
Linux
 2.6.9-42.ELsmp (webserver) 12/01/2008_i686_
 (8 CPU)
 
 
 
Device:
 tps Blk_read/sBlk_wrtn/sBlk_read
 Blk_wrtn
 
sda 1.87 2.58 114.12 6479462 286537372
 
 
 
Device:
 tps Blk_read/sBlk_wrtn/sBlk_read
 Blk_wrtn
 
sda
 0.00 0.00 0.00 0 0
 
 
Device:
 tps Blk_read/sBlk_wrtn/sBlk_read
 Blk_wrtn
 
sda
 1.00 0.00 12.00 0 24
解释如下：
Blk_read/s--每秒读取数据块数
Blk_wrtn/s--每秒写入数据块数
Blk_read--读取的所有块数
Blk_wrtn--写入的所有块数
可通过Blk_read/s和Blk_wrtn/s值对磁盘的读写性能有一个基本的了解.
如Blk_wrtn/s值很大，表示磁盘写操作频繁，考虑优化磁盘或程序，
如Blk_read/s值很大，表示磁盘直接读操作很多，可将读取的数据放入内存
规则遵循：
长期的、超大的数据读写，肯定是不正常的，这种情况一定会影响系统性能。
3.利用sar评估磁盘性能
通过“sar –d”组合，可以对系统的磁盘IO做一个基本的统计，请看下面的一个输出：
[root@webserver ~]# sar -d 2 3
 
Linux
 2.6.9-42.ELsmp (webserver) 11/30/2008_i686_
 (8 CPU)
 
11:09:33
 PM DEV tps rd_sec/swr_sec/savgrq-sz
 avgqu-sz await svctm %util
 
11:09:35
 PM dev8-0 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00
 
11:09:35
 PM DEV tps rd_sec/swr_sec/savgrq-sz
 avgqu-sz await svctm %util
 
11:09:37
 PM dev8-0 1.00 0.00 12.00 12.00 0.00 0.00 0.00 0.00
 
11:09:37
 PM DEV tps rd_sec/swr_sec/savgrq-sz
 avgqu-sz await svctm %util
 
11:09:39
 PM dev8-0 1.99 0.00 47.76 24.00 0.00 0.50 0.25 0.05
 
Average:
 DEV tps rd_sec/swr_sec/savgrq-sz
 avgqu-sz await svctm %util
 
Average:
 dev8-0 1.00 0.00 19.97 20.00 0.00 0.33 0.17 0.02
参数含义：
await--平均每次设备I/O操作等待时间（毫秒）
svctm--平均每次设备I/O操作的服务时间（毫秒）
%util--一秒中有百分之几的时间用于I/O操作
对磁盘IO性能评判标准：
正常svctm应小于await值，而svctm和磁盘性能有关，CPU、内存负荷也会对svctm值造成影响，过多的请求也会间接的导致svctm值的增加。
await值取决svctm和I/O队列长度以及I/O请求模式，
如果svctm的值与await很接近，表示几乎没有I/O等待，磁盘性能很好，
如果await的值远高于svctm的值，则表示I/O队列等待太长，系统上运行的应用程序将变慢，
此时可以通过更换更快的硬盘来解决问题。
%util--衡量磁盘I/O重要指标，
如%util接近100%，表示磁盘产生的I/O请求太多，I/O系统已经满负荷工作，该磁盘可能存在瓶颈。
可优化程序或者 通过更换 更高、更快的磁盘。
2.5.1. 网络性能评估
（1）通过ping命令检测网络的连通性
（2）通过netstat –i组合检测网络接口状况
（3）通过netstat –r组合检测系统的路由表信息
（4）通过sar –n组合显示系统的网络运行状态
三 Linux服务器性能调优
1.为磁盘I/O调整Linux内核电梯算法
选择文件系统后，该算法可以平衡低延迟需求，收集足够数据，有效组织对磁盘读写请求。
2.禁用不必要的守护进程，节省内存和CPU资源
许多守护进程或服务通常非必需，消耗宝贵内存和CPU时间。将服务器置于险地。
禁用可加快启动时间，释放内存。
 
减少CPU要处理的进程数
一些应被禁用的Linux守护进程，默认自动运行：
序号 守护进程 描述
1 Apmd 高级电源管理守护进程
2 Nfslock 用于NFS文件锁定
3 Isdn ISDN Moderm支持
4 Autofs 在后台自动挂载文件系统(如自动挂载CD-ROM)
5 Sendmail 邮件传输代理
6 Xfs X Window的字体服务器
3.关掉GUI
4、清理不需要的模块或功能
服务器软件包中太多被启动的功能或模块实际上是不需要的(如Apache中的许多功能模块)，禁用掉有助于提高系统内存可用量，腾出资源给那些真正需要的软件，让它们运行得更快。
5、禁用控制面板
在Linux中，有许多流行的控制面板，如Cpanel，Plesk，Webmin和phpMyAdmin等，禁用释放出大约120MB内存，内存使用量大约下降30-40%。
6、改善Linux Exim服务器性能
使用DNS缓存守护进程，可降低解析DNS记录需要的带宽和CPU时间，DNS缓存通过消除每次都从根节点开始查找DNS记录的需求，从而改善网络性能。
Djbdns是一个非常强大的DNS服务器，它具有DNS缓存功能，Djbdns比BIND DNS服务器更安全，性能更好，可以直接通过http://cr.yp.to/下载，或通过Red Hat提供的软件包获得。
7、使用AES256增强gpg文件加密安全
为提高备份文件或敏感信息安全，许多Linux系统管理员都使用gpg进行加密，在使用gpg时，最好指定gpg使用AES256加密算法，AES256使用256位密钥，它是一个开放的加密算法，美国国家安全局(NSA)使用它保护绝密信息。
8、远程备份服务安全
安全是选择远程备份服务最重要的因素，大多数系统管理员都害怕两件事：(黑客)可以删除备份文件，不能从备份恢复系统。
为了保证备份文件100%的安全，备份服务公司提供远程备份服务器，使用scp脚本或RSYNC通过SSH传输数据，这样，没有人可以直接进入和访问远程系统，因此，也没有人可以从备份服务删除数据。在选择远程备份服务提供商时，最好从多个方面了解其服务强壮性，如果可以，可以亲自测试一下。
9、更新默认内核参数设置
为了顺利和成功运行企业应用程序，如数据库服务器，可能需要更新一些默认的内核参数设置，例如，2.4.x系列内核消息队列参数msgmni有一个默认值(例如，共享内存，或shmmax在Red Hat系统上默认只有33554432字节)，它只允许有限的数据库并发连接，下面为数据库服务器更好地运行提供了一些建议值(来自IBM DB2支持网站)：
kernel.shmmax=268435456 (32位)
kernel.shmmax=1073741824 (64位)
kernel.msgmni=1024
fs.file-max=8192
kernel.sem=”250 32000 32 1024″
10、优化TCP
优化TCP协议有助于提高网络吞吐量，跨广域网的通信使用的带宽越大，延迟时间越长时，建议使用越大的TCP Linux大小，以提高数据传输速率，TCP Linux大小决定了发送主机在没有收到数据传输确认时，可以向接收主机发送多少数据。
11、选择正确的文件系统
使用ext4文件系统取代ext3
● Ext4是ext3文件系统的增强版，扩展了存储限制
●具有日志功能，保证高水平的数据完整性(在非正常关闭事件中)
●非正常关闭和重启时，它不需要检查磁盘(这是一个非常耗时的动作)
●更快的写入速度，ext4日志优化了硬盘磁头动作
12、使用noatime文件系统挂载选项
在文件系统启动配置文件fstab中使用noatime选项，如果使用了外部存储，这个挂载选项可以有效改善性能。
13、调整Linux文件描述符限制
Linux限制了任何进程可以打开的文件描述符数量，默认限制是每进程1024，这些限制可能会阻碍基准测试客户端(如httperf和apachebench)和Web服务器本身获得最佳性能，Apache每个连接使用一个进程，因此不会受到影响，但单进程Web服务器，如Zeus是每连接使用一个文件描述符，因此很容易受默认限制的影响。
打开文件限制是一个可以用ulimit命令调整的限制，ulimit -aS命令显示当前的限制，ulimit -aH命令显示硬限制(在未调整/proc中的内核参数前，你不能增加限制)。
Linux第三方应用程序性能技巧
对于运行在Linux上的第三方应用程序，一样有许多性能优化技巧，这些技巧可以帮助你提高Linux服务器的性能，降低运行成本。
14、正确配置MySQL
为了给MySQL分配更多的内存，可设置MySQL缓存大小，要是MySQL服务器实例使用了更多内存，就减少缓存大小，如果MySQL在请求增多时停滞不动，就增加MySQL缓存。
15、正确配置Apache
检查Apache使用了多少内存，再调整StartServers和MinSpareServers参数，以释放更多的内存，将有助于你节省30-40%的内存。
16、分析Linux服务器性能
提高系统效率最好的办法是找出导致整体速度下降的瓶颈并解决掉，下面是找出系统关键瓶颈的一些基本技巧：
● 当大型应用程序，如OpenOffice和Firefox同时运行时，计算机可能会开始变慢，内存不足的出现几率更高。
● 如果启动时真的很慢，可能是应用程序初次启动需要较长的加载时间，一旦启动好后运行就正常了，否则很可能是硬盘太慢了。
●CPU负载持续很高，内存也够用，但CPU利用率很低，可以使用CPU负载分析工具监控负载时间。
17、学习5个Linux性能命令
使用几个命令就可以管理Linux系统的性能了，下面列出了5个最常用的Linux性能命令，包括
top、vmstat、iostat、free和sar，它们有助于系统管理员快速解决性能问题。
(1)top
当前内核服务的任务，还显示许多主机状态的统计数据，默认情况下，它每隔5秒自动更新一次。
如：当前正常运行时间，系统负载，进程数量和内存使用率，
此外，这个命令也显示了那些使用最多CPU时间的进程(包括每个进程的各种信息，如运行用户，执行的命令等)。
(2)vmstat
Vmstat命令提供当前CPU、IO、进程和内存使用率的快照，它和top命令类似，自动更新数据，如：
$ vmstat 10
(3)iostat
Iostat提供三个报告：CPU利用率、设备利用率和网络文件系统利用率，使用-c，-d和-h参数可以分别独立显示这三个报告。
(4)free
显示主内存和交换空间内存统计数据，指定-t参数显示总内存，指定-b参数按字节为单位，使用-m则以兆为单位，默认情况下千字节为单位。
Free命令也可以使用-s参数加一个延迟时间(单位：秒)连续运行，如：
$ free -s 5
(5)sar
收集，查看和记录性能数据，这个命令比前面几个命令历史更悠久，它可以收集和显示较长周期的数据。
其它
下面是一些归类为其它的性能技巧：
18、将日志文件转移到内存中
当一台机器处于运行中时，最好是将系统日志放在内存中，当系统关闭时再将其复制到硬盘，当你运行一台开启了syslog功能的笔记本电脑或移动设备时，ramlog可以帮助你提高系统电池或移动设备闪存驱动器的寿命，使用ramlog的一个好处是，不用再担心某个守护进程每隔30秒向syslog发送一条消息，放在以前，硬盘必须随时保持运转，这样对硬盘和电池都不好。
19、先打包，后写入
在内存中划分出固定大小的空间保存日志文件，这意味着笔记本电脑硬盘不用一直保持运转，只有当某个守护进程需要写入日志时才运转，注意ramlog使用的内存空间大小是固定的，否则系统内存会很快被用光，如果笔记本使用固态硬盘，可以分配50-80MB内存给ramlog使用，ramlog可以减少许多写入周期，极大地提高固态硬盘的使用寿命。
20、一般调优技巧
尽可能使用静态内容替代动态内容，如果你在生成天气预告，或其它每隔1小时就必须更新的数据，最好是写一个程序，每隔1小时生成一个静态的文件，而不是让用户运行一个CGI动态地生成报告。
为动态应用程序选择最快最合适的API，CGI可能最容易编程，但它会为每个请求产生一个进程，通常，这是一个成本很高，且不必要的过程，FastCGI是更好的选择，和Apache的mod_perl一样，都可以极大地提高应用程序的性能。
种一棵树，最好的时间是十年前，其次是现在。
```


## 

```yml



```


## Linux系统日志及日志分析

```yml

Linux系统日志及日志分析
Linux系统拥有非常灵活和强大的日志功能，可以保存几乎所有的操作记录，并可以从中检索出我们需要的信息。

大部分Linux发行版默认的日志守护进程为 syslog，位于 /etc/syslog 或 /etc/syslogd，默认配置文件为 /etc/syslog.conf，任何希望生成日志的程序都可以向 syslog 发送信息。 

Linux系统内核和许多程序会产生各种错误信息、警告信息和其他的提示信息，这些信息对管理员了解系统的运行状态是非常有用的，所以应该把它们写到日志文件中去。完成这个过程的程序就是syslog。syslog可以根据日志的类别和优先级将日志保存到不同的文件中。例如，为了方便查阅，可以把内核信息与其他信息分开，单独保存到一个独立的日志文件中。默认配置下，日志文件通常都保存在“/var/log”目录下。

日志类型
下面是常见的日志类型，但并不是所有的Linux发行版都包含这些类型：

类型	说明
auth	用户认证时产生的日志，如login命令、su命令。
authpriv	与 auth 类似，但是只能被特定用户查看。
console	针对系统控制台的消息。
cron	系统定期执行计划任务时产生的日志。
daemon	某些守护进程产生的日志。
ftp	FTP服务。
kern	系统内核消息。
local0.local7	由自定义程序使用。
lpr	与打印机活动有关。
mail	邮件日志。
mark	产生时间戳。系统每隔一段时间向日志文件中输出当前时间，每行的格式类似于 May 26 11:17:09 rs2 -- MARK --，可以由此推断系统发生故障的大概时间。
news	网络新闻传输协议(nntp)产生的消息。
ntp	网络时间协议(ntp)产生的消息。
user	用户进程。
uucp	UUCP子系统。
日志优先级
常见的日志优先级请见下标：

优先级	说明
emerg	紧急情况，系统不可用（例如系统崩溃），一般会通知所有用户。
alert	需要立即修复，例如系统数据库损坏。
crit	危险情况，例如硬盘错误，可能会阻碍程序的部分功能。
err	一般错误消息。
warning	警告。
notice	不是错误，但是可能需要处理。
info	通用性消息，一般用来提供有用信息。
debug	调试程序产生的信息。
none	没有优先级，不记录任何日志消息。
常见日志文件
所有的系统应用都会在 /var/log 目录下创建日志文件，或创建子目录再创建日志文件。例如：

文件/目录	说明
/var/log/boot.log	开启或重启日志。
/var/log/cron	计划任务日志
/var/log/maillog	邮件日志。
/var/log/messages	该日志文件是许多进程日志文件的汇总，从该文件可以看出任何入侵企图或成功的入侵。
/var/log/httpd 目录	Apache HTTP 服务日志。
/var/log/samba 目录	samba 软件日志
 

/etc/syslog.conf 文件
/etc/syslog.conf 是 syslog 的配置文件，会根据日志类型和优先级来决定将日志保存到何处。典型的 syslog.conf 文件格式如下所示：

*.err;kern.debug;auth.notice /dev/console
daemon,auth.notice           /var/log/messages
lpr.info                     /var/log/lpr.log
mail.*                       /var/log/mail.log
ftp.*                        /var/log/ftp.log
auth.*                       @see.xidian.edu.cn
auth.*                       root,amrood
netinfo.err                  /var/log/netinfo.log
install.*                    /var/log/install.log
*.emerg                      *
*.alert                      |program_name
mark.*                       /dev/console
第一列为日志类型和日志优先级的组合，每个类型和优先级的组合称为一个选择器；后面一列为保存日志的文件、服务器，或输出日志的终端。syslog 进程根据选择器决定如何操作日志。

对配置文件的几点说明：

日志类型和优先级由点号(.)分开，例如 kern.debug 表示由内核产生的调试信息。
kern.debug 的优先级大于 debug。
星号(*)表示所有，例如 *.debug 表示所有类型的调试信息，kern.* 表示由内核产生的所有消息。
可以使用逗号(,)分隔多个日志类型，使用分号(;)分隔多个选择器。

对日志的操作包括：

将日志输出到文件，例如 /var/log/maillog 或 /dev/console。
将消息发送给用户，多个用户用逗号(,)分隔，例如 root, amrood。
通过管道将消息发送给用户程序，注意程序要放在管道符(|)后面。
将消息发送给其他主机上的 syslog 进程，这时 /etc/syslog.conf 文件后面一列为以@开头的主机名，例如@see.xidian.edu.cn。
logger 命令
logger 是Shell命令，可以通过该命令使用 syslog 的系统日志模块，还可以从命令行直接向系统日志文件写入一行信息。

logger命令的语法为：

logger [-i] [-f filename] [-p priority] [-t tag] [message...]
每个选项的含义如下：

选项	说明
-f filename	将 filename 文件的内容作为日志。
-i	每行都记录 logger 进程的ID。
-p priority	指定优先级；优先级必须是形如 facility.priority 的完整的选择器，默认优先级为 user.notice。
-t tag	使用指定的标签标记每一个记录行。
message	要写入的日志内容，多条日志以空格为分隔；如果没有指定日志内容，并且 -f filename 选项为空，那么会把标准输入作为日志内容。

例如，将ping命令的结果写入日志：

$ ping 192.168.0.1 | logger -it logger_test -p local3.notice&
$ tail -f /var/log/userlog
Oct 6 12:48:43 kevein logger_test[22484]: PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
Oct 6 12:48:43 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=1 ttl=253 time=49.7 ms
Oct 6 12:48:44 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=2 ttl=253 time=68.4 ms
Oct 6 12:48:45 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=3 ttl=253 time=315 ms
Oct 6 12:48:46 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=4 ttl=253 time=279 ms
Oct 6 12:48:47 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=5 ttl=253 time=347 ms
Oct 6 12:48:49 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=6 ttl=253 time=701 ms
Oct 6 12:48:50 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=7 ttl=253 time=591 ms
Oct 6 12:48:51 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=8 ttl=253 time=592 ms
Oct 6 12:48:52 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=9 ttl=253 time=611 ms
Oct 6 12:48:53 kevein logger_test[22484]: 64 bytes from 192.168.0.1: icmp_seq=10 ttl=253 time=931 ms
ping命令的结果成功输出到 /var/log/userlog 文件。

命令 logger -it logger_test -p local3.notice 各选项的含义：

-i：在每行都记录进程ID；
-t logger_test：每行记录都加上“logger_test”这个标签；
-p local3.notice：设置日志类型和优先级。
日志转储
日志转储也叫日志回卷或日志轮转。Linux中的日志通常增长很快，会占用大量硬盘空间，需要在日志文件达到指定大小时分开存储。

syslog 只负责接收日志并保存到相应的文件，但不会对日志文件进行管理，因此经常会造成日志文件过大，尤其是WEB服务器，轻易就能超过1G，给检索带来困难。

大多数Linux发行版使用 logrotate 或 newsyslog 对日志进行管理。logrotate 程序不但可以压缩日志文件，减少存储空间，还可以将日志发送到指定 E-mail，方便管理员及时查看日志。

例如，规定邮件日志 /var/log/maillog 超过1G时转储，每周一次，那么每隔一周 logrotate 进程就会检查 /var/log/maillog 文件的大小：

如果没有超过1G，不进行任何操作。
如果在1G~2G之间，就会创建新文件 /var/log/maillog.1，并将多出的1G日志转移到该文件，以给 /var/log/maillog 文件瘦身。
如果在2G~3G之间，会继续创建新文件 /var/log/maillog.2，并将 /var/log/maillog.1 的内容转移到该文件，将 /var/log/maillog 的内容转移到 /var/log/maillog.1，以保持 /var/log/maillog 文件不超过1G。

可以看到，每次转存都会创建一个新文件（如果不存在），命名格式为日志文件名加一个数字（从1开始自动增长），以保持当前日志文件和转存后的日志文件不超过指定大小。

logrotate 的主要配置文件是 /etc/logrotate.conf，/etc/logrotate.d 目录是对 /etc/logrotate.conf 的补充，或者说为了不使 /etc/logrotate.conf 过大而设置。

可以通过 cat 命令查看它的内容：

$cat /etc/logrotate.conf
# see "man logrotate" for details  //可以查看帮助文档
# rotate log files weekly
weekly                             //设置每周转储一次
# keep 4 weeks worth of backlogs
rotate 4                           //最多转储4次
# create new (empty) log files after rotating old ones
create                             //当转储后文件不存储时创建它
# uncomment this if you want your log files compressed
#compress                          //以压缩方式转储
# RPM packages drop log rotation information into this directory
include /etc/logrotate.d           //其他日志文件的转储方式，包含在该目录下
# no packages own wtmp -- we'll rotate them here
/var/log/wtmp {                    //设置/var/log/wtmp日志文件的转储参数
    monthly                        //每月转储
    create 0664 root utmp          //转储后文件不存在时创建它，文件所有者为root，所属组为utmp，对应的权限为0664
    rotate 1                       //最多转储一次
}

注意：include 允许管理员把多个分散的文件集中到一个，类似于C语言的 #include，将其他文件的内容包含进当前文件。

include 非常有用，一些程序会把转储日志的配置文件放在 /etc/logrotate.d 目录，这些配置文件会覆盖或增加 /etc/logrotate.conf 的配置项，如果没有指定相关配置，那么采用 /etc/logrotate.conf 的默认配置。

所以，建议将 /etc/logrotate.conf 作为默认配置文件，第三方程序在 /etc/logrotate.d 目录下自定义配置文件。

logrotate 也可以作为命令直接运行来修改配置文件。



```


## 

```yml



```


## 查看Linux磁盘及内存占用情况

```yml

查看Linux磁盘及内存占用情况
2017年12月11日 17:56:46 PickJerry 阅读数 38270
 版权声明：本文为博主原创文章，未经博主允许不得转载。 https://blog.csdn.net/u014311799/article/details/78775175
查看磁盘使用情况： 
df -k：以KB为单位显示磁盘使用量和占用率 
这里写图片描述 
df -m：以Mb为单位显示磁盘使用量和占用率 
这里写图片描述 
df –help：查看更多df命令及使用方法 
这里写图片描述

查看内存占用情况： 
1.top 
这里写图片描述

PID：当前运行进程的ID 
USER：进程属主 
PR：每个进程的优先级别 
NInice：反应一个进程“优先级”状态的值，其取值范围是-20至19，一 
　　　　共40个级别。这个值越小，表示进程”优先级”越高，而值越 
　　　　大“优先级”越低。一般会把nice值叫做静态优先级 
VIRT：进程占用的虚拟内存 
RES：进程占用的物理内存 
SHR：进程使用的共享内存 
S：进程的状态。S表示休眠，R表示正在运行，Z表示僵死状态，N表示 
　 该进程优先值为负数 
%CPU：进程占用CPU的使用率 
%MEM：进程使用的物理内存和总内存的百分比 
TIME+：该进程启动后占用的总的CPU时间，即占用CPU使用时间的累加值。 
COMMAND：进程启动命令名称

２.free 
这里写图片描述 
total : 总计物理内存的大小。 
used : 已使用多大。 
free : 可用有多少。 
Shared : 多个进程共享的内存总额。 
Buffers/cached : 磁盘缓存的大小。 
-/+ buffers/cached) : 
used:已使用多大; 
free:可用有多少。 
注意： 
（mem）的used/free与(-/+ buffers/cache) used/free的区别： 
这两者的区别在于使用的角度来看，前者是从OS（Operating Sys）的角度来看，因为对于OS，buffers/cached 都是属于被使用，所以他的可用内存是11737644KB,已用内存是54215352KB, 
后者所指的是从应用程序角度来看，对于应用程序来说，buffers/cached 是等于可用的，因为buffer/cached是为了提高文件读取的性能，当应用程序需在用到内存的时候，buffer/cached会很快地被回收。 
所以从应用程序的角度来说，可用内存=系统free memory+buffers+cached。

3.cat /proc/meminfo 
查看RAM使用情况最简单的方法是通过命令：cat /proc/meminfo； 
这个动态更新的虚拟文件实际上是许多其他内存相关工具(如：free / ps / top)等的组合显示。 
/proc/meminfo列出了所有你想了解的内存的使用情况。 
进程的内存使用信息也可以通过命令：cat /proc//statm 、 cat /proc//status 来查看。 
这里写图片描述

4.ps aux –sort -rss 
ps aux: 列出目前所有的正在内存当中的程序。 
a显示终端上地所有进程,包括其他用户地进程(有的进程没有终端)。 
-a 显示所有终端机下执行的进程，除了阶段作业领导者之外。 
u 　以用户为主的格式来显示进程状况。 
x 　显示所有进程，不以终端机来区分。 
a会包括其他用户(否则只有用户本身); x会包括其他终端; 
aux就可以包括内存所有; 
这里写图片描述

USER：该 process 属于那个使用者账号的 
PID ：该 process 的号码 
%CPU：该 process 使用掉的 CPU 资源百分比 
%MEM：该 process 所占用的物理内存百分比 
VSZ ：该 process 使用掉的虚拟内存量 (Kbytes) 
RSS ：该 process 占用的固定的内存量 (Kbytes) 
TTY ：该 process 是在那个终端机上面运作，若与终端机无关，则显示 ?，另外， tty1-tty6 是本机上面的登入者程序，若为 pts/0 等等的，则表示为由网络连接进主机的程序。 
STAT：该程序目前的状态，主要的状态有 
R ：该程序目前正在运作，或者是可被运作 
S ：该程序目前正在睡眠当中 (可说是 idle 状态)，但可被某些讯号 (signal) 唤醒。 
T ：该程序目前正在侦测或者是停止了 
Z ：该程序应该已经终止，但是其父程序却无法正常的终止他，造成 zombie (疆尸) 程序的状态 
START：该 process 被触发启动的时间 
TIME ：该 process 实际使用 CPU 运作的时间 
COMMAND：该程序的实际指令

5.vmstat -s 
vmstat命令显示实时的和平均的统计，覆盖CPU、内存、I/O等内容。例如内存情况，不仅显示物理内存，也统计虚拟内存。 
这里写图片描述

6.gnome-shell-system-monitor-applet 
Gnome-shell系统监视器gnome-shell-system-monitor-applet,是一个Gnome-shell 面板小程序，此程序用户监视CPU占用百分比、内存使用和SWAP使用情况，如图通过顶部栏显示和关闭。 
此程序下载地址：https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet

和其他gnome-shell扩展小程序相比，安装可能有点困难，首先需要安装git-core核心。 
在终端输入命令： 
mkdir ~/git_projects 
cd ~/git_projects 
git clone git://github.com/paradoxxxzero/gnome-shell-system-monitor-applet.git 
mkdir -p ~/.local/share/gnome-shell/extensions 
cd ~/.local/share/gnome-shell/extensions 
ln -s ~/git_projects/gnome-shell-system-monitor-applet/system-monitor@paradoxxx.zero.gmail.com 
sudo cp ~/git_projects/gnome-shell-system-monitor-applet/org.gnome.shell.extensions.system-monitor.gschema.xml /usr/share/glib-2.0/schemas 
cd /usr/share/glib-2.0/schemas 
sudo glib-compile-schemas . 
如果你使用的jhbuild编译的gnome-shell,可能会无法工作！

7.相关知识

linux上进程有5种状态: 
1. 运行(正在运行或在运行队列中等待) 
2. 中断(休眠中, 受阻, 在等待某个条件的形成或接受到信号) 
3. 不可中断(收到信号不唤醒和不可运行, 进程必须等待直到有中断发生) 
4. 僵死(进程已终止, 但进程描述符存在, 直到父进程调用wait4()系统调用后释放) 
5. 停止(进程收到SIGSTOP, SIGSTP, SIGTIN, SIGTOU信号后停止运行运行) 
ps工具标识进程的5种状态码: 
D 不可中断 uninterruptible sleep (usually IO) 
R 运行 runnable (on run queue) 
S 中断 sleeping 
T 停止 traced or stopped 
Z 僵死 a defunct (”zombie”) process 
注: 其它状态还包括W(无驻留页), <(高优先级进程), N(低优先级进程), L(内存锁页). 
使用ps格式输出来查看进程状态: 
ps -eo user,stat..,cmd 
user 用户名 
uid 用户号 
pid 进程号 
ppid 父进程号 
size 内存大小, Kbytes字节. 
vsize 总虚拟内存大小, bytes字节(包含code+data+stack) 
share 总共享页数 
nice 进程优先级(缺省为0, 最大为-20) 
priority(pri) 内核调度优先级 
pmem 进程分享的物理内存数的百分比 
trs 程序执行代码驻留大小 
rss 进程使用的总物理内存数, Kbytes字节 
time 进程执行起到现在总的CPU暂用时间 
stat 进程状态 
cmd(args) 执行命令的简单格式 
例子: 
查看当前系统进程的uid,pid,stat,pri, 以uid号排序. 
ps -eo pid,stat,pri,uid –sort uid 
查看当前系统进程的user,pid,stat,rss,args, 以rss排序. 
ps -eo user,pid,stat,rss,args –sort rss

```


## 

```yml



```



## Linux性能检测常用的10个基本命令

```yml

Linux性能检测常用的10个基本命令
2018年05月31日 16:44:02 guoxiaojie_415 阅读数 2852
本文的内容主要来自对Netflix的一篇技术博客( Linux Performance Analysis in 60,000 Milliseconds(可能需要翻墙才能访问) )，并添加了一些自己的理解，仅供参考。

一、常用检测性能的10个基本命令
1. uptime
$ uptime 
23:51:26 up 21:31, 1 user, load average: 30.02, 26.43, 19.02

该命令可以大致的看出计算机的整体负载情况，load average后的数字分别表示计算机在1min、5min、15min内的平均负载。

2. dmesg | tail
$ dmesg | tail
[1880957.563150] perl invoked oom-killer: gfp_mask=0x280da, order=0, oom_score_adj=0
[...]
[1880957.563400] Out of memory: Kill process 18694 (perl) score 246 or sacrifice child
[1880957.563408] Killed process 18694 (perl) total-vm:1972392kB, anon-rss:1953348kB, file-rss:0kB
[2320864.954447] TCP: Possible SYN flooding on port 7001. Dropping request.  Check SNMP counters.

打印内核环形缓存区中的内容，可以用来查看一些错误；

上面的例子中，显示进程18694 因引内存越界被kill掉以及TCP request被丢弃的错误。通过dmesg可以快速判断是否有导致系统性能异常的问题。

3. vmstat 1
$ vmstat 1
procs ---------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
34  0    0 200889792  73708 591828    0    0     0     5    6   10 96  1  3  0  0
32  0    0 200889920  73708 591860    0    0     0   592 13284 4282 98  1  1  0  0
32  0    0 200890112  73708 591860    0    0     0     0 9501 2154 99  1  0  0  0
32  0    0 200889568  73712 591856    0    0     0    48 11900 2459 99  0  0  0  0
32  0    0 200890208  73712 591860    0    0     0     0 15898 4840 98  1  1  0  0
^C

打印进程、内存、交换分区、IO和CPU等的统计信息；

vmstat的格式如下

vmstat [options] [delay [count]]

vmstat第一次输出表示从开机到vmstat运行时的平均值；剩余输出的都是在指定的时间间隔内的平均值，上述例子中delay的值设置为1，除第一次以外，剩余的都是1秒统计一次，count未设置，将会一直循环打印。

$ vmstat 10 3
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 2527112 1086888 13720228    0    0     1    14    2    1  1  1 99  0  0
 0  0      0 2527156 1086888 13719856    0    0     0   104 3003 4901  0  0 99  0  0
 0  0      0 2526412 1086888 13719904    0    0     0    10 3345 4870  0  1 99  0  0

上述的例子中delay设置为10，count设置为3，表示每行打印10秒内的平均值，只打印3次。

需要检查的列
r：表示正在运行或者等待CPU调度的进程数。因为该列数据不包含I/O的统计信息，因此可以用来检测CPU是否饱和。若r列中的数字大于CPU的核数，表示CPU已经处于饱和状态。
free：当前剩余的内存；
si, so：交换分区换入和换出的个数，若换入换出个数大于0，表示内存不足；
us, sy, id, wa：CPU的统计信息，分别表示user time、system time(kernel)、idle、wait I/O。I/O处理所用的时间包含在system time中，因此若system time超过20%，则I/O可能存在瓶颈或异常；
4. mpstat -P ALL 1
$ mpstat -P ALL
Linux 3.10.0-229.el7.x86_64 (localhost.localdomain)     05/30/2018  _x86_64_    (16 CPU)

04:03:55 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
04:03:55 PM  all    3.67    0.00    0.61    0.71    0.00    0.00    0.00    0.00    0.00   95.02
04:03:55 PM    0    3.52    0.00    0.57    0.76    0.00    0.00    0.00    0.00    0.00   95.15
04:03:55 PM    1    3.83    0.00    0.61    0.71    0.00    0.00    0.00    0.00    0.00   94.85
04:03:55 PM    2    3.80    0.00    0.61    0.60    0.00    0.00    0.00    0.00    0.00   94.99
04:03:55 PM    3    3.68    0.00    0.58    0.60    0.00    0.00    0.00    0.00    0.00   95.13
04:03:55 PM    4    3.54    0.00    0.57    0.60    0.00    0.00    0.00    0.00    0.00   95.30
[...]

该命令用于每秒打印一次每个CPU的统计信息，可用于查看CPU的调度是否均匀。

5. pidstat 1
$ pidstat 1
Linux 3.13.0-49-generic (titanclusters-xxxxx)  07/14/2015    _x86_64_    (32 CPU)

07:41:02 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
07:41:03 PM     0         9    0.00    0.94    0.00    0.94     1  rcuos/0
07:41:03 PM     0      4214    5.66    5.66    0.00   11.32    15  mesos-slave
07:41:03 PM     0      4354    0.94    0.94    0.00    1.89     8  java
07:41:03 PM     0      6521 1596.23    1.89    0.00 1598.11    27  java
07:41:03 PM     0      6564 1571.70    7.55    0.00 1579.25    28  java
07:41:03 PM 60004     60154    0.94    4.72    0.00    5.66     9  pidstat

07:41:03 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
07:41:04 PM     0      4214    6.00    2.00    0.00    8.00    15  mesos-slave
07:41:04 PM     0      6521 1590.00    1.00    0.00 1591.00    27  java
07:41:04 PM     0      6564 1573.00   10.00    0.00 1583.00    28  java
07:41:04 PM   108      6718    1.00    0.00    0.00    1.00     0  snmp-pass
07:41:04 PM 60004     60154    1.00    4.00    0.00    5.00     9  pidstat
^C

该命令用于打印各个进程对CPU的占用情况，类似top命令中显示的内容。pidstat的优势在于，可以滚动的打印进程运行情况，而不像top那样会清屏。

上述例子中，%CPU中两个java进程的cpu利用率分别达到了1590%和1573%，表示java进程占用了16颗CPU。

6. iostat -xz 1
类似vmstat，第一次输出的是从系统开机到统计这段时间的采样数据；

$ iostat -xz 1
Linux 3.13.0-49-generic (titanclusters-xxxxx)  07/14/2015  _x86_64_ (32 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          73.96    0.00    3.73    0.03    0.06   22.21

Device:   rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
xvda        0.00     0.23    0.21    0.18     4.52     2.08    34.37     0.00    9.98   13.80    5.42   2.44   0.09
xvdb        0.01     0.00    1.02    8.94   127.97   598.53   145.79     0.00    0.43    1.78    0.28   0.25   0.25
xvdc        0.01     0.00    1.02    8.86   127.79   595.94   146.50     0.00    0.45    1.82    0.30   0.27   0.26
dm-0        0.00     0.00    0.69    2.32    10.47    31.69    28.01     0.01    3.23    0.71    3.98   0.13   0.04
dm-1        0.00     0.00    0.00    0.94     0.01     3.78     8.00     0.33  345.84    0.04  346.81   0.01   0.00
dm-2        0.00     0.00    0.09    0.07     1.35     0.36    22.50     0.00    2.55    0.23    5.62   1.78   0.03
[...]
^C

检查列
r/s, w/s, rkB/s, wkB/s，表示每秒向I/O设备发出的reads、writes、read Kbytes、write Kbytes的数量。
await，表示应用程序排队等待和被服务的平均I/O时间，该值若大于预期的时间，这表示I/O设备处于饱和状态或者异常。
avgqu-sz，表示请求被发送给I/O设备的平均时间，若该值大于1，则表示I/O设备可能已经饱和；
%util，每秒设备的利用率；若该利用率超过60%，则表示设备出现性能异常；
7. free -m
$ free -m
             total       used       free     shared    buffers     cached
Mem:        245998      24545     221453         83         59        541
-/+ buffers/cache:      23944     222053
Swap:            0          0          0

检查的列：

buffers: For the buffer cache, used for block device I/O.
cached: For the page cache, used by file systems.
若buffers和cached接近0，说明I/O的使用率过高，系统存在性能问题。 
Linux中会用free内存作为cache，若应用程序需要分配内存，系统能够快速的将cache占用的内存回收，因此free的内存包含cache占用的部分。

8. sar -n DEV 1
sar是System Activity Reporter的缩写，系统活动状态报告。

-n { keyword [,…] | ALL }，用于报告网络统计数据。keyword可以是以下的一个或者多个： DEV, EDEV, NFS, NFSD, SOCK, IP, EIP, ICMP, EICMP, TCP, ETCP, UDP, SOCK6, IP6, EIP6, ICMP6, EICMP6 和UDP6。

-n DEV 1, 每秒统计一次网络的使用情况； 
-n EDEV 1，每秒统计一次错误的网络信息；

$ sar -n DEV 1
Linux 3.10.0-229.el7.x86_64 (localhost.localdomain)     05/31/2018  _x86_64_    (16 CPU)

03:54:57 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
03:54:58 PM     ens32   3286.00   7207.00    283.34  18333.90      0.00      0.00      0.00
03:54:58 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
03:54:58 PM vethe915e51      0.00      0.00      0.00      0.00      0.00      0.00      0.00
03:54:58 PM   docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00

03:54:58 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
03:54:59 PM     ens32   3304.00   7362.00    276.89  18898.51      0.00      0.00      0.00
03:54:59 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
03:54:59 PM vethe915e51      0.00      0.00      0.00      0.00      0.00      0.00      0.00
03:54:59 PM   docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00
^C


IFACE ，网络接口名称；
rxpck/s ，每秒接收到包数；
txpck/s ，每秒传输的报数；(transmit packages)
rxkB/s ，每秒接收的千字节数；
txkB/s ，每秒发送的千字节数；
rxcmp/s ，每秒接收的压缩包的数量；
txcmp/s ，每秒发送的压缩包的数量；
rxmcst/s，每秒接收的组数据包数量；
9. sar -n TCP,ETCP 1
该命令可以用于粗略的判断网络的吞吐量，如发起的网络连接数量和接收的网络连接数量；

TCP, 报告关于TCPv4网络流量的统计信息;
ETCP, 报告有关TCPv4网络错误的统计信息;
$ sar -n TCP,ETCP 1
Linux 3.10.0-514.26.2.el7.x86_64 (aushop)   05/31/2018  _x86_64_    (2 CPU)

04:16:27 PM  active/s passive/s    iseg/s    oseg/s
04:16:44 PM      0.00      2.00     15.00     13.00
04:16:45 PM      0.00      3.00    126.00    203.00
04:16:46 PM      0.00      0.00     99.00     99.00
04:16:47 PM      0.00      0.00     18.00      9.00
04:16:48 PM      0.00      0.00      5.00      6.00
04:16:49 PM      0.00      0.00      1.00      1.00
04:16:50 PM      0.00      1.00      4.00      4.00
04:16:51 PM      0.00      3.00    171.00    243.00
^C

检测的列：

active/s: Number of locally-initiated TCP connections per second (e.g., via connect())，发起的网络连接数量；
passive/s: Number of remotely-initiated TCP connections per second (e.g., via accept())，接收的网络连接数量；
retrans/s: Number of TCP retransmits per second，重传的数量；
10. top
top命令包含更多的指标统计，相当于一个综合命令。

$ top
top - 00:15:40 up 21:56,  1 user,  load average: 31.09, 29.87, 29.92
Tasks: 871 total,   1 running, 868 sleeping,   0 stopped,   2 zombie
%Cpu(s): 96.8 us,  0.4 sy,  0.0 ni,  2.7 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem:  25190241+total, 24921688 used, 22698073+free,    60448 buffers
KiB Swap:        0 total,        0 used,        0 free.   554208 cached Mem

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 20248 root      20   0  0.227t 0.012t  18748 S  3090  5.2  29812:58 java
  4213 root      20   0 2722544  64640  44232 S  23.5  0.0 233:35.37 mesos-slave
 66128 titancl+  20   0   24344   2332   1172 R   1.0  0.0   0:00.07 top
  5235 root      20   0 38.227g 547004  49996 S   0.7  0.2   2:02.74 java
  4299 root      20   0 20.015g 2.682g  16836 S   0.3  1.1  33:14.42 java
     1 root      20   0   33620   2920   1496 S   0.0  0.0   0:03.82 init
     2 root      20   0       0      0      0 S   0.0  0.0   0:00.02 kthreadd
     3 root      20   0       0      0      0 S   0.0  0.0   0:05.35 ksoftirqd/0
     5 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H
     6 root      20   0       0      0      0 S   0.0  0.0   0:06.94 kworker/u256:0
     8 root      20   0       0      0      0 S   0.0  0.0   2:38.05 rcu_sched

11. 总结
下面的图片很好的展示了各个命令的主要作用，如使用vmstat查看系统的整体性能，mpstat用于查看cpu的性能，pidstat用于查看进程的状态，iostat用于查看io的状态，free用于产看内存的状态，sar用于产看网络的状态等

```


## 

```yml



```


## Linux查看机器负载

```yml

Linux查看机器负载
2017年03月07日 11:19:52 坦GA 阅读数 1711
原文地址：http://blog.csdn.net/szchtx/article/details/38455385
负载(load)是Linux机器的一个重要指标，直观了反应了机器当前的状态。如果机器负载过高，那么对机器的操作将难以进行。

Linux的负载高，主要是由于CPU使用、内存使用、IO消耗三部分构成。任意一项使用过多，都将导致服务器负载的急剧攀升。

查看服务器负载有多种命令，w或者uptime都可以直接展示负载，

$ uptime
 12:20:30 up 44 days, 21:46,  2 users,  load average: 8.99, 7.55, 5.40
$ w
 12:22:02 up 44 days, 21:48,  2 users,  load average: 3.96, 6.28, 5.16
load average分别对应于过去1分钟，5分钟，15分钟的负载平均值。
这两个命令只是单纯的反映出负载，linux提供了更为强大，也更为实用的top命令来查看服务器负载。

$ top



top命令能够清晰的展现出系统的状态，而且它是实时的监控，按q退出。



Tasks行展示了目前的进程总数及所处状态，要注意zombie，表示僵尸进程，不为0则表示有进程出现问题。

Cpu(s)行展示了当前CPU的状态，us表示用户进程占用CPU比例，sy表示内核进程占用CPU比例，id表示空闲CPU百分比，wa表示IO等待所占用的CPU时间的百分比。wa占用超过30%则表示IO压力很大。

Mem行展示了当前内存的状态，total是总的内存大小，userd是已使用的，free是剩余的，buffers是目录缓存。

Swap行同Mem行，cached表示缓存，用户已打开的文件。如果Swap的used很高，则表示系统内存不足。



在top命令下，按1，则可以展示出服务器有多少CPU，及每个CPU的使用情况



一般而言，服务器的合理负载是CPU核数*2。也就是说对于8核的CPU，负载在16以内表明机器运行很稳定流畅。如果负载超过16了，就说明服务器的运行有一定的压力了。

在top命令下，按shift + "p"，则将进程按照CPU使用率从大到小排序，按shift+"m"，则将进程按照内存使用率从大到小排序，很容易能够定位出哪些服务占用了较高的CPU和内存。



仅仅有top命令是不够的，因为它仅能展示CPU和内存的使用情况，对于负载升高的另一重要原因——IO没有清晰明确的展示。linux提供了iostat命令，可以了解io的开销。

输入iostat -x 1 10命令，表示开始监控输入输出状态，-x表示显示所有参数信息，1表示每隔1秒监控一次，10表示共监控10次。



其中rsec/s表示读入，wsec/s表示每秒写入，这两个参数某一个特别高的时候就表示磁盘IO有很大压力，util表示IO使用率，如果接近100%，说明IO满负荷运转。 



总结：

（1）使用top命令查看负载，在top下按“1”查看CPU核心数量，shift+"p"按cpu使用率大小排序，shift+"m"按内存使用率高低排序；

（2）使用iostat -x 命令来监控io的输入输出是否过大

```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```


## 

```yml



```









