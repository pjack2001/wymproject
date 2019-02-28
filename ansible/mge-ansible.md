# 



## ansible笔记

```
运维自动化-Ansible ( 一 )
https://blog.51cto.com/191226139/2066936
运维自动化-Ansible ( 二 )
https://blog.51cto.com/191226139/2067831
运维自动化-Ansible ( 三 )
https://blog.51cto.com/191226139/2068623
运维自动化-Ansible ( 四 )
https://blog.51cto.com/191226139/2069226

```

## 马哥2019全新ansible入门到精通-学习笔记

## ansible环境


### 练习环境
/home/y/docker-compose/chusiangansible/docker-compose.yml

$ docker-compose up -d
$ docker-compose ps
$ docker-compose stop
$ docker-compose start
$ docker-compose rm -f

登录
http://192.168.102.3:8004

或登录控制台
$ docker exec -it chusiangansible_control_machine_1 sh
vi /home/inventory



### 升级ansible

$ ansible --version
$ sudo pip install --upgrade ansible
或
$ sudo pip3 install --upgrade ansible



```

$ whereis ansible
ansible: /usr/bin/ansible /etc/ansible /usr/share/man/man1/ansible.1.gz

$ rpm -qa ansible
ansible-2.7.5-1.el7.noarch

$ rpm -ql ansible |less

$ rpm -ql ansible |grep file.py

$ ansible --version            
ansible 2.7.5
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Oct 30 2018, 23:45:53) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]

$ file /usr/bin/ansible
/usr/bin/ansible: symbolic link to `/usr/bin/ansible-2.7'

$ ll /usr/bin/ansible
lrwxrwxrwx 1 root root 20 12月 20 10:01 /usr/bin/ansible -> /usr/bin/ansible-2.7

$ cat /usr/bin/ansible
$ cat /usr/bin/ansible-2.7

$ file /usr/bin/ansible   
/usr/bin/ansible: symbolic link to `/usr/bin/ansible-2.7'
 
$ file /usr/bin/ansible-2.7 
/usr/bin/ansible-2.7: Python script, ASCII text executable

$ vim /etc/ansible/ansible.cfg
#去掉注释
# uncomment this to disable SSH key host checking
host_key_checking = False

# logging is off by default unless this path is defined
# if so defined, consider logrotate
log_path = /var/log/ansible.log





```


## ansible-doc帮助

```
#详细说明，帮助的后面有playbook的例子
$ ansible-doc file 
> FILE    (/usr/lib/python2.7/site-packages/ansible/modules/files/file.py)


# 只显示后面的playbook
$ ansible-doc -s copy



$ ansible-doc -l |wc -l
2080
#20181226有2080个模块






```

## 主机列表

```
$ vim /etc/ansible/hosts

[test]
192.168.102.20
192.168.102.4
192.168.102.14


[test]
192.168.102.20 ansible_ssh_user=root ansible_ssh_passwd=vagrant
192.168.102.14 ansible_ssh_user=root ansible_ssh_passwd=vagrant
192.168.102.4 ansible_ssh_user=root ansible_ssh_passwd=vagrant



$ ansible all --list    
  hosts (4):
    192.168.102.20
    192.168.102.4
    192.168.102.14
    192.168.102.2

$ ansible test --list
  hosts (3):
    192.168.102.20
    192.168.102.4
    192.168.102.14


列出所有的主机
$ ansible all --list
$ ansible all --list-hosts
$ ansible test --list-hosts

$ ansible test -m ping -u vagrant -k

$ ansible test -m shell -a 'hostname' -u root -k
SSH password: 
192.168.102.4 | CHANGED | rc=0 >>
k8s-node1

192.168.102.14 | CHANGED | rc=0 >>
k8s-node2

192.168.102.20 | CHANGED | rc=0 >>
k8s-master



```


## Ad-Hoc命令

```
常用模块
ping
command
shell
script
copy
file

```

### 批量推送公钥
$ ansible-playbook PushKey.yml -u root -k

### command模块
默认command模块,参数可以省略,command模块不适合管道、变量、重定向、特殊符合之类的命令
$ ansible test -a 'df -h' -u root -k
$ ansible test -m command -a 'df -h' -u root -k

### shell模块
$ ansible test -m shell -a 'echo $HOSTNAME'

$ ansible test -m shell -a 'cat /etc/redhat-release'

$ ansible test -m shell -a 'ls /home'

$ ansible test -m shell -a 'reboot'

$ ansible test -m shell -a 'getenforce'


$ ansible test -m shell -a 'ss -ntl'

$ ansible test -m shell -a 'getent passwd'
$ ansible test -m shell -a 'getent passwd |grep 1000'

$ ansible test -m shell -a 'getent group |grep ftp'




### script模块
$ cat hostname.sh 
```
#!/bin/bash
hostname
```

$ chmod +x hostname.sh
$ ansible test -m script -a '/home/y/python/wymproject01/ansiblewym/testw/hostname.sh'

$ ansible test -m shell -a 'ls -l /etc/selinux/config'

### copy模块
$ ansible test -m shell -a 'ls -l /home'
$ ansible test -m copy -a 'src=/home/hostname.sh dest=/home/hostnametest.sh backup=yes'
$ ansible test -m copy -a 'src=/home/hostname.sh dest=/home/hostnametest.sh mode=755 owner=vagrant backup=yes'

$ ansible test -m copy -a 'src=/home/y/python/wymproject01/ansiblewym/testw/hostname.sh dest=/home/hostnametest.sh backup=yes'

$ ansible test -m copy -a 'content="hello\nThanks\n^_^" dest=/home/hostnametest2.sh mode=755 owner=root backup=yes'


$ ansible test -m shell -a 'ls -l /home'
$ ansible test -m shell -a 'cat /home/hostname.sh'
$ ansible test -m shell -a 'cat /home/hostnametest2.sh'

$ ansible test -m shell -a 'rm -rf /home/hostname.*'



### fetch模块，与copy模块相反，从服务器上抓取文件到本地

ansible test -m fetch -a 'src=/home/hostnametest2.sh dest=/home/hostnametest2 mode=755 owner=root backup=yes'

$ tree
.
├── 192.168.102.14
│   └── home
│       └── hostnametest2.sh
├── 192.168.102.20
│   └── home
│       └── hostnametest2.sh
└── 192.168.102.4
    └── home
        └── hostnametest2.sh


$ ansible test -m shell -a 'tar Jcf /home/log.tar.xz /var/log/*.log'
$ ansible test -m shell -a 'ls -l /home'
$ ansible test -m fetch -a 'src=/home/log.tar dest=/home/log mode=755 owner=root backup=yes'
$ tree log 
log
├── 192.168.102.14
│   └── home
│       └── log.tar
├── 192.168.102.20
│   └── home
│       └── log.tar
└── 192.168.102.4
    └── home
        └── log.tar

$ tar tvf log/192.168.102.14/home/log.tar.xz


### file模块

参数path、name、dest都是等价的
$ ansible-doc file
= path
        Path to the file being managed.
        (Aliases: dest, name)

创建、删除文件
$ ansible test -m shell -a 'ls -l /home' 
$ ansible test -m file -a 'name=/home/test1 state=touch'
$ ansible test -m file -a 'name=/home/test1 state=absent'


创建、删除目录
$ ansible test -m shell -a 'ls -l /home' 
$ ansible test -m file -a 'name=/home/testdir1 state=directory'
$ ansible test -m file -a 'name=/home/testdir1 state=absent'

创建、删除软链接
$ ansible test -m shell -a 'ls -l /home' 
$ ansible test -m file -a 'src=/etc/fstab dest=/home/fstab.link state=link'
$ ansible test -m file -a 'dest=/home/fstab.link state=absent'




### hostname模块

$ ansible test -m shell -a 'hostname' 
$ ansible 192.168.102.20 -m hostname -a 'name=k8sm'
192.168.102.20 | CHANGED => {
    "ansible_facts": {
        "ansible_domain": "", 
        "ansible_fqdn": "k8sm", 
        "ansible_hostname": "k8sm", 
        "ansible_nodename": "k8sm"
    }, 
    "changed": true, 
    "name": "k8sm"
}

可以看到，只修改了hostname文件里面的，hosts里面的没有修改
$ ansible test -m shell -a 'cat /etc/hostname'
$ ansible test -m shell -a 'cat /etc/hosts'



### cron模块

$ which wall
/usr/bin/wall

周一，三，六，每分钟报警，显示HelloWord！
$ ansible test -m cron -a 'minute=* weekday=1,3,6 job="/usr/bin/wall HelloWorld!" name=cronwall'

$ ansible test -m shell -a 'crontab -l'                                                         
192.168.102.20 | CHANGED | rc=0 >>
#Ansible: cronwall
* * * * 1,3,6 /usr/bin/wall HelloWorld!

禁用
$ ansible test -m cron -a 'disabled=true job="/usr/bin/wall HelloWorld!" name=cronwall'

$ ansible test -m shell -a 'crontab -l'                                                
192.168.102.20 | CHANGED | rc=0 >>
#Ansible: cronwall
#* * * * * /usr/bin/wall HelloWorld!

启用
$ ansible test -m cron -a 'disabled=false job="/usr/bin/wall HelloWorld!" name=cronwall'
$ ansible test -m shell -a 'crontab -l'

删除
$ ansible test -m cron -a 'job="/usr/bin/wall HelloWorld!" name=cronwall state=absent'
$ ansible test -m shell -a 'crontab -l'



### yum模块

$ ansible test -m shell -a 'rpm -qa |grep ssh'

默认参数是安装 state=present
$ ansible test -m yum -a 'name=tree'

安装，多个软件用,隔开
$ ansible test -m yum -a 'name=tree,vim,dstat state=present'

安装rpm包
$ ansible test -m yum -a 'name=/home/xxx.rpm state=present'

卸载
$ ansible test -m yum -a 'name=tree,vim,dstat state=absent'

更新缓存,相当于yum clean all，yum makecache，yum install
$ ansible test -m yum -a 'name=dstat update_cache=yes'

$ ansible test -m yum -a 'name=docker-ce update_cache=yes'



### service模块


reloaded, restarted, started, stopped
关闭并禁止自启动
$ ansible test -m service -a 'name=firewalld state=stopped enabled=no'

$ ansible test -m service -a 'name=firewalld state=started'




### user账户模块

创建一个ftp账号，没有登录权限，属于系统组，指定家目录，加上描述
$ ansible test -m user -a 'name=ftpuser shell=/sbin/nologin system=yes home=/opt/ftp comment="FTP user"'

指定主组，附加组，uid等信息
$ ansible test -m user -a 'name=ftpuser shell=/sbin/nologin system=yes home=/opt/ftp group=ftp groups=root,bin uid=1001 comment="FTP user"'

$ ansible test -a 'getent passwd ftpuser'
$ ansible test -a 'ls -l /opt'

删除用户，remove表示删除家目录
$ ansible test -m user -a 'name=ftpuser state=absent remove=yes'


### group组模块


$ ansible test -m group -a 'name=oracle system=yes gid=1002'

$ ansible test -m shell -a 'getent group |grep oracle'

$ ansible test -m group -a 'name=oracle state=absent'

### 







### 







### 





## ansible-playbook

### 

$ ansible-playbook hello.yml





### 






### 





## ansible-vault加密和解密

加密
$ ansible-vault encrypt hello.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful

解密
$ ansible-vault decrypt hello.yml
Vault password: 
Decryption successful

查看
$ ansible-vault view hello.yml
Vault password:

修改
$ ansible-vault edit hello.yml
Vault password: 

修改口令
$ ansible-vault rekey hello.yml

创建
$ ansible-vault create hello2.yml


## ansible-console交互式命令

### 


$  ansible-console

？显示帮助

cd test 进入test主机列表



### 












## ansible-galaxy


ansible-galaxy 语法：

ansible-galaxy [delete|import|info|init|install|list|login|remove|search|setup] [--help] [options] 

ansible-galaxy search --author geerlingguy


 列出已安装的galaxy
#ansible-galaxy list geerlingguy.mysql
- geerlingguy.mysql, 2.8.1

 安装galaxy
ansible-galaxy install geerlingguy.redis

 删除galaxy
ansible-galaxy remove geerlingguy.redis



$ vim /etc/ansible/ansible.cfg
$ cd /etc/ansible/roles
$ cd ~/.ansible/roles/

https://github.com/geerlingguy?tab=repositories
https://galaxy.ansible.com/geerlingguy

https://www.jeffgeerling.com/blog/2018/updating-kubernetes-deployment-and-waiting-it-roll-out-shell-script


https://github.com/geerlingguy/ansible-role-nginx.git

$ git clone https://github.com/geerlingguy/ansible-role-nginx.git


$ ansible-galaxy login


We need your Github login to identify you.
This information will not be sent to Galaxy, only to api.github.com.
The password will not be displayed.

Use --github-token if you do not want to enter your password.

Github Username: pjack2001
Password for pjack2001: 

### 

安装的剧本默认是存放在家目录的隐藏文件中。
/root/.ansible

$ ansible-galaxy list
$ ansible-galaxy install geerlingguy.nginx
$ ansible-galaxy remove geerlingguy.nginx

$ ansible-galaxy search elasticsearch --author geerlingguy



$ ansible-galaxy install geerlingguy.nginx
如果因为网络原因无法下载，就用git下载

下载的roles可以删除,改名等操作

$ ansible-galaxy info geerlingguy.nginx


### 


```javascript

可以在一个文件中指定多个需要下载的roles

# ansible-galaxy install -r roles.txt 
# cat roles.txt 
patrik.uytterhoeven.Zabbix-Agent
patrik.uytterhoeven.Zabbix_Server


ansible-galaxy search --author geerlingguy > temp.txt
$ awk '{print $1}' temp.txt > geerlingguyroles.txt



Found 96 roles matching your search:

 Name                              Description
 ----                              -----------
 geerlingguy.setup                 A role to prepare the solr environment.
 geerlingguy.adminer               Installs Adminer for Database management.
 geerlingguy.ansible               Ansible for RedHat/CentOS/Debian/Ubuntu.
 geerlingguy.ansible-role-packer   Packer for Linux
 geerlingguy.apache                Apache 2.x for Linux.
 geerlingguy.apache-php-fpm        Apache 2.4+ PHP-FPM support for Linux.
 geerlingguy.aws-inspector         AWS Inspector installation for Linux.
 geerlingguy.awx                   Installs and configures AWX (Ansible Tower's open source version).
 geerlingguy.awx-container         Ansible AWX container for Docker.
 geerlingguy.backup                Backup for Simple Servers.
 geerlingguy.blackfire             Blackfire installation for Linux
 geerlingguy.certbot               Installs and configures Certbot (for Let's Encrypt).
 geerlingguy.clamav                ClamAV installation and configuration.
 geerlingguy.collectd-signalfx     SignalFx Collectd installation for Linux.
 geerlingguy.composer              Composer PHP Dependency Manager
 geerlingguy.daemonize             Daemonize for Unix-like operating systems
 geerlingguy.docker                Docker for Linux.
 geerlingguy.docker_arm            Docker setup for Rasbperry Pi and ARM-based devices.
 geerlingguy.dotfiles              Dotfile installation for UNIX/Linux.
 geerlingguy.drupal                Deploy or install Drupal on your servers.
 geerlingguy.drupal-console        Drupal Console
 geerlingguy.drush                 Drush - command line shell for Drupal
 geerlingguy.ecr_container_build   ECR docker image build and push management role.
 geerlingguy.elasticsearch         Elasticsearch for Linux.
 geerlingguy.elasticsearch-curator Elasticsearch curator for Linux.
 geerlingguy.exim                  Exim installation for Linux.
 geerlingguy.fathom                Fathom web analytics
 geerlingguy.filebeat              Filebeat for Linux.
 geerlingguy.firewall              Simple iptables firewall for most Unix-like systems.
 geerlingguy.git                   Git version control software
 geerlingguy.github-users          Create users based on GitHub accounts.
 geerlingguy.gitlab                GitLab Git web interface
 geerlingguy.glusterfs             GlusterFS installation for Linux.
 geerlingguy.gogs                  Gogs: Go Git Service
 geerlingguy.haproxy               HAProxy installation and configuration.
 geerlingguy.hdparm                hdparm installation and configuration for Linux.
 geerlingguy.homebrew              Homebrew for Mac OS X
 geerlingguy.htpasswd              htpasswd installation and helper role for Linux servers.
 geerlingguy.java                  Java for Linux
 geerlingguy.jenkins               Jenkins CI
 geerlingguy.k8s_manifests         Kubernetes manifest management role.
 geerlingguy.kibana                Kibana for Linux.
 geerlingguy.kubernetes            Kubernetes for Linux.
 geerlingguy.logstash              Logstash for Linux.
 geerlingguy.logstash-forwarder    Logstash Forwarder for Linux.
 geerlingguy.mailhog               MailHog for Linux
 geerlingguy.mas                   Mac App Store CLI installation for macOS
 geerlingguy.memcached             Memcached for Linux
 geerlingguy.munin                 Munin monitoring server for RedHat/CentOS or Debian/Ubuntu.
 geerlingguy.munin-node            Munin node monitoring endpoint for RedHat/CentOS or Debian/Ubuntu.
 geerlingguy.mysql                 MySQL server for RHEL/CentOS and Debian/Ubuntu.
 geerlingguy.nfs                   NFS installation for Linux.
 geerlingguy.nginx                 Nginx installation for Linux, FreeBSD and OpenBSD.
 geerlingguy.nodejs                Node.js installation for Linux
 geerlingguy.ntp                   NTP installation and configuration for Linux.
 geerlingguy.packer-debian         Debian/Ubuntu configuration for Packer.
 geerlingguy.packer-rhel           RedHat/CentOS configuration for Packer.
 geerlingguy.passenger             Passenger installation for Linux/UNIX.
 geerlingguy.phergie               Phergie - a PHP IRC bot
 geerlingguy.php                   PHP for RedHat/CentOS/Fedora/Debian/Ubuntu.
 geerlingguy.php-memcached         PHP Memcached support for Linux
 geerlingguy.phpmyadmin            phpMyAdmin installation for Linux
 geerlingguy.php-mysql             PHP MySQL support for Linux.
 geerlingguy.php-pear              PHP PEAR library installation.
 geerlingguy.php-pecl              PHP PECL extension installation.
 geerlingguy.php-pgsql             PHP PostgreSQL support for Linux.
 geerlingguy.php-redis             PhpRedis support for Linux
 geerlingguy.php-tideways          Tideways PHP Profiler Extension for Linux
 geerlingguy.php-versions          Allows different PHP versions to be installed.
 geerlingguy.php-xdebug            PHP XDebug for Linux
 geerlingguy.php-xhprof            PHP XHProf for Linux
 geerlingguy.pimpmylog             Pimp my Log installation for Linux
 geerlingguy.pip                   Pip (Python package manager) for Linux.
 geerlingguy.postfix               Postfix for RedHat/CentOS or Debian/Ubuntu.
 geerlingguy.postgresql            PostgreSQL server for Linux.
 geerlingguy.puppet                Puppet for Linux.
 geerlingguy.rabbitmq              RabbitMQ installation for Linux.
 geerlingguy.raspberry-pi          Configures a Raspberry Pi.
 geerlingguy.redis                 Redis for Linux
 geerlingguy.repo-dotdeb           DotDeb repository for Debian.
 geerlingguy.repo-epel             EPEL repository for RHEL/CentOS.
 geerlingguy.repo-puias            PUIAS repository for RHEL/CentOS.
 geerlingguy.repo-remi             Remi's RPM repository for RHEL/CentOS.
 geerlingguy.ruby                  Ruby installation for Linux.
 geerlingguy.samba                 Samba for RHEL/CentOS.
 geerlingguy.security              Security software installation and configuration.
 geerlingguy.solr                  Apache Solr for Linux.
 geerlingguy.sonar                 SonarQube for Linux
 geerlingguy.sonar-runner          Sonar Runner for Linux
 geerlingguy.ssh-chroot-jail       Simple SSH chroot jail management.
 geerlingguy.supervisor            Supervisor (process state manager) for Linux.
 geerlingguy.svn                   SVN web server for Linux
 geerlingguy.svn2git               Svn2Git VCS conversion software for Linux.
 geerlingguy.swap                  Swap file and swap management for Linux.
 geerlingguy.tomcat6               Tomcat 6 for RHEL/CentOS and Debian/Ubuntu.
 geerlingguy.varnish               Varnish for Linux.
(END)


```




### 


Ansible-vault
功能：管理加密解密yml文件

ansible-vault [create|decrypt|edit|encrypt|rekey|view]
 ansible-vault encrypt hello.yml 加密
 ansible-vault decrypt hello.yml 解密
 ansible-vault view hello.yml 查看加密问题
 ansible-vault edit hello.yml 编辑加密文件
 ansible-vault rekey hello.yml 修改口令
 ansible-vault create new.yml 创建新文件




### 





## ansible-playbook

```
Ansible-playbook
语法：

ansible-playbook <filename.yml> ... [options]
常见选项
--check 只检测可能会发生的改变，但不真正执行操作
--list-hosts 列出运行任务的主机
--list-tasks 列出此playbook中的所有任务
--list-tags 列出此playbook中的所有的tags
--limit 主机列表 只针对主机列表中的主机执行
--step 一步一步执行脚本
--flush-cache  清除fact缓存
-C 文件名     执行前先检查语法。
-D 显示出执行前后的变化内容
-v 显示过程 -vv -vvv 更详细
第一个playbook
---

- hosts: all
  remote_user: root

  tasks:
    - name: test yml
      command: /usr/bin/wall "hello world"



```


## ansible-galaxy

```




```


##

```




```


##

```




```


##

```




```


##

```




```


##

```




```


##

```




```


##

```




```


##

```




```


##

```




```


##

```




```


##

```




```


