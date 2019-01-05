# 马哥2019全新ansible入门到精通-学习笔记

## ansible环境

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

$ ansible-galaxy list
$ ansible-galaxy install geerlingguy.nginx
$ ansible-galaxy remove geerlingguy.nginx

$ ansible-galaxy search elasticsearch --author geerlingguy



$ ansible-galaxy install geerlingguy.nginx
如果因为网络原因无法下载，就用git下载

下载的roles可以删除,改名等操作

### 







### 







### 








## ansible-playbook

```




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


##

```




```


