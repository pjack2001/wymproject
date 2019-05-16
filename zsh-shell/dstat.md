# dstat



```yml


```

## 使用

```yml


yum instatll -y dstat

找出占用资源最高的进程和用户
--top-(io|bio|cpu|cputime|cputime-avg|mem) 通过这几个选项，可以看到具体是那个用户那个进程占用了相关系统资源，对系统调优非常有效。如查看当前占用I/O、cpu、内存等最高的进程信息可以使用

# dstat --top-mem --top-io --top-cpu
--most-expensive- ----most-expensive---- -most-expensive-
  memory process |     i/o process      |  cpu process   
python2     16.0M|sshd        599k  253k|systemd      0.0
python2     16.0M|VBoxService1536B    0 |                
python2     16.0M|sshd: vagra 148B   68B|                
python2     16.0M|sshd: vagra 155B   60B|kworker/0:2  1.0



# dstat 5 #5秒刷新
You did not select any stats, using -cdngy by default.
----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  1   1  98   0   0   0|  48k  171k|   0     0 |   0     0 |  85   131 
  0   0 100   0   0   0|   0     0 |  84B  135B|   0     0 |  22    31 
  0   0 100   0   0   0|   0     0 |  60B  103B|   0     0 |  19    26
  
输出csv文件
# dstat --output /root/dstat.csv &

输出日志
# dstat -tydncs --output ./dstat.log

# dstat -tydncs >> ./dstat.log



配置计划任务
# echo "* 8 * * * /root/dstat/dstat.py" >> /var/spool/cron/root

每天8点启动，（什么时候停止需要研究）
# echo "* 6 * * * /opt/dstat/dstat.py -tydncs --output /opt/dstat/dstat.log --pidfile /opt/dstat/dstat.lck --nocolor 10" >> /var/spool/cron/root

查看计划任务
# crontab -l

# cat /var/spool/cron/root 
* 8 * * * /root/dstat/dstat.py
* 6 * * * /opt/dstat/dstat.py -tydncs --output /opt/dstat/dstat.log --pidfile /opt/dstat/dstat.lck --nocolor 10



```

## 优化dstat监控日志

```yml
$ git clone https://github.com/dbafree/dstat.git

优化dstat监控日志
http://ju.outofmemory.cn/entry/55979

/home/oracle/dbafree/dstat -tydncs --output /home/oracle/dbafree/dstat.log --pidfile /home/oracle/dbafree/dstat.lck --nocolor 10


./dstat -tydncs --output ./dstat.log --pidfile ./dstat.lck --nocolor 10

$ tail -100f dstat_raw.log

#################################################
优化dstat监控日志

http://ju.outofmemory.cn/entry/55979

dbafree首页 2013年12月1日 424阅读

dstat是一个用来替换vmstat，iostat netstat，nfsstat和ifstat这些命令的工具，是一个全能系统信息统计工具。
因为实际使用起来，感觉不是很方便，因此作了一些修改，方便数据的采集和事后问题的排查。
用下面的命令来运行修改后的dstat（dstat代码下载）

/home/oracle/dbafree/dstat -tydncs --output /home/oracle/dbafree/dstat.log
--pidfile /home/oracle/dbafree/dstat.lck --nocolor 10
1.支持了pidfile参数，并通过pidfile进程文件来防止并发执行如果重复次启动dstat，会出现如下错误：

pidfile ['/home/oracle/dbafree/dstat.lck'] is exist,process ['2350'] is running!
Failed to create pidfile /home/oracle/dbafree/dstat.lck 0

2.自动记录dstat.log及自动收集元数据dstat_raw.log。
参数通过-output指定，dstat_raw.log自动根据output_raw.log来生成，-output必需以.LOG后缀结尾。

[oracle@testdb /home/oracle/dbafree]
$ ls -ltr
total 104
-rwxr-xr-x 1 oracle oinstall 84182 Dec  1 19:20 dstat
-rw-r--r-- 1 oracle oinstall     4 Dec  1 19:34 dstat.lck
-rw-r--r-- 1 oracle oinstall  5526 Dec  1 19:36 dstat_raw.log
-rw-r--r-- 1 oracle oinstall  3468 Dec  1 19:36 dstat.log
查看dstat.log，对于这个文件，在本地保存，方便直接通过日志文件排查问题。

[oracle@testdb /home/oracle/dbafree]
$ tail -100f dstat.log

查看dstat_raw.log，这个是元数据文件，可以采集到数据库中，作曲线分析和对比等使用。

3.增加了日志自动归档功能，大于100m，会自动归档，归档最多保留2个。

这样，我们把dstat的代码部署到的crontab中，将dstat_raw.log采集入库，就可以很方便的实现操作系统层面的监控了。




```


## 

```yml


```


## 教程

### dstat 性能监测工具
```yml

dstat 是一个可以取代vmstat，iostat，netstat和ifstat这些命令的多功能产品。dstat克服了这些命令的局限并增加了一些另外的功能，增加了监控项，也变得更灵活了。dstat可以很方便监控系统运行状况并用于基准测试和排除故障。
dstat可以让你实时地看到所有系统资源，例如，你能够通过统计IDE控制器当前状态来比较磁盘利用率，或者直接通过网络带宽数值来比较磁盘的吞吐率（在相同的时间间隔内）。
dstat将以列表的形式为你提供选项信息并清晰地告诉你是在何种幅度和单位显示输出。这样更好地避免了信息混乱和误报。更重要的是，它可以让你更容易编写插件来收集你想要的数据信息，以从未有过的方式进行扩展。
Dstat的默认输出是专门为人们实时查看而设计的，不过你也可以将详细信息通过CSV输出到一个文件，并导入到Gnumeric或者Excel生成表格中。
特性

结合了vmstat，iostat，ifstat，netstat以及更多的信息
实时显示统计情况
在分析和排障时可以通过启用监控项并排序
模块化设计
使用python编写的，更方便扩展现有的工作任务
容易扩展和添加你的计数器（请为此做出贡献）
包含的许多扩展插件充分说明了增加新的监控项目是很方便的
可以分组统计块设备/网络设备，并给出总数
可以显示每台设备的当前状态
极准确的时间精度，即便是系统负荷较高也不会延迟显示
显示准确地单位和和限制转换误差范围
用不同的颜色显示不同的单位
显示中间结果延时小于1秒
支持输出CSV格式报表，并能导入到Gnumeric和Excel以生成图形


```
### 默认输出显示的信息

```yml
dstat的默认选项
与许多命令一样，dstat命令有默认选项，执行dstat命令不加任何参数，它默认会收集-cpu-、-disk-、-net-、－paging-、-system-的数据，一秒钟收集一次。 默认输入 dstat 等于输入了dstat -cdngy 1或dstat -a 1

直接跟数字，表示#秒收集一次数据，默认为一秒；dstat 5表示5秒更新一次

# dstat
You did not select any stats, using -cdngy by default.
----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  1   1  97   0   0   0|  72k  280k|   0     0 |   0     0 | 119   175 
  0   1  99   0   0   0|   0     0 | 120B  226B|   0     0 |  34    38 


这是默认输出显示的信息：
默认情况下分五个区域：

1、 --total-cpu-usage---- CPU使用率
usr：用户空间的程序所占百分比；
sys：系统空间程序所占百分比；
idel：空闲百分比；
wai：等待磁盘I/O所消耗的百分比；
hiq：硬中断次数；
siq：软中断次数；

2、-dsk/total-磁盘统计
read：读总数
writ：写总数

3、-net/total- 网络统计
recv：网络收包总数
send：网络发包总数

4、---paging-- 内存分页统计
in： pagein（换入）
out：page out（换出）
注：系统的分页活动。分页指的是一种内存管理技术用于查找系统场景，一个较大的分页表明系统正在使用大量的交换空间，通常情况下当系统已经开始用交换空间的时候，就说明你的内存已经不够用了，或者说内存非常分散，理想情况下page in（换入）和page out（换出）的值是0 0。

5、--system--系统信息
int：中断次数
csw：上下文切换
注：中断（int）和上下文切换（csw）。这项统计仅在有比较基线时才有意义。这一栏中较高的统计值通常表示大量的进程造成拥塞，需要对CPU进行关注。你的服务器一般情况下都会运行运行一些程序，所以这项总是显示一些数值。

默认情况下，dstat 会每隔一秒刷新一次数据，一直刷新并一直输出，按 Ctrl+C 退出 "dstat"；
dstat 还有许多具体的参数，可通过man dstat命令查看，


```
### 常用参数如下

```yml
常用参数如下：
通过dstat --list可以查看dstat能使用的所有参数

-l ：显示负载统计量
-m ：显示内存使用率（包括used，buffer，cache，free值）
-r ：显示I/O统计
-s ：显示交换分区使用情况
-t ：将当前时间显示在第一行
–fs ：显示文件系统统计数据（包括文件总数量和inodes值）
–nocolor ：不显示颜色（有时候有用）
–socket ：显示网络统计数据
–tcp ：显示常用的TCP统计
–udp ：显示监听的UDP接口及其当前用量的一些动态数据

当然不止这些用法，dstat附带了一些插件很大程度地扩展了它的功能。你可以通过查看/usr/share/dstat目录来查看它们的一些使用方法，常用的有这些：

-–disk-util ：显示某一时间磁盘的忙碌状况
-–freespace ：显示当前磁盘空间使用率
-–proc-count ：显示正在运行的程序数量
-–top-bio ：指出块I/O最大的进程
-–top-cpu ：图形化显示CPU占用最大的进程
-–top-io ：显示正常I/O最大的进程
-–top-mem ：显示占用最多内存的进程


```
##

```yml
-c,--cpu   统计CPU状态，包括 user, system, idle（空闲等待时间百分比）, wait（等待磁盘IO）, hardware interrupt（硬件中断）, software interrupt（软件中断）等；
-d, --disk 统计磁盘读写状态
-D total,sda 统计指定磁盘或汇总信息
-l, --load 统计系统负载情况，包括1分钟、5分钟、15分钟平均值
-m, --mem 统计系统物理内存使用情况，包括used, buffers, cache, free
-s, --swap 统计swap已使用和剩余量
-n, --net 统计网络使用情况，包括接收和发送数据
-N eth1,total  统计eth1接口汇总流量
-r, --io 统计I/O请求，包括读写请求
-p, --proc 统计进程信息，包括runnable、uninterruptible、new
-y, --sys 统计系统信息，包括中断、上下文切换
-t 显示统计时时间，对分析历史数据非常有用
--fs 统计文件打开数和inodes数

以上这些就是最常用的选项，而一般都组合使用，个人比较常用的是：

dstat -cmsdnl -D sda9 -N lo,eth0 100 5


```
### dstat的高级用法

```yml
dstat的高级用法
dstat的功能非常强大，除了上述常用用法外，还有一些大家不常用的高级用法，如下：
3.1 找出占用资源最高的进程和用户
--top-(io|bio|cpu|cputime|cputime-avg|mem) 通过这几个选项，可以看到具体是那个用户那个进程占用了相关系统资源，对系统调优非常有效。如查看当前占用I/O、cpu、内存等最高的进程信息可以使用dstat --top-mem --top-io --top-cpu：

作者：SkTj
链接：https://www.jianshu.com/p/a07b3786144b
来源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。

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