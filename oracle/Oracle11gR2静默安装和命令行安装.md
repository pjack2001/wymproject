


## Oracle 11gR2静默安装 & 命令行安装




```

https://www.cnblogs.com/ivictor/p/4384583.html

Oracle 11gR2静默安装 & 命令行安装

### 静默安装


经常搭建Oracle测试环境，有时候觉得OUI（即图形界面）方式甚是繁琐，你得一步一步进行确认，所幸，Oracle支持静默安装。在我看来，它主要有两方面的好处：一、极大地提升了效率，尤其是批量安装。二、很多时候，只有终端环境可供使用。

```

### 一、准备responseFile文件

```
    从Oracle软件中获取文件模板

[oracle@node2 ~]$ cd database/response/
dbca.rsp        db_install.rsp  netca.rsp
   其中database是Oracle软件解压后生成的目录。可见在response目录下有三个模板，其中dbca.rsp是用来创建数据库的。db_install.rsp是用来安装Oracle软件的。netca.rsp是用来创建监听器的。当然也可在db_install.rsp中直接创建数据库。在这里，为求方便，我们选择db_install.rsp模板一并安装软件，创建数据库。
```


### 二、编辑responseFile文件

```

[oracle@node2 ~]$ grep -Ev "^$|^#" db_install.rsp 

oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_AND_CONFIG
ORACLE_HOSTNAME=node2.being.com
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/u01/app/oracle/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/u01/app/oracle/product/11.2.0.1/db_1
ORACLE_BASE=/u01/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=false
oracle.install.db.optionalComponents=oracle.rdbms.partitioning:11.2.0.4.0,oracle.oraolap:11.2.0.4.0,oracle.rdbms.dm:11.2.0.4.0,oracle.rdbms.dv:11.2.0.4.0,oracle.rdbms.lbac:11.2.0.4.0,oracle.rdbms.rat:11.2.0.4.0
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=oper
oracle.install.db.CLUSTER_NODES=
oracle.install.db.isRACOneInstall=
oracle.install.db.racOneServiceName=
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.config.starterdb.globalDBName=orcl
oracle.install.db.config.starterdb.SID=orcl
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.memoryOption=true
oracle.install.db.config.starterdb.memoryLimit=400
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.enableSecuritySettings=true
oracle.install.db.config.starterdb.password.ALL=oracle
oracle.install.db.config.starterdb.password.SYS=
oracle.install.db.config.starterdb.password.SYSTEM=
oracle.install.db.config.starterdb.password.SYSMAN=
oracle.install.db.config.starterdb.password.DBSNMP=
oracle.install.db.config.starterdb.control=DB_CONTROL
oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=
oracle.install.db.config.starterdb.automatedBackup.enable=false
oracle.install.db.config.starterdb.automatedBackup.osuid=
oracle.install.db.config.starterdb.automatedBackup.ospwd=
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=/u01/app/oracle/oradata
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=/u01/app/oracle/fast_recovery_area
oracle.install.db.config.asm.diskGroup=
oracle.install.db.config.asm.ASMSNMPPassword=
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=
SECURITY_UPDATES_VIA_MYORACLESUPPORT=
DECLINE_SECURITY_UPDATES=true
PROXY_HOST=
PROXY_PORT=
PROXY_USER=
PROXY_PWD=
PROXY_REALM=
COLLECTOR_SUPPORTHUB_URL=
oracle.installer.autoupdates.option=SKIP_UPDATES
oracle.installer.autoupdates.downloadUpdatesLoc=
AUTOUPDATES_MYORACLESUPPORT_USERNAME=
AUTOUPDATES_MYORACLESUPPORT_PASSWORD=


注意部分如上所示，关于每个参数的说明，可参考模板中的解释。

```

#### db_install.rsp详解，oracle静默安装应答文件详解
```


《11gR2使用dbca静默(silent)创建RAC数据库》http://space.itpub.net/?uid-23135684-action-viewspace-itemid-747223

    Oracle Database 11gR2软件静默安装是一件非常容易的事情，解压了安装软件之后，会看到如下的目录结构：
[oracle@redhat6 database]$ ls
doc/  install/ readme.html*  response/  rpm/  runInstaller*  sshsetup/  stage/  welcome.html*

    使用静默方式安装软件跟使用图形化方式的最大区别在于，在安装前需要将整个安装过程会选择和填入的参数以文本的方式提前设置好，执行安装的时候只需要指定该文件即可自动的以silent和非图形化的形式完成整个安装过程，这个保存配置的文件叫做响应文件，response是响应文件目录，其中包含了3个响应文件：
[oracle@redhat6 response]$ ls
dbca.rsp*  db_install.rsp*  netca.rsp*
    
    db_install.rsp是用于安装Database的响应文件，dbca.rsp是用于创建数据库的响应文件，netca.rsp是用于创建监听器的响应文件。每个响应文件打开之后都有详细的说明，包括哪些参数，参数的含义及参数的可选项。以db_install.rsp为例，在该文件中对每个参数的含义、选项都做了详细的说明，下面是对db_install.rsp修改的值，用于Oracle Database 11gR2软件的安装(以下配置仅供修改参考，不可直接使用)。


/home/oracle/db.rsp
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0//标注响应文件版本
oracle.install.option=INSTALL_DB_SWONLY//.只装数据库软件
ORACLE_HOSTNAME=主机名
UNIX_GROUP_NAME=oinstall//指定oracle inventory目录的所有者
INVENTORY_LOCATION=/u01/app/oraInventory指定产品清单oracle inventory目录的路径
SELECTED_LANGUAGES=en,zh_CN//指定语言
ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_home1//设置oracle_HOME的路径
ORACLE_BASE=/u01/app/oracle//指定oracle_BASE的路径
oracle.install.db.InstallEdition=EE//安装数据库软件的版本，企业版
oracle.install.db.EEOptionsSelection=false//手动指定企业安装组件
oracle.install.db.optionalComponents=oracle.rdbms.partitioning:11.2.0.4.0,oracle.oraolap:11.2.0.4.0,oracle.rdbms.dm:11.2.0.4.0,oracle.rdbms.dv:11.2.0.4.0,oracle.rdbms.lbac:11.2.0.4.0,oracle.rdbms.rat:11.2.0.4.0//如果上面选true，这些就是手动指定的组件
oracle.install.db.DBA_GROUP=dba//指定拥有DBA用户组，通常会是dba组
oracle.install.db.OPER_GROUP=oper//指定oper用户组
oracle.install.db.CLUSTER_NODES=//指定所有的节点
oracle.install.db.isRACOneInstall=false//是否是RACO方式安装
oracle.install.db.racOneServiceName=
oracle.install.db.config.starterdb.type=//选择数据库的用途，一般用途/事物处理，数据仓库
oracle.install.db.config.starterdb.globalDBName=指定GlobalName
oracle.install.db.config.starterdb.SID=//你指定的SID
oracle.install.db.config.starterdb.characterSet=AL32UTF8//设置数据库编码
oracle.install.db.config.starterdb.memoryOption=true//11g的新特性自动内存管理，也就是SGA_TARGET和PAG_AGGREGATE_TARGET都，不用设置了，Oracle会自动调配两部分大小
oracle.install.db.config.starterdb.memoryLimit=指定Oracle自动管理内存的大小
oracle.install.db.config.starterdb.installExampleSchemas=false是否载入模板示例
oracle.install.db.config.starterdb.enableSecuritySettings=true  是否启用安全设置
oracle.install.db.config.starterdb.password.ALL=123456所有用户名的密码
oracle.install.db.config.starterdb.password.SYS=
oracle.install.db.config.starterdb.password.SYSTEM=
oracle.install.db.config.starterdb.password.SYSMAN=
oracle.install.db.config.starterdb.password.DBSNMP=
oracle.install.db.config.starterdb.control=DB_CONTROL数据库本地管理工具DB_CONTROL，远程集中管理工具GRID_CONTROL
oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=GRID_CONTROL需要设定grid control的远程路径URL
oracle.install.db.config.starterdb.automatedBackup.enable=false设置自动备份
oracle.install.db.config.starterdb.automatedBackup.osuid=.自动备份会启动一个job，指定启动JOB的系统用户ID
oracle.install.db.config.starterdb.automatedBackup.ospwd=自动备份会开启一个job，需要指定OSUser的密码
oracle.install.db.config.starterdb.storageType=要求指定使用的文件系统存放数据库文件还是ASM
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=使用文件系统存放数据库文件才需要指定数据文件、控制文件、Redo log的存放目录
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=使用文件系统存放数据库文件才需要指定备份恢复目录
oracle.install.db.config.asm.diskGroup=使用ASM存放数据库文件才需要指定存放的磁盘组
oracle.install.db.config.asm.ASMSNMPPassword=使用ASM存放数据库文件才需要指定ASM实例密码
MYORACLESUPPORT_USERNAME=指定metalink账户用户名
MYORACLESUPPORT_PASSWORD=指定metalink账户密码
SECURITY_UPDATES_VIA_MYORACLESUPPORT=用户是否可以设置metalink密码
DECLINE_SECURITY_UPDATES=true是否设置安全更新，
PROXY_HOST=代理服务器名
PROXY_PORT=代理服务器端口
PROXY_USER=代理服务器用户名
PROXY_PWD=代理服务器密码
PROXY_REALM=
COLLECTOR_SUPPORTHUB_URL=
oracle.installer.autoupdates.option=自动更新
oracle.installer.autoupdates.downloadUpdatesLoc=自动更新下载目录
AUTOUPDATES_MYORACLESUPPORT_USERNAME=自动更新的用户名
AUTOUPDATES_MYORACLESUPPORT_PASSWORD=自动更新的密码

--------------------- 
作者：yinzhipeng123 
来源：CSDN 
原文：https://blog.csdn.net/yinzhipeng123/article/details/53141950 
版权声明：本文为博主原创文章，转载请附上博文链接！

```







### 三、 静默安装

```
      [oracle@node2 database]$ ./runInstaller -help

      如果对runInstaller的参数不是很了解的话，可通过该命令进行查看。



[oracle@node2 database]$ ./runInstaller -help

Preparing to launch Oracle Universal Installer from /tmp/OraInstall2015-04-01_10-05-47PM. Please wait ...[oracle@node2 database]$ Usage: 
runInstaller  [-options] [(<CommandLineVariable=Value>)*]

Where options include:
  -clusterware oracle.crs,<crs version>  
    Version of Cluster ready services installed.

  -crsLocation <Path>  
    Used only for cluster installs, specifies the path to the crs home location. Specifying this overrides CRS information obtained from central inventory.

  -invPtrLoc <full path of oraInst.loc>  
    Unix only. To point to a different inventory location. The orainst.loc file contains:
inventory_loc=<location of central inventory>
inst_group=<> 

  -jreLoc <location>  
    Path where Java Runtime Environment is installed. OUI cannot be run without it.

  -logLevel <level>  
    To filter log messages that have a lesser priority level than <level>. Valid options are: severe, warning, info, config, fine, finer, finest, basic, general, detailed, trace. The use of basic, general, detailed, trace is deprecated.

  -paramFile <location of file>  
    Specify location of oraparam.ini file to be used by OUI.

  -responseFile <Path>  
    Specifies the response file and path to use.

  -attachHome  
    For attaching homes to the OUI inventory.

  -cfs  
    Indicates that the Oracle home specified is on cluster file system (shared). This is mandatory when '-local' is specified so that Oracle Universal Installer can register the home appropriately into the inventory.

  -clone  
    For making an Oracle Home copy match its current environment.

  -debug  
    For getting the debug information from OUI.

  -detachHome  
    For detaching homes from the OUI inventory without deleting inventory directory inside Oracle home.

  -enableRollingUpgrade  
    Used in cluster environment, to enable upgrade of a product on a subset of nodes (on which the product was installed). 

  -executeSysPrereqs  
    Execute system pre-requisite checks and exit.

  -force  
    Allowing silent mode installation into a non-empty directory.

  -help  
    Displays above usage.

  -ignoreSysPrereqs  
    For ignoring the results of the system pre-requisite checks.

  -local  
    Performs the operation on the local node irrespective of the cluster nodes specified.

  -printdiskusage  
    Log debug information for disk usage.

  -printmemory  
    Log debug information for memory usage.

  -printtime  
    Log debug information for time usage.

  -relink  
    For performing relink actions on the oracle home 
     Usage: -relink -maketargetsxml <location of maketargetsxml> [-makedepsxml <location of makedepsxml>] [name=value] 

  -silent  
    For silent mode operations, the inputs can be a response file or a list of command line variable value pairs.

  -waitforcompletion  
    Installer will wait for completion instead of spawning the java engine and exiting.

  -suppressPreCopyScript  
    Suppress the execution of precopy script.

  -acceptUntrustedCertificates  
    Accept untrusted certificates from a secure site.

  -suppressPostCopyScript  
    Suppress the execution of postcopy script.

  -noconfig  
    Do not execute config tools.

  -noconsole  
    For suppressing display of messages to console. Console is not allocated.

  -formCluster  
    To install the Oracle clusterware in order to form the cluster.

  -remotecp <Path>  
    Unix specific option. Used only for cluster installs, specifies the path to the remote copy program on the local cluster node.

  -remoteshell <Path>  
    Unix specific option. Used only for cluster installs, specifies the path to the remote shell program on the local cluster node.

  -executePrereqs
    To execute only the prerequisite checks.

  -ignorePrereq
    To ignore running the prerequisite checks.

  -ignoreInternalDriverError
    To ignore any internal driver errors.

  -downloadUpdates
    To download updates only.

  -showProgress
    To show the installation progress on the console. This option is supported only in case of silent installation.

Command Line Variables Usage
  Command line variables are specified using <name=value>; for example:
    [ session: | compName: | compName:version: ]variableName=" valueOfVariable"]

   Session/Installer variables are specified using:
          [session:]varName=value
    Ex 1: session:ORACLE_HOME_NAME="OraHome"
    Ex 2: ORACLE_HOME_NAME="OraHome"
    The lookup order is session:varName then just varName. The session prefix is used to avoid ambiguity.

   Component variables are specified using:
          [compInternalName:[Version:]]varName
    Ex 1: oracle.comp1:1.0.1:varName="VarValue"
    Ex 2: oracle.comp1:varName="VarValue"
    The lookup order is compInternalName:Version:varName, then compInternalName:varName, then just varName.

```
    
### 开始静默安装

```
    [oracle@node2 database]$ ./runInstaller -silent -ignoreSysPrereqs -showProgress -responseFile /home/oracle/db_install.rsp

    其中-silent指的是静默安装，-ignorePrereq忽略prerequisite的检查结果，showProgress显示进度，responseFile是种子文件。


[oracle@node2 database]$ ./runInstaller -silent -ignorePrereq -showProgress -responseFile /home/oracle/db_install.rsp 
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 3073 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 3999 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2015-04-01_10-13-42PM. Please wait ...[oracle@node2 database]$ [WARNING] [INS-32055] The Central Inventory is located in the Oracle base.
   CAUSE: The Central Inventory is located in the Oracle base.
   ACTION: Oracle recommends placing this Central Inventory in a location outside the Oracle base directory.
[WARNING] [INS-30011] The ADMIN password entered does not conform to the Oracle recommended standards.
   CAUSE: Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9].
   ACTION: Provide a password that conforms to the Oracle recommended standards.
You can find the log of this install session at:
 /u01/app/oracle/oraInventory/logs/installActions2015-04-01_10-13-42PM.log

Prepare in progress.
..................................................   8% Done.

Prepare successful.

Copy files in progress.
..................................................   15% Done.
..................................................   21% Done.
..................................................   27% Done.
..................................................   34% Done.
..................................................   39% Done.
..................................................   44% Done.
..................................................   52% Done.
..................................................   57% Done.
..................................................   62% Done.
..................................................   67% Done.
........................................
Copy files successful.

Link binaries in progress.
..........
Link binaries successful.

Setup files in progress.
..................................................   72% Done.
..............................
Setup files successful.
The installation of Oracle Database 11g was successful.
Please check '/u01/app/oracle/oraInventory/logs/silentInstall2015-04-01_10-13-42PM.log' for more details.

Oracle Net Configuration Assistant in progress.
..................................................   86% Done.

Oracle Net Configuration Assistant successful.

Oracle Database Configuration Assistant in progress.
..................................................   95% Done.

Oracle Database Configuration Assistant successful.

Execute Root Scripts in progress.

As a root user, execute the following script(s):
    1. /u01/app/oracle/oraInventory/orainstRoot.sh
    2. /u01/app/oracle/product/11.2.0.1/db_1/root.sh


..................................................   100% Done.

Execute Root Scripts successful.
Successfully Setup Software.


    最后，需root用户手动执行以下两个文件：

    1. /u01/app/oracle/oraInventory/orainstRoot.sh

    2. /u01/app/oracle/product/11.2.0.1/db_1/root.sh

    当然，也可查看/u01/app/oracle/oraInventory/logs/installActions2015-04-01_10-13-42PM.log了解具体的安装信息。

```


### 命令行安装

```
首先来看dbca命令行支持哪些参数。


[oracle@node2 ~]$ dbca -help
dbca  [-silent | -progressOnly | -customCreate] {<command> <options> }  | { [<command> [options] ] -responseFile  <response file > } [-continueOnNonFatalErrors <true | false>]
Please refer to the manual for details.
You can enter one of the following command:

Create a database by specifying the following parameters:
    -createDatabase
        -templateName <name of an existing template in default location or the complete template path>
        [-cloneTemplate]
        -gdbName <global database name>
        [-sid <database system identifier>]
        [-sysPassword <SYS user password>]
        [-systemPassword <SYSTEM user password>]
        [-emConfiguration <CENTRAL|LOCAL|ALL|NONE>
            -dbsnmpPassword <DBSNMP user password>
            -sysmanPassword <SYSMAN user password>
            [-hostUserName <Host user name for EM backup job>
             -hostUserPassword <Host user password for EM backup job>
             -backupSchedule <Daily backup schedule in the form of hh:mm>]
            [-centralAgent <Enterprise Manager central agent home>]]
        [-disableSecurityConfiguration <ALL|AUDIT|PASSWORD_PROFILE|NONE>
        [-datafileDestination <destination directory for all database files> |  -datafileNames <a text file containing database objects such as controlfiles, tablespaces, redo log files and spfile to their corresponding raw device file names mappings in name=value format.>]
        [-redoLogFileSize <size of each redo log file in megabytes>]
        [-recoveryAreaDestination <destination directory for all recovery files>]
        [-datafileJarLocation  <location of the data file jar, used only for clone database creation>]
        [-storageType < FS | ASM > 
            [-asmsnmpPassword     <ASMSNMP password for ASM monitoring>]
             -diskGroupName   <database area disk group name>
             -recoveryGroupName       <recovery area disk group name>
        [-characterSet <character set for the database>]
        [-nationalCharacterSet  <national character set for the database>]
        [-registerWithDirService <true | false> 
            -dirServiceUserName    <user name for directory service>
            -dirServicePassword    <password for directory service >
            -walletPassword    <password for database wallet >]
        [-listeners  <list of listeners to configure the database with>]
        [-variablesFile   <file name for the variable-value pair for variables in the template>]]
        [-variables  <comma separated list of name=value pairs>]
        [-initParams <comma separated list of name=value pairs>]
        [-sampleSchema  <true | false> ]
        [-memoryPercentage <percentage of physical memory for Oracle>]
        [-automaticMemoryManagement ]
        [-totalMemory <memory allocated for Oracle in MB>]
        [-databaseType <MULTIPURPOSE|DATA_WAREHOUSING|OLTP>]]

Configure a database by specifying the following parameters:
    -configureDatabase
        -sourceDB    <source database sid>
        [-sysDBAUserName     <user name  with SYSDBA privileges>
         -sysDBAPassword     <password for sysDBAUserName user name>]
        [-registerWithDirService|-unregisterWithDirService|-regenerateDBPassword <true | false> 
            -dirServiceUserName    <user name for directory service>
            -dirServicePassword    <password for directory service >
            -walletPassword    <password for database wallet >]
        [-disableSecurityConfiguration <ALL|AUDIT|PASSWORD_PROFILE|NONE>
        [-enableSecurityConfiguration <true|false>
        [-emConfiguration <CENTRAL|LOCAL|ALL|NONE>
            -dbsnmpPassword <DBSNMP user password>
            -sysmanPassword <SYSMAN user password>
            [-hostUserName <Host user name for EM backup job>
             -hostUserPassword <Host user password for EM backup job>
             -backupSchedule <Daily backup schedule in the form of hh:mm>]
            [-centralAgent <Enterprise Manager central agent home>]]


Create a template from an existing database by specifying the following parameters:
    -createTemplateFromDB
        -sourceDB    <service in the form of <host>:<port>:<sid>>
        -templateName      <new template name>
        -sysDBAUserName     <user name  with SYSDBA privileges>
        -sysDBAPassword     <password for sysDBAUserName user name>
        [-maintainFileLocations <true | false>]


Create a clone template from an existing database by specifying the following parameters:
    -createCloneTemplate
        -sourceSID    <source database sid>
        -templateName      <new template name>
        [-sysDBAUserName     <user name  with SYSDBA privileges>
         -sysDBAPassword     <password for sysDBAUserName user name>]
        [-maintainFileLocations <true | false>]
        [-datafileJarLocation       <directory to place the datafiles in a compressed format>]

Generate scripts to create database by specifying the following parameters:
    -generateScripts
        -templateName <name of an existing template in default location or the complete template path>
        -gdbName <global database name>
        [-scriptDest       <destination for all the scriptfiles>]

Delete a database by specifying the following parameters:
    -deleteDatabase
        -sourceDB    <source database sid>
        [-sysDBAUserName     <user name  with SYSDBA privileges>
         -sysDBAPassword     <password for sysDBAUserName user name>]
Query for help by specifying the following options: -h | -help

由此来看，dbca命令行参数还是及其丰富的，完全可DIY建库。

```



##### 下面，用最少参数建了一个库。

```
[oracle@node2 trace]$ dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName test -sysPassword oracle -systemPassword oracle
注意，密码需指定，不然会有以下提示

A value for the command line argument "systemPassword" is not provided. We cannot proceed without a value for this argument.                      
最后输出结果如下：

复制代码
Copying database files                                                   
1% complete                                                                                                              
3% complete                                                                                                              
11% complete                                                                                                             
18% complete                                                                                                             
26% complete                                                                                                             
37% complete                                                                                                             
Creating and starting Oracle instance                                                                                    
40% complete                                                                                                             
45% complete                                                                                                             
50% complete                                                                                                             
55% complete                                                                                                             
56% complete                                                                                                             
60% complete                                                                                                             
62% complete                                                                                                             
Completing Database Creation                                                                                             
66% complete
70% complete
73% complete
85% complete
96% complete
100% complete
Look at the log file "/u01/app/oracle/cfgtoollogs/dbca/test/test.log" for further details.


注意：建库时的日志信息可在$ORACLE_BASE/cfgtoollogs/dbca/<dbname>下查看。



```


### 静默(silent)安装Oracle错误

```

2016年04月01日 09:44:00 零碎梦颜 阅读数：2888
  
              《11gR2使用dbca静默(silent)创建RAC数据库》http://space.itpub.net/?uid-23135684-action-viewspace-itemid-747223

    Oracle Database 11gR2软件静默安装是一件非常容易的事情，解压了安装软件之后，会看到如下的目录结构：
[oracle@redhat6 database]$ ls
doc/  install/ readme.html*  response/  rpm/  runInstaller*  sshsetup/  stage/  welcome.html*

    使用静默方式安装软件跟使用图形化方式的最大区别在于，在安装前需要将整个安装过程会选择和填入的参数以文本的方式提前设置好，执行安装的时候只需要指定该文件即可自动的以silent和非图形化的形式完成整个安装过程，这个保存配置的文件叫做响应文件，response是响应文件目录，其中包含了3个响应文件：
[oracle@redhat6 response]$ ls
dbca.rsp*  db_install.rsp*  netca.rsp*
    
    db_install.rsp是用于安装Database的响应文件，dbca.rsp是用于创建数据库的响应文件，netca.rsp是用于创建监听器的响应文件。每个响应文件打开之后都有详细的说明，包括哪些参数，参数的含义及参数的可选项。以db_install.rsp为例，在该文件中对每个参数的含义、选项都做了详细的说明，下面是对db_install.rsp修改的值，用于Oracle Database 11gR2软件的安装(以下配置仅供修改参考，不可直接使用)。

oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/u01/app/oraInventory
ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
ORACLE_BASE=/u01/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=true
oracle.install.db.optionalComponents=oracle.rdbms.partitioning:11.2.0.3.0,oracle.oraolap:11.2.0.3.0,oracle.rdbms.dm:11.2.0.3.0,oracle.rdbms.lbac:11.2.0.3.0,oracle.rdbms.rat:11.2.0.3.0
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=oper
oracle.install.db.isRACOneInstall=false
DECLINE_SECURITY_UPDATES=true

    以上配置只会安装单机环境的数据库软件，不会创建数据库。
    其中DECLINE_SECURITY_UPDATES一定要设置成true，否则在安装的时候会出现以下的告警：
[WARNING] - My Oracle Support Username/Email Address Not Specified
[SEVERE] - Provide the My Oracle Support password.
无法继续安装。
    根据不同的安装要求，会编辑填入不同的值，在编辑之前需要首先熟悉图形化安装的过程，哪些情况下需要填入哪些值，哪些情况下不需要填入哪些值要有所了解。例如，如果是只安装软件的情况下，db_install.rsp响应文件中和创建数据库相关的值就不需要理会。

    下面是编辑好db_install.rsp响应文件后，执行runInstaller命令以静默方式安装Oracle Database 11gR2软件的过程。
[oracle@redhat6 database]$ ./runInstaller -silent -noconfig -responseFile /u01/soft/database/response/db_install.rsp -ignoreSysPrereqs
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 22653 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 9762 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2012-08-26_11-39-09AM. Please wait ...[oracle@redhat6 database]$ [WARNING] [INS-13014] Target environment do not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. /u01/app/oraInventory/logs/installActions2012-08-26_11-39-09AM.log
   ACTION: Identify the list of failed prerequisite checks from the log: /u01/app/oraInventory/logs/installActions2012-08-26_11-39-09AM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
You can find the log of this install session at:
 /u01/app/oraInventory/logs/installActions2012-08-26_11-39-09AM.log
The installation of Oracle Database 11g was successful.
Please check '/u01/app/oraInventory/logs/silentInstall2012-08-26_11-39-09AM.log' for more details.

As a root user, execute the following script(s):
1. /u01/app/oracle/product/11.2.0/db_1/root.sh


Successfully Setup Software.

      整个执行过程大部分时间都是在后台完成的，而且可能等待好一会儿才会有响应，所以需要耐心等待，通过监控/u01/app/oracle目录的大小可以确定完成的情况，按照以上的配置完成安装后/u01/app/oracle目录的大小为4.1GB。
      在最后会提示执行root.sh脚本，在新的会话窗口执行root.sh脚本：
[root@redhat6 ~]# /u01/app/oracle/product/11.2.0/db_1/root.sh
Check /u01/app/oracle/product/11.2.0/db_1/install/root_redhat6.localdomain_2012-08-26_12-16-30.log for the output of root script
    执行结果也是没有前台显示出来。

    runInstaller脚本的responseFile参数指定的路径最好是完整的路径，否则可能找不到相应的响应文件。通过执行./runInstaller -help可以看到runInstaller脚本详细的帮助信息。
    
    另外，除了有相应的响应模板文件直接编辑意外，还可以在图形化安装的时候生成相应的响应文件，在此基础上进行编辑也是非常的方便。下图是使用图形化方式安装Oracle 11gR2 Database软件，最后的Summary界面：


    点击"Save Response File..."按钮即可保存配置对应的响应文件。

    除了Database数据库软件可以slient安装外，Grid Infrastructure，创建数据库，监听器等都可以通过静默的方式安装，方法都是类似的，编辑对应的响应文件，使用相应的工具执行即可。

    本次配置完整的db_install.rsp响应文件可以到这里下载db_install.rsp。

    如果是静默安装Oracle RAC Database软件，参考以下步骤：
1）.手动建立服务器的oracle系统用户之间的用户有效性，完成之后在两个节点执行以下命令：
$ssh rac1 date
$ssh rac2 date
    RAC的所有节点相互之间的等效性都必须配置成功！

2）.使用CVU工具验证安装环境：
    登录到oracle用户，切换到$GRID_HOME/bin目录，执行如下命令验证安装环境：
./cluvfy stage -pre dbinst -n rac1,rac2 -verbose

3）.配置响应文件：
    除了以上的响应文件配置外还需要配置：
oracle.install.db.CLUSTER_NODES=rac1,rac2

4）.在oracle用户下执行runInstaller命令开始静默安装Database软件：
[oracle@rac1 database]$ ./runInstaller -silent -noconfig -responseFile /u01/soft/database/response/db_install.rsp -ignoreSysPrereqs -ignorePrereq -showprogress

Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 35919 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 10236 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2012-11-06_05-27-35PM. Please wait ...[oracle@rac1 database]$ You can find the log of this install session at:
 /u01/app/oraInventory/logs/installActions2012-11-06_05-27-35PM.log

Prepare in progress.
..................................................   9% Done.

Prepare successful.

Copy files in progress.
..................................................   15% Done.
..................................................   20% Done.
..................................................   27% Done.
..................................................   32% Done.
..................................................   37% Done.
..................................................   44% Done.
..................................................   49% Done.
..................................................   54% Done.
....................
Copy files successful.
..................................................   60% Done.

Link binaries in progress.

Link binaries successful.
..................................................   77% Done.

Setup files in progress.
..................................................   94% Done.

Setup files successful.
The installation of Oracle Database 11g was successful.
Please check '/u01/app/oraInventory/logs/silentInstall2012-11-06_05-27-35PM.log' for more details.

Execute Root Scripts in progress.

As a root user, execute the following script(s):
        1. /u01/app/oracle/product/11.2.0/dbhome_1/root.sh

Execute /u01/app/oracle/product/11.2.0/dbhome_1/root.sh on the following nodes: 
[rac1, rac2, rac3, rac4]

..................................................   100% Done.

Execute Root Scripts successful.
Successfully Setup Software.

```


