## ansible安装oracle


## oracle database install

###

```yml
$ ansible-galaxy search database

ansible-galaxy search --author sysco-middleware > sysco-middleware.txt
$ awk '{print $1}' sysco-middleware.txt > sysco-middleware.yml

vim sysco-middleware.yml
删除开头几行
:%s/sysco-middleware/- src: sysco-middleware/g

$ ansible-galaxy install -r sysco-middleware.yml

$ ansible-galaxy list




```



### 使用lean_delivery.oracle_db

每一步的执行都会列出执行文件的路径、名称和行数

出现问题加-vv 参数显示详细信息

TASK [lean_delivery.oracle_db : Create db] **********************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:38






#### 层次

```yml
/etc/ansible/roles/lean_delivery.oracle_db


# w @ uw in /etc/ansible/roles/lean_delivery.oracle_db [10:58:55] 
$ tree -L 2
.
├── defaults
│   └── main.yml
├── handlers
│   └── main.yml
├── LICENSE
├── meta
│   └── main.yml
├── molecule
│   ├── cloud-aws-oracle-11-delegated
│   ├── cloud-aws-oracle-12-delegated
│   ├── cloud-aws-oracle-xe-delegated
│   ├── cloud-epc-oracle-11-delegated
│   ├── cloud-epc-oracle-12-delegated
│   ├── cloud-epc-oracle-xe-delegated
│   ├── docker-oracle-11
│   ├── docker-oracle-12
│   ├── docker-oracle-xe
│   └── resources
├── README.md
├── requirements.yml
├── tasks
│   ├── fetch
│   ├── main.yml
│   ├── oracle-db-11-12.yml
│   ├── oracle-db-xe.yml
│   ├── oraInst
│   ├── profile
│   └── system
├── templates
│   ├── change_port.sql.j2
│   ├── db.rsp.11.j2
│   ├── db.rsp.12.j2
│   ├── db.rsp.xe.j2
│   ├── env.oracledb.j2
│   ├── env.oracledb.sysconfig.j2
│   ├── oracledb.systemd.j2
│   ├── oracledb.sysv.j2
│   ├── pwd.rsp.j2
│   └── user.sql.j2
└── vars
    ├── main.yml
    ├── not-supported.yml
    ├── oracle11.yml
    ├── oracle12.yml
    └── oraclexe.yml

21 directories, 24 files

```

#### 修改配置

```yml

0、首先要修改执行的lean_delivery_oracle112040.yml

$ cat /media/xh/i/python/wymproject/oracle/oracleinstalltest/lean_delivery_oracle12201.yml

$ cat lean_delivery_oracle112040.yml.yml 
- name: "Install oracle db"
  hosts: oracle

  roles:
    - role: "lean_delivery.oracle_db"
      oracle_version: 11
      patch_version: 11.2.0.4
      transport: "local"
      transport_local: "/home/w/tool/oralce/oracle11.2.0.4"
      oracle_images:
        - "p13390677_112040_Linux-x86-64_1of7.zip"
        - "p13390677_112040_Linux-x86-64_2of7.zip"
        - "p13390677_112040_Linux-x86-64_3of7.zip"

$ cat lean_delivery_oracle12201.yml.yml 
- name: "Install oracle db"
  hosts: 172.17.8.242

  roles:
    - role: "lean_delivery.oracle_db"
      oracle_version: 12
      patch_version: 12.2.0.1
      transport: "local"
      transport_local: "/home/w/tool/oralce"
      oracle_images:
        - "linuxx64_12201_database.zip"


调用关系，用-vvv参数执行ansible-playbook lean_delivery_oracle112040.yml.yml会有输出


$ ansible all --list


$ ansible-playbook /media/xh/i/python/wymproject/oracle/oracleinstalltest/lean_delivery_oracle112040.yml -vv


$ ansible-playbook /media/xh/i/python/wymproject/oracle/oracleinstalltest/lean_delivery_oracle12201.yml -vv

##################################################

1、/etc/ansible/roles/lean_delivery.oracle_db/defaults/main.yml

可以不修改，写到lean_delivery_oracle112040.yml文件里优先级最高

#trasnport_local: "/tmp"
trasnport_local: "/home/w/tool/oralce"

oracle_version: 11
patch_version: 11.2.0.4

oracle_images:
  - "p13390677_112040_Linux-x86-64_1of7.zip"
  - "p13390677_112040_Linux-x86-64_2of7.zip"
  - "p13390677_112040_Linux-x86-64_3of7.zip"

#oracle_version: 12
#patch_version: 12.1.0.2
#oracle_images:
#  - "linuxx64_12201_database.zip"


2、/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle11.yml
包括需要的软件包列表

/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle12.yml只添加glibc.i686即可

  install_requirements:
    - "binutils"
    - "gcc"
    - "gcc-c++"
    - "glibc"
    - "glibc-common"
    - "glibc-devel"
    - "glibc-headers"
    - "ksh"
    - "libaio"
    - "libaio-devel"
    - "libgcc"
    - "libstdc++"
    - "libstdc++-devel"
    - "libXext"
    - "libXtst"
    - "libX11"
    - "libXau"
    - "libXi"
    - "make"
    - "sysstat"
    - "unixODBC"
    - "unixODBC-devel"
    - "zlib-devel"
    - "compat-libcap1"
    - "compat-libstdc++-33"
    - "unzip"
    - "glibc.i686"
    - "glibc-devel.i686"
    - "libaio.i686"
    - "libaio-devel.i686"
    - "libstdc++.i686"
    - "libstdc++-devel.i686"
    - "libXi.i686"
    - "libXtst.i686"


3、注释掉/etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml里
第71行
- name: "Unzip oracle installer"的    #remote_src: True

4、安装Oracle12c，
修改/etc/ansible/roles/lean_delivery.oracle_db/templates/db.rsp.12.j2，添加
oracle.install.db.OSRACDBA_GROUP={{ oracledb.dba_group }}








相关日志导出

$ scp root@172.17.8.242:/tmp/OraInstall2019-03-05_08-49-40AM/installActions2019-03-05_08-49-40AM.log /media/xh/i/python/wymproject/oracle

/opt/oracledb/product/12.2.0.1/db_1/cfgtoollogs/oui/configActions2019-03-12_11-03-25-AM.log



```


#### 安装oracle 11g过程，安装12c也是这个错误

TASK [lean_delivery.oracle_db : Create db] *********************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:38

......报错......查找原因中

```yml
首先要修改lean_delivery_oracle112040.yml，
# w @ uw in /media/xh/i/python/wymproject/oracle/oracleinstalltest on git:master x [19:04:05] 
$ ansible-playbook lean_delivery_oracle112040.yml -vv

ansible-playbook 2.7.8
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/w/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.6/dist-packages/ansible
  executable location = /usr/local/bin/ansible-playbook
  python version = 3.6.7 (default, Oct 22 2018, 11:32:17) [GCC 8.2.0]
Using /etc/ansible/ansible.cfg as config file
/etc/ansible/hosts did not meet host_list requirements, check plugin documentation if this is unexpected
/etc/ansible/hosts did not meet script requirements, check plugin documentation if this is unexpected

PLAYBOOK: lean_delivery_oracle112040.yml ***********************************************************************************
1 plays in lean_delivery_oracle112040.yml

PLAY [Install oracle db] ***************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************
task path: /media/xh/i/python/wymproject/oracle/oracleinstalltest/lean_delivery_oracle112040.yml:1
ok: [172.17.8.242]
META: ran handlers

TASK [lean_delivery.oracle_db : Check /etc/oratab exists] ******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:3
ok: [172.17.8.242] => {"changed": false, "stat": {"exists": false}}

TASK [lean_delivery.oracle_db : Choose vars based on oracle version] *******************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:11
ok: [172.17.8.242] => (item=/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle11.yml) => {"ansible_facts": {"oracle_default_tablespace_size": "200M", "oracle_temp_tablespace_size": "100M", "oracledb": {"cert": true, "characterset": "AL32UTF8", "dba_group": "dba", "filesystemstorage": "{{ oracle_base }}/oradata", "install_directory": "/opt/install/oracledb", "install_group": "oinstall", "install_requirements": ["binutils", "gcc", "gcc-c++", "glibc", "glibc-common", "glibc-devel", "glibc-headers", "ksh", "libaio", "libaio-devel", "libgcc", "libstdc++", "libstdc++-devel", "libXext", "libXtst", "libX11", "libXau", "libXi", "make", "sysstat", "unixODBC", "unixODBC-devel", "zlib-devel", "compat-libcap1", "compat-libstdc++-33", "unzip", "glibc.i686", "glibc-devel.i686", "libaio.i686", "libaio-devel.i686", "libstdc++.i686", "libstdc++-devel.i686", "libXi.i686", "libXtst.i686"], "limits": ["oracle   soft   nofile   1024", "oracle   hard   nofile   65536", "oracle   soft   nproc    2047", "oracle   hard   nproc    16384", "oracle   soft   stack    10240", "oracle   hard   stack    32768"], "limits_file": "/etc/security/limits.conf", "memorylimit": "512", "oracle_home": "{{ oracle_base }}/product/{{ patch_version }}/db_1", "pwd_file": "pwd.rsp", "rsp_file": "db.rsp", "rsp_template": "db.rsp.{{ oracle_version }}", "shm_size_mb": "{{ ansible_memtotal_mb }}", "swapfile_bs_size_mb": "1", "swapfile_count": "{{ oracle_db_swap_count }}", "swapfile_path": "{{ oracle_db_swapfile }}", "sysctl": [{"name": "fs.file-max", "value": "6815744"}, {"name": "kernel.sem", "value": "250 32000 100 128"}, {"name": "kernel.shmmni", "value": "4096"}, {"name": "kernel.shmall", "value": "1073741824"}, {"name": "kernel.shmmax", "value": "4398046511104"}, {"name": "net.core.rmem_default", "value": "262144"}, {"name": "net.core.rmem_max", "value": "4194304"}, {"name": "net.core.wmem_default", "value": "262144"}, {"name": "net.core.wmem_max", "value": "1048576"}, {"name": "fs.aio-max-nr", "value": "1048576"}, {"name": "net.ipv4.ip_local_port_range", "value": "9000 65500"}], "user": "oracle"}}, "ansible_included_var_files": ["/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle11.yml"], "changed": false, "version": "/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle11.yml"}

TASK [lean_delivery.oracle_db : Make preparations and install requirements] ************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:19
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Create dba group] **************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:3
changed: [172.17.8.242] => {"changed": true, "gid": 1001, "name": "dba", "state": "present", "system": false}

TASK [lean_delivery.oracle_db : Create oracle user] ************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:9
changed: [172.17.8.242] => {"changed": true, "comment": "", "create_home": true, "group": 1001, "home": "/home/oracle", "name": "oracle", "shell": "/bin/bash", "state": "present", "system": false, "uid": 1001}

TASK [lean_delivery.oracle_db : Check oracle inventory requirements] *******************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:19
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Check /etc/oraInst.loc exists] *************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:3
ok: [172.17.8.242] => {"changed": false, "stat": {"exists": false}}

TASK [lean_delivery.oracle_db : Read /etc/oraInst.loc content] *************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:8
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Create oinstall group] *********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:12
changed: [172.17.8.242] => {"changed": true, "gid": 1002, "name": "oinstall", "state": "present", "system": false}

TASK [lean_delivery.oracle_db : Add oracle to oinstall] ********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:19
changed: [172.17.8.242] => {"append": true, "changed": true, "comment": "", "group": 1001, "groups": "oinstall", "home": "/home/oracle", "move_home": false, "name": "oracle", "shell": "/bin/bash", "state": "present", "uid": 1001}

TASK [lean_delivery.oracle_db : Check inventory directory] *****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:26
ok: [172.17.8.242] => {"changed": false, "stat": {"exists": false}}

TASK [lean_delivery.oracle_db : Create inventory directory] ****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:32
changed: [172.17.8.242] => {"changed": true, "gid": 1002, "group": "oinstall", "mode": "0774", "owner": "oracle", "path": "/opt/oraInventory", "secontext": "unconfined_u:object_r:usr_t:s0", "size": 6, "state": "directory", "uid": 1001}

TASK [lean_delivery.oracle_db : Create oracledb directories (install)] *****************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:22
changed: [172.17.8.242] => {"changed": true, "gid": 0, "group": "root", "mode": "0755", "owner": "root", "path": "/opt/install/oracledb", "secontext": "unconfined_u:object_r:usr_t:s0", "size": 6, "state": "directory", "uid": 0}

TASK [lean_delivery.oracle_db : Create /opt/oracledb directory] ************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:29
changed: [172.17.8.242] => {"changed": true, "gid": 1002, "group": "oinstall", "mode": "0755", "owner": "oracle", "path": "/opt/oracledb", "secontext": "unconfined_u:object_r:usr_t:s0", "size": 6, "state": "directory", "uid": 1001}

TASK [lean_delivery.oracle_db : Chown install directory to oracle user] ****************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:38
changed: [172.17.8.242] => {"changed": true, "gid": 1002, "group": "oinstall", "mode": "0755", "owner": "oracle", "path": "/opt/install/oracledb", "secontext": "unconfined_u:object_r:usr_t:s0", "size": 6, "state": "directory", "uid": 1001}

TASK [lean_delivery.oracle_db : Install requirements] **********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:47
FAILED - RETRYING: Install requirements (10 retries left).
FAILED - RETRYING: Install requirements (9 retries left).
FAILED - RETRYING: Install requirements (8 retries left).
changed: [172.17.8.242] => {"attempts": 4, "changed": true, "msg": "warning: /var/cache/yum/x86_64/7/base/packages/compat-libcap1-1.10-7.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY\nImporting GPG key 0xF4A80EB5:\n Userid     : \"CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>\"\n Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5\n Package    : centos-release-7-4.1708.el7.centos.x86_64 (@anaconda)\n From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\n", "rc": 0, "results": --> Finished 

TASK [lean_delivery.oracle_db : Fetch artifact with local transport] *******************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:57
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/fetch/local.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Artifacts stored localy] *******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/fetch/local.yml:3
ok: [172.17.8.242] => (item=p13390677_112040_Linux-x86-64_1of7.zip) => {"ansible_facts": {"oracle_db_artifacts": ["/home/w/tool/oralce/p13390677_112040_Linux-x86-64_1of7.zip"]}, "changed": false, "item": "p13390677_112040_Linux-x86-64_1of7.zip"}
ok: [172.17.8.242] => (item=p13390677_112040_Linux-x86-64_2of7.zip) => {"ansible_facts": {"oracle_db_artifacts": ["/home/w/tool/oralce/p13390677_112040_Linux-x86-64_1of7.zip", "/home/w/tool/oralce/p13390677_112040_Linux-x86-64_2of7.zip"]}, "changed": false, "item": "p13390677_112040_Linux-x86-64_2of7.zip"}
ok: [172.17.8.242] => (item=p13390677_112040_Linux-x86-64_3of7.zip) => {"ansible_facts": {"oracle_db_artifacts": ["/home/w/tool/oralce/p13390677_112040_Linux-x86-64_1of7.zip", "/home/w/tool/oralce/p13390677_112040_Linux-x86-64_2of7.zip", "/home/w/tool/oralce/p13390677_112040_Linux-x86-64_3of7.zip"]}, "changed": false, "item": "p13390677_112040_Linux-x86-64_3of7.zip"}

TASK [lean_delivery.oracle_db : Check unziped folder] **********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:65
ok: [172.17.8.242] => {"changed": false, "stat": {"exists": false}}

TASK [lean_delivery.oracle_db : Unzip oracle installer] ********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:71
changed: [172.17.8.242] => (item=/home/w/tool/oralce/p13390677_112040_Linux-x86-64_1of7.zip) => {"changed": true, "dest": "/opt/install/oracledb", "extract_results": {"cmd": ["/usr/bin/unzip", "-o", "/root/.ansible/tmp/ansible-tmp-1552302685.1475568-165752864793794/source", "-d", "/opt/install/oracledb"], "err": "", "out": "Archive:  /root/.ansible/tmp/ansible-tmp-1552302685.1475568-165752864793794/source\n   creating: /opt/install/oracledb/database/\n  

解压缩输出信息较多，时间较长，省略......



TASK [lean_delivery.oracle_db : Remove installs] ***************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:80
ok: [172.17.8.242] => (item=p13390677_112040_Linux-x86-64_1of7.zip) => {"changed": false, "item": "p13390677_112040_Linux-x86-64_1of7.zip", "path": "/opt/install/oracledb/p13390677_112040_Linux-x86-64_1of7.zip", "state": "absent"}
ok: [172.17.8.242] => (item=p13390677_112040_Linux-x86-64_2of7.zip) => {"changed": false, "item": "p13390677_112040_Linux-x86-64_2of7.zip", "path": "/opt/install/oracledb/p13390677_112040_Linux-x86-64_2of7.zip", "state": "absent"}
ok: [172.17.8.242] => (item=p13390677_112040_Linux-x86-64_3of7.zip) => {"changed": false, "item": "p13390677_112040_Linux-x86-64_3of7.zip", "path": "/opt/install/oracledb/p13390677_112040_Linux-x86-64_3of7.zip", "state": "absent"}

TASK [lean_delivery.oracle_db : Copy rsp file for Oracle] ******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:87
changed: [172.17.8.242] => {"changed": true, "checksum": "2c60c0252f6cb8c1994fbb609316400314c1ce19", "dest": "/opt/install/oracledb/db.rsp", "gid": 1002, "group": "oinstall", "md5sum": "6060b05e8156e62a8f277d019dd4e445", "mode": "0644", "owner": "oracle", "secontext": "system_u:object_r:usr_t:s0", "size": 2608, "src": "/root/.ansible/tmp/ansible-tmp-1552303008.2340288-86681013444358/source", "state": "file", "uid": 1001}

TASK [lean_delivery.oracle_db : Read Oracle profile] ***********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:95
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/profile/oracle-db-profile.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Create environment variables for Oracle DB] ************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/profile/oracle-db-profile.yml:3
changed: [172.17.8.242] => {"changed": true, "checksum": "c3527e2e9e1af231f30445e68c0d2594c50aab4d", "dest": "/etc/profile.d/oracle_env.sh", "gid": 0, "group": "root", "md5sum": "e8fa726e0a7aaabff4fb2733f26262dc", "mode": "0644", "owner": "root", "secontext": "system_u:object_r:bin_t:s0", "size": 448, "src": "/root/.ansible/tmp/ansible-tmp-1552303009.4204655-64643719905907/source", "state": "file", "uid": 0}

TASK [lean_delivery.oracle_db : Create swap file] **************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:22
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Check swapfile] ****************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml:2
ok: [172.17.8.242] => {"changed": false, "stat": {"exists": false}}

TASK [lean_delivery.oracle_db : Unmount swap] ******************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml:10
ok: [172.17.8.242] => {"changed": false, "dump": "0", "fstab": "/etc/fstab", "fstype": "swap", "name": "swap", "opts": "defaults", "passno": "0", "src": "/oracle-swapfile-11"}

TASK [lean_delivery.oracle_db : Create swapfile] ***************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml:17
changed: [172.17.8.242] => {"changed": true, "cmd": ["dd", "if=/dev/zero", "of=/oracle-swapfile-11", "bs=1M", "count=2048"], "delta": "0:00:05.215508", "end": "2019-03-11 02:26:06.417073", "rc": 0, "start": "2019-03-11 02:26:01.201565", "stderr": "2048+0 records in\n2048+0 records out\n2147483648 bytes (2.1 GB) copied, 5.20476 s, 413 MB/s", "stderr_lines": ["2048+0 records in", "2048+0 records out", "2147483648 bytes (2.1 GB) copied, 5.20476 s, 413 MB/s"], "stdout": "", "stdout_lines": []}

TASK [lean_delivery.oracle_db : Set swapfile permissions] ******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml:26
changed: [172.17.8.242] => {"changed": true, "gid": 0, "group": "root", "mode": "0600", "owner": "root", "path": "/oracle-swapfile-11", "secontext": "unconfined_u:object_r:etc_runtime_t:s0", "size": 2147483648, "state": "file", "uid": 0}

TASK [lean_delivery.oracle_db : Make swap] *********************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml:31
changed: [172.17.8.242] => {"changed": true, "cmd": ["/sbin/mkswap", "/oracle-swapfile-11"], "delta": "0:00:00.593020", "end": "2019-03-11 02:26:08.112780", "rc": 0, "start": "2019-03-11 02:26:07.519760", "stderr": "", "stderr_lines": [], "stdout": "Setting up swapspace version 1, size = 2097148 KiB\nno label, UUID=70290af3-670d-4120-ae3b-b56e1dc1f452", "stdout_lines": ["Setting up swapspace version 1, size = 2097148 KiB", "no label, UUID=70290af3-670d-4120-ae3b-b56e1dc1f452"]}

TASK [lean_delivery.oracle_db : Swap on] ***********************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml:36
changed: [172.17.8.242] => {"changed": true, "cmd": ["/sbin/swapon", "/oracle-swapfile-11"], "delta": "0:00:00.201233", "end": "2019-03-11 02:26:08.875471", "rc": 0, "start": "2019-03-11 02:26:08.674238", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}

TASK [lean_delivery.oracle_db : Add swap to /etc/fstab] ********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/swap.yml:41
changed: [172.17.8.242] => {"backup": "", "changed": true, "msg": "line added"}

TASK [lean_delivery.oracle_db : Adjust kernel parameters and shared memory] ************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:26
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Change kernel parameters] ******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:3
changed: [172.17.8.242] => (item={'name': 'fs.file-max', 'value': '6815744'}) => {"changed": true, "item": {"name": "fs.file-max", "value": "6815744"}}
changed: [172.17.8.242] => (item={'name': 'kernel.sem', 'value': '250 32000 100 128'}) => {"changed": true, "item": {"name": "kernel.sem", "value": "250 32000 100 128"}}
changed: [172.17.8.242] => (item={'name': 'kernel.shmmni', 'value': '4096'}) => {"changed": true, "item": {"name": "kernel.shmmni", "value": "4096"}}
changed: [172.17.8.242] => (item={'name': 'kernel.shmall', 'value': '1073741824'}) => {"changed": true, "item": {"name": "kernel.shmall", "value": "1073741824"}}
changed: [172.17.8.242] => (item={'name': 'kernel.shmmax', 'value': '4398046511104'}) => {"changed": true, "item": {"name": "kernel.shmmax", "value": "4398046511104"}}
changed: [172.17.8.242] => (item={'name': 'net.core.rmem_default', 'value': '262144'}) => {"changed": true, "item": {"name": "net.core.rmem_default", "value": "262144"}}
changed: [172.17.8.242] => (item={'name': 'net.core.rmem_max', 'value': '4194304'}) => {"changed": true, "item": {"name": "net.core.rmem_max", "value": "4194304"}}
changed: [172.17.8.242] => (item={'name': 'net.core.wmem_default', 'value': '262144'}) => {"changed": true, "item": {"name": "net.core.wmem_default", "value": "262144"}}
changed: [172.17.8.242] => (item={'name': 'net.core.wmem_max', 'value': '1048576'}) => {"changed": true, "item": {"name": "net.core.wmem_max", "value": "1048576"}}
changed: [172.17.8.242] => (item={'name': 'fs.aio-max-nr', 'value': '1048576'}) => {"changed": true, "item": {"name": "fs.aio-max-nr", "value": "1048576"}}
changed: [172.17.8.242] => (item={'name': 'net.ipv4.ip_local_port_range', 'value': '9000 65500'}) => {"changed": true, "item": {"name": "net.ipv4.ip_local_port_range", "value": "9000 65500"}}

TASK [lean_delivery.oracle_db : Change limits] *****************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:13
changed: [172.17.8.242] => (item=oracle   soft   nofile   1024) => {"backup": "", "changed": true, "item": "oracle   soft   nofile   1024", "msg": "line added"}
changed: [172.17.8.242] => (item=oracle   hard   nofile   65536) => {"backup": "", "changed": true, "item": "oracle   hard   nofile   65536", "msg": "line added"}
changed: [172.17.8.242] => (item=oracle   soft   nproc    2047) => {"backup": "", "changed": true, "item": "oracle   soft   nproc    2047", "msg": "line added"}
changed: [172.17.8.242] => (item=oracle   hard   nproc    16384) => {"backup": "", "changed": true, "item": "oracle   hard   nproc    16384", "msg": "line added"}
changed: [172.17.8.242] => (item=oracle   soft   stack    10240) => {"backup": "", "changed": true, "item": "oracle   soft   stack    10240", "msg": "line added"}
changed: [172.17.8.242] => (item=oracle   hard   stack    32768) => {"backup": "", "changed": true, "item": "oracle   hard   stack    32768", "msg": "line added"}

TASK [lean_delivery.oracle_db : Resize /dev/shm] ***************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:21
changed: [172.17.8.242] => {"changed": true, "dump": "0", "fstab": "/etc/fstab", "fstype": "tmpfs", "name": "/dev/shm", "opts": "defaults,size=2847M", "passno": "0", "src": "tmpfs"}

TASK [lean_delivery.oracle_db : Remember shm state] ************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:31
ok: [172.17.8.242] => {"ansible_facts": {"need_remount": true}, "changed": false}

TASK [lean_delivery.oracle_db : Unmount tmpfs] *****************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:35
changed: [172.17.8.242] => {"changed": true, "dump": "0", "fstab": "/etc/fstab", "name": "/dev/shm", "opts": "defaults", "passno": "0"}

TASK [lean_delivery.oracle_db : Mounting tmpfs] ****************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:42
changed: [172.17.8.242] => {"changed": true, "dump": "0", "fstab": "/etc/fstab", "fstype": "tmpfs", "name": "/dev/shm", "opts": "defaults,size=2847M", "passno": "0", "src": "tmpfs"}

TASK [lean_delivery.oracle_db : Oracle DB XE install] **********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:29
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Oracle DB 11 or 12 install] ****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:33
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Install Oracle RDBMS] **********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:3
 [WARNING]: Module remote_tmp /home/oracle/.ansible/tmp did not exist and was created with a mode of 0700, this may cause
issues when running as another user. To avoid this, create the remote_tmp dir with the correct permissions manually

changed: [172.17.8.242] => {"changed": true, "cmd": ["/opt/install/oracledb/database/runInstaller", "-silent", "-waitforcompletion", "-ignorePrereq", "-responseFile", "/opt/install/oracledb/db.rsp"], "delta": "0:13:55.050574", "end": "2019-03-11 02:40:16.315095", "failed_when_result": false, "rc": 0, "start": "2019-03-11 02:26:21.264521", "stderr": "", "stderr_lines": [], "stdout": "正在启动 Oracle Universal Installer...\n\n检查临时空间: 必须大于 120 MB。   实际为 31595 MB    通过\n检查交换空间: 必须大于 150 MB。   实际为 3583 MB    通过\n准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-11_02-26-21AM. 请稍候...可以在以下位置找到本次安装会话的日志:\n /opt/oraInventory/logs/installActions2019-03-11_02-26-21AM.log\nOracle Database 11g 的 安装 已成功。\n请查看 '/opt/oraInventory/logs/silentInstall2019-03-11_02-26-21AM.log' 以获取详细资料。\n\n以 root 用户的身份执行以下脚本:\n\t1. /opt/oraInventory/orainstRoot.sh\n\t2. /opt/oracledb/product/11.2.0.4/db_1/root.sh\n\n\nSuccessfully Setup Software.", "stdout_lines": ["正在启动 Oracle Universal Installer...", "", "检查临时空间: 必须大于 120 MB。   实际为 31595 MB    通过", "检查交换空间: 必须大于 150 MB。   实际为 3583 MB    通过", "准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-11_02-26-21AM. 请稍候...可以在以下位置找到本次安装会话的日志:", " /opt/oraInventory/logs/installActions2019-03-11_02-26-21AM.log", "Oracle Database 11g 的 安装 已成功。", "请查看 '/opt/oraInventory/logs/silentInstall2019-03-11_02-26-21AM.log' 以获取详细资料。", "", "以 root 用户的身份执行以下脚本:", "\t1. /opt/oraInventory/orainstRoot.sh", "\t2. /opt/oracledb/product/11.2.0.4/db_1/root.sh", "", "", "Successfully Setup Software."]}

TASK [lean_delivery.oracle_db : Start scripts after install] ***************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:16
changed: [172.17.8.242] => {"changed": true, "cmd": ["/bin/bash", "/opt/oraInventory/orainstRoot.sh"], "delta": "0:00:00.388819", "end": "2019-03-11 02:40:23.620947", "rc": 0, "start": "2019-03-11 02:40:23.232128", "stderr": "", "stderr_lines": [], "stdout": "更改权限/opt/oraInventory.\n添加组的读取和写入权限。\n删除全局的读取, 写入和执行权限。\n\n更改组名/opt/oraInventory 到 oinstall.\n脚本的执行已完成。", "stdout_lines": ["更改权限/opt/oraInventory.", "添加组的读取和写入权限。", "删除全局的读取, 写入和执行权限。", "", "更改组名/opt/oraInventory 到 oinstall.", "脚本的执行已完成。"]}

TASK [lean_delivery.oracle_db : Start root.sh script] **********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:23
changed: [172.17.8.242] => {"changed": true, "cmd": ["/bin/bash", "/opt/oracledb/product/11.2.0.4/db_1/root.sh"], "delta": "0:00:03.987809", "end": "2019-03-11 02:40:30.428487", "rc": 0, "start": "2019-03-11 02:40:26.440678", "stderr": "", "stderr_lines": [], "stdout": "Check /opt/oracledb/product/11.2.0.4/db_1/install/root_oracle2_2019-03-11_02-40-26.log for the output of root script", "stdout_lines": ["Check /opt/oracledb/product/11.2.0.4/db_1/install/root_oracle2_2019-03-11_02-40-26.log for the output of root script"]}

TASK [lean_delivery.oracle_db : Create rsp file for oracle] ****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:30
changed: [172.17.8.242] => {"changed": true, "checksum": "9158f6de8df1318913939534dc1f32174b68e914", "dest": "/opt/install/oracledb/pwd.rsp", "gid": 1002, "group": "oinstall", "md5sum": "f4694c598107f9bf88d1acae8b1fdb1c", "mode": "0644", "owner": "oracle", "secontext": "system_u:object_r:usr_t:s0", "size": 282, "src": "/root/.ansible/tmp/ansible-tmp-1552303814.8505347-72185098126659/source", "state": "file", "uid": 1001}

TASK [lean_delivery.oracle_db : Create db] *********************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:38
fatal: [172.17.8.242]: FAILED! => {"changed": false, "cmd": ["/bin/bash", "/opt/oracledb/product/11.2.0.4/db_1/cfgtoollogs/configToolAllCommands", "RESPONSE_FILE=/opt/install/oracledb/pwd.rsp"], "delta": "0:00:18.834051", "end": "2019-03-11 02:40:58.640231", "failed_when_result": true, "msg": "non-zero return code", "rc": 3, "start": "2019-03-11 02:40:39.806180", "stderr": "", "stderr_lines": [], "stdout": "Setting the invPtrLoc to /opt/oracledb/product/11.2.0.4/db_1/oraInst.loc\n\nperform - 操作的模式正在启动: configure\n\n\nperform - 操作的模式已完成: configure\n\n您可以查看日志文件: /opt/oracledb/product/11.2.0.4/db_1/cfgtoollogs/oui/configActions2019-03-11_02-40-45-AM.log", "stdout_lines": ["Setting the invPtrLoc to /opt/oracledb/product/11.2.0.4/db_1/oraInst.loc", "", "perform - 操作的模式正在启动: configure", "", "", "perform - 操作的模式已完成: configure", "", "您可以查看日志文件: /opt/oracledb/product/11.2.0.4/db_1/cfgtoollogs/oui/configActions2019-03-11_02-40-45-AM.log"]}
	to retry, use: --limit @/media/xh/i/python/wymproject/oracle/oracleinstalltest/lean_delivery_oracle112040.retry

PLAY RECAP *****************************************************************************************************************
172.17.8.242               : ok=44   changed=26   unreachable=0    failed=1   


$ /bin/bash /opt/oracledb/product/12.2.0.1/db_1/cfgtoollogs/configToolAllCommands RESPONSE_FILE=/opt/install/oracledb/pwd.rsp



```


#### 执行

```yml







失败记录




6、TASK [lean_delivery.oracle_db : Create db] *********************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:38
fatal: [172.17.8.241]: FAILED! => {"changed": false, "cmd": ["/bin/bash", "/opt/oracledb/product/11.2.0.4/db_1/cfgtoollogs/configToolAllCommands", "RESPONSE_FILE=/opt/install/oracledb/pwd.rsp"], "delta": "0:00:22.668243", "end": "2019-03-11 01:52:39.646225", "failed_when_result": true, "msg": "non-zero return code", "rc": 3, "start": "2019-03-11 01:52:16.977982", "stderr": "", "stderr_lines": [], "stdout": "Setting the invPtrLoc to /opt/oracledb/product/11.2.0.4/db_1/oraInst.loc\n\nperform - 操作的模式正在启动: configure\n\n\nperform - 操作的模式已完成: configure\n\n您可以查看日志文件: /opt/oracledb/product/11.2.0.4/db_1/cfgtoollogs/oui/configActions2019-03-11_01-52-24-AM.log", "stdout_lines": ["Setting the invPtrLoc to /opt/oracledb/product/11.2.0.4/db_1/oraInst.loc", "", "perform - 操作的模式正在启动: configure", "", "", "perform - 操作的模式已完成: configure", "", "您可以查看日志文件: /opt/oracledb/product/11.2.0.4/db_1/cfgtoollogs/oui/configActions2019-03-11_01-52-24-AM.log"]}


# cat /opt/oracledb/product/11.2.0.4/db_1/cfgtoollogs/oui/configActions2019-03-11_01-52-24-AM.log
###################################################
The action configuration is performing
------------------------------------------------------
The plug-in Oracle Net Configuration Assistant is running


正在对命令行参数进行语法分析:
参数"orahome" = /opt/oracledb/product/11.2.0.4/db_1
参数"orahnam" = OraDb11g_home1
参数"instype" = typical
参数"inscomp" = client,oraclenet,javavm,server,ano
参数"insprtcl" = tcp
参数"cfg" = local
参数"authadp" = NO_VALUE
参数"responsefile" = /opt/oracledb/product/11.2.0.4/db_1/network/install/netca_typ.rsp
参数"silent" = true
参数"silent" = true
完成对命令行参数进行语法分析。
Oracle Net Services 配置:
完成概要文件配置。
监听程序 "LISTENER" 已存在。
成功完成 Oracle Net Services 配置。退出代码是0

The plug-in Oracle Net Configuration Assistant has successfully been performed
------------------------------------------------------
------------------------------------------------------
The plug-in Oracle Database Configuration Assistant is running


The plug-in Oracle Database Configuration Assistant has failed its perform method
------------------------------------------------------
The action configuration has failed its perform method
###################################################







```







### Example Playbook

```yml

https://github.com/lean-delivery/ansible-role-oracle-db


Example Playbook
Installing Oracle 11.2.0.1

- name: "Install oracle db"
  hosts: all

  roles:
    - role: "lean_delivery.oracle_db"
      oracle_version: 11
      patch_version: 11.2.0.1
      transport_web: "http://my-storage.example.com"
      oracle_images:
        - "linux.x64_11gR2_database_1of2.zip"
        - "linux.x64_11gR2_database_2of2.zip"
Installing Oracle 11.2.0.3 from local files

- name: "Install oracle db"
  hosts: all

  roles:
    - role: "lean_delivery.oracle_db"
      oracle_version: 11
      patch_version: 11.2.0.3
      transport: "local"
      transport_local: "/tmp"
      oracle_images:
        - "p10404530_112030_Linux-x86-64_1of7.zip"
        - "p10404530_112030_Linux-x86-64_2of7.zip"
        - "p10404530_112030_Linux-x86-64_3of7.zip"
        - "p10404530_112030_Linux-x86-64_4of7.zip"
        - "p10404530_112030_Linux-x86-64_5of7.zip"
        - "p10404530_112030_Linux-x86-64_6of7.zip"
        - "p10404530_112030_Linux-x86-64_7of7.zip"
Installing Oracle 11.2.0.4 with custom swap file size

- name: "Install oracle db"
  hosts: all

  roles:
    - role: "lean_delivery.oracle_db"
      oracle_version: 11
      patch_version: 11.2.0.4
      transport_web: "http://my-storage.example.com"
      oracle_images:
        - "p10404530_112040_Linux-x86-64_1of7.zip"
        - "p10404530_112040_Linux-x86-64_2of7.zip"
        - "p10404530_112040_Linux-x86-64_3of7.zip"
        - "p10404530_112040_Linux-x86-64_4of7.zip"
        - "p10404530_112040_Linux-x86-64_5of7.zip"
        - "p10404530_112040_Linux-x86-64_6of7.zip"
        - "p10404530_112040_Linux-x86-64_7of7.zip"
      oracle_db_swapfile: "/oracle-swapfile-11"
      oracle_db_swap_count: 2048
Installing Oracle 12.1.0.2

- name: "Install oracle db"
  hosts: all

  roles:
    - role: "lean_delivery.oracle_db"
      oracle_version: 12
      patch_version: 12.1.0.2
      transport_web: "http://my-storage.example.com"
      oracle_images:
        - "linuxamd64_12102_database_1of2.zip"
        - "linuxamd64_12102_database_2of2.zip"
Installing Oracle XE

- name: "Install oracle db"
  hosts: all

  roles:
    - role: "lean_delivery.oracle_db"
      oracle_version: xe
      transport_web: "http://my-storage.example.com"
      oracle_images:
        - "linux.x64_11gR2_xe.zip"


```




### 12c安装过程

```yml
# w @ uw in /media/xh/i/python/wymproject/oracle/oracleinstalltest on git:master x [18:19:17] C:2
$ ansible-playbook lean_delivery_oracle12201.yml -vv
ansible-playbook 2.7.5
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/w/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.6/dist-packages/ansible
  executable location = /usr/local/bin/ansible-playbook
  python version = 3.6.7 (default, Oct 22 2018, 11:32:17) [GCC 8.2.0]
Using /etc/ansible/ansible.cfg as config file
/etc/ansible/hosts did not meet host_list requirements, check plugin documentation if this is unexpected
/etc/ansible/hosts did not meet script requirements, check plugin documentation if this is unexpected

PLAYBOOK: lean_delivery_oracle12201.yml ***********************************************************************************
1 plays in lean_delivery_oracle12201.yml

PLAY [Install oracle db] **************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************
task path: /media/xh/i/python/wymproject/oracle/oracleinstalltest/lean_delivery_oracle12201.yml:1
ok: [172.17.8.242]
META: ran handlers

TASK [lean_delivery.oracle_db : Check /etc/oratab exists] *****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:3
ok: [172.17.8.242] => {"changed": false, "stat": {"exists": false}}

TASK [lean_delivery.oracle_db : Choose vars based on oracle version] ******************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:11
ok: [172.17.8.242] => (item=/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle12.yml) => {"ansible_facts": {"oracle_default_tablespace_size": "200M", "oracle_temp_tablespace_size": "100M", "oracledb": {"cert": true, "characterset": "AL32UTF8", "dba_group": "dba", "filesystemstorage": "{{ oracle_base }}/oradata", "install_directory": "/opt/install/oracledb", "install_group": "oinstall", "install_requirements": ["binutils", "gcc", "gcc-c++", "glibc", "glibc-common", "glibc-devel", "glibc-headers", "ksh", "libaio", "libaio-devel", "libgcc", "libstdc++", "libstdc++-devel", "libXext", "libXtst", "libX11", "libXau", "libXi", "make", "sysstat", "unixODBC", "unixODBC-devel", "zlib-devel", "compat-libcap1", "compat-libstdc++-33", "unzip", "glibc.i686", "compat-libcap1", "glibc-devel.i686", "libaio.i686", "libaio-devel.i686", "libstdc++.i686", "libstdc++-devel.i686", "libXi.i686", "libXtst", "libXtst.i686"], "limits": ["oracle   soft   nofile   1024", "oracle   hard   nofile   65536", "oracle   soft   nproc    2047", "oracle   hard   nproc    16384", "oracle   soft   stack    10240", "oracle   hard   stack    32768", "oracle   soft   memlock  7340032", "oracle   hard   memlock  8388608"], "limits_file": "/etc/security/limits.conf", "memorylimit": "{{ (ansible_memtotal_mb * 0.8)| round | int if ansible_memtotal_mb is defined else 1024 }}", "oracle_home": "{{ oracle_base }}/product/{{ patch_version }}/db_1", "pwd_file": "pwd.rsp", "rsp_file": "db.rsp", "rsp_template": "db.rsp.{{ oracle_version }}", "sga_target": "{{ (ansible_memtotal_mb * 0.4)| round | int if ansible_memtotal_mb is defined else 1024 }}", "shm_size_mb": "{{ ansible_memtotal_mb }}", "swapfile_bs_size_mb": "1", "swapfile_count": "{{ oracle_db_swap_count }}", "swapfile_path": "{{ oracle_db_swapfile }}", "sysctl": [{"name": "fs.file-max", "value": "6815744"}, {"name": "kernel.sem", "value": "250 32000 100 128"}, {"name": "kernel.shmmni", "value": "4096"}, {"name": "kernel.shmall", "value": "1073741824"}, {"name": "kernel.shmmax", "value": "4398046511104"}, {"name": "net.core.rmem_default", "value": "262144"}, {"name": "net.core.rmem_max", "value": "4194304"}, {"name": "net.core.wmem_default", "value": "262144"}, {"name": "net.core.wmem_max", "value": "1048576"}, {"name": "fs.aio-max-nr", "value": "1048576"}, {"name": "net.ipv4.ip_local_port_range", "value": "9000 65500"}], "user": "oracle"}}, "ansible_included_var_files": ["/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle12.yml"], "changed": false, "version": "/etc/ansible/roles/lean_delivery.oracle_db/vars/oracle12.yml"}

TASK [lean_delivery.oracle_db : Make preparations and install requirements] ***********************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:19
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Create dba group] *************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:3
ok: [172.17.8.242] => {"changed": false, "gid": 1001, "name": "dba", "state": "present", "system": false}

TASK [lean_delivery.oracle_db : Create oracle user] ***********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:9
ok: [172.17.8.242] => {"append": true, "changed": false, "comment": "", "group": 1001, "home": "/home/oracle", "move_home": false, "name": "oracle", "shell": "/bin/bash", "state": "present", "uid": 1001}

TASK [lean_delivery.oracle_db : Check oracle inventory requirements] ******************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:19
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Check /etc/oraInst.loc exists] ************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:3
ok: [172.17.8.242] => {"changed": false, "stat": {"exists": false}}

TASK [lean_delivery.oracle_db : Read /etc/oraInst.loc content] ************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:8
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Create oinstall group] ********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:12
ok: [172.17.8.242] => {"changed": false, "gid": 1002, "name": "oinstall", "state": "present", "system": false}

TASK [lean_delivery.oracle_db : Add oracle to oinstall] *******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:19
ok: [172.17.8.242] => {"append": true, "changed": false, "comment": "", "group": 1001, "groups": "oinstall", "home": "/home/oracle", "move_home": false, "name": "oracle", "shell": "/bin/bash", "state": "present", "uid": 1001}

TASK [lean_delivery.oracle_db : Check inventory directory] ****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:26
ok: [172.17.8.242] => {"changed": false, "stat": {"atime": 1551821118.7710035, "attr_flags": "", "attributes": [], "block_size": 4096, "blocks": 0, "charset": "binary", "ctime": 1551821118.7710035, "dev": 64768, "device_type": 0, "executable": true, "exists": true, "gid": 1002, "gr_name": "oinstall", "inode": 67147322, "isblk": false, "ischr": false, "isdir": true, "isfifo": false, "isgid": false, "islnk": false, "isreg": false, "issock": false, "isuid": false, "mimetype": "inode/directory", "mode": "0774", "mtime": 1551775161.259156, "nlink": 2, "path": "/opt/oraInventory", "pw_name": "oracle", "readable": true, "rgrp": true, "roth": true, "rusr": true, "size": 6, "uid": 1001, "version": "18446744073111552036", "wgrp": true, "woth": false, "writeable": true, "wusr": true, "xgrp": true, "xoth": false, "xusr": true}}

TASK [lean_delivery.oracle_db : Create inventory directory] ***************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oraInst/checkOraInst.yml:32
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Create oracledb directories (install)] ****************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:22
ok: [172.17.8.242] => {"changed": false, "gid": 1002, "group": "oinstall", "mode": "0755", "owner": "oracle", "path": "/opt/install/oracledb", "secontext": "unconfined_u:object_r:usr_t:s0", "size": 36, "state": "directory", "uid": 1001}

TASK [lean_delivery.oracle_db : Create /opt/oracledb directory] ***********************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:29
ok: [172.17.8.242] => {"changed": false, "gid": 1002, "group": "oinstall", "mode": "0755", "owner": "oracle", "path": "/opt/oracledb", "secontext": "unconfined_u:object_r:usr_t:s0", "size": 6, "state": "directory", "uid": 1001}

TASK [lean_delivery.oracle_db : Chown install directory to oracle user] ***************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:38
ok: [172.17.8.242] => {"changed": false, "gid": 1002, "group": "oinstall", "mode": "0755", "owner": "oracle", "path": "/opt/install/oracledb", "secontext": "unconfined_u:object_r:usr_t:s0", "size": 36, "state": "directory", "uid": 1001}

TASK [lean_delivery.oracle_db : Install requirements] *********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:47
ok: [172.17.8.242] => {"attempts": 1, "changed": false, "msg": "", "rc": 0, "results": ["binutils-2.25.1-32.base.el7_4.1.x86_64 providing binutils is already installed", "gcc-4.8.5-36.el7.x86_64 providing gcc is already installed", "gcc-c++-4.8.5-36.el7.x86_64 providing gcc-c++ is already installed", "glibc-2.17-260.el7_6.3.x86_64 providing glibc is already installed", "glibc-common-2.17-260.el7_6.3.x86_64 providing glibc-common is already installed", "glibc-devel-2.17-260.el7_6.3.i686 providing glibc-devel is already installed", "glibc-headers-2.17-260.el7_6.3.x86_64 providing glibc-headers is already installed", "ksh-20120801-139.el7.x86_64 providing ksh is already installed", "libaio-0.3.109-13.el7.i686 providing libaio is already installed", "libaio-devel-0.3.109-13.el7.x86_64 providing libaio-devel is already installed", "libgcc-4.8.5-36.el7.x86_64 providing libgcc is already installed", "libstdc++-4.8.5-36.el7.i686 providing libstdc++ is already installed", "libstdc++-devel-4.8.5-36.el7.x86_64 providing libstdc++-devel is already installed", "libXext-1.3.3-3.el7.x86_64 providing libXext is already installed", "libXtst-1.2.3-1.el7.i686 providing libXtst is already installed", "libX11-1.6.5-2.el7.x86_64 providing libX11 is already installed", "libXau-1.0.8-2.1.el7.i686 providing libXau is already installed", "libXi-1.7.9-1.el7.i686 providing libXi is already installed", "1:make-3.82-23.el7.x86_64 providing make is already installed", "sysstat-10.1.5-17.el7.x86_64 providing sysstat is already installed", "unixODBC-2.3.1-11.el7.x86_64 providing unixODBC is already installed", "unixODBC-devel-2.3.1-11.el7.x86_64 providing unixODBC-devel is already installed", "zlib-devel-1.2.7-18.el7.x86_64 providing zlib-devel is already installed", "compat-libcap1-1.10-7.el7.x86_64 providing compat-libcap1 is already installed", "compat-libstdc++-33-3.2.3-72.el7.x86_64 providing compat-libstdc++-33 is already installed", "unzip-6.0-19.el7.x86_64 providing unzip is already installed", "glibc-2.17-260.el7_6.3.i686 providing glibc.i686 is already installed", "compat-libcap1-1.10-7.el7.x86_64 providing compat-libcap1 is already installed", "glibc-devel-2.17-260.el7_6.3.i686 providing glibc-devel.i686 is already installed", "libaio-0.3.109-13.el7.i686 providing libaio.i686 is already installed", "libaio-devel-0.3.109-13.el7.i686 providing libaio-devel.i686 is already installed", "libstdc++-4.8.5-36.el7.i686 providing libstdc++.i686 is already installed", "libstdc++-devel-4.8.5-36.el7.i686 providing libstdc++-devel.i686 is already installed", "libXi-1.7.9-1.el7.i686 providing libXi.i686 is already installed", "libXtst-1.2.3-1.el7.i686 providing libXtst is already installed", "libXtst-1.2.3-1.el7.i686 providing libXtst.i686 is already installed"]}

TASK [lean_delivery.oracle_db : Fetch artifact with local transport] ******************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:57
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/fetch/local.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Artifacts stored localy] ******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/fetch/local.yml:3
ok: [172.17.8.242] => (item=linuxx64_12201_database.zip) => {"ansible_facts": {"oracle_db_artifacts": ["/home/w/tool/oralce/linuxx64_12201_database.zip"]}, "changed": false, "item": "linuxx64_12201_database.zip"}

TASK [lean_delivery.oracle_db : Check unziped folder] *********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:65
ok: [172.17.8.242] => {"changed": false, "stat": {"atime": 1551822078.6733859, "attr_flags": "", "attributes": [], "block_size": 4096, "blocks": 0, "charset": "binary", "ctime": 1551821053.6179786, "dev": 64768, "device_type": 0, "executable": true, "exists": true, "gid": 1002, "gr_name": "oinstall", "inode": 29273, "isblk": false, "ischr": false, "isdir": true, "isfifo": false, "isgid": false, "islnk": false, "isreg": false, "issock": false, "isuid": false, "mimetype": "inode/directory", "mode": "0755", "mtime": 1485447727.0, "nlink": 7, "path": "/opt/install/oracledb/database", "pw_name": "oracle", "readable": true, "rgrp": true, "roth": true, "rusr": true, "size": 117, "uid": 1001, "version": "18446744071991976379", "wgrp": false, "woth": false, "writeable": true, "wusr": true, "xgrp": true, "xoth": true, "xusr": true}}

TASK [lean_delivery.oracle_db : Unzip oracle installer] *******************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:71
skipping: [172.17.8.242] => (item=/home/w/tool/oralce/linuxx64_12201_database.zip)  => {"changed": false, "item": "/home/w/tool/oralce/linuxx64_12201_database.zip", "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Remove installs] **************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:80
ok: [172.17.8.242] => (item=linuxx64_12201_database.zip) => {"changed": false, "item": "linuxx64_12201_database.zip", "path": "/opt/install/oracledb/linuxx64_12201_database.zip", "state": "absent"}

TASK [lean_delivery.oracle_db : Copy rsp file for Oracle] *****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:87
changed: [172.17.8.242] => {"changed": true, "checksum": "69bcf9b5f2eb6f788a375e512c4523e3b8628dd9", "dest": "/opt/install/oracledb/db.rsp", "gid": 1002, "group": "oinstall", "md5sum": "761b1f9f03e5c75fde3a32f966ba4f14", "mode": "0644", "owner": "oracle", "secontext": "system_u:object_r:usr_t:s0", "size": 2352, "src": "/root/.ansible/tmp/ansible-tmp-1551867578.7876067-159789350102027/source", "state": "file", "uid": 1001}

TASK [lean_delivery.oracle_db : Read Oracle profile] **********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/prepare.yml:95
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/profile/oracle-db-profile.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Create environment variables for Oracle DB] ***********************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/profile/oracle-db-profile.yml:3
ok: [172.17.8.242] => {"changed": false, "checksum": "e2fcfedd0e25de1aedc30f02a5d220261143eb59", "dest": "/etc/profile.d/oracle_env.sh", "gid": 0, "group": "root", "mode": "0644", "owner": "root", "path": "/etc/profile.d/oracle_env.sh", "secontext": "system_u:object_r:bin_t:s0", "size": 448, "state": "file", "uid": 0}

TASK [lean_delivery.oracle_db : Create swap file] *************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:22
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Adjust kernel parameters and shared memory] ***********************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:26
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Change kernel parameters] *****************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:3
ok: [172.17.8.242] => (item={'name': 'fs.file-max', 'value': '6815744'}) => {"changed": false, "item": {"name": "fs.file-max", "value": "6815744"}}
ok: [172.17.8.242] => (item={'name': 'kernel.sem', 'value': '250 32000 100 128'}) => {"changed": false, "item": {"name": "kernel.sem", "value": "250 32000 100 128"}}
ok: [172.17.8.242] => (item={'name': 'kernel.shmmni', 'value': '4096'}) => {"changed": false, "item": {"name": "kernel.shmmni", "value": "4096"}}
ok: [172.17.8.242] => (item={'name': 'kernel.shmall', 'value': '1073741824'}) => {"changed": false, "item": {"name": "kernel.shmall", "value": "1073741824"}}
ok: [172.17.8.242] => (item={'name': 'kernel.shmmax', 'value': '4398046511104'}) => {"changed": false, "item": {"name": "kernel.shmmax", "value": "4398046511104"}}
ok: [172.17.8.242] => (item={'name': 'net.core.rmem_default', 'value': '262144'}) => {"changed": false, "item": {"name": "net.core.rmem_default", "value": "262144"}}
ok: [172.17.8.242] => (item={'name': 'net.core.rmem_max', 'value': '4194304'}) => {"changed": false, "item": {"name": "net.core.rmem_max", "value": "4194304"}}
ok: [172.17.8.242] => (item={'name': 'net.core.wmem_default', 'value': '262144'}) => {"changed": false, "item": {"name": "net.core.wmem_default", "value": "262144"}}
ok: [172.17.8.242] => (item={'name': 'net.core.wmem_max', 'value': '1048576'}) => {"changed": false, "item": {"name": "net.core.wmem_max", "value": "1048576"}}
ok: [172.17.8.242] => (item={'name': 'fs.aio-max-nr', 'value': '1048576'}) => {"changed": false, "item": {"name": "fs.aio-max-nr", "value": "1048576"}}
ok: [172.17.8.242] => (item={'name': 'net.ipv4.ip_local_port_range', 'value': '9000 65500'}) => {"changed": false, "item": {"name": "net.ipv4.ip_local_port_range", "value": "9000 65500"}}

TASK [lean_delivery.oracle_db : Change limits] ****************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:13
ok: [172.17.8.242] => (item=oracle   soft   nofile   1024) => {"backup": "", "changed": false, "item": "oracle   soft   nofile   1024", "msg": ""}
ok: [172.17.8.242] => (item=oracle   hard   nofile   65536) => {"backup": "", "changed": false, "item": "oracle   hard   nofile   65536", "msg": ""}
ok: [172.17.8.242] => (item=oracle   soft   nproc    2047) => {"backup": "", "changed": false, "item": "oracle   soft   nproc    2047", "msg": ""}
ok: [172.17.8.242] => (item=oracle   hard   nproc    16384) => {"backup": "", "changed": false, "item": "oracle   hard   nproc    16384", "msg": ""}
ok: [172.17.8.242] => (item=oracle   soft   stack    10240) => {"backup": "", "changed": false, "item": "oracle   soft   stack    10240", "msg": ""}
ok: [172.17.8.242] => (item=oracle   hard   stack    32768) => {"backup": "", "changed": false, "item": "oracle   hard   stack    32768", "msg": ""}
ok: [172.17.8.242] => (item=oracle   soft   memlock  7340032) => {"backup": "", "changed": false, "item": "oracle   soft   memlock  7340032", "msg": ""}
ok: [172.17.8.242] => (item=oracle   hard   memlock  8388608) => {"backup": "", "changed": false, "item": "oracle   hard   memlock  8388608", "msg": ""}

TASK [lean_delivery.oracle_db : Resize /dev/shm] **************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:21
ok: [172.17.8.242] => {"changed": false, "dump": "0", "fstab": "/etc/fstab", "fstype": "tmpfs", "name": "/dev/shm", "opts": "defaults,size=2847M", "passno": "0", "src": "tmpfs"}

TASK [lean_delivery.oracle_db : Remember shm state] ***********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:31
ok: [172.17.8.242] => {"ansible_facts": {"need_remount": false}, "changed": false}

TASK [lean_delivery.oracle_db : Unmount tmpfs] ****************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:35
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Mounting tmpfs] ***************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/system/kernel.yml:42
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Oracle DB XE install] *********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:29
skipping: [172.17.8.242] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [lean_delivery.oracle_db : Oracle DB 11 or 12 install] ***************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/main.yml:33
included: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml for 172.17.8.242

TASK [lean_delivery.oracle_db : Install Oracle RDBMS] *********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:3
changed: [172.17.8.242] => {"changed": true, "cmd": ["/opt/install/oracledb/database/runInstaller", "-silent", "-waitforcompletion", "-ignorePrereq", "-responseFile", "/opt/install/oracledb/db.rsp"], "delta": "0:06:11.780834", "end": "2019-03-05 21:47:53.521154", "failed_when_result": false, "rc": 0, "start": "2019-03-05 21:41:41.740320", "stderr": "", "stderr_lines": [], "stdout": "正在启动 Oracle Universal Installer...\n\n检查临时空间: 必须大于 500 MB。   实际为 29482 MB    通过\n检查交换空间: 必须大于 150 MB。   实际为 5805 MB    通过\n准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-05_09-41-41PM. 请稍候...可以在以下位置找到本次安装会话的日志:\n /opt/oraInventory/logs/installActions2019-03-05_09-41-41PM.log\nOracle Database 12c 的 安装 已成功。\n请查看 '/opt/oraInventory/logs/silentInstall2019-03-05_09-41-41PM.log' 以获取详细资料。\n\n以 root 用户的身份执行以下脚本:\n\t1. /opt/oraInventory/orainstRoot.sh\n\t2. /opt/oracledb/product/12.2.0.1/db_1/root.sh\n\n\n\nSuccessfully Setup Software.\n安装用户可以执行以下命令来完成配置。\n\t/opt/install/oracledb/database/runInstaller -executeConfigTools -responseFile /opt/install/oracledb/db.rsp [-silent]", "stdout_lines": ["正在启动 Oracle Universal Installer...", "", "检查临时空间: 必须大于 500 MB。   实际为 29482 MB    通过", "检查交换空间: 必须大于 150 MB。   实际为 5805 MB    通过", "准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-05_09-41-41PM. 请稍候...可以在以下位置找到本次安装会话的日志:", " /opt/oraInventory/logs/installActions2019-03-05_09-41-41PM.log", "Oracle Database 12c 的 安装 已成功。", "请查看 '/opt/oraInventory/logs/silentInstall2019-03-05_09-41-41PM.log' 以获取详细资料。", "", "以 root 用户的身份执行以下脚本:", "\t1. /opt/oraInventory/orainstRoot.sh", "\t2. /opt/oracledb/product/12.2.0.1/db_1/root.sh", "", "", "", "Successfully Setup Software.", "安装用户可以执行以下命令来完成配置。", "\t/opt/install/oracledb/database/runInstaller -executeConfigTools -responseFile /opt/install/oracledb/db.rsp [-silent]"]}

TASK [lean_delivery.oracle_db : Start scripts after install] **************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:16
changed: [172.17.8.242] => {"changed": true, "cmd": ["/bin/bash", "/opt/oraInventory/orainstRoot.sh"], "delta": "0:00:00.088857", "end": "2019-03-05 21:47:56.737979", "rc": 0, "start": "2019-03-05 21:47:56.649122", "stderr": "", "stderr_lines": [], "stdout": "更改权限/opt/oraInventory.\n添加组的读取和写入权限。\n删除全局的读取, 写入和执行权限。\n\n更改组名/opt/oraInventory 到 oinstall.\n脚本的执行已完成。", "stdout_lines": ["更改权限/opt/oraInventory.", "添加组的读取和写入权限。", "删除全局的读取, 写入和执行权限。", "", "更改组名/opt/oraInventory 到 oinstall.", "脚本的执行已完成。"]}

TASK [lean_delivery.oracle_db : Start root.sh script] *********************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:23
changed: [172.17.8.242] => {"changed": true, "cmd": ["/bin/bash", "/opt/oracledb/product/12.2.0.1/db_1/root.sh"], "delta": "0:00:00.275027", "end": "2019-03-05 21:47:57.667099", "rc": 0, "start": "2019-03-05 21:47:57.392072", "stderr": "", "stderr_lines": [], "stdout": "Check /opt/oracledb/product/12.2.0.1/db_1/install/root_oracle2_2019-03-05_21-47-57-414776236.log for the output of root script", "stdout_lines": ["Check /opt/oracledb/product/12.2.0.1/db_1/install/root_oracle2_2019-03-05_21-47-57-414776236.log for the output of root script"]}

TASK [lean_delivery.oracle_db : Create rsp file for oracle] ***************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:30
changed: [172.17.8.242] => {"changed": true, "checksum": "bdb69cafc38536626f225ed9212ac51ab7a71e57", "dest": "/opt/install/oracledb/pwd.rsp", "gid": 1002, "group": "oinstall", "md5sum": "a276c972a45e47486df33eb3f84feb6d", "mode": "0644", "owner": "oracle", "secontext": "system_u:object_r:usr_t:s0", "size": 286, "src": "/root/.ansible/tmp/ansible-tmp-1551867940.9619715-187201551600404/source", "state": "file", "uid": 1001}

TASK [lean_delivery.oracle_db : Create db] ********************************************************************************
task path: /etc/ansible/roles/lean_delivery.oracle_db/tasks/oracle-db-11-12.yml:38
fatal: [172.17.8.242]: FAILED! => {"changed": false, "cmd": ["/bin/bash", "/opt/oracledb/product/12.2.0.1/db_1/cfgtoollogs/configToolAllCommands", "RESPONSE_FILE=/opt/install/oracledb/pwd.rsp"], "delta": "0:00:08.534211", "end": "2019-03-05 21:48:08.074149", "failed_when_result": true, "msg": "non-zero return code", "rc": 3, "start": "2019-03-05 21:47:59.539938", "stderr": "三月 05, 2019 9:48:03 下午 oracle.install.config.common.NetCAInternalPlugIn invoke\n信息: NetCAInternalPlugIn: ... adding </ouiinternal>\n三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn invoke\n信息: Executing NETCA\n三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn invoke\n信息: Command /opt/oracledb/product/12.2.0.1/db_1/bin/netca /orahome /opt/oracledb/product/12.2.0.1/db_1 /instype typical /inscomp client,oraclenet,javavm,server,ano /insprtcl tcp /cfg local /authadp NO_VALUE /responseFile /opt/oracledb/product/12.2.0.1/db_1/network/install/netca_typ.rsp /silent /orahnam OraDB12Home1 /ouiinternal \n三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: ... GenericInternalPlugIn.handleProcess() entered.\n三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: ... GenericInternalPlugIn: getting configAssistantParmas.\n三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: ... GenericInternalPlugIn: checking secretArguments.\n三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: No arguments to pass to stdin\n三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: ... GenericInternalPlugIn: starting read loop.\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: \n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: \n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: End of argument passing to stdin\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: 正在对命令行参数进行语法分析:\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: 正在对命令行参数进行语法分析:\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"orahome\" = /opt/oracledb/product/12.2.0.1/db_1\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"orahome\" = /opt/oracledb/product/12.2.0.1/db_1\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"instype\" = typical\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"instype\" = typical\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"inscomp\" = client,oraclenet,javavm,server,ano\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"inscomp\" = client,oraclenet,javavm,server,ano\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"insprtcl\" = tcp\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"insprtcl\" = tcp\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"cfg\" = local\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"cfg\" = local\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"authadp\" = NO_VALUE\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"authadp\" = NO_VALUE\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"responsefile\" = /opt/oracledb/product/12.2.0.1/db_1/network/install/netca_typ.rsp\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"responsefile\" = /opt/oracledb/product/12.2.0.1/db_1/network/install/netca_typ.rsp\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"silent\" = true\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"silent\" = true\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"orahnam\" = OraDB12Home1\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"orahnam\" = OraDB12Home1\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     参数\"ouiinternal\" = true\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     参数\"ouiinternal\" = true\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: 完成对命令行参数进行语法分析。\n三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: 完成对命令行参数进行语法分析。\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: Oracle Net Services 配置:\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: Oracle Net Services 配置:\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: 完成概要文件配置。\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: 完成概要文件配置。\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: Oracle Net 监听程序启动:\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: Oracle Net 监听程序启动:\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: 为该监听程序提供的信息正由此计算机上的其他软件使用。\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: 为该监听程序提供的信息正由此计算机上的其他软件使用。\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read:     未能启动监听程序。\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line:     未能启动监听程序。\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: 有关详细信息, 请查看跟踪文件: /opt/oracledb/cfgtoollogs/netca/trace_OraDB12Home1-1903059下午4804.log\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: 有关详细信息, 请查看跟踪文件: /opt/oracledb/cfgtoollogs/netca/trace_OraDB12Home1-1903059下午4804.log\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n信息: Read: Oracle Net Services 配置失败。退出代码是1\n三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess\n警告: Skipping line: Oracle Net Services 配置失败。退出代码是1", "stderr_lines": ["三月 05, 2019 9:48:03 下午 oracle.install.config.common.NetCAInternalPlugIn invoke", "信息: NetCAInternalPlugIn: ... adding </ouiinternal>", "三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn invoke", "信息: Executing NETCA", "三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn invoke", "信息: Command /opt/oracledb/product/12.2.0.1/db_1/bin/netca /orahome /opt/oracledb/product/12.2.0.1/db_1 /instype typical /inscomp client,oraclenet,javavm,server,ano /insprtcl tcp /cfg local /authadp NO_VALUE /responseFile /opt/oracledb/product/12.2.0.1/db_1/network/install/netca_typ.rsp /silent /orahnam OraDB12Home1 /ouiinternal ", "三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: ... GenericInternalPlugIn.handleProcess() entered.", "三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: ... GenericInternalPlugIn: getting configAssistantParmas.", "三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: ... GenericInternalPlugIn: checking secretArguments.", "三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: No arguments to pass to stdin", "三月 05, 2019 9:48:03 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: ... GenericInternalPlugIn: starting read loop.", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: ", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: ", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: End of argument passing to stdin", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: 正在对命令行参数进行语法分析:", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: 正在对命令行参数进行语法分析:", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"orahome\" = /opt/oracledb/product/12.2.0.1/db_1", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"orahome\" = /opt/oracledb/product/12.2.0.1/db_1", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"instype\" = typical", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"instype\" = typical", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"inscomp\" = client,oraclenet,javavm,server,ano", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"inscomp\" = client,oraclenet,javavm,server,ano", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"insprtcl\" = tcp", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"insprtcl\" = tcp", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"cfg\" = local", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"cfg\" = local", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"authadp\" = NO_VALUE", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"authadp\" = NO_VALUE", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"responsefile\" = /opt/oracledb/product/12.2.0.1/db_1/network/install/netca_typ.rsp", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"responsefile\" = /opt/oracledb/product/12.2.0.1/db_1/network/install/netca_typ.rsp", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"silent\" = true", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"silent\" = true", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"orahnam\" = OraDB12Home1", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"orahnam\" = OraDB12Home1", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     参数\"ouiinternal\" = true", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     参数\"ouiinternal\" = true", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: 完成对命令行参数进行语法分析。", "三月 05, 2019 9:48:06 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: 完成对命令行参数进行语法分析。", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: Oracle Net Services 配置:", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: Oracle Net Services 配置:", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: 完成概要文件配置。", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: 完成概要文件配置。", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: Oracle Net 监听程序启动:", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: Oracle Net 监听程序启动:", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: 为该监听程序提供的信息正由此计算机上的其他软件使用。", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: 为该监听程序提供的信息正由此计算机上的其他软件使用。", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read:     未能启动监听程序。", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line:     未能启动监听程序。", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: 有关详细信息, 请查看跟踪文件: /opt/oracledb/cfgtoollogs/netca/trace_OraDB12Home1-1903059下午4804.log", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: 有关详细信息, 请查看跟踪文件: /opt/oracledb/cfgtoollogs/netca/trace_OraDB12Home1-1903059下午4804.log", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "信息: Read: Oracle Net Services 配置失败。退出代码是1", "三月 05, 2019 9:48:07 下午 oracle.install.driver.oui.config.GenericInternalPlugIn handleProcess", "警告: Skipping line: Oracle Net Services 配置失败。退出代码是1"], "stdout": "Setting the invPtrLoc to /opt/oracledb/product/12.2.0.1/db_1/oraInst.loc\n\nperform - 操作的模式正在启动: configure\n\n\nperform - 操作的模式已完成: configure\n\n您可以查看日志文件: /opt/oracledb/product/12.2.0.1/db_1/cfgtoollogs/oui/configActions2019-03-05_09-48-01-PM.log", "stdout_lines": ["Setting the invPtrLoc to /opt/oracledb/product/12.2.0.1/db_1/oraInst.loc", "", "perform - 操作的模式正在启动: configure", "", "", "perform - 操作的模式已完成: configure", "", "您可以查看日志文件: /opt/oracledb/product/12.2.0.1/db_1/cfgtoollogs/oui/configActions2019-03-05_09-48-01-PM.log"]}
        to retry, use: --limit @/media/xh/i/python/wymproject/oracle/oracleinstalltest/lean_delivery_oracle12201.retry

PLAY RECAP ****************************************************************************************************************
172.17.8.242               : ok=32   changed=5    unreachable=0    failed=1 





$ /bin/bash /opt/oracledb/product/12.2.0.1/db_1/cfgtoollogs/configToolAllCommands RESPONSE_FILE=/opt/install/oracledb/pwd.rsp


```

























### 使用sysco-middleware.oracle-database

#### 目录

```yml

~/.ansible/roles/sysco-middleware.oracle-database [15:40:21] 
$ tree -L 2
.
├── defaults
│   └── main.yml
├── handlers
│   └── main.yml
├── LICENSE
├── meta
│   └── main.yml
├── README.md
├── tasks
│   ├── install.yml
│   ├── main.yml
│   ├── postinstall.yml
│   ├── prepare-OracleLinux.yml
│   ├── prepare.yml
│   └── validate.yml
├── templates
│   ├── db-install-11g.rsp.j2
│   └── db-install-12c.rsp.j2
├── tests
│   ├── docker
│   ├── main.yml
│   ├── roles.yml
│   └── Vagrantfile
└── vars
    ├── main.yml
    └── oracle-database.yml

8 directories, 18 files

```


#### 数据库信息

````

ORACLE_HOME=/home/oracle/product/oracle_home
ORACLE_BASE=/home/oracle/product


SID = TESTDB
SYSTEMPASSWORD = welcome1

````



#### 相关配置

```yml

/etc/ansible/roles/sysco-middleware.oracle-database

1、修改配置（可以不修改，写到sysco_oracle11204.yml文件里优先级最高）

/etc/ansible/roles/sysco-middleware.oracle-database/defaults/main.yml
oracle_database_version: 11g # supported versions: [11g, 12c]
oracle_database_edition: EE #SE # supported editions: [SE,EE]
# installers
oracle_database_installer_directory: /oracle/oracle11.2.0.4/database



2./etc/ansible/roles/sysco-middleware.oracle-database/vars/oracle-database.yml
此文件包括需要安装的软件包列表、内核参数，修改改为最新版本格式和参数

oracle_database_kernel_params:
  sysctl:
    - {name: "fs.file-max", value: "6815744"}
    - {name: "kernel.sem", value: "250 32000 100 128"}
    - {name: "kernel.shmmni", value: "4096"}
    - {name: "kernel.shmall", value: "1073741824"}
    - {name: "kernel.shmmax", value: "4398046511104"}
    - {name: "net.core.rmem_default", value: "262144"}
    - {name: "net.core.rmem_max", value: "4194304"}
    - {name: "net.core.wmem_default", value: "262144"}
    - {name: "net.core.wmem_max", value: "1048576"}
    - {name: "fs.aio-max-nr", value: "1048576"}
    - {name: "net.ipv4.ip_local_port_range", value: "9000 65500"}



3./etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml
修改第四行，预安装要求，新ansible版本已经弃用的循环方式
- name: "Install requirements"
  package:
    name: "{{ oracle_database_packages_list }}"
    state: present
  register: status
  retries: 10
  delay: 2
  until: status is success
  become: True

20多行
- name: "Change kernel parameters"
  sysctl:
    name: "{{ item.name }}"
    value: "{{ item.value }}"
    state: present
    ignoreerrors: True
    reload: True
  loop: "{{ oracle_database_kernel_params.sysctl }}"
  become: True


4、执行
$ ansible-playbook /media/xh/i/python/wymproject/oracle/oracleinstalltest/sysco_oracle11204.yml -vv


```

#### 报错信息

```yml



```



#### 安装过程记录

```yml
# w @ uw in /media/xh/i/python/wymproject/oracle/oracleinstalltest on git:master x [11:30:55] C:2
$ ansible-playbook sysco_oracle11204.yml -vv
ansible-playbook 2.7.5
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/w/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.6/dist-packages/ansible
  executable location = /usr/local/bin/ansible-playbook
  python version = 3.6.7 (default, Oct 22 2018, 11:32:17) [GCC 8.2.0]
Using /etc/ansible/ansible.cfg as config file
/etc/ansible/hosts did not meet host_list requirements, check plugin documentation if this is unexpected
/etc/ansible/hosts did not meet script requirements, check plugin documentation if this is unexpected
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/validate.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare-OracleLinux.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/install.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/postinstall.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/validate.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-listener.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance.yml
statically imported: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance-service.yml

PLAYBOOK: sysco_oracle11204.yml *****************************************************
1 plays in sysco_oracle11204.yml

PLAY [oracle database 11g (11.2.0.4)] ***********************************************

TASK [Gathering Facts] **************************************************************
task path: /media/xh/i/python/wymproject/oracle/oracleinstalltest/sysco_oracle11204.yml:1
ok: [172.17.8.241]
META: ran handlers

TASK [sysco-middleware.oracle-database : validate oracle database is already installed] ***
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/validate.yml:1
ok: [172.17.8.241] => {"changed": false, "stat": {"exists": false}}

TASK [sysco-middleware.oracle-database : debug] *************************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/validate.yml:6
skipping: [172.17.8.241] => {}

TASK [sysco-middleware.oracle-database : set_fact] **********************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/validate.yml:10
skipping: [172.17.8.241] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [sysco-middleware.oracle-database : debug] *************************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/main.yml:6
ok: [172.17.8.241] => {
    "msg": "OS Family: CentOS"
}

TASK [sysco-middleware.oracle-database : install pre-installation package] **********
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare-OracleLinux.yml:3
skipping: [172.17.8.241] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [sysco-middleware.oracle-database : install pre-installation package] **********
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare-OracleLinux.yml:7
skipping: [172.17.8.241] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [sysco-middleware.oracle-database : file] **************************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare-OracleLinux.yml:11
skipping: [172.17.8.241] => (item=/home/oracle/oracle_inventory)  => {"changed": false, "item": "/home/oracle/oracle_inventory", "skip_reason": "Conditional result was False"}
skipping: [172.17.8.241] => (item=/home/oracle/product)  => {"changed": false, "item": "/home/oracle/product", "skip_reason": "Conditional result was False"}
skipping: [172.17.8.241] => (item=/home/oracle/product/oracle_home)  => {"changed": false, "item": "/home/oracle/product/oracle_home", "skip_reason": "Conditional result was False"}

TASK [sysco-middleware.oracle-database : include_vars] ******************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:2
ok: [172.17.8.241] => {"ansible_facts": {"oracle_database_kernel_params": {"fs.file-max": 409600, "kernel.sem": "250 32000 100 128", "kernel.shmall": 393216, "kernel.shmmax": 4398046511104, "kernel.shmmni": 4096, "net.core.rmem_max": 16777216, "net.core.wmem_max": 16777216, "net.ipv4.ip_local_port_range": "9000 65500", "net.ipv4.tcp_keepalive_intvl": 60, "net.ipv4.tcp_keepalive_probes": 10, "net.ipv4.tcp_keepalive_time": 300, "net.ipv4.tcp_rmem": "4096 87380 16777216", "net.ipv4.tcp_wmem": "4096 65536 16777216", "vm.dirty_background_ratio": 5, "vm.dirty_ratio": 10, "vm.swappiness": 10}, "oracle_database_limits_hard_memlock": 1887437, "oracle_database_limits_hard_no_file": 65536, "oracle_database_limits_hard_nproc": 16384, "oracle_database_limits_hard_stack": 32768, "oracle_database_limits_soft_memlock": 1887437, "oracle_database_limits_soft_no_file": 4096, "oracle_database_limits_soft_nproc": 2047, "oracle_database_limits_soft_stack": 10240, "oracle_database_packages_list": ["binutils", "compat-libcap1", "gcc", "gcc-c++", "glibc", "glibc-common", "glibc.i686", "glibc-devel", "glibc-headers", "glibc-devel.i686", "ksh", "libaio.i686", "libaio-devel", "libaio-devel.i686", "libstdc++.i686", "libstdc++-devel", "libstdc++-devel.i686", "libXi", "libXi.i686", "libXtst", "libXtst.i686", "sysstat", "unixODBC", "unzip"], "syscooracledb": {"sysctl": [{"name": "fs.file-max", "value": "6815744"}, {"name": "kernel.sem", "value": "250 32000 100 128"}, {"name": "kernel.shmmni", "value": "4096"}, {"name": "kernel.shmall", "value": "1073741824"}, {"name": "kernel.shmmax", "value": "4398046511104"}, {"name": "net.core.rmem_default", "value": "262144"}, {"name": "net.core.rmem_max", "value": "4194304"}, {"name": "net.core.wmem_default", "value": "262144"}, {"name": "net.core.wmem_max", "value": "1048576"}, {"name": "fs.aio-max-nr", "value": "1048576"}, {"name": "net.ipv4.ip_local_port_range", "value": "9000 65500"}]}, "sysctl": [{"name": "fs.file-max", "value": "6815744"}, {"name": "kernel.sem", "value": "250 32000 100 128"}, {"name": "kernel.shmmni", "value": "4096"}, {"name": "kernel.shmall", "value": "1073741824"}, {"name": "kernel.shmmax", "value": "4398046511104"}, {"name": "net.core.rmem_default", "value": "262144"}, {"name": "net.core.rmem_max", "value": "4194304"}, {"name": "net.core.wmem_default", "value": "262144"}, {"name": "net.core.wmem_max", "value": "1048576"}, {"name": "fs.aio-max-nr", "value": "1048576"}, {"name": "net.ipv4.ip_local_port_range", "value": "9000 65500"}]}, "ansible_included_var_files": ["/etc/ansible/roles/sysco-middleware.oracle-database/vars/oracle-database.yml"], "changed": false}

TASK [sysco-middleware.oracle-database : Install requirements] **********************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:8
ok: [172.17.8.241] => (item=binutils) => {"changed": false, "item": "binutils", "msg": "", "rc": 0, "results": ["binutils-2.25.1-32.base.el7_4.1.x86_64 providing binutils is already installed"]}
ok: [172.17.8.241] => (item=compat-libcap1) => {"changed": false, "item": "compat-libcap1", "msg": "", "rc": 0, "results": ["compat-libcap1-1.10-7.el7.x86_64 providing compat-libcap1 is already installed"]}
ok: [172.17.8.241] => (item=gcc) => {"changed": false, "item": "gcc", "msg": "", "rc": 0, "results": ["gcc-4.8.5-36.el7.x86_64 providing gcc is already installed"]}
ok: [172.17.8.241] => (item=gcc-c++) => {"changed": false, "item": "gcc-c++", "msg": "", "rc": 0, "results": ["gcc-c++-4.8.5-36.el7.x86_64 providing gcc-c++ is already installed"]}
ok: [172.17.8.241] => (item=glibc) => {"changed": false, "item": "glibc", "msg": "", "rc": 0, "results": ["glibc-2.17-260.el7_6.3.x86_64 providing glibc is already installed"]}
ok: [172.17.8.241] => (item=glibc-common) => {"changed": false, "item": "glibc-common", "msg": "", "rc": 0, "results": ["glibc-common-2.17-260.el7_6.3.x86_64 providing glibc-common is already installed"]}
ok: [172.17.8.241] => (item=glibc.i686) => {"changed": false, "item": "glibc.i686", "msg": "", "rc": 0, "results": ["glibc-2.17-260.el7_6.3.i686 providing glibc.i686 is already installed"]}
ok: [172.17.8.241] => (item=glibc-devel) => {"changed": false, "item": "glibc-devel", "msg": "", "rc": 0, "results": ["glibc-devel-2.17-260.el7_6.3.i686 providing glibc-devel is already installed"]}
ok: [172.17.8.241] => (item=glibc-headers) => {"changed": false, "item": "glibc-headers", "msg": "", "rc": 0, "results": ["glibc-headers-2.17-260.el7_6.3.x86_64 providing glibc-headers is already installed"]}
ok: [172.17.8.241] => (item=glibc-devel.i686) => {"changed": false, "item": "glibc-devel.i686", "msg": "", "rc": 0, "results": ["glibc-devel-2.17-260.el7_6.3.i686 providing glibc-devel.i686 is already installed"]}
ok: [172.17.8.241] => (item=ksh) => {"changed": false, "item": "ksh", "msg": "", "rc": 0, "results": ["ksh-20120801-139.el7.x86_64 providing ksh is already installed"]}
ok: [172.17.8.241] => (item=libaio.i686) => {"changed": false, "item": "libaio.i686", "msg": "", "rc": 0, "results": ["libaio-0.3.109-13.el7.i686 providing libaio.i686 is already installed"]}
ok: [172.17.8.241] => (item=libaio-devel) => {"changed": false, "item": "libaio-devel", "msg": "", "rc": 0, "results": ["libaio-devel-0.3.109-13.el7.x86_64 providing libaio-devel is already installed"]}
ok: [172.17.8.241] => (item=libaio-devel.i686) => {"changed": false, "item": "libaio-devel.i686", "msg": "", "rc": 0, "results": ["libaio-devel-0.3.109-13.el7.i686 providing libaio-devel.i686 is already installed"]}
ok: [172.17.8.241] => (item=libstdc++.i686) => {"changed": false, "item": "libstdc++.i686", "msg": "", "rc": 0, "results": ["libstdc++-4.8.5-36.el7.i686 providing libstdc++.i686 is already installed"]}
ok: [172.17.8.241] => (item=libstdc++-devel) => {"changed": false, "item": "libstdc++-devel", "msg": "", "rc": 0, "results": ["libstdc++-devel-4.8.5-36.el7.x86_64 providing libstdc++-devel is already installed"]}
ok: [172.17.8.241] => (item=libstdc++-devel.i686) => {"changed": false, "item": "libstdc++-devel.i686", "msg": "", "rc": 0, "results": ["libstdc++-devel-4.8.5-36.el7.i686 providing libstdc++-devel.i686 is already installed"]}
ok: [172.17.8.241] => (item=libXi) => {"changed": false, "item": "libXi", "msg": "", "rc": 0, "results": ["libXi-1.7.9-1.el7.i686 providing libXi is already installed"]}
ok: [172.17.8.241] => (item=libXi.i686) => {"changed": false, "item": "libXi.i686", "msg": "", "rc": 0, "results": ["libXi-1.7.9-1.el7.i686 providing libXi.i686 is already installed"]}
ok: [172.17.8.241] => (item=libXtst) => {"changed": false, "item": "libXtst", "msg": "", "rc": 0, "results": ["libXtst-1.2.3-1.el7.i686 providing libXtst is already installed"]}
ok: [172.17.8.241] => (item=libXtst.i686) => {"changed": false, "item": "libXtst.i686", "msg": "", "rc": 0, "results": ["libXtst-1.2.3-1.el7.i686 providing libXtst.i686 is already installed"]}
ok: [172.17.8.241] => (item=sysstat) => {"changed": false, "item": "sysstat", "msg": "", "rc": 0, "results": ["sysstat-10.1.5-17.el7.x86_64 providing sysstat is already installed"]}
ok: [172.17.8.241] => (item=unixODBC) => {"changed": false, "item": "unixODBC", "msg": "", "rc": 0, "results": ["unixODBC-2.3.1-11.el7.x86_64 providing unixODBC is already installed"]}
ok: [172.17.8.241] => (item=unzip) => {"changed": false, "item": "unzip", "msg": "", "rc": 0, "results": ["unzip-6.0-19.el7.x86_64 providing unzip is already installed"]}

TASK [sysco-middleware.oracle-database : disable selinux] ***************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:14
 [WARNING]: SELinux state change will take effect next reboot

ok: [172.17.8.241] => {"changed": false, "configfile": "/etc/selinux/config", "msg": "", "policy": "targeted", "reboot_required": true, "state": "disabled"}

TASK [sysco-middleware.oracle-database : disable firewall deamon (firewalld)] *******
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:18
ok: [172.17.8.241] => {"changed": false, "enabled": false, "name": "firewalld", "state": "stopped", "status": {"ActiveEnterTimestampMonotonic": "0", "ActiveExitTimestampMonotonic": "0", "ActiveState": "inactive", "After": "system.slice polkit.service basic.target dbus.service", "AllowIsolate": "no", "AmbientCapabilities": "0", "AssertResult": "no", "AssertTimestampMonotonic": "0", "Before": "network-pre.target shutdown.target", "BlockIOAccounting": "no", "BlockIOWeight": "18446744073709551615", "BusName": "org.fedoraproject.FirewallD1", "CPUAccounting": "no", "CPUQuotaPerSecUSec": "infinity", "CPUSchedulingPolicy": "0", "CPUSchedulingPriority": "0", "CPUSchedulingResetOnFork": "no", "CPUShares": "18446744073709551615", "CanIsolate": "no", "CanReload": "yes", "CanStart": "yes", "CanStop": "yes", "CapabilityBoundingSet": "18446744073709551615", "ConditionResult": "no", "ConditionTimestampMonotonic": "0", "Conflicts": "shutdown.target iptables.service ebtables.service ipset.service ip6tables.service", "ControlPID": "0", "DefaultDependencies": "yes", "Delegate": "no", "Description": "firewalld - dynamic firewall daemon", "DevicePolicy": "auto", "Documentation": "man:firewalld(1)", "EnvironmentFile": "/etc/sysconfig/firewalld (ignore_errors=yes)", "ExecMainCode": "0", "ExecMainExitTimestampMonotonic": "0", "ExecMainPID": "0", "ExecMainStartTimestampMonotonic": "0", "ExecMainStatus": "0", "ExecReload": "{ path=/bin/kill ; argv[]=/bin/kill -HUP $MAINPID ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "ExecStart": "{ path=/usr/sbin/firewalld ; argv[]=/usr/sbin/firewalld --nofork --nopid $FIREWALLD_ARGS ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "FailureAction": "none", "FileDescriptorStoreMax": "0", "FragmentPath": "/usr/lib/systemd/system/firewalld.service", "GuessMainPID": "yes", "IOScheduling": "0", "Id": "firewalld.service", "IgnoreOnIsolate": "no", "IgnoreOnSnapshot": "no", "IgnoreSIGPIPE": "yes", "InactiveEnterTimestampMonotonic": "0", "InactiveExitTimestampMonotonic": "0", "JobTimeoutAction": "none", "JobTimeoutUSec": "0", "KillMode": "mixed", "KillSignal": "15", "LimitAS": "18446744073709551615", "LimitCORE": "18446744073709551615", "LimitCPU": "18446744073709551615", "LimitDATA": "18446744073709551615", "LimitFSIZE": "18446744073709551615", "LimitLOCKS": "18446744073709551615", "LimitMEMLOCK": "65536", "LimitMSGQUEUE": "819200", "LimitNICE": "0", "LimitNOFILE": "4096", "LimitNPROC": "11321", "LimitRSS": "18446744073709551615", "LimitRTPRIO": "0", "LimitRTTIME": "18446744073709551615", "LimitSIGPENDING": "11321", "LimitSTACK": "18446744073709551615", "LoadState": "loaded", "MainPID": "0", "MemoryAccounting": "no", "MemoryCurrent": "18446744073709551615", "MemoryLimit": "18446744073709551615", "MountFlags": "0", "Names": "firewalld.service", "NeedDaemonReload": "no", "Nice": "0", "NoNewPrivileges": "no", "NonBlocking": "no", "NotifyAccess": "none", "OOMScoreAdjust": "0", "OnFailureJobMode": "replace", "PermissionsStartOnly": "no", "PrivateDevices": "no", "PrivateNetwork": "no", "PrivateTmp": "no", "ProtectHome": "no", "ProtectSystem": "no", "RefuseManualStart": "no", "RefuseManualStop": "no", "RemainAfterExit": "no", "Requires": "basic.target", "Restart": "no", "RestartUSec": "100ms", "Result": "success", "RootDirectoryStartOnly": "no", "RuntimeDirectoryMode": "0755", "SameProcessGroup": "no", "SecureBits": "0", "SendSIGHUP": "no", "SendSIGKILL": "yes", "Slice": "system.slice", "StandardError": "null", "StandardInput": "null", "StandardOutput": "null", "StartLimitAction": "none", "StartLimitBurst": "5", "StartLimitInterval": "10000000", "StartupBlockIOWeight": "18446744073709551615", "StartupCPUShares": "18446744073709551615", "StatusErrno": "0", "StopWhenUnneeded": "no", "SubState": "dead", "SyslogLevelPrefix": "yes", "SyslogPriority": "30", "SystemCallErrorNumber": "0", "TTYReset": "no", "TTYVHangup": "no", "TTYVTDisallocate": "no", "TasksAccounting": "no", "TasksCurrent": "18446744073709551615", "TasksMax": "18446744073709551615", "TimeoutStartUSec": "1min 30s", "TimeoutStopUSec": "1min 30s", "TimerSlackNSec": "50000", "Transient": "no", "Type": "dbus", "UMask": "0022", "UnitFilePreset": "enabled", "UnitFileState": "disabled", "Wants": "network-pre.target system.slice", "WatchdogTimestampMonotonic": "0", "WatchdogUSec": "0"}}

TASK [sysco-middleware.oracle-database : Change kernel parameters] ******************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:29
ok: [172.17.8.241] => (item={'name': 'fs.file-max', 'value': '6815744'}) => {"changed": false, "item": {"name": "fs.file-max", "value": "6815744"}}
ok: [172.17.8.241] => (item={'name': 'kernel.sem', 'value': '250 32000 100 128'}) => {"changed": false, "item": {"name": "kernel.sem", "value": "250 32000 100 128"}}
ok: [172.17.8.241] => (item={'name': 'kernel.shmmni', 'value': '4096'}) => {"changed": false, "item": {"name": "kernel.shmmni", "value": "4096"}}
ok: [172.17.8.241] => (item={'name': 'kernel.shmall', 'value': '1073741824'}) => {"changed": false, "item": {"name": "kernel.shmall", "value": "1073741824"}}
ok: [172.17.8.241] => (item={'name': 'kernel.shmmax', 'value': '4398046511104'}) => {"changed": false, "item": {"name": "kernel.shmmax", "value": "4398046511104"}}
ok: [172.17.8.241] => (item={'name': 'net.core.rmem_default', 'value': '262144'}) => {"changed": false, "item": {"name": "net.core.rmem_default", "value": "262144"}}
ok: [172.17.8.241] => (item={'name': 'net.core.rmem_max', 'value': '4194304'}) => {"changed": false, "item": {"name": "net.core.rmem_max", "value": "4194304"}}
ok: [172.17.8.241] => (item={'name': 'net.core.wmem_default', 'value': '262144'}) => {"changed": false, "item": {"name": "net.core.wmem_default", "value": "262144"}}
ok: [172.17.8.241] => (item={'name': 'net.core.wmem_max', 'value': '1048576'}) => {"changed": false, "item": {"name": "net.core.wmem_max", "value": "1048576"}}
ok: [172.17.8.241] => (item={'name': 'fs.aio-max-nr', 'value': '1048576'}) => {"changed": false, "item": {"name": "fs.aio-max-nr", "value": "1048576"}}
ok: [172.17.8.241] => (item={'name': 'net.ipv4.ip_local_port_range', 'value': '9000 65500'}) => {"changed": false, "item": {"name": "net.ipv4.ip_local_port_range", "value": "9000 65500"}}

TASK [sysco-middleware.oracle-database : create groups] *****************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:39
ok: [172.17.8.241] => {"changed": false, "gid": 1002, "name": "oinstall", "state": "present", "system": false}

TASK [sysco-middleware.oracle-database : add extra groups] **************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:42

TASK [sysco-middleware.oracle-database : create user] *******************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:46
ok: [172.17.8.241] => {"append": false, "changed": false, "comment": "", "group": 1002, "home": "/home/oracle", "move_home": false, "name": "oracle", "shell": "/bin/bash", "state": "present", "uid": 1001}

TASK [sysco-middleware.oracle-database : add extra groups] **************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:49

TASK [sysco-middleware.oracle-database : add oracle user limits] ********************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:53
ok: [172.17.8.241] => (item={'limit': 'soft', 'type': 'nofile', 'value': 4096}) => {"backup": "", "changed": false, "item": {"limit": "soft", "type": "nofile", "value": 4096}, "msg": ""}
ok: [172.17.8.241] => (item={'limit': 'hard', 'type': 'nofile', 'value': 65536}) => {"backup": "", "changed": false, "item": {"limit": "hard", "type": "nofile", "value": 65536}, "msg": ""}
ok: [172.17.8.241] => (item={'limit': 'soft', 'type': 'nproc', 'value': 2047}) => {"backup": "", "changed": false, "item": {"limit": "soft", "type": "nproc", "value": 2047}, "msg": ""}
ok: [172.17.8.241] => (item={'limit': 'hard', 'type': 'nproc', 'value': 16384}) => {"backup": "", "changed": false, "item": {"limit": "hard", "type": "nproc", "value": 16384}, "msg": ""}
ok: [172.17.8.241] => (item={'limit': 'soft', 'type': 'stack', 'value': 10240}) => {"backup": "", "changed": false, "item": {"limit": "soft", "type": "stack", "value": 10240}, "msg": ""}
ok: [172.17.8.241] => (item={'limit': 'hard', 'type': 'stack', 'value': 32768}) => {"backup": "", "changed": false, "item": {"limit": "hard", "type": "stack", "value": 32768}, "msg": ""}
ok: [172.17.8.241] => (item={'limit': 'soft', 'type': 'memlock', 'value': 1887437}) => {"backup": "", "changed": false, "item": {"limit": "soft", "type": "memlock", "value": 1887437}, "msg": ""}
ok: [172.17.8.241] => (item={'limit': 'hard', 'type': 'memlock', 'value': 1887437}) => {"backup": "", "changed": false, "item": {"limit": "hard", "type": "memlock", "value": 1887437}, "msg": ""}

TASK [sysco-middleware.oracle-database : create oracle base directory] **************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/prepare.yml:67
ok: [172.17.8.241] => {"changed": false, "gid": 1002, "group": "oinstall", "mode": "0755", "owner": "oracle", "path": "/home/oracle/product", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 6, "state": "directory", "uid": 1001}

TASK [sysco-middleware.oracle-database : preparing database installation template] ***
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/install.yml:2
ok: [172.17.8.241] => {"changed": false, "checksum": "6e2ef14de49f01b39d1575ee53a2dcdf0fe89791", "dest": "/tmp/db-install.rsp", "gid": 1002, "group": "oinstall", "mode": "0644", "owner": "oracle", "path": "/tmp/db-install.rsp", "secontext": "unconfined_u:object_r:user_tmp_t:s0", "size": 4985, "state": "file", "uid": 1001}

TASK [sysco-middleware.oracle-database : run installer] *****************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/install.yml:8
changed: [172.17.8.241] => {"changed": true, "cmd": "/oracle/oracle11.2.0.4/database/runInstaller -silent -waitforcompletion -ignoreSysPrereqs -responseFile /tmp/db-install.rsp", "delta": "0:04:39.655219", "end": "2019-03-05 14:23:52.842203", "failed_when_result": false, "msg": "non-zero return code", "rc": 6, "start": "2019-03-05 14:19:13.186984", "stderr": "", "stderr_lines": [], "stdout": "正在启动 Oracle Universal Installer...\n\n检查临时空间: 必须大于 120 MB。   实际为 32498 MB    通过\n检查交换空间: 必须大于 150 MB。   实际为 3583 MB    通过\n准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-05_02-19-13PM. 请稍候...[WARNING] [INS-13014] 目标环境不满足一些可选要求。\n   原因: 不满足一些可选的先决条件。有关详细信息, 请查看日志。/tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log\n   操作: 从日志 /tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log 中确定失败的先决条件检查列表。然后, 从日志文件或安装手册中查找满足这些先决条件的适当配置, 并手动进行修复。\n可以在以下位置找到本次安装会话的日志:\n /home/oracle/oracle_inventory/logs/installActions2019-03-05_02-19-13PM.log\nOracle Database 11g 的 安装 已成功。\n请查看 '/home/oracle/oracle_inventory/logs/silentInstall2019-03-05_02-19-13PM.log' 以获取详细资料。\n\n以 root 用户的身份执行以下脚本:\n\t1. /home/oracle/oracle_inventory/orainstRoot.sh\n\t2. /home/oracle/product/oracle_home/root.sh\n\n\nSuccessfully Setup Software.", "stdout_lines": ["正在启动 Oracle Universal Installer...", "", "检查临时空间: 必须大于 120 MB。   实际为 32498 MB    通过", "检查交换空间: 必须大于 150 MB。   实际为 3583 MB    通过", "准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-05_02-19-13PM. 请稍候...[WARNING] [INS-13014] 目标环境不满足一些可选要求。", "   原因: 不满足一些可选的先决条件。有关详细信息, 请查看日志。/tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log", "   操作: 从日志 /tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log 中确定失败的先决条件检查列表。然后, 从日志文件或安装手册中查找满足这些先决条件的适当配置, 并手动进行修复。", "可以在以下位置找到本次安装会话的日志:", " /home/oracle/oracle_inventory/logs/installActions2019-03-05_02-19-13PM.log", "Oracle Database 11g 的 安装 已成功。", "请查看 '/home/oracle/oracle_inventory/logs/silentInstall2019-03-05_02-19-13PM.log' 以获取详细资料。", "", "以 root 用户的身份执行以下脚本:", "\t1. /home/oracle/oracle_inventory/orainstRoot.sh", "\t2. /home/oracle/product/oracle_home/root.sh", "", "", "Successfully Setup Software."]}

TASK [sysco-middleware.oracle-database : installation results] **********************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/install.yml:17
ok: [172.17.8.241] => {
    "command_result": {
        "changed": true,
        "cmd": "/oracle/oracle11.2.0.4/database/runInstaller -silent -waitforcompletion -ignoreSysPrereqs -responseFile /tmp/db-install.rsp",
        "delta": "0:04:39.655219",
        "end": "2019-03-05 14:23:52.842203",
        "failed": false,
        "failed_when_result": false,
        "msg": "non-zero return code",
        "rc": 6,
        "start": "2019-03-05 14:19:13.186984",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "正在启动 Oracle Universal Installer...\n\n检查临时空间: 必须大于 120 MB。   实际为 32498 MB    通过\n检查交换空间: 必须大于 150 MB。   实际为 3583 MB    通过\n准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-05_02-19-13PM. 请稍候...[WARNING] [INS-13014] 目标环境不满足一些可选要求。\n   原因: 不满足一些可选的先决条件。有关详细信息, 请查看日志。/tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log\n   操作: 从日志 /tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log 中确定失败的先决条件检查列表。然后, 从日志文件或安装手册中查找满足这些先决条件的适当配置, 并手动进行修复。\n可以在以下位置找到本次安装会话的日志:\n /home/oracle/oracle_inventory/logs/installActions2019-03-05_02-19-13PM.log\nOracle Database 11g 的 安装 已成功。\n请查看 '/home/oracle/oracle_inventory/logs/silentInstall2019-03-05_02-19-13PM.log' 以获取详细资料。\n\n以 root 用户的身份执行以下脚本:\n\t1. /home/oracle/oracle_inventory/orainstRoot.sh\n\t2. /home/oracle/product/oracle_home/root.sh\n\n\nSuccessfully Setup Software.",
        "stdout_lines": [
            "正在启动 Oracle Universal Installer...",
            "",
            "检查临时空间: 必须大于 120 MB。   实际为 32498 MB    通过",
            "检查交换空间: 必须大于 150 MB。   实际为 3583 MB    通过",
            "准备从以下地址启动 Oracle Universal Installer /tmp/OraInstall2019-03-05_02-19-13PM. 请稍候...[WARNING] [INS-13014] 目标环境不满足一些可选要求。",
            "   原因: 不满足一些可选的先决条件。有关详细信息, 请查看日志。/tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log",
            "   操作: 从日志 /tmp/OraInstall2019-03-05_02-19-13PM/installActions2019-03-05_02-19-13PM.log 中确定失败的先决条件检查列表。然后, 从日志文件或安装手册中查找满足这些先决条件的适当配置, 并手动进行修复。",
            "可以在以下位置找到本次安装会话的日志:",
            " /home/oracle/oracle_inventory/logs/installActions2019-03-05_02-19-13PM.log",
            "Oracle Database 11g 的 安装 已成功。",
            "请查看 '/home/oracle/oracle_inventory/logs/silentInstall2019-03-05_02-19-13PM.log' 以获取详细资料。",
            "",
            "以 root 用户的身份执行以下脚本:",
            "\t1. /home/oracle/oracle_inventory/orainstRoot.sh",
            "\t2. /home/oracle/product/oracle_home/root.sh",
            "",
            "",
            "Successfully Setup Software."
        ]
    }
}

TASK [sysco-middleware.oracle-database : set oracle home] ***************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/install.yml:21
changed: [172.17.8.241] => (item={'regexp': '^ORACLE_HOME=', 'line': 'ORACLE_HOME=/home/oracle/product/oracle_home'}) => {"backup": "", "changed": true, "item": {"line": "ORACLE_HOME=/home/oracle/product/oracle_home", "regexp": "^ORACLE_HOME="}, "msg": "line added"}
changed: [172.17.8.241] => (item={'regexp': 'PATH=\\$ORACLE_HOME/bin', 'line': 'PATH=$ORACLE_HOME/bin:$PATH'}) => {"backup": "", "changed": true, "item": {"line": "PATH=$ORACLE_HOME/bin:$PATH", "regexp": "PATH=\\$ORACLE_HOME/bin"}, "msg": "line added"}
changed: [172.17.8.241] => (item={'regexp': '^export ORACLE_HOME', 'line': 'export ORACLE_HOME'}) => {"backup": "", "changed": true, "item": {"line": "export ORACLE_HOME", "regexp": "^export ORACLE_HOME"}, "msg": "line added"}

TASK [sysco-middleware.oracle-database : run post-installation scripts as root] *****
task path: /etc/ansible/roles/sysco-middleware.oracle-database/tasks/postinstall.yml:2
changed: [172.17.8.241] => (item=/home/oracle/oracle_inventory/orainstRoot.sh) => {"changed": true, "cmd": "/home/oracle/oracle_inventory/orainstRoot.sh", "delta": "0:00:00.061254", "end": "2019-03-05 14:23:56.043939", "item": "/home/oracle/oracle_inventory/orainstRoot.sh", "rc": 0, "start": "2019-03-05 14:23:55.982685", "stderr": "", "stderr_lines": [], "stdout": "更改权限/home/oracle/oracle_inventory.\n添加组的读取和写入权限。\n删除全局的读取, 写入和执行权限。\n\n更改组名/home/oracle/oracle_inventory 到 oinstall.\n脚本的执行已完成。", "stdout_lines": ["更改权限/home/oracle/oracle_inventory.", "添加组的读取和写入权限。", "删除全局的读取, 写入和执行权限。", "", "更改组名/home/oracle/oracle_inventory 到 oinstall.", "脚本的执行已完成。"]}
changed: [172.17.8.241] => (item=/home/oracle/product/oracle_home/root.sh) => {"changed": true, "cmd": "/home/oracle/product/oracle_home/root.sh", "delta": "0:00:00.366747", "end": "2019-03-05 14:23:56.905900", "item": "/home/oracle/product/oracle_home/root.sh", "rc": 0, "start": "2019-03-05 14:23:56.539153", "stderr": "", "stderr_lines": [], "stdout": "Check /home/oracle/product/oracle_home/install/root_oracle1_2019-03-05_14-23-56.log for the output of root script", "stdout_lines": ["Check /home/oracle/product/oracle_home/install/root_oracle1_2019-03-05_14-23-56.log for the output of root script"]}

TASK [sysco-middleware.oracle-database-instance : validate oracle database instance is already created] ***
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/validate.yml:1
ok: [172.17.8.241] => {"changed": false, "stat": {"exists": false}}

TASK [sysco-middleware.oracle-database-instance : debug] ****************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/validate.yml:7
skipping: [172.17.8.241] => {}

TASK [sysco-middleware.oracle-database-instance : set_fact] *************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/validate.yml:11
skipping: [172.17.8.241] => {"changed": false, "skip_reason": "Conditional result was False"}

TASK [sysco-middleware.oracle-database-instance : set netca response file] **********
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-listener.yml:3
changed: [172.17.8.241] => {"changed": true, "checksum": "9a182db5dfb8072cbc60110330aafba844ae61dd", "dest": "/tmp/netca.rsp", "gid": 1002, "group": "oinstall", "md5sum": "4a95f5efea7d257188167cf1ff6dfc16", "mode": "0644", "owner": "oracle", "secontext": "unconfined_u:object_r:user_tmp_t:s0", "size": 5838, "src": "/var/tmp/ansible-tmp-1551843361.099237-30642031874545/source", "state": "file", "uid": 1001}

TASK [sysco-middleware.oracle-database-instance : configure listener] ***************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-listener.yml:8
changed: [172.17.8.241] => {"changed": true, "cmd": "/home/oracle/product/oracle_home/bin/netca /silent /responseFile /tmp/netca.rsp", "delta": "0:00:05.863064", "end": "2019-03-05 14:24:05.857554", "rc": 0, "start": "2019-03-05 14:23:59.994490", "stderr": "", "stderr_lines": [], "stdout": "\n正在对命令行参数进行语法分析:\n参数\"silent\" = true\n参数\"responsefile\" = /tmp/netca.rsp\n完成对命令行参数进行语法分析。\nOracle Net Services 配置:\n完成概要文件配置。\nOracle Net 监听程序启动:\n    正在运行监听程序控制: \n      /home/oracle/product/oracle_home/bin/lsnrctl start LISTENER\n    监听程序控制完成。\n    监听程序已成功启动。\n监听程序配置完成。\n成功完成 Oracle Net Services 配置。退出代码是0", "stdout_lines": ["", "正在对命令行参数进行语法分析:", "参数\"silent\" = true", "参数\"responsefile\" = /tmp/netca.rsp", "完成对命令行参数进行语法分析。", "Oracle Net Services 配置:", "完成概要文件配置。", "Oracle Net 监听程序启动:", "    正在运行监听程序控制: ", "      /home/oracle/product/oracle_home/bin/lsnrctl start LISTENER", "    监听程序控制完成。", "    监听程序已成功启动。", "监听程序配置完成。", "成功完成 Oracle Net Services 配置。退出代码是0"]}

TASK [sysco-middleware.oracle-database-instance : create dbca response file] ********
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance.yml:3
changed: [172.17.8.241] => {"changed": true, "checksum": "588bb029cd7a66e36626e080de50bd7097b12be1", "dest": "/tmp/dbca.rsp", "gid": 1002, "group": "oinstall", "md5sum": "567f14975ccbe022a97b50fd9c9bccf8", "mode": "0644", "owner": "oracle", "secontext": "unconfined_u:object_r:user_tmp_t:s0", "size": 44712, "src": "/var/tmp/ansible-tmp-1551843368.5864606-165583180588069/source", "state": "file", "uid": 1001}

TASK [sysco-middleware.oracle-database-instance : create database instance] *********
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance.yml:8
changed: [172.17.8.241] => {"changed": true, "cmd": "/home/oracle/product/oracle_home/bin/dbca -silent -responseFile /tmp/dbca.rsp", "delta": "0:04:00.889831", "end": "2019-03-05 14:28:08.564423", "rc": 0, "start": "2019-03-05 14:24:07.674592", "stderr": "", "stderr_lines": [], "stdout": "复制数据库文件\n1% 已完成\n3% 已完成\n37% 已完成\n正在创建并启动 Oracle 实例\n40% 已完成\n45% 已完成\n50% 已完成\n55% 已完成\n56% 已完成\n60% 已完成\n62% 已完成\n正在进行数据库创建\n66% 已完成\n70% 已完成\n73% 已完成\n85% 已完成\n96% 已完成\n100% 已完成\n有关详细信息, 请参阅日志文件 \"/home/oracle/product/cfgtoollogs/dbca/TESTDB/TESTDB.log\"。", "stdout_lines": ["复制数据库文件", "1% 已完成", "3% 已完成", "37% 已完成", "正在创建并启动 Oracle 实例", "40% 已完成", "45% 已完成", "50% 已完成", "55% 已完成", "56% 已完成", "60% 已完成", "62% 已完成", "正在进行数据库创建", "66% 已完成", "70% 已完成", "73% 已完成", "85% 已完成", "96% 已完成", "100% 已完成", "有关详细信息, 请参阅日志文件 \"/home/oracle/product/cfgtoollogs/dbca/TESTDB/TESTDB.log\"。"]}

TASK [sysco-middleware.oracle-database-instance : debug] ****************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance.yml:15
ok: [172.17.8.241] => {
    "command_result": {
        "changed": true,
        "cmd": "/home/oracle/product/oracle_home/bin/dbca -silent -responseFile /tmp/dbca.rsp",
        "delta": "0:04:00.889831",
        "end": "2019-03-05 14:28:08.564423",
        "failed": false,
        "rc": 0,
        "start": "2019-03-05 14:24:07.674592",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "复制数据库文件\n1% 已完成\n3% 已完成\n37% 已完成\n正在创建并启动 Oracle 实例\n40% 已完成\n45% 已完成\n50% 已完成\n55% 已完成\n56% 已完成\n60% 已完成\n62% 已完成\n正在进行数据库创建\n66% 已完成\n70% 已完成\n73% 已完成\n85% 已完成\n96% 已完成\n100% 已完成\n有关详细信息, 请参阅日志文件 \"/home/oracle/product/cfgtoollogs/dbca/TESTDB/TESTDB.log\"。",
        "stdout_lines": [
            "复制数据库文件",
            "1% 已完成",
            "3% 已完成",
            "37% 已完成",
            "正在创建并启动 Oracle 实例",
            "40% 已完成",
            "45% 已完成",
            "50% 已完成",
            "55% 已完成",
            "56% 已完成",
            "60% 已完成",
            "62% 已完成",
            "正在进行数据库创建",
            "66% 已完成",
            "70% 已完成",
            "73% 已完成",
            "85% 已完成",
            "96% 已完成",
            "100% 已完成",
            "有关详细信息, 请参阅日志文件 \"/home/oracle/product/cfgtoollogs/dbca/TESTDB/TESTDB.log\"。"
        ]
    }
}

TASK [sysco-middleware.oracle-database-instance : add oratab] ***********************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance.yml:22
changed: [172.17.8.241] => {"changed": true, "checksum": "94c919dfd1b1fe7905165b7a98e31ac3cad7ea3a", "dest": "/etc/oratab", "gid": 1002, "group": "oinstall", "md5sum": "93eb726460c9ab0be8abadd2a22d05ad", "mode": "0664", "owner": "oracle", "secontext": "unconfined_u:object_r:etc_t:s0", "size": 780, "src": "/root/.ansible/tmp/ansible-tmp-1551843592.964527-75360416260301/source", "state": "file", "uid": 1001}

TASK [sysco-middleware.oracle-database-instance : set oracle sid] *******************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance.yml:31
changed: [172.17.8.241] => (item={'start': 'ORACLE_SID=', 'end': 'TESTDB'}) => {"backup": "", "changed": true, "item": {"end": "TESTDB", "start": "ORACLE_SID="}, "msg": "line added"}
changed: [172.17.8.241] => (item={'start': 'export ORACLE_SID', 'end': ''}) => {"backup": "", "changed": true, "item": {"end": "", "start": "export ORACLE_SID"}, "msg": "line added"}

TASK [sysco-middleware.oracle-database-instance : set_fact] *************************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance-service.yml:3
ok: [172.17.8.241] => {"ansible_facts": {"service_name": "oracle-db"}, "changed": false}

TASK [sysco-middleware.oracle-database-instance : define service] *******************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance-service.yml:6
changed: [172.17.8.241] => {"changed": true, "checksum": "19d6615d9a5977a506e34b2cd85a457442490c55", "dest": "/etc/systemd/system/oracle-db.service", "gid": 0, "group": "root", "md5sum": "a69d1fffdd3b9c397c00a2337521cac0", "mode": "0644", "owner": "root", "secontext": "system_u:object_r:systemd_unit_file_t:s0", "size": 400, "src": "/root/.ansible/tmp/ansible-tmp-1551843596.9805033-241369492632607/source", "state": "file", "uid": 0}

TASK [sysco-middleware.oracle-database-instance : enable service] *******************
task path: /etc/ansible/roles/sysco-middleware.oracle-database-instance/tasks/configure-instance-service.yml:12
changed: [172.17.8.241] => {"changed": true, "enabled": true, "name": "oracle-db", "status": {"ActiveEnterTimestampMonotonic": "0", "ActiveExitTimestampMonotonic": "0", "ActiveState": "inactive", "After": "system.slice basic.target systemd-journald.socket network.target syslog.target", "AllowIsolate": "no", "AmbientCapabilities": "0", "AssertResult": "no", "AssertTimestampMonotonic": "0", "Before": "shutdown.target", "BlockIOAccounting": "no", "BlockIOWeight": "18446744073709551615", "CPUAccounting": "no", "CPUQuotaPerSecUSec": "infinity", "CPUSchedulingPolicy": "0", "CPUSchedulingPriority": "0", "CPUSchedulingResetOnFork": "no", "CPUShares": "18446744073709551615", "CanIsolate": "no", "CanReload": "no", "CanStart": "yes", "CanStop": "yes", "CapabilityBoundingSet": "18446744073709551615", "ConditionResult": "no", "ConditionTimestampMonotonic": "0", "Conflicts": "shutdown.target", "ControlPID": "0", "DefaultDependencies": "yes", "Delegate": "no", "Description": "Oracle Database Service", "DevicePolicy": "auto", "ExecMainCode": "0", "ExecMainExitTimestampMonotonic": "0", "ExecMainPID": "0", "ExecMainStartTimestampMonotonic": "0", "ExecMainStatus": "0", "ExecStart": "{ path=/home/oracle/product/oracle_home/bin/dbstart ; argv[]=/home/oracle/product/oracle_home/bin/dbstart /home/oracle/product/oracle_home ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "ExecStop": "{ path=/home/oracle/product/oracle_home/bin/dbshut ; argv[]=/home/oracle/product/oracle_home/bin/dbshut /home/oracle/product/oracle_home ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "FailureAction": "none", "FileDescriptorStoreMax": "0", "FragmentPath": "/etc/systemd/system/oracle-db.service", "Group": "oinstall", "GuessMainPID": "yes", "IOScheduling": "0", "Id": "oracle-db.service", "IgnoreOnIsolate": "no", "IgnoreOnSnapshot": "no", "IgnoreSIGPIPE": "yes", "InactiveEnterTimestampMonotonic": "0", "InactiveExitTimestampMonotonic": "0", "JobTimeoutAction": "none", "JobTimeoutUSec": "0", "KillMode": "control-group", "KillSignal": "15", "LimitAS": "18446744073709551615", "LimitCORE": "18446744073709551615", "LimitCPU": "18446744073709551615", "LimitDATA": "18446744073709551615", "LimitFSIZE": "18446744073709551615", "LimitLOCKS": "18446744073709551615", "LimitMEMLOCK": "18446744073709551615", "LimitMSGQUEUE": "819200", "LimitNICE": "0", "LimitNOFILE": "65535", "LimitNPROC": "11321", "LimitRSS": "18446744073709551615", "LimitRTPRIO": "0", "LimitRTTIME": "18446744073709551615", "LimitSIGPENDING": "11321", "LimitSTACK": "18446744073709551615", "LoadState": "loaded", "MainPID": "0", "MemoryAccounting": "no", "MemoryCurrent": "18446744073709551615", "MemoryLimit": "18446744073709551615", "MountFlags": "0", "Names": "oracle-db.service", "NeedDaemonReload": "no", "Nice": "0", "NoNewPrivileges": "no", "NonBlocking": "no", "NotifyAccess": "none", "OOMScoreAdjust": "0", "OnFailureJobMode": "replace", "PermissionsStartOnly": "no", "PrivateDevices": "no", "PrivateNetwork": "no", "PrivateTmp": "no", "ProtectHome": "no", "ProtectSystem": "no", "RefuseManualStart": "no", "RefuseManualStop": "no", "RemainAfterExit": "yes", "Requires": "basic.target", "Restart": "no", "RestartUSec": "100ms", "Result": "success", "RootDirectoryStartOnly": "no", "RuntimeDirectoryMode": "0755", "SameProcessGroup": "no", "SecureBits": "0", "SendSIGHUP": "no", "SendSIGKILL": "yes", "Slice": "system.slice", "StandardError": "inherit", "StandardInput": "null", "StandardOutput": "journal", "StartLimitAction": "none", "StartLimitBurst": "5", "StartLimitInterval": "10000000", "StartupBlockIOWeight": "18446744073709551615", "StartupCPUShares": "18446744073709551615", "StatusErrno": "0", "StopWhenUnneeded": "no", "SubState": "dead", "SyslogLevelPrefix": "yes", "SyslogPriority": "30", "SystemCallErrorNumber": "0", "TTYReset": "no", "TTYVHangup": "no", "TTYVTDisallocate": "no", "TasksAccounting": "no", "TasksCurrent": "18446744073709551615", "TasksMax": "18446744073709551615", "TimeoutStartUSec": "1min 30s", "TimeoutStopUSec": "1min 30s", "TimerSlackNSec": "50000", "Transient": "no", "Type": "simple", "UMask": "0022", "UnitFilePreset": "disabled", "UnitFileState": "disabled", "User": "oracle", "Wants": "system.slice", "WatchdogTimestampMonotonic": "0", "WatchdogUSec": "0"}}
META: ran handlers
META: ran handlers

PLAY RECAP **************************************************************************
172.17.8.241               : ok=28   changed=11   unreachable=0    failed=0   


# w @ uw in /media/xh/i/python/wymproject/oracle/oracleinstalltest on git:master x [11:39:59] 
$ 



```