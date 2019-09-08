# ansible学习笔记


## 常用或重要

```yml
查询模块：
http://docs.ansible.com/ansible/unarchive_module.html
https://docs.ansible.com/ansible/latest/modules/debug_module.html

查错：
-vvv 
debug模块

$ sudo mv ~/.ansible/roles/* /etc/ansible/roles

$ ansible all --list
$ ansible-galaxy list


当找到一个ansible脚本时，查看调用关系，最简单的就是加上-vv参数执行一遍


```

## 运维自动化-Ansibleb 和 马哥2019全新ansible入门到精通

```yml
运维自动化-Ansible ( 一 )
https://blog.51cto.com/191226139/2066936
运维自动化-Ansible ( 二 )
https://blog.51cto.com/191226139/2067831
运维自动化-Ansible ( 三 )
https://blog.51cto.com/191226139/2068623
运维自动化-Ansible ( 四 )
https://blog.51cto.com/191226139/2069226

```


## ansible环境

模块查询
http://docs.ansible.com/ansible/latest/user_module.html


### 练习环境

102服务器
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

```yml 
配置免密登录或修改密码，对应想要修改hosts文件的主机列表
$ ssh-copy-id root@192.168.113.242


注意：ansible.cfg和hosts文件权限只能设置755，不能有可读权限，否则不生效
# cat ansible.cfg 
[defaults]
inventory = hosts
remote_user = wym
host_key_checking = False

# cat hosts
[rancher]
192.168.113.41 ansible_ssh_user=wym ansible_become_user=root ansible_become=true ansible_become_pass='newcapecwym'

# ansible all --list
# ansible all -m ping -u wym -k

批量推送公钥
# cat PushKey.yml 
---
- hosts: rancher
  remote_user: wym
  become: yes
  become_user: wym
  become_method: sudo
  tasks:
  - name: deliver authorized_keys
    authorized_key:
      user: wym
      key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
      state: present
      exclusive: yes

首先要登录一次
# ssh root@192.168.113.37
# ansible-playbook PushKey.yml -u wym -k
# ansible all -m ping

修改密码
# cat userpass.yml 
---
- hosts: rancher1
  gather_facts: false
  tasks:
  - name: change user passwd
    user: name={{ item.name }} password={{ item.chpass | password_hash('sha512') }}  update_password=always
    with_items:
         - { name: 'wym', chpass: 'newcapec' }

如果配置了免密登录，就不用加-u和-k参数
# ansible-playbook userpass.yml
# ansible-playbook userpass.yml -u wym -k

修改完密码，如果没有配置免密登录，就需要修改hosts里面的密码
# cat hosts
[rancher]
192.168.113.41 ansible_ssh_user=wym  ansible_become_user=root ansible_become=true ansible_become_pass='newcapec'

# ansible all -m ping

```

#### 本机


```yml

使用vagrant虚拟机，~/tool/vagrant/oracle

ansible-galaxy的roles默认下载到/home/w/.ansible/roles，
拷贝到/media/xh/i/linuxtool/ansible/roles，压缩保存
拷贝到/etc/ansible/roles修改验证，

验证通过的拷贝到/media/xh/i/linuxtool/ansible/roles/modified
或
/media/xh/i/python/wymproject/ansible/testw/modified


vagrant up
vagrant ssh-config
vagrant snapshop save

快照的名字写错了，写成了oracle1
vagrant snapshot save oracle1
vagrant snapshot restore oracle1


$ ansible all --list
$ ansible all -m ping

$ ansible-playbook /home/w/tool/vagrant/oracle/testinstall.yml -vv

如果需要root权限，要加-b参数
$ ansible-playbook -b testinstall.yml -vv 


执行安装oracle
$ ansible-playbook /media/xh/i/python/wymproject/oracle/oracleinstalltest/sysco_oracle11204.yml -vv

```
### keepalived+nginx


```yml


$ ansible all --list
$ ansible all -m ping

测试roles

$ cat testinstall.yml 
- name: "Install"
  hosts: all

  roles:
    # - uzer.keepalived
    - geerlingguy.nginx
    - geerlingguy.docker

$ ansible-playbook /home/w/tool/vagrant/oracle/testinstall.yml -vv

如果需要root权限，要加-b参数
$ ansible-playbook -b testinstall.yml -vv 



$ ansible all -b -m yum -a 'name=keepalived state=present' -vv

安装，多个软件用,隔开
$ ansible test -b -m yum -a 'name=tree,vim,dstat state=present'


各节点分别拷贝

ansible oracle1 -b -m copy -a 'src=/home/w/tool/oracle/keepalived-nginx/wm.keepalived.conf  dest=/etc/keepalived/keepalived.conf backup=yes'

ansible oracle2 -b -m copy -a 'src=/home/w/tool/oracle/keepalived-nginx/wb.keepalived.conf  dest=/etc/keepalived/keepalived.conf backup=yes'

全部节点执行

ansible all -b -m copy -a 'src=/home/w/tool/oracle/keepalived-nginx/nginx_check.sh  dest=/etc/keepalived backup=yes'

ansible all -b -m copy -a 'src=/home/w/tool/oracle/keepalived-nginx/nginx/nginx.conf  dest=/etc/nginx backup=yes'

恢复原始备份nginx.conf
$ ansible all -b -m copy -a 'src=/home/w/tool/oracle/keepalived-nginx/nginx/nginx.conf.bak  dest=/etc/nginx/nginx.conf backup=yes'

$ ansible all -b -m copy -a 'src=/home/w/tool/oracle/keepalived-nginx/nginx/nginx.conf-w dest=/etc/nginx/nginx.conf backup=yes'

ansible all -b -m copy -a 'src=/home/w/tool/oracle/keepalived-nginx/nginx/8080.conf  dest=/etc/nginx/conf.d backup=yes'

注意：/etc/nginx/conf.d/default.conf已经侦听80端口，所以新建的监听端口不能重复，或者default.conf改后缀名


$ ansible all -b -m shell -a 'echo $HOSTNAME > /usr/share/nginx/html/index.html'

$ ansible all -b -m service -a 'name=nginx state=restarted enabled=yes'

$ ansible all -b -m service -a 'name=keepalived state=restarted enabled=yes'

$ ansible all -b -m shell -a 'rm -rf /etc/nginx/conf.d/80*'

$ ansible all -b -m shell -a 'rm -rf /etc/nginx/nginx.conf.*'




集群:vagrant虚拟机oracle
安装keepalived+nginx

VIP:172.17.8.244
172.17.8.241
172.17.8.242

两个web应用：nginx容器，80端口映射出来

127.0.0.1:8041
127.0.0.1:8042

http://192.168.157.118:8041/
http://192.168.157.118:8042/





```


###


```yml
# w @ uw in ~/tool/vagrant/oracle [13:05:32] 
$ tree
.
├── ansible.cfg
├── docker-compose.yml
├── hosts
├── mysite.template
└── Vagrantfile




$ cd /home/w/tool/vagrant/oracle
建立两个虚拟机

$ vagrant ssh-config
Host oracle1
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/w/tool/vagrant/oracle/.vagrant/machines/oracle1/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL

Host oracle2
  HostName 127.0.0.1
  User vagrant
  Port 2200
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/w/tool/vagrant/oracle/.vagrant/machines/oracle2/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL


在本地目录建立主机清单，关闭主机秘钥检查host_key_checking = False，这样就可以在重建vagrant虚拟机的时候，方便再次ssh登录。

$ cat ansible.cfg 
[defaults]
inventory = hosts
remote_user = vagrant
#private_key_file = .vagrant/machines/default/virtualbox/private_key #注意路径
host_key_checking = False

$ cat hosts 
oracle1 ansible_host=127.0.0.1 ansible_port=2222 ansible_private_key_file=.vagrant/machines/oracle1/virtualbox/private_key
oracle2 ansible_host=127.0.0.1 ansible_port=2200 ansible_private_key_file=.vagrant/machines/oracle2/virtualbox/private_key

$ ansible all --list
$ ansible all -m ping


$ cat Vagrantfile 
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.provider 'virtualbox' do |vb|
   vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
  end  
#config.vm.synced_folder ".", "/oracle", type: "nfs", nfs_udp: false
  config.vm.synced_folder "/home/w/tool/oracle/", "/oracle", type: "nfs", nfs_udp: false
  $num_instances = 2
  # curl https://discovery.etcd.io/new?size=3
  #i$etcd_cluster = "node1=http://172.17.8.101:2380"
  (1..$num_instances).each do |i|
    config.vm.define "oracle#{i}" do |node|
      node.vm.box = "centos/7"
      node.vm.hostname = "oracle#{i}"
      ip = "172.17.8.#{i+240}"
      node.vm.network "private_network", ip: ip
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "3072"
        vb.cpus = 1
        vb.name = "oracle#{i}"
      end
  # node.vm.provision "shell", path: "install.sh", args: [i, ip, $etcd_cluster]
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo mkdir -p /etc/yum.repos.d/repobak
    sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak
    sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    sudo curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/CentOS-7.repo > /etc/yum.repos.d/Centos-7.repo
#sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/epel-7.repo > /etc/yum.repos.d/epel-7.repo
#sudo curl http://192.168.102.3/CentOS-YUM/centos/repo/docker-ce1806.repo > /etc/yum.repos.d/docker-ce.repo
    sudo yum clean all && yum makecache
    sudo yum install -y wget vim tree
#sudo yum install -y docker-ce
#sudo systemctl start docker
#sudo systemctl enable docker
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo setenforce 0
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    sudo sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo systemctl restart sshd

  SHELL

end


root和vagrant用户密码都是vagrant

#如果上面的做了，应该就可以ssh登录了
ssh root@172.17.8.241
ssh root@172.17.8.242

如果重建虚拟机，清除公钥
ssh-keygen -f "/home/w/.ssh/known_hosts" -R "172.17.8.241"
ssh-keygen -f "/home/w/.ssh/known_hosts" -R "172.17.8.242"


如果不能ssh登录，登录后修改ssh配置
$ vagrant ssh oracle1
sudo vim /etc/ssh/sshd_config
删除注释的#号
#   PasswordAuthentication yes
PasswordAuthentication yes

sudo systemctl restart sshd


修改PushKey.yml文件里的hosts，上传公钥
$ ansible-playbook /media/xh/i/python/wymproject/ansible/testw/Verified/PushKey.yml -u root -k

$ ansible-playbook /media/xh/i/wymproject/ansible/testw/Verified/PushKey.yml -u root -k


```

### temp

```

$ ansible 172.17.8.241 -m lineinfile -a 'dest=/etc/selinux/config regexp='^SELINUX=enforcing' line='SELINUX=disabled''

$ ansible 172.17.8.241 -m service -a 'name=sshd state=restarted'



   - name: seline modify enforcing
      lineinfile:
         dest: /etc/selinux/config
         regexp: '^SELINUX='
         line: 'SELINUX=enforcing'



```




$ docker exec -it d0800 /bin/bash

root/newcapec


## 学习笔记


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


### 配置文件

```

配置文件或指令	描述
/etc/ansible/ansible.cfg	主配置文件，配置ansible工作特性
/etc/ansible/hosts	主机清单
/etc/ansible/roles/	存放角色的目录
/usr/bin/ansible	主程序，临时命令执行工具
/usr/bin/ansible-doc	查看配置文档，模块功能查看工具
/usr/bin/ansible-galaxy	下载/上传优秀代码或Roles模块的官网平台
/usr/bin/ansible-playbook	定制自动化任务，编排剧本工具
/usr/bin/ansible-pull	远程执行命令的工具
/usr/bin/ansible-vault	文件加密工具
/usr/bin/ansible-console	基于Console界面与用户交互的执行工具

```

### Ansible 配置文件ansible.cfg


```yml


ansible.cfg文件查找顺序
1、ANSIBLE_CONFIG环境变量所指定的文件
2、./ansible.cfg 当前目录下
3、 ～/.ansible.cfg 主目录下
4、 /etc/ansible/ansible.cfg

通常可以把ansible.cfg文件和playbook一起放在某个目录，就可以用git来管理


注意：ansible.cfg和hosts文件权限只能设置755，不能有可读权限，否则不生效

Ansible 配置文件/etc/ansible/ansible.cfg （一般保持默认）
 [defaults]
 #inventory = /etc/ansible/hosts # 主机列表配置文件
 #library = /usr/share/my_modules/ # 库文件存放目录
 #remote_tmp = $HOME/.ansible/tmp #临时py命令文件存放在远程主机目录
 #local_tmp = $HOME/.ansible/tmp # 本机的临时命令执行目录
 #forks = 5 # 默认并发数
 #sudo_user = root # 默认sudo 用户
 #ask_sudo_pass = True #每次执行ansible命令是否询问ssh密码
 #ask_pass = True      #连接时提示输入ssh密码
 #remote_port = 22     #远程主机的默认端口，生产中这个端口应该会不同
 #log_path = /var/log/ansible.log #日志
 #host_key_checking = False # 检查对应服务器的host_key，建议取消注释。也就是不会弹出
                                Are you sure you want to continue connecting (yes/no)? 
```


### Inventory 主机清单

```

Ansible必须通过Inventory 来管理主机。Ansible 可同时操作属于一个组的多台主机,组和主机之间的关系通过 inventory 文件配置。

语法格式：

单台主机
green.example.com    >   FQDN
192.168.100.10       >   IP地址
192.168.100.11:2222  >   非标准SSH端口

[webservers]         >   定义了一个组名     
alpha.example.org    >   组内的单台主机
192.168.100.10 

[dbservers]
192.168.100.10       >   一台主机可以是不同的组，这台主机同时属于[webservers] 

[group:children]     >  组嵌套组，group为自定义的组名，children是关键字，固定语法，必须填写。
dns                  >  group组内包含的其他组名
db                   >  group组内包含的其他组名

[webservers] 
www[001:006].hunk.tech > 有规律的名称列表，
这里表示相当于：
www001.hunk.tech
www002.hunk.tech
www003.hunk.tech
www004.hunk.tech
www005.hunk.tech
www006.hunk.tech

[databases]
db-[a:e].example.com   >   定义字母范围的简写模式,
这里表示相当于：
db-a.example.com
db-b.example.com
db-c.example.com
db-d.example.com
db-e.example.com

以下这2条定义了一台主机的连接方式，而不是读取默认的配置设定
localhost       ansible_connection=local
www.163.com     ansible_connection=ssh        ansible_ssh_user=hunk

最后还有一个隐藏的分组，那就是all，代表全部主机,这个是隐式的，不需要写出来的。

```

### Inventory 参数说明

```
ansible_ssh_host
      将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置.

ansible_ssh_port
      ssh端口号.如果不是默认的端口号,通过此变量设置.这种可以使用 ip:端口 192.168.1.100:2222

ansible_ssh_user
      默认的 ssh 用户名

ansible_ssh_pass
      ssh 密码(这种方式并不安全,我们强烈建议使用 --ask-pass 或 SSH 密钥)

ansible_sudo_pass
      sudo 密码(这种方式并不安全,我们强烈建议使用 --ask-sudo-pass)

ansible_sudo_exe (new in version 1.8)
      sudo 命令路径(适用于1.8及以上版本)

ansible_connection
      与主机的连接类型.比如:local, ssh 或者 paramiko. Ansible 1.2 以前默认使用 paramiko.1.2 以后默认使用 'smart','smart' 方式会根据是否支持 ControlPersist, 来判断'ssh' 方式是否可行.

ansible_ssh_private_key_file
      ssh 使用的私钥文件.适用于有多个密钥,而你不想使用 SSH 代理的情况.

ansible_shell_type
      目标系统的shell类型.默认情况下,命令的执行使用 'sh' 语法,可设置为 'csh' 或 'fish'.

ansible_python_interpreter
      目标主机的 python 路径.适用于的情况: 系统中有多个 Python, 或者命令路径不是"/usr/bin/python",比如  \*BSD, 或者 /usr/bin/python 不是 2.X 版本的 Python.
      我们不使用 "/usr/bin/env" 机制,因为这要求远程用户的路径设置正确,且要求 "python" 可执行程序名不可为 python以外的名字(实际有可能名为python26).

      与 ansible_python_interpreter 的工作方式相同,可设定如 ruby 或 perl 的路径....
上面的参数用这几个例子来展示可能会更加直观

some_host         ansible_ssh_port=2222     ansible_ssh_user=manager
aws_host          ansible_ssh_private_key_file=/home/example/.ssh/aws.pem
freebsd_host      ansible_python_interpreter=/usr/local/bin/python
ruby_module_host  ansible_ruby_interpreter=/usr/bin/ruby.1.9.3

第一条 Ansible 命令
很重要的一点，主机清单必须要先配置，由于这搭建了内部DNS服务器，所以，这里的主机使用了FQDN名称。

#cat /etc/ansible/hosts 
[web]
6-web-1.hunk.tech
7-web-0.hunk.tech
7-web-2.hunk.tech

[group:children]
dns
db

[dns]
6-dns-1.hunk.tech

[db]
7-db-3.hunk.tech

192.168.7.[200:203]
192.168.7.254


#ansible dns -m ping       # 使用ansible对dns组内的主机进行ping模块测试

```




### Ansible常用命令语法


```


ansible <host-pattern> [-m module_name] [options]
指令 匹配规则的主机清单 -m 模块名 选项

--version 显示版本
-a 模块参数（如果有）
-m module 指定模块，默认为command
-v 详细过程 –vv -vvv更详细
--list-hosts 显示主机列表，可简写--list
-k, --ask-pass 提示连接密码，默认Key验证
-K，--ask-become-pass 提示使用sudo密码
-C, --check 检查，并不执行
-T, --timeout=TIMEOUT 执行命令的超时时间，默认10s
-u, --user=REMOTE_USER 执行远程执行的用户
-U， SUDO_USER, --sudo-user 指定sudu用户
-b, --become 代替旧版的sudo 切换


ansible-doc: 显示模块帮助
ansible-doc [options] [module...]

-a 显示所有模块的文档
-l, --list 列出可用模块
-s, --snippet 显示指定模块的简要说明

例子：#ansible-doc ping

由于ansible的模块有1378个(2.4.2.0),并且一直在持续更新。因此，这个指令必须要掌握的。
#ansible-doc -l |wc -l
1378



```


###


```


```


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


由于在本机的~/.ssh/known_hosts文件中并有fingerprint key串，ssh第一次连接的时候一般会提示输入yes 进行确认为将key字符串加入到  ~/.ssh/known_hosts 文件中。
默认host_key_checking部分是注释的，通过找开该行的注释，同样也可以实现跳过 ssh 首次连接提示验证部分。

$ vim /etc/ansible/ansible.cfg
#去掉注释
# uncomment this to disable SSH key host checking
host_key_checking = False



# logging is off by default unless this path is defined
# if so defined, consider logrotate
log_path = /var/log/ansible.log

$ sudo touch /var/log/ansible.log
$ sudo chmod 777 /var/log/ansible.log



```



## 主机列表

```




$ vim /etc/ansible/hosts

[oracle]
172.17.8.241 ansible_ssh_user=root ansible_ssh_passwd=vagrant
172.17.8.242 ansible_ssh_user=root ansible_ssh_passwd=vagrant


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

```
基于key的免密码登录
#ssh-keygen
#ssh-copy-id IP

```


$ ansible-playbook PushKey.yml -u root -k

### command模块
默认command模块,参数可以省略,command模块不适合管道、变量、重定向、特殊符合之类的命令
$ ansible test -a 'df -h' -u root -k
$ ansible test -m command -a 'df -h' -u root -k
$ ansible test -m command -a uptime

### shell模块


```
$ ansible test -m shell -a 'echo $HOSTNAME'

$ ansible test -m shell -a 'cat /etc/redhat-release'

$ ansible test -m shell -a 'ls /home'

$ ansible test -m shell -a 'reboot'

$ ansible test -m shell -a 'getenforce'


$ ansible test -m shell -a 'ss -ntl'

$ ansible test -m shell -a 'getent passwd'
$ ansible test -m shell -a 'getent passwd |grep 1000'

$ ansible test -m shell -a 'getent group |grep ftp'

有些复杂命令，即使使用shell也可能会失败，
解决办法：写到脚本时，copy到远程，执行，再把需要的结果拉回执行命令的机器
#ansible web -m shell -a df | awk '{print $5}'

```


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

copy
功能：复制文件或目录到远程节点。默认会覆盖目标文件

backup：在覆盖之前将原文件备份，备份文件包含时间信息。有两个选项：yes|no 
content：用于替代"src",可以直接设定指定文件的内容，相当于echo 重定向内容到文件
dest：必选项。要将源文件复制到的远程主机的绝对路径，如果源文件是一个目录，那么该路径也必须是个目录 
directory_mode：递归的设定目录的权限，默认为系统默认权限
force：如果目标主机包含该文件，但内容不同，如果设置为yes，则强制覆盖，如果为no，则只有当目标主机的目标位置不存在该文件时，才复制。默认为yes
others：所有的file模块里的选项都可以在这里使用
src：要复制到远程主机的文件在本地的地址，可以是绝对路径，也可以是相对路径。如果路径是一个目录，它将递归复制。在这种情况下，如果路径使用"/"来结尾，则只复制目录里的内容，如果没有使用"/"来结尾，则包含目录在内的整个内容全部复制，类似于rsync。

ansible dns -m copy -a 'src=/tmp/abc.txt  dest=/app backup=yes'


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


功能：设置远程节点的文件的文件属性

force：需要在两种情况下强制创建软链接，一种是源文件不存在但之后会建立的情况下；另一种是目标软链接已存在,需要先取消之前的软链，然后创建新的软链，有两个选项：yes|no 
group：定义文件/目录的属组 
mode：定义文件/目录的权限
owner：定义文件/目录的属主
path：必选项，定义文件/目录的路径
recurse：递归的设置文件的属性，只对目录有效
src：要被链接的源文件的路径，只应用于state=link的情况
dest：被链接到的路径，只应用于state=link的情况 
state：  操作方法
    directory：如果目录不存在，创建目录
    file：即使文件不存在，也不会被创建
    link：创建软链接
    hard：创建硬链接
    touch：如果文件不存在，则会创建一个新的文件，如果文件或目录已存在，则更新其最后修改时间
    absent：删除目录、文件或者取消链接文件。相当于rm -rf

创建空文件，类似于touch    
ansible dns -m file -a 'path=/app/dir2/abc.txt state=touch mode=0666 owner=ftp'    

创建空目录， 类似于mkdir -p
ansible dns -m file -a 'path=/app/dir2/dir3/dir4 state=directory mode=0666 owner=ftp'

├ dir2
│ └── dir3
│     └── dir4

创建软链接
ansible dns -m file -a 'path=/app/abc.txt state=link src=/app/dir2/abc.txt'
lrwxrwxrwx  1 root root   17 Feb  1 00:58 abc.txt -> /app/dir2/abc.txt



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

```
cron
功能：管理计划任务

backup：对远程主机上的原任务计划内容修改之前做备份 
cron_file：如果指定该选项，则用该文件替换远程主机上的cron.d目录下的用户的任务计划 
day：日（1-31，*，*/2,……） 
hour：小时（0-23，*，*/2，……）  
minute：分钟（0-59，*，*/2，……） 
month：月（1-12，*，*/2，……） 
weekday：周（0-7，*，……）
job：要执行的任务，依赖于state=present 
name：该任务的描述 
special_time：指定什么时候执行，参数：reboot,yearly,annually,monthly,weekly,daily,hourly 
state：确认该任务计划是创建还是删除 
user：以哪个用户的身份执行

ansible dns -m cron -a 'name="test cron job" minute=*/2 job="/usr/bin/wall hello world"'

禁用某个计划任务

Ansible: test cron job
*/2 * * * * /usr/bin/wall hello world

正确的写法：必须完整的写完，包括name等属性
ansible dns -m cron -a 'disabled=yes name=None minute=*/3 job="/usr/bin/wall hello world"'

ansible dns -m cron -a 'disabled=yes job="/usr/bin/wall hello world"'   > 这种写法是不对的，它会创建一条以下记录并禁用它
Ansible: None
* * * * * /usr/bin/wall hello world

删除计划任务
ansible dns -m cron -a 'state=absent name=None'


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

```

### yum模块

```
yum
功能：使用yum包管理器来管理软件包

config_file：yum的配置文件 
disable_gpg_check：关闭gpg_check 
disablerepo：不启用某个源 
enablerepo：启用某个源
name：要进行操作的软件包的名字，也可以传递一个url或者一个本地的rpm包的路径 
state：Whether to install (`present' or `installed', `latest'), or remove (`absent' or `removed') a package.
        (可选值: present, installed, latest, absent, removed) [Default: present]

#ansible all -m yum -a 'name=tree state=present'

#ansible all -a 'rpm -q tree' -o

```

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



### yum_repository

```
功能：配置管理yum源

reposdir： repo文件存放目录
file：      repo文件名，默认为name的值
name:       唯一的repository ID
gpgkey：设置gpgkey
gpgcheck:设置gpg检查
enabled:设置开启关闭
bandwidth：控制带宽，0为无限
state：状态（present，absent
description：描述

#ansible dns -m yum_repository -a 'state=present name=epel enabled=yes gpgcheck=yes description="Aliyun EPEL" baseurl="http://mirrors.aliyun.com/epel/6/$basearch,http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/" gpgkey="https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-6Server"'
```



### service模块


```
service
功能：配置管理服务

arguments：给命令行提供一些选项 。可以使用别名 args
enabled：是否开机启动 yes|no
name：必选项，服务名称 
pattern：定义一个模式，如果通过status指令来查看服务的状态时，没有响应，就会通过ps指令在进程中根据该模式进行查找，如果匹配到，则认为该服务依然在运行
runlevel：运行级别
sleep：如果执行了restarted，在则stop和start之间沉睡几秒钟
state：对当前服务执行启动，停止、重启、重新加载等操作（started,stopped,restarted,reloaded）

#ansible db -m service -a 'name=httpd state=started'  > 一次只能操作一个服务

```

reloaded, restarted, started, stopped
关闭并禁止自启动
$ ansible test -m service -a 'name=firewalld state=stopped enabled=no'

$ ansible test -m service -a 'name=firewalld state=started'


### setup模块

```


功能：收集关于远程主机的信息。

在playbooks里经常会用到的一个参数gather_facts就与该模块相关

--tree :将所有主机的输出信息保存到/tmp/目录下，以/etc/ansible/hosts里的主机名为文件名
ansible all -m setup -a 'filter=ansible_distribution_version' --tree /tmp/

filter ：过滤关键字
#ansible db -m setup -a 'filter=ansible_distribution_version'

gather_subset：按子集收集信息，值有all, min, hardware, network, virtual, ohai, facter。不包含请使用！号，如，!network
关键字	说明	返回值例子
ansible_nodename	节点名	"6-dns-1.hunk.tech"
ansible_fqdn	FQDN名	"6-dns-1.hunk.tech"
ansible_hostname	主机短名称	"6-dns-1"
ansible_domain	主机域名后缀	"hunk.teh"
ansible_memtotal_mb	总物理内存	"ansible_memtotal_mb": 222
ansible_swaptotal_mb	SWAP总大小	"1023"
ansible_processor	CPU信息	Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz
ansible_processor_cores	CPU核心数量	4
ansible_processor_vcpus	CPU逻辑核心数量	2
ansible_all_ipv4_addresses	有所IPV4地址	192.168.0.200
ansible_all_ipv6_addresses	所有IPV6地址
ansible_default_ipv4	默认网关的网卡配置信息
ansible_eth2	具体某张网卡信息	不同系统名称需要变化
ansible_dns	DNS设置信
ansible_architecture	系统架构	x86_64
ansible_machine	主机类型	x86_64
ansible_kernel	内核版本	"2.6.32-696.el6.x86_64"
ansible_distribution	发行版本	"CentOS"
ansible_distribution_major_version	操作系统主版本号	"6"
ansible_distribution_release	发行版名称	"Final"
ansible_distribution_version	完整版本号	"7.4.1708"
ansible_pkg_mgr	软件包管理方式	"yum"
ansible_service_mgr	进行服务方式	"systemd"
ansible_os_family	家族系列	"RedHat"
ansible_cmdline	内核启动参数
ansible_selinux	SElinux状态	"disabled"
ansible_env	当前环境变量参数
ansible_date_time	时间相关
ansible_python_version	python版本	"2.6.6"
ansible_lvm	LVM卷相关信息
ansible_mounts	所有挂载点
ansible_device_links	所有挂载的设备的UUID和卷标名
ansible_devices	所有/dev/下的正在使用的设备的信息
ansible_user_dir	执行用户的家目录	"/root"
ansible_user_gecos	执行用户的描述信息	"The root "
ansible_user_gid	执行用户的的GID	0
ansible_user_id	执行用户的的用户名	"root"
ansible_user_shell	执行用户的shell类型	"/bin/bash"
ansible_user_uid	执行用户的UID	0


```

### user账户模块

```yml
user
功能：管理用户账号

选项太多，与useradd这类系统命令差不多
http://docs.ansible.com/ansible/latest/user_module.html

name：用户名，可以使用别名user
#ansible db -m user -a 'name=hunk4 shell=/sbin/nologin system=yes comment="name is hunk"'
7-db-3.hunk.tech | SUCCESS => {
    "changed": true, 
    "comment": "name is hunk", 
    "createhome": true, 
    "group": 996, 
    "home": "/home/hunk4", 
    "name": "hunk4", 
    "shell": "/sbin/nologin", 
    "state": "present", 
    "system": true, 
    "uid": 998
}

删除用户
#ansible db -m user -a 'name=hunk4 state=absent'
7-db-3.hunk.tech | SUCCESS => {
    "changed": true, 
    "force": false, 
    "name": "hunk4", 
    "remove": false, 
    "state": "absent"
}

修改用户指定信息
#ansible db -m user -a 'name=hunk4 state=present comment=" hunk is my"'

remove：删除用户时一并删除用户家目录，需要与state=absent一起使用

#ansible db -m user -a 'name=hunk3 state=absent remove=yes'
7-db-3.hunk.tech | SUCCESS => {
    "changed": true, 
    "force": false, 
    "name": "hunk3", 
    "remove": true, 
    "state": "absent"
}

state：操作方法。(present , absent)

groups: 添加辅助组
group: 指定用户的主组

以下这个例子注意看，group和groups所代表的含义不同。
    - name: add user
      user: name={{ username }} group=ftp groups={{ groupname }}


创建一个ftp账号，没有登录权限，属于系统组，指定家目录，加上描述
$ ansible test -m user -a 'name=ftpuser shell=/sbin/nologin system=yes home=/opt/ftp comment="FTP user"'

指定主组，附加组，uid等信息
$ ansible test -m user -a 'name=ftpuser shell=/sbin/nologin system=yes home=/opt/ftp group=ftp groups=root,bin uid=1001 comment="FTP user"'

$ ansible test -a 'getent passwd ftpuser'
$ ansible test -a 'ls -l /opt'

删除用户，remove表示删除家目录
$ ansible test -m user -a 'name=ftpuser state=absent remove=yes'



使用Ansible的user模块批量修改用户密码
Galactics关注0人评论42720人阅读2018-07-11 14:51:52
介绍使用ansible批量修改用户密码的方法，因为在使用ansible修改用户密码的时候不能使用明文的方式，需要先加密，所以就需要使用一个方法对输入的明文的密码进行加密，下面就直接上干货。

方法一：
1、这个方法适用于更改多个固定的用户；playbook写法如下：

# cat userpass.yml
---
- hosts: test
  gather_facts: false
  tasks:
  - name: change user passwd
    user: name={{ item.name }} password={{ item.chpass | password_hash('sha512') }}  update_password=always
    with_items:
         - { name: 'root', chpass: 'admin#123' }
         - { name: 'wym', chpass: 'newcapec ' }
1.1、执行playbook如下：
# ansible-playbook userpass.yml

以非root用户连接目标主机通过 sudo执行 剧本：

　　　　ansible-playbook play.yml --user=app --private-key=/home/app/.ssh/id_rsa -b 
　　　　解析：-b 是 become  -s 是旧版本的sudo


方法二：
2、这个方法更改单用户比较方便，从外面使用-e参数传递变量到playbook中，playbook写法如下：

  # cat  userpass2.yml               
    ---
    - hosts: test
      gather_facts: false
      tasks:
      - name: Change password
        user: name={{ name1 }}  password={{ chpass | password_hash('sha512') }}  update_password=always
2 .1、执行playbook脚本，使用-e参数传递用户名和密码给剧本，其中test为用户名，admin#123就是要设置密码，执行如下：
# ansible-playbook userpass2.yml -e "name1=test chpass=admin#123"



```



### group组模块

```

功能：添加组或删除组

group模块请求的是groupadd, groupdel, groupmod 三个指令.
用法都是差不多的。

```

$ ansible test -m group -a 'name=oracle system=yes gid=1002'

$ ansible test -m shell -a 'getent group |grep oracle'

$ ansible test -m group -a 'name=oracle state=absent'

### get_url模块


```yml

功能：从 HTTP, HTTPS, or FTP 下载文件

checksum：下载完成后进行checksum；格式： e.g. checksum="sha256:D98291AC[...]B6DC7B97".值有sha1, sha224, sha384, sha256, sha512, md5
timeout：下载超时时间，默认10s
url：下载的URL
url_password、url_username：主要用于需要用户名密码进行验证的情况
use_proxy：是事使用代理，代理需事先在环境变更中定义
force：yes目标存在时是否下载，no目标文件不存在时下载
backup:创建一个包含时间戳信息的备份文件

#ansible dns -m get_url -a 'dest=/app/ url="https://github.com/bennojoy/nginx/archive/master.zip"'

#ansible dns -m get_url -a 'dest=/app/ELS.txt checksum=sha1:8c9e20bd25525c3ed04ebaa407097fe875f02b2c url="ftp://172.18.0.1/pub/Files/ELS.txt" force=yes'
6-dns-1.hunk.tech | SUCCESS => {
    "changed": false, 
    "checksum_dest": "8c9e20bd25525c3ed04ebaa407097fe875f02b2c", 
    "checksum_src": "8c9e20bd25525c3ed04ebaa407097fe875f02b2c", 

```



### fail模块


```
功能：自定义消息失败

- fail:
    msg: "The system may not be provisioned according to the CMDB status."
  when: cmdb_status != "to-be-staged"

默认返回 'Failed as requested from task'
```

### lineinfile模块

```
功能：替换一个文件中特定的行，或者使用一个反引用的正则表达式替换一个现有的行。

只有找到的最后一行将被替换
backup：创建一个包含时间戳信息的备份文件
backrefs：  为no时，如果没有匹配,则添加一行line。如果匹配了，则把匹配内容替被换为line内容。
            为yes时，如果没有匹配，则文件保持不变。如果匹配了，把匹配内容替被换为line内容。
insertafter：配合state=present。该行将在指定正则表达式的最后一个匹配之后插入。一个特殊的价值是在EOF; EOF用于在文件的末尾插入行。如果指定的正则表达式没有匹配，则将使用EOF
insertBefore：state=present。该行将在指定正则表达式的最后一个匹配之前插入。 BOF用于在文件的开头插入行。如果指定的正则表达式不匹配，则该行将被插入到文件的末尾。不能使用backrefs
valiate：在保存sudoers文件前，验证语法，如果有错，执行时，会报出来，重新编辑playbook
regexp: 正则表达式
# Before 2.3, option 'dest', 'destfile' or 'name' was used instead of 'path'
- lineinfile:
    path: /etc/selinux/config
    regexp: '^SELINUX='
    line: 'SELINUX=enforcing'

正则匹配，更改某个关键参数值

   - name: seline modify enforcing
      lineinfile:
         dest: /etc/selinux/config
         regexp: '^SELINUX='
         line: 'SELINUX=enforcing'

- lineinfile:
    path: /etc/sudoers
    state: absent
    regexp: '^%wheel'

- lineinfile:
    path: /etc/hosts
    regexp: '^127\.0\.0\.1'
    line: '127.0.0.1 localhost'
    owner: root
    group: root
    mode: 0644

- lineinfile:
    path: /etc/httpd/conf/httpd.conf
    regexp: '^Listen '
    insertafter: '^#Listen '
    line: 'Listen 8080'

- lineinfile:
    path: /etc/services
    regexp: '^# port for http'
    insertbefore: '^www.*80/tcp'
    line: '# port for http by default'

# Add a line to a file if it does not exist, without passing regexp
- lineinfile:
    path: /tmp/testfile
    line: '192.168.1.99 foo.lab.net foo'

# Fully quoted because of the ': ' on the line. See the Gotchas in the YAML docs.
- lineinfile:
    path: /etc/sudoers
    state: present
    regexp: '^%wheel\s'
    line: '%wheel ALL=(ALL) NOPASSWD: ALL'

# Yaml requires escaping backslashes in double quotes but not in single quotes
- lineinfile:
    path: /opt/jboss-as/bin/standalone.conf
    regexp: '^(.*)Xms(\\d+)m(.*)$'
    line: '\1Xms${xms}m\3'
    backrefs: yes

# Validate the sudoers file before saving
- lineinfile:
    path: /etc/sudoers
    state: present
    regexp: '^%ADMIN ALL='
    line: '%ADMIN ALL=(ALL) NOPASSWD: ALL'
    validate: '/usr/sbin/visudo -cf %s'

```


### replace模块

```

功能：替换一个文件中符合匹配的所有行，或者使用一个反引用的正则表达式替换所有的行。

- replace:
        path: /etc/selinux/config
        regexp: '^SELINUX=.*'
        replace: 'SELINUX=disabled'

# Before 2.3, option 'dest', 'destfile' or 'name' was used instead of 'path'
- replace:
    path: /etc/hosts
    regexp: '(\s+)old\.host\.name(\s+.*)?$'
    replace: '\1new.host.name\2'
    backup: yes

# Replace after the expression till the end of the file (requires >=2.4)
- replace:
    path: /etc/hosts
    regexp: '(\s+)old\.host\.name(\s+.*)?$'
    replace: '\1new.host.name\2'
    after: 'Start after line.*'
    backup: yes

# Replace before the expression till the begin of the file (requires >=2.4)
- replace:
    path: /etc/hosts
    regexp: '(\s+)old\.host\.name(\s+.*)?$'
    replace: '\1new.host.name\2'
    before: 'Start before line.*'
    backup: yes

# Replace between the expressions (requires >=2.4)
- replace:
    path: /etc/hosts
    regexp: '(\s+)old\.host\.name(\s+.*)?$'
    replace: '\1new.host.name\2'
    after: 'Start after line.*'
    before: 'Start before line.*'
    backup: yes

- replace:
    path: /home/jdoe/.ssh/known_hosts
    regexp: '^old\.host\.name[^\n]*\n'
    owner: jdoe
    group: jdoe
    mode: 0644

- replace:
    path: /etc/apache/ports
    regexp: '^(NameVirtualHost|Listen)\s+80\s*$'
    replace: '\1 127.0.0.1:8080'
    validate: '/usr/sbin/apache2ctl -f %s -t'

- name: short form task (in ansible 2+) necessitates backslash-escaped sequences
  replace: dest=/etc/hosts regexp='\\b(localhost)(\\d*)\\b' replace='\\1\\2.localdomain\\2 \\1\\2'

- name: long form task does not
  replace:
    dest: /etc/hosts
    regexp: '\b(localhost)(\d*)\b'
    replace: '\1\2.localdomain\2 \1\2'
模块太多了，这里仅仅是列出范例用法。

```



### unarchive模块


```
unarchive模块：http://docs.ansible.com/ansible/unarchive_module.html

 这个模块的主要作用就是解压。模块有两种用法：

1：如果参数copy=yes，则把本地的压缩包拷贝到远程主机，然后执行压缩。

2：如果参数copy=no，则直接解压远程主机上给出的压缩包。

复制代码
creates：指定一个文件名，当该文件存在时，则解压指令不执行

dest：远程主机上的一个路径，即文件解压的路径 

grop：解压后的目录或文件的属组

list_files：如果为yes，则会列出压缩包里的文件，默认为no，2.0版本新增的选项

mode：解决后文件的权限

src：如果copy为yes，则需要指定压缩文件的源路径 

owner：解压后文件或目录的属主
复制代码
实例如下：

ansible -i /root/hosts all  -m unarchive -a 'src=/usr/loca/src/mysql.tar.gz dest=/usr/local/ copy=no'
与之相对的压缩命令的模块是archive。


$ ansible all -m unarchive -a 'src=/home/w/tool/oracle/linux_11gR2_database_1of2.zip dest=/opt/install/'

$ ansible all -m unarchive -a 'src=/home/w/tool/oracle/linux_11gR2_database_2of2.zip dest=/opt/install/'




---
- hosts: oracle

  tasks:

  - name: "磁盘"
    shell: df -lh

  - name: "Unzip temp"
    unarchive: src=/home/w/tool/oracle/temp.zip dest=/opt/install/

  - name: "Unzip oracle installer 1of2"
    unarchive: src=/home/w/tool/oracle/linux_11gR2_database_1of2.zip dest=/opt/install/ 

  - name: "Unzip oracle installer 2of2"
    unarchive: src=/home/w/tool/oracle/linux_11gR2_database_2of2.zip dest=/opt/install/



```


### debug模块


```yml

 
模块说明
调试模块，用于在调试中输出信息
常用参数：
msg：调试输出的消息
var：将某个任务执行的输出作为变量传递给debug模块，debug会直接将其打印输出
verbosity：debug的级别（默认是0级，全部显示）


ansible debug模块学习笔记
2018年06月05日 10:44:33 JackLiu16 阅读数：2424
平时我们在使用ansible编写playbook时，经常会遇到错误，很多时候有不知道问题在哪里 。这个时候可以使用-vvv参数打印出来详细信息，不过很多时候-vvv参数里很多东西并不是我们想要的，这时候就可以使用官方提供的debug模块来查找问题出现在哪里。

playbook示例
# verbosity(added in 2.1),如果使用的的该本低于该版本，使用时会报错
- name: debug test one host
hosts: 200.200.6.53
tasks:
- debug:
msg: "System {{ inventory_hostname }} has uuid {{ ansible_product_uuid }}"
- debug:
msg: "System {{ inventory_hostname }} has gateway {{ ansible_default_ipv4.gateway }}"
when: ansible_default_ipv4.gateway is defined
- shell: /usr/bin/uptime
register: result
- debug:
var: result
verbosity: 4
- name: Display all variables/facts known for a host
debug:
var: hostvars[inventory_hostname]
verbosity: 2
上面我们写了一个playbook，基本就是按照官方的示例做了一点修改。通过该示例，我们可以输出setup模块里引用的几个fact项的值，也可以输出定义的一个变量result－－－其内容为uptime命令执行的结果 。

执行结果


点击图片可以看大图 。

从上面的执行结果来看，发现在获取变量的时候出错了，这是因为我使用的ansible版本比较老导致的，verbosity参数是从ansible 2.1版本之后加入的一个参数，该变量对应的值当大于等于3时，将显示详细信息 。升级了版本后，uptime部分执行结果如下：

TASK [debug] *******************************************************************
ok: [200.200.6.53] => {
"result": {
"changed": true,
"cmd": "/usr/bin/uptime",
"delta": "0:00:00.020206",
"end": "2016-07-09 17:27:58.793521",
"rc": 0,
"start": "2016-07-09 17:27:58.773315",
"stderr": "",
"stdout": " 17:27:58 up 69 days, 1:54, 1 user, load average: 0.03, 0.02, 0.05",
"stdout_lines": [
" 17:27:58 up 69 days, 1:54, 1 user, load average: 0.03, 0.02, 0.05"
],
"warnings": []
}
}
 

ansible playbook可以将多个命令组合来执行，但是很多时候我们需要接收服务器的反馈，所以debug模块就非常重要了。

出处：https://docs.ansible.com/ansible/latest/modules/debug_module.html



```























## ansible-vault加密和解密

```
Ansible-vault
功能：管理加密解密yml文件

ansible-vault [create|decrypt|edit|encrypt|rekey|view]
 ansible-vault encrypt hello.yml 加密
 ansible-vault decrypt hello.yml 解密
 ansible-vault view hello.yml 查看加密问题
 ansible-vault edit hello.yml 编辑加密文件
 ansible-vault rekey hello.yml 修改口令
 ansible-vault create new.yml 创建新文件

```

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

```
Ansible-console
可交互执行命令，支持tab补全。

#ansible-console
Vault password:默认是当前登录账号密码

root@all (5)[f:5]$
列出所有的内置命令： ?或help

执行用户@当前操作的主机组(all) (当前组的主机数量5)[f:并发数5]
设置并发数： forks n
root@all (5)[f:5]$ forks 10

切换组： cd 主机组
root@all (5)[f:10]$ cd db

列出当前组主机列表： list
root@all (5)[f:10]$ list
6-web-1.hunk.tech
7-web-0.hunk.tech
7-web-2.hunk.tech
6-dns-1.hunk.tech
7-db-3.hunk.tech

执行一行指令
root@web (3)[f:10]$ setup filter=ansible_distribution_version

```

$  ansible-console

？显示帮助

cd test 进入test主机列表












































## ansible-playbook

### 

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

```



### ansible-playbook

```
第一个playbook
$ cat hello.yml 
---
- hosts: test
  remote_user: root
  tasks:
  - name: hostname
    command: hostname
  - name: ls /home
    shell: ls /home
  - name: test yml
    command: /usr/bin/wall "hello world!"



语法检查
ansible-playbook -C hello.yml

真正执行
$ ansible-playbook hello.yml -vv





```


#### 收集的playbook，尚未验证
````yml



使用Ansible的user模块批量修改用户密码
Galactics关注0人评论42720人阅读2018-07-11 14:51:52
介绍使用ansible批量修改用户密码的方法，因为在使用ansible修改用户密码的时候不能使用明文的方式，需要先加密，所以就需要使用一个方法对输入的明文的密码进行加密，下面就直接上干货。

方法一：
1、这个方法适用于更改多个固定的用户；playbook写法如下：

# cat userpass.yml
---
- hosts: test
  gather_facts: false
  tasks:
  - name: change user passwd
    user: name={{ item.name }} password={{ item.chpass | password_hash('sha512') }}  update_password=always
    with_items:
         - { name: 'root', chpass: 'admin#123' }
         - { name: 'wym', chpass: 'newcapec ' }


1.1、执行playbook如下：
# ansible-playbook userpass.yml

以非root用户连接目标主机通过 sudo执行 剧本：

　　　　ansible-playbook play.yml --user=app --private-key=/home/app/.ssh/id_rsa -b 
　　　　解析：-b 是 become  -s 是旧版本的sudo


方法二：
2、这个方法更改单用户比较方便，从外面使用-e参数传递变量到playbook中，playbook写法如下：

  # cat  userpass2.yml               
    ---
    - hosts: test
      gather_facts: false
      tasks:
      - name: Change password
        user: name={{ name1 }}  password={{ chpass | password_hash('sha512') }}  update_password=always
2 .1、执行playbook脚本，使用-e参数传递用户名和密码给剧本，其中test为用户名，admin#123就是要设置密码，执行如下：

# ansible-playbook userpass2.yml -e "name1=test chpass=admin#123"


#数据库
---
- hosts: oracle

  tasks:

  - name: "磁盘"
    shell: df -lh

  - name: "Unzip temp"
    unarchive: src=/home/w/tool/oracle/temp.zip dest=/opt/install/

  - name: "Unzip oracle installer 1of2"
    unarchive: src=/home/w/tool/oracle/linux_11gR2_database_1of2.zip dest=/opt/install/ 

  - name: "Unzip oracle installer 2of2"
    unarchive: src=/home/w/tool/oracle/linux_11gR2_database_2of2.zip dest=/opt/install/


# ssh
一、描述

   拿到一批机器，需要做首先是修改ssh端口，防火墙配置，以及limits.conf控制文件描述符，进程数，栈大小等。

二、剧本如下：

---
    - hosts: "{{ host }}"
      remote_user: "{{ user }}"
      gather_facts: false
 
      tasks:
          - name: Modify ssh port 69410
            lineinfile:
                dest: /etc/ssh/{{ item }}
                regexp: '^Port 69410'
                insertafter: '#Port 22'
                line: 'Port 69410'
 
            with_items:
                - sshd_config
                - ssh_config
            tags:
                - sshport
 
          - name: Set sysctl file limiits
#            pam_limits: domain='*' limit_type=`item`.`limit_type` limit_item=`item`.`limit_item` value=`item`.`value` 
            pam_limits:
                dest: "{{ item.dest }}"
                domain: '*'
                limit_type: "{{ item.limit_type }}"
                limit_item: "{{ item.limit_item }}"
                value: "{{ item.value }}"
            with_items:
                - { dest: '/etc/security/limits.conf',limit_type: 'soft',limit_item: 'nofile', value: '655350' }
                - { dest: '/etc/security/limits.conf',limit_type: 'hard',limit_item: 'nofile', value: '655350'}
                - { dest: '/etc/security/limits.conf',limit_type: 'soft',limit_item: 'nproc', value: '102400' }
                - { dest: '/etc/security/limits.conf',limit_type: 'hard',limit_item: 'nproc', value: '102400' }
                - { dest: '/etc/security/limits.conf',limit_type: 'soft',limit_item: 'sigpending', value: '255377' }
                - { dest: '/etc/security/limits.conf',limit_type: 'hard',limit_item: 'sigpending', value: '255377' }
                - { dest: '/etc/security/limits.d/90-nproc.conf', limit_type: 'soft',limit_item: 'nproc', value: '262144' }
                - { dest: '/etc/security/limits.d/90-nproc.conf', limit_type: 'hard',limit_item: 'nproc', value: '262144' }
 
            tags:
                - setlimits

#按IP修改主机名
changehostname.yml 
- hosts : testall
  remote_user : root
  tasks :
  - name : show hostname
    shell : hostname
  - name : show ip
    command : ip a
  - hostname : name=web{{ ansible_default_ipv4.address.split('.')[-1] }}   


 # ansible 增加本机/etc/hosts 下hostsname 与IP

---
- hosts: all
  vars:
     IP: "{{ ansible_eth0['ipv4']['address'] }}"
  tasks:
    - name: 将原有的hosts文件备份
      shell: mv /etc/hosts /etc/hosts_bak

    - name: 将ansible端的hosts复制到各自机器上
      copy: src=/root/hosts dest=/etc/ owner=root group=root mode=0644

    - name: 在新的hosts文件后面追加各自机器内网ip和hostname
      lineinfile: dest=/etc/hosts line="{{IP}}  {{ansible_hostname}}"

---
- name: host file update - Local DSN setup across all the servers
  hosts: " {{ group }} "
  vars: 
    group: " {{ group }} "
  tasks:
    - name: update the /etc/hosts file with node name
      become: yes
      become_user: root
      lineinfile:
        path: "/etc/hosts"
        regexp: "{{ hostvars[item]['ansible_env'].SSH_CONNECTION.split(' ')[2] }}\t{{ hostvars[item]['ansible_hostname']}}"
        line: "{{ hostvars[item]['ansible_env'].SSH_CONNECTION.split(' ')[2] }}\t{{ hostvars[item]['ansible_hostname'] }}"
        state: present
      when: ansible_hostname != "{{ item }}" or ansible_hostname == "{{ item }}"
      with_items: "{{groups[group]}}"


```


#### YAML语法简介
````


这里只涉及到playbook相关的语法，更多请参考官网http://www.yaml.org

语法非常严格，请仔细仔细再仔细。

在单一档案中，可用连续三个连字号(---)区分多个档案。另外，还有选择性的连续三个点号( ... )用来表示档案结尾
 次行开始正常写Playbook的内容，一般建议写明该Playbook的功能
 使用#号注释代码
 缩进必须是统一的，不能空格和tab混用,一般缩进2个空格
 缩进的级别也必须是一致的，同样的缩进代表同样的级别，程序判别配置的级别是通过缩进结合换行来实现的
 YAML文件内容和Linux系统大小写判断方式保持一致，是区别大小写的，key/value的值均需大小写敏感
 key/value的值可以写在同一行，也可换行写。同一行使用 , 逗号分隔
 value可是个字符串，也可是另一个列表
 一个完整的代码块功能需最少元素需包括 name和task
 一个name只能包括一个task
 使用| 和 > 来分隔多行，实际上这只是一行。
        include_newlines: |
            exactly as you see
            will appear these three
            lines of poetry

        ignore_newlines: >
            this is really a
            single line of text
            despite appearances
 Yaml中不允许在双引号中出现转义符号，所以都是以单引号来避免转义符错误           
 YAML文件扩展名通常为yml或yaml

````

#### 

```
在使用ansible playbook时，经常出现部分主机执行失败：

此时，需要在失败节点重新执行，但是不想重新修改hosts文件，教你一招：

单节点：

ansible-playbook -i hostslist ***.yml --limit 10.254.9.10


节点列表(提前保存为retry.txt，此时使用认证方式依然使用hostlist文件中的ssh密码，retry.txt中只包含节点ip)

to retry, use: --limit @/media/xh/i/python/wymproject/oracle/oracleinstalltest/oracle112040-2.retry

ansible-playbook -i hostslist ***.yml --limit @failed.txt



```


#### 

```



```


#### 

```



```


#### 

```



```


#### 

```



```


#### 

```



```



### ansible-galaxy


### 

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

### ansible-galaxy 语法


```
ansible-galaxy 语法：

ansible-galaxy [delete|import|info|init|install|list|login|remove|search|setup] [--help] [options] 

比较多的roles作者

geerlingguy：roles比较多
alikins：roles比较多
klewan:oracle database grid的管理、补丁下载更新
azavea



ansible-galaxy search --author geerlingguy

ansible-galaxy search alikins



 列出已安装的galaxy
#ansible-galaxy list geerlingguy.mysql
- geerlingguy.mysql, 2.8.1

 安装galaxy
ansible-galaxy install geerlingguy.redis

 删除galaxy
ansible-galaxy remove geerlingguy.redis

升级版本
$ ansible-galaxy install geerlingguy.mysql,2.9.4 --force

roles必须在/etc/ansible/roles/目录下，才能替换成功
$ sudo mv ~/.ansible/roles/* /etc/ansible/roles/



安装的剧本默认是存放在家目录的隐藏文件中。
/root/.ansible

#tree -L 2

```


$ ansible-galaxy list
$ ansible-galaxy install geerlingguy.nginx
$ ansible-galaxy remove geerlingguy.nginx

$ ansible-galaxy search elasticsearch --author geerlingguy



$ ansible-galaxy install geerlingguy.nginx
如果因为网络原因无法下载，就用git下载

下载的roles可以删除,改名等操作

$ ansible-galaxy info geerlingguy.nginx



#### roles


```

roles
用于层次性、结构化地组织playbook。 roles能够根据层次型结构自动装载变量文件、tasks以及handlers等。

要使用roles只需要在playbook中使用import_tasks指令即可。(include也可以用，官方明确声明此命令将会淘汰)

简单来讲，roles就是通过分别将变量、文件、任务、模板及处理器放置于单独的目录中，并可以便捷地

include它们的一种机制。角色一般用于基于主机构建服务的场景中，但也可以是用于构建守护进程等场景中

 复杂场景：建议使用roles，代码复用度高

创建role的步骤
(1) 创建以roles命名的目录
(2) 在roles目录中分别创建以各角色名称命名的目录，如webservers等
(3) 在每个角色命名的目录中分别创建files、 handlers、meta、 tasks、 templates和vars目录；
    用不到的目录可以创建为空目录，也可以不创建
(4) 在playbook文件中，调用各自角色
建议的目录结构

├── roles                   > 必须是这个名字
│   ├── git                 > 具体项目名称
│   │   ├── default         > 设定默认变量时使用此目录中的main.yml文件
│   │   │   └── main.yml            > 至少应该包含一个名为main.yml的文件
│   │   ├── files           > 存放有copy或script模块等调用的文件
│   │   ├── handlers        > 定义触发器
│   │   │   └── main.yml            > 至少应该包含一个名为main.yml的文件
│   │   ├── meta            > 定义当前角色的特殊设定及其依赖关系
│   │   │   └── main.yml            > 至少应该包含一个名为main.yml的文件
│   │   ├── tasks           > 定义任务
│   │   │   └── main.yml            > 至少应该包含一个名为main.yml的文件
│   │   ├── templates       > template模块查找所需要模板文件目录
│   │   │   └── main.yml            > 至少应该包含一个名为main.yml的文件
│   │   └── vars            > 定义变量；；其他的文件需要在此文件中通过include进行包含
│   │       └── main.yml            > 至少应该包含一个名为main.yml的文件
还是拿一个实例来说：

如果要在一台初始化的主机上面安装httpd服务，有以下过程：(这里不考虑编译安装情况，假设yum脚本里不会创建组和用户)

1.创建用于httpd服务的组
2.创建用于httpd服务的用户
3.安装httpd软件包
4.启动httpd服务
把这些过程体现在ansible上面就是对应的具体的tasks,因此，将需要在roles/tasks/下面创建分别用于这些过程的独立yml文件

1.创建用于httpd服务的
#vim groupadd.yml
- name: groupadd apache
  group: name=apache 

2.创建用于httpd服务的用户
#vim useradd.yml
- name: useradd apache
  user: name=apache group=apache shell=/sbin/nologin system=yes

3.安装httpd软件包
#vim install_httpd.yml
- name: yum install httpd
  yum: name=httpd

4.启动httpd服务
#vim start_httpd.yml
- name: start httpd
  service: name=httpd state=started
每个具体的小任务有了，那么就得有一个主的配置文件，默认剧本就会读取它，从而确定其他任务的关系。

注意，文件名必须是main.yml

注意，顺序不能颠倒，步骤是从上而下顺序执行，就像编排电影剧本一样。有没有当导演的感觉?
#vim main.yml
- import_tasks: groupadd.yml
- import_tasks: useradd.yml
- import_tasks: install_httpd.yml
- import_tasks: start_httpd.yml
最后，创建一个执行的playbook文件，这个文件与roles目录是同级目录。

#vim httpd_roles.yml
---
- hosts: web
  remote_user: root

  roles:
    - httpd              > 注意，这个- 后面跟就是roles目录下的子目录名称

当然，也可以写成
  roles:
    - role: httpd        > 注意，这个- role: 是不可以改变名称的，后面跟就是roles目录下的子目录名称
image

至此，此时的目录结构为：

├── httpd_roles.yml                 > 执行的playbook文件
└── roles                           > roles角色目录
    ├── httpd                       > 项目文件夹
    │   ├── default
    │   ├── files
    │   ├── handlers
    │   ├── meta
    │   ├── tasks                   > 任务文件夹
    │   │   ├── groupadd.yml
    │   │   ├── install_httpd.yml
    │   │   ├── main.yml
    │   │   ├── start_httpd.yml
    │   │   └── useradd.yml
    │   ├── templates
    │   └── vars

#ansible web -m shell -a 'ss -nlt|grep 80'
6-web-1.hunk.tech | SUCCESS | rc=0 >>
LISTEN     0      128         :::80
7-web-2.hunk.tech | SUCCESS | rc=0 >>
LISTEN     0      128         :::80
7-web-0.hunk.tech | SUCCESS | rc=0 >>
LISTEN     0      128         :::80

调用其他任务
为了更好的复用代码，可以将一些公共的代码集中在一个目录里，按需要在以后的roles进行调用

├── pubtasks
│   └── create_nginx_user_and_group.yml

#cat create_nginx_user.yml
- name: create nginx group
  group: name=nginx

- name: create nginx user
  user: name=nginx shell=/usr/sbin/nologin comment="nginx service" group=nginx createhome=no

调用的时候，在tasks中引入即可

- hosts: dns
  remote_user: root

  tasks:
    - name: test
      import_tasks: /app/yml/pubtasks/create_nginx_user_and_group.yml
同理，在别的文件中引入import_role也是可以的。

roles中的tags
前面的章节针对tasks有tags,而roles中也可以运用此方法

- hosts: web
  remote_user: root

  roles:
    - { role: httpd, tags: [ 'web', 'apache22' ] }  > 其实，这是字典的一种写法，前面章节有讲到，只不过是写在一行里了。

所以，下面的写法是同等的
  roles:
    - role: httpd
      tags: 
        - web
        - apache22
基于条件判断的roles的tags

- { role: nginx, tags: [ 'nginx', 'web' ], when: ansible_distribution_major_version == "6" }
当roles中有了tags后，执行时候加上-t tags名称即可

# ansible-playbook  httpd_roles.yml -t web
# ansible-playbook  httpd_roles.yml -t apache22

也可以同时调用多个tags
# ansible-playbook  httpd_roles.yml -t "web,db"

```






####  geerlingguy roles


```yml

可以在一个文件中指定多个需要下载的roles

$ ansible-galaxy search database

$ ansible-galaxy search --author geerlingguy > temp.txt
$ awk '{print $1}' temp.txt > requirements.yml

vim requirements.yml
删除开头几行
:%s/geerlingguy/- src: geerlingguy/g

$ ansible-galaxy install -r geerlingguy.yml --ignore-errors -vv

$ ansible-galaxy install -r robertdebock.yml --ignore-errors -vv


ansible-galaxy install dj-wasabi.zabbix-agent






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






#### 详解Ansible(Roles)自动化部署配置LAMP架构

```yml

https://blog.51cto.com/13630803/2154767

详解Ansible(Roles)自动化部署配置LAMP架构
若此生无缘关注0人评论1061人阅读2018-08-04 20:52:13
Roles简介
Ansible为了层次化、结构化地组织Playbook，使用了角色（roles）。Roles能够根据层次型结构自动装载变量文件、task以及handlers等。简单来讲，roles就是通过分别将变量、文件、任务、模块及处理器放置于单独的目录中，并可以便捷地include它们，roles一般用于基于主机构建服务的场景中，但也可以用于构建守护进程等场景中。
 

创建Roles
创建roles时一般需要以下步骤：首先创建以roles命名的目录。然后在roles目标下分别创建以个角色名称命令的目录，如websevers等，在每个角色命令的目录中分别创建files、handlers、tasks、templates、meta、defaults和vars目录，用不到的目录可以创建为空目录。最后在Playbook文件中调用各角色进行使用

roles内各目录含义解释
files：用来存放由copy模块或script模块调用的文件。
templates：用来存放jinjia2模板，template模块会自动在此目录中寻找jinjia2模板文件。
tasks：此目录应当包含一个main.yml文件，用于定义此角色的任务列表，此文件可以使用include包含其它的位于此目录的task文件。
handlers：此目录应当包含一个main.yml文件，用于定义此角色中触发条件时执行的动作。
vars：此目录应当包含一个main.yml文件，用于定义此角色用到的变量。
defaults：此目录应当包含一个main.yml文件，用于为当前角色设定默认变量。
meta：此目录应当包含一个main.yml文件，用于定义此角色的特殊设定及其依赖关系。

案例：使用roles安装LAMP架构
1：创建httpd、mysql、php角色名称目录，并在其目录下创建files、handlers、tasks、templates、meta、defaults和vars目录

# mkdir /etc/ansible/roles/httpd/{files,templates,tasks,handlers,vars,defaults,meta} -p
# mkdir /etc/ansible/roles/mysql/{files,templates,tasks,handlers,vars,defaults,meta} -p
# mkdir /etc/ansible/roles/php/{files,templates,tasks,handlers,vars,defaults,meta} -p

mkdir -pv /etc/ansible/roles/{httpd,mysql,php}/{tasks,files,templates,meta,handlers,vars,defaults}

# touch /etc/ansible/roles/httpd/{defaults,vars,tasks,meta,handlers}/main.yml
# touch /etc/ansible/roles/mysql/{defaults,vars,tasks,meta,handlers}/main.yml
# touch /etc/ansible/roles/php/{defaults,vars,tasks,meta,handlers}/main.yml

touch /etc/ansible/roles/{httpd,mysql,php}/{defaults,vars,tasks,meta,handlers}/main.yml

编写httpd模块
安装httpd服务
修改httpd.conf配置文件

# vim /etc/ansible/roles/httpd/tasks/main.yml
    - name: ensure apache is at the latest version 
      yum: pkg={{ servicenames}} state=latest
      template: src=/etc/ansible/templates/httpd.conf.j2 dest=/etc/httpd/conf/httpd.conf
    - name: restart httpd server
      service: name=httpd enabled=true state=restarted
定义变量

# vim /etc/ansible/roles/httpd/vars/main.yml
# servicenames: httpd
编写mysql模块
并且定义变量

# vi /etc/ansible/roles/mysql/tasks/main.yml
- name: ensure mysql is at the latest version 
  yum: pkg={{ servicenames}} state=latest

# vi /etc/ansible/roles/mysql/vars/main.yml
servicenames: mariadb*
编写php模块
并且定义变量

# vi /etc/ansible/roles/php/tasks/main.yml
- name: ensure php is at the latest version
  yum: pkg={{ servicenames}} state=latest

# vi /etc/ansible/roles/php/vars/main.yml
servicenames: php
修改httpd配置文件模板
监听IP 和域名 设为变量 方便其他主机使用这个模块
详解Ansible(Roles)自动化部署配置LAMP架构详解Ansible(Roles)自动化部署配置LAMP架构详解Ansible(Roles)自动化部署配置LAMP架构详解Ansible(Roles)自动化部署配置LAMP架构

在/etc/ansible/hosts文件中设置变量
详解Ansible(Roles)自动化部署配置LAMP架构

创建Playbook文件调用上面各角色安装LAMP

[root@rabbitmq01 ansible# vim /etc/ansible/site.yml
---
- hosts: abc
    remote_user: root
    roles:
     - httpd
     - mysql
     - php

[root@rabbitmq01 ansible]# ansible-playbook site.yml --syntax-check  //检测语法

playbook: site.yml
[root@rabbitmq01 ansible]# ansible-playbook site.yml    //执行剧本
详解Ansible(Roles)自动化部署配置LAMP架构

 

测试验证
去192.168.200.129主机上写一个PHP测试页面

# echo "<?php phpinfo();?>" > /var/www/html/index.php
# systemctl restart httpd
打开浏览器输入192.168.200.129/index.php





```


##

```yml

```


## V8常用ansible命令

```yml


配置免密登录或修改密码，对应想要修改hosts文件的主机列表
$ ssh-copy-id root@192.168.113.242
$ ssh-copy-id root@192.168.113.244
$ ssh-copy-id root@192.168.113.248


注意：ansible.cfg和hosts文件权限只能设置755，不能有可读权限，否则不生效
# cat ansible.cfg 
[defaults]
inventory = hosts
remote_user = root
#private_key_file = .vagrant/machines/default/virtualbox/private_key
host_key_checking = False

# cat hosts
[test]
192.168.113.242
192.168.113.244
192.168.113.248

# ansible all --list
# ansible all -m ping


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


