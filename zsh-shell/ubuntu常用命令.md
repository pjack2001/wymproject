
# Ubuntu使用总结



## Ubuntu安装前备份
```yml
cp .bash_history /media/w/m/history-bak




```

## Dell vostro3480安装ubuntu18.04
```yml

使用UEFI不认固态盘

按F12进入进启动选项

1. 重启，按F2进入进bios设置

2.security->PTT Security->取消PTT on 

3.在General中：

    1）在Advanced bootOptions中，勾选Enable Legacy Option ROMs,勾选Enable Attempt Legacy Boot

    如果提示legacy option roms cannot be enabled with ptt 
    首先取消security->PTT Security->取消PTT on 

    2)UEFI Boot Path Security->选择Never

    3)将Boot Sequence中，Boot List Option 改为 Legacy External Devices
    好像重启完，还是UEFI，但是不影响启动Ubuntu

4.System Configuration->SATA Operation->AHCI
 
5.在Secure Boot下->Secure Boot Enable->取消勾选
 Secure Boot下->Secure Boot Mode->选择Audit Mode
 
6. 保存退出，重启

```



## Ubuntu安装配置常用软件
```yml
1T硬盘设置为/mnt/work


sudo apt update && sudo apt dist-upgrade && sudo apt autoremove

dpkg -l | grep open查看是否安装某一个软件

$ sudo apt-get install -y terminator vim synaptic meld tmux iptux unity-tweak-tool zip unzip p7zip exfat-utils catfish

sudo apt-get install ttf-wqy-microhei  #文泉驿-微米黑

$ sudo dpkg -i vagrant_2.2.4_x86_64.deb


$ sudo ./VMware-Workstation-Full-14.1.1-7528167.x86_64.bundle
AC5XK-0ZD4H-088HP-9NQZV-ZG2R4



```



## 安装Ubuntu18.04配置常用软件
```yml

$ sudo apt install -y terminator vim synaptic meld tmux iptux unity-tweak-tool p7zip zip unzip exfat-utils catfish gcc




$ sudo ./VMware-Workstation-Full-14.1.1-7528167.x86_64.bundle


$ sudo dpkg -i virtualbox-6.0_6.0.6-130049~Ubuntu~bionic_amd64.deb


$ sudo dpkg -i wps-office_10.1.0.6757_amd64.deb
安装字体
$ sudo apt install -y ttf-wqy-microhei




ubunru18.04下面安装docker18.03

开始安装doker

    由于apt官方库里的docker版本可能比较旧，所以先卸载可能存在的旧版本：

    sudo apt-get remove docker docker-engine docker-ce docker.io

     
    更新apt包索引：

    sudo apt-get update

     
    安装以下包以使apt可以通过HTTPS使用存储库（repository）：

    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

     
    添加Docker官方的GPG密钥：

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

     
    这个时间点（2018.06.09），Ubuntu 18.04 LTS (Bionic Beaver) 对应的docker package is not available，所以只能通过下面的语句安装stable存储库

    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu artful stable" 

    再更新一下apt包索引：

    sudo apt-get update

     
    安装最新版本的Docker CE：

    sudo apt-get install -y docker-ce

     
    这里安装的最新版，其实是安装你电脑上可用的最新版，查看系统可用的版本：

    apt-cache madison docker-ce

     
    选择要安装的特定版本，第二列是版本字符串，第三列是存储库名称，它指示包来自哪个存储库，以及扩展它的稳定性级别。要安装一个特定的版本，将版本字符串附加到包名中，并通过等号(=)分隔它们：

    sudo apt-get install docker-ce=<VERSION>

     
    验证docker
    查看docker服务是否启动：

    systemctl status docker

     
    若未启动，则启动docker服务：

    sudo systemctl start docker

     
    测试经典的hello world：

    sudo docker run hello-world



$ sudo usermod -aG docker ak



```


## 
```yml


```


## 
```yml


```


## 将 Ubuntu 16.04 LTS 升级到 Ubuntu 18.04 LTS
```yml

 
Ubuntu 18.04 LTS(Bionic Beaver)即将发布, 如果您正在使用Ubuntu 16.04LTS 那么可以轻松的升级到18.04LTS...

工具/原料
 
Ubuntu 16.04LTS
方法/步骤
 
1.更新Ubuntu 16.04 

在升级之前, 您应该先更新当前的16.04. 建议升级之前更新/升级所有已安装的软件包.

运行以下命令:

sudo apt update && sudo apt dist-upgrade && sudo apt autoremove


2.安装Ubuntu update manager

更新完 系统后,运行以下命令安装update-manager-core(如果您没有安装).

sudo apt-get install update-manager-core

3.打开update-manager配置文件并确保提示行设置为 lts

sudo nano /etc/update-manager/release-upgrades

Prompt=lts

END

方法/步骤
 
1.执行升级命令:

sudo do-release-upgrade -d

2.当屏幕出现升级提示是 选择y

等待所有的软件包下载...安装...到重启... 

当安装完成后,你的系统就升级到最新的Ubuntu开发版本


3.清理无用的安装包

$ sudo apt-get remove


注意：

1、如果碰到签名问题，到apt源文件取消
sudo vim /etc/apt/sources.list

2、如果碰到Your python3 install is corrupted. Please fix the '/usr/bin/python3'
 执行如下命令就ok了：

 sudo ln -sf /usr/bin/python2.7 /usr/bin/python

 如果还是不行，reinstall

  sudo apt-get install --reinstall python3



```










