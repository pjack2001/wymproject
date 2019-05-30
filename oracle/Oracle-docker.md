## oracle-docker



### Oracle安装 

```yml

登录52
配置oracle数据库

使用sath89/oracle-12c镜像，５.7G
# docker pull 192.168.113.38/library/sath89/oracle-12c
# mkdir -p /u01/app/oracle
# chmod -R 777 /u01/app/oracle

# sudo docker run -d --restart=always -p 8080:8080 -p 5500:5500 -p 1521:1521 -v /u01/app/oracle:/u01/app/oracle -e DBCA_TOTAL_MEMORY=1024 --name oracle12c 192.168.113.38/library/sath89/oracle-12c

查看日志 
# docker logs -f 23e，发现正在创建数据库实例，安装成功

进入容器
# wym@rancher12:/u01/app/oracle$ docker exec -it 23e /bin/bash
# root@23e5750b5330:/# su oracle
# oracle@23e5750b5330:/$ cd $ORACLE_HOME

# oracle@23e5750b5330:/u01/app/oracle/product/12.1.0/xe$ bin/sqlplus / as sysdba

设置密码不限时间
# SQL> alter profile default limit password_life_time unlimited;
解锁system用户
# SQL> alter user system account unlock;
修改system用户的密码为oracle
# SQL> alter user system identified by oracle;

访问数据库的工具

DataGrip-2017.3.4
1、打开激活程序
# cd /media/w/n/work/python/Pythontool/pycharm/idea.lanyus.com注册/IntelliJIDEALicenseServer
# ./IntelliJIDEALicenseServer_linux_amd64

2、 打开安装好的pycharm，选择本机注册即可
# cd /media/w/n/work/python/Pythontool/pycharm/DataGrip-2017.3.4/bin 
# ./datagrip.sh


navicat启动
# cd /media/w/n/work/linux/Ubuntu16.04-bak/+tool/navicat_premium/navicat121_premium_cs_x64
# ./start_navicat

```
### 常用命令

```yml

Oracle用户命令
http://IP:1158/em            端口配置文件：portlist.ini
http://IP:5560/isqlplus  http://IP:5560/isqlplus/dba

$ imp ccense/ccense@t5 file=/home/opc/t5\(5.0.0600\).dmp log=*.log full=y

导出exp，不要加full参数
exp ccense/ccense@t5 file=/home/opc/t5\(5.0.0600\).dmp 
log=*.log
 
 ps -ef | grep ora
$ netca
$ dbca
$ lsnrctl status                start或stop
$ emctl status dbconsole        start或stop

$ sqlplus /nolog
SQL>conn as sysdba或conn，输入用户名和密码即可
Oracle中默认的用户名和密码如下表格：
用户名 / 密码                           登录身份                                  说明   
sys/change_on_install    SYSDBA 或 SYSOPER    不能以 NORMAL 登录，可作为默认的系统管理员   
system/manager            SYSDBA 或 NORMAL    不能以 SYSOPER 登录，可作为默认的系统管理员   
scott/tiger  

SQL> select username from dba_users;  查看用户列表
SQL> alter user 用户名 identified by 新密码;

$ sqlplus “/as sysdba” 或sqlplus / as sysdba
SQL>shutdown immediate
SQL>startup
SQL>startup mount;
SQL>alter database open;

SQL>conn ccense/ccense
SQL>help set
SQL>show user;
SQL> show release;              显示数据库的版本
SQL> show all;                  显示当前环境变量的值
SQL> show SGA;                  显示SGA的大小
SQL> show error;                显示当前在创建函数、存储过程、触发器、包等对象的错误信息
SQL>show parameter 参数名
SQL> select * from tab;         列出所有表
SQL> desc 表名;                 列出表结构
SQL> select name from v$datafile;             查看表空间文件
SQL> select name from v$tempfile;             查看临时表空间文件
SQL> select member from v$logfile;        查看日志文件
SQL> select name from v$controlfile;          查看控制文件
SQL>select name from v$database;              查看实例名
select * from v$version;

select a.sql_text from v$sqlarea a order by a.first_load_time desc;
select * from v$sqltext

SQL>select username,sid,serial# from v$session;
SQL>select * from table_name where trunc(日期字段)＝to_date('2003-05-02','yyyy-mm-dd');
SQL>select * into 表2 from 表1 where …     查询并新建
SQL>insert into 表2 (select * from 表1@链接 where...)
SQL>truncate table 表

```

### 配置Oracle客户端

```yml

#########################################################################

Ubuntu16.04安装Oracle Instant Client

下载
https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html?ssSourceSiteId=otncn

instantclient-basic-linux.x64-12.2.0.1.0.zip
instantclient-jdbc-linux.x64-12.2.0.1.0.zip
instantclient-odbc-linux.x64-12.2.0.1.0-2.zip
instantclient-sdk-linux.x64-12.2.0.1.0.zip
instantclient-sqlplus-linux.x64-12.2.0.1.0.zip
instantclient-tools-linux.x64-12.2.0.1.0.zip

解压安装
$ cd /media/xh/f/Oracle/instant client/12.2

$ unzip instantclient-basic-linux.x64-12.2.0.1.0.zip
$ unzip instantclient-sqlplus-linux.x64-12.2.0.1.0.zip
$ unzip xxx.zip

自然解压后，会生成“instantclient_12_2”目录，创建软链接
$ cd instantclient_12_2
$ sudo ln -s libclntsh.so.12.1 libclntsh.so
$ sudo ln -s libocci.so.12.1 libocci.so
$ sudo ln -s libclntshcore.so.12.1 libclntshcore.so

移动
sudo mv instantclient_12_2 /opt/instantclient

环境变量
$ sudo vim /etc/profile或.bash_profile

export ORACLE_HOME=/opt/instantclient
export LD_LIBRARY_PATH=/opt/instantclient
export TNS_ADMIN=/opt/instantclient
export PATH=$PATH:/opt/instantclient

生效
$ source /etc/profile

设置tnsnames.ora
$ sudo vim /opt/instantclient/tnsnames.ora

T6 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.102.226)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = t6)
    )
  )

$ cat tnsnames.ora
xe =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.113.52)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = xe)
    )
  )
 

安装依赖
$ sudo apt install libaio1

访问数据库
$ sqlplus ccense/ccense@t6
$ sqlplus datalook/newcapec@xe

```



### 资料

```yml

https://blog.csdn.net/Aria_Miazzy/article/details/85156895

Docker快速搭建Oracle12c
2018年12月21日 09:34:44 YumWisdom 阅读数：300
转载来源：https://hub.docker.com/r/sath89/oracle-12c/

 

Docker快速搭建Oracle12c
 


快速启动
使用Docker命令拉取oracle-12c镜像

docker pull sath89/oracle-12c
启动并暴露8080&1521端口，8080可以登录网页端管理，1521是数据连接端口:

docker run -d -p 8080:8080 -p 1521:1521 sath89/oracle-12c
启动并暴露8080&1521端口，并且挂载宿主机目录 /my/oracle/data 到oracle服务器/u01/app/oracle目录，这样database数据就保存在本地宿主机上：

docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle sath89/oracle-12c
 启动并定制化DBCA总内存大小，DBCA_TOTAL_MEMORY (in Mb):

docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle -e DBCA_TOTAL_MEMORY=1024 sath89/oracle-12c
 Orale服务器连接参数:

hostname: localhost
port: 1521
sid: xe
service name: xe
username: system
password: oracle
使用如下命令连接sqlplus:

 sqlplus system/oracle@//localhost:1521/xe 
Password for SYS & SYSTEM:

oracle
 Oracle Web管理端连接参数:

http://localhost:8080/apex
workspace: INTERNAL
user: ADMIN
password: 0Racle$
Apex upgrade up to v 5. （配置Apex   Oracle Application Express）*

docker run -it --rm --volumes-from ${DB_CONTAINER_NAME} --link ${DB_CONTAINER_NAME}:oracle-database -e PASS=YourSYSPASS sath89/apex install
Details could be found here: https://github.com/MaksymBilenko/docker-oracle-apex

Oracle Enterprise Management console （Oracle企业管理控制台）:

http://localhost:8080/em
user: sys
password: oracle
connect as sysdba: true
 配置环境变量参数，关闭Web CONSOLE:

docker run -d -e WEB_CONSOLE=false -p 1521:1521 -v /my/oracle/data:/u01/app/oracle sath89/oracle-12c
#You can Enable/Disable it on any time
启动Oracle，并加载初始化脚本:

docker run -d -p 1521:1521 -v /my/oracle/data:/u01/app/oracle -v /my/oracle/init/SCRIPTSorSQL:/docker-entrypoint-initdb.d sath89/oracle-12c
By default Import from docker-entrypoint-initdb.d is enabled only if you are initializing database (1st run).

To customize dump import use IMPDP_OPTIONS env variable like -e IMPDP_OPTIONS="REMAP_TABLESPACE=FOO:BAR" To run import at any case add -e IMPORT_FROM_VOLUME=true

In case of using DMP imports dump file should be named like ${IMPORT_SCHEME_NAME}.dmp

User credentials for imports are ${IMPORT_SCHEME_NAME}/${IMPORT_SCHEME_NAME}

If you have an issue with database init like DBCA operation failed, please reffer to this issue

 

标准版OracleSE12c DockerFile:
FROM sath89/oracle-12c-base
 
### This image is a build from non automated image cause of no possibility of Oracle 12c instalation in Docker container
 
ENV WEB_CONSOLE true
ENV DBCA_TOTAL_MEMORY 2048
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/u01/app/oracle/product/12.1.0/xe/bin
ENV USE_UTF8_IF_CHARSET_EMPTY true
 
ADD entrypoint.sh /entrypoint.sh
 
RUN apt-get update && apt-get -y install curl && apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* 
 
EXPOSE 1521
EXPOSE 8080
VOLUME ["/docker-entrypoint-initdb.d"]
 
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
 
企业版OracleEE12c DockerFile:
FROM sath89/docker-oracle-ee-12c-base:latest
 
ENV DBCA_TOTAL_MEMORY 4096
ENV WEB_CONSOLE true
 
ENV ORACLE_SID=EE
ENV ORACLE_HOME=/u01/app/oracle/product/12.2.0/EE
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/u01/app/oracle/product/12.2.0/EE/bin
ENV DISPLAY :0
ENV VNC_PASSWORD oracle
ENV MANUAL_DBCA false
 
RUN yum install -y epel-release && yum install -y xorg-x11-server-Xvfb x11vnc fluxbox xterm novnc && yum clean all
 
ADD entrypoint.sh /entrypoint.sh
 
EXPOSE 1521
EXPOSE 8080
EXPOSE 6800
VOLUME ["/docker-entrypoint-initdb.d"]
 
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
 

TODO LIST
Web management console HTTPS port
Add functionality to run custom scripts on startup, for example User creation
Add Parameter that would setup processes amount for database (Currently by default processes=300)
Spike with clustering support
Spike with DB migration from 11g
In case of any issues please post it here.

 

OracleEE12c Docker镜像介绍：
sath89/docker-oracle-ee-12c-base

This image is not ready to work. Cause of issues with Oracle 12c install on docker I'd have to do manual install on VM and transfer install files. Dockerfile with this build are available here: https://github.com/MaksymBilenko/docker-oracle-ee-12c/oracle-ee-12c-base

If you would like to use/fork this image you need to perform this steps to make it work:

chown -R oracle:dba /u01/app/oracle rm -f /u01/app/oracle/product ln -s /u01/app/oracle-product /u01/app/oracle/product

#Start tnslsnt su oracle -c "/u01/app/oracle/product/12.2.0/EE/bin/tnslsnr &"

#Create Database: su oracle -c "$ORACLE_HOME/bin/dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbname xe.oracle.docker -sid xe -responseFile NO_VALUE -characterSet AL32UTF8 -totalMemory 512 -emConfiguration LOCAL -pdbAdminPassword oracle -sysPassword oracle -systemPassword oracle"

 

参考资料：https://hub.docker.com/r/sath89/oracle-ee-12c

参考资料：https://github.com/MaksymBilenko/docker-oracle-ee-12c/oracle-ee-12c-base

```

```yml
http://blog.sina.com.cn/s/blog_a32eff280102xaia.html

mritschel/oracle12cr2_base
Last pushed: 6 months ago
Repo InfoTags
Short Description
Docker Basis Image for Oracle Database 12c Release 2
Full Description
Oracle Linunx with Oracle Database 12c Release 2 installation
Content
Oracle Linux Server release 7.3
Oracle Database 12.2.0.1 Standard Edition 2
Perl 5, version 14
Pull the latest trusted build from here.
Installation
Using Default Settings (recommended)
Complete the following steps to create a new container:
Pull the image
docker pull mritschel/oracle12cr2_base
Create the container
docker run -d -p 8080:8080 -p 5500:5500 -p 1521:1521 -v [:]/u01/oracle/oradata --name oracle-base mritschel/oracle12cr2_base
wait around 5 minutes until the image is downloaded. Check logs with docker logs oracle base. The container stops if an error occurred.
Check the logs to determine how to proceed.

On first startup of the container a new database will be created, the following lines highlight when the database is ready to be used:
###################################
Database is started and ready!
###################################
Options
Environment Variables
You may set the environment variables in the docker run statement to configure the container setup process. The following table lists all environment variables with its default values:
Environment variable
Default value
Comments
DBCA_TOTAL_MEMORY
1024
Keep in mind that DBCA fails if you set this value too low
ORACLE_BASE
/u01/app/oracle
Oracle Base directory
ORACLE_HOME
/u01/app/oracle/product/12.1.0.2/dbhome_1
Oracle Home directory
PATH
$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH \
Path
ORACLE_SID
ORCLCDB
The Oracle SID
SOFTWARE_HOME
$ORACLE_BASE/install
Install directory
SCRIPTS_HOME
$ORACLE_BASE
Scripts directory
Database Connections
Once the container has been started and the database created you can connect to it just like to any other database:
sqlplus sys/@//localhost:1521/ as sysdba
sqlplus system/@//localhost:1521/
sqlplus pdbadmin/@//localhost:1521/
The Oracle Database inside the container also has Oracle Enterprise Manager Express configured. To access OEM Express, start your browser and follow the URL:
https://localhost:5500/em/
NOTE: Oracle Database bypasses file system level caching for some of the files by using the O_DIRECT flag. It is not advised to run the container on a file system that does not support the O_DIRECT flag.
Changing the admin accounts passwords
On the first startup of the container a random password will be generated for the database. You can find this password in the output line:
######################################################################
Automatic generated password fOr the user SYS, SYSTEM AND PDBAMIN is
######################################################################
The password for those accounts can be changed via the docker exec command. Note, the container has to be running:
docker exec ./set_Password.sh
Backup
Complete the following steps to backup the data volume:
Stop the container with
docker stop oracle-base
Backup the data volume to a compressed file `oracle-base.tar.gz in the current directory with a little help from the linux image
docker run --rm --volumes-from oracle12cr2_base -v $(pwd):/backup linux tar czvf /backup/oracle12cr2_base.tar.gz /u01/app/oracle
Restart the container
docker start oracle12cr2_base
Issues
Please file your bug reports, enhancement requests, questions and other support requests within Github's issue tracker:
Existing issues
License
Docker Image oracle12cr2_base is licensed under the Apache License, Version 2.0. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
See Oracle Database Licensing Information User Manual and Oracle Database 12c Standard Edition 2 for further information.

https://hub.docker.com/r/mritschel/oracle12cr2_base/


```

```yml
基于Docker的Oracle12c的学习与使用
2018年08月18日 12:48:14 小gu 阅读数：2637
基于Docker的Oracle12c的学习与使用
1.安装docker ce
不再赘述。

2.拉取镜像
注意拉取镜像时间较长，建议在最好在空闲或者网络比较好的时间段拉取

$ docker pull mritschel/oracle12cr2_base


下载完成后查看镜像

$ docker images


3.创建容器:
方式一：创建端口运行，每次退出数据不会保留
$ docker run -d -p 8080:8080 -p 1521:1521 sath89/oracle-12c
方式二：使用数据卷实现容器数据分离，实现数据持久化(本次采用)
 $ docker run -d -p 8080:8080 -p 5500:5500 -p 1521:1521 -v /home/gugu/oradata:/u01/app/oracle --name oracle-base mritschel/oracle12cr2_base
解释:-d后台运行容器，并返回容器id，-p指定端口映射关系 -v指定数据卷位置

在上面的docker run命令中的参数如下

参数名

默认值

备注

DBCA_TOTAL_MEMORY

1024

如果将此值设置得太低，DBCA将失败

ORACLE_BASE

/u01/app/oracle

基础路径

ORACLE_HOME

/u01/app/oracle/product/12.1.0.2/dbhome_1

主目录

PATH

$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH \

 

ORACLE_SID

ORCLCDB

SID

SOFTWARE_HOME

$ORACLE_BASE/install

安装路径

SCRIPTS_HOME

$ORACLE_BASE

脚本路径



查看日志:

$ docker logs oracle-base


最下面可以找到



说明Oracle正常启动和创建实例，耐心等待一下，如果分分钟创建成功，就需要查看是不是创建失败了解读一下日志，可以比较方便的分析出原因。



说明您的数据库实例化并且准备就绪

查看docker运行进程

$ docker ps


4.进入系统
$ docker exec -it oracle-base /bin/bash


5.重置oracle密码
运行脚本

$ ./set_password.sh password
 

6.Sqlplus登录
$ sqlplus system/asd@//localhost:1521/ORCLCDB


本地的navicat测试

 

美滋滋。

参考说明
官方解说

```