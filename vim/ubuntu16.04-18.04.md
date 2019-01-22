
将 Ubuntu 16.04 LTS 升级到 Ubuntu 18.04 LTS
 
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









