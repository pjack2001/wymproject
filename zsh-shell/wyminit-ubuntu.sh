#!/bin/sh
# File    :   wyminit-Ubuntu.sh
# Time    :   2019/05/05 16:06:40
# Author  :   wangyuming 
# Version :   0.1
# License :   (C)Copyright 2018-2019, MIT
# Desc    :   None

#SET DNS
sudo su
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/base
echo "nameserver 8.8.8.8" >> /etc/resolv.conf


#当前用户代理
cat << EOF >> ~/.bashrc
export ftp_proxy=http://192.168.*.*:端口号
export http_proxy=http://192.168.*.*:端口号
export https_proxy=http://192.168.*.*:端口号
export all_proxy=http://192.168.*.*:端口号
export no_proxy=localhost,127.0.0.1,.baidu.net
EOF

cat << EOF >> ~/.bashrc
export ftp_proxy=http://192.168.102.3:3128
export http_proxy=http://192.168.102.3:3128
export https_proxy=http://192.168.102.3:3128
export all_proxy=http://192.168.102.3:3128
export no_proxy=localhost,127.0.0.1
EOF

#root用户代理
sudo su -
cat << EOF >> ~/.bashrc
export ftp_proxy=http://192.168.*.*:端口号
export http_proxy=http://192.168.*.*:端口号
export https_proxy=http://192.168.*.*:端口号
export all_proxy=http://192.168.*.*:端口号
export no_proxy=localhost,127.0.0.1,.baidu.net
EOF

#图形客户端代理
gsettings set org.gnome.system.proxy mode "manual"
gsettings set org.gnome.system.proxy.http host "192.168.*.*"
gsettings set org.gnome.system.proxy.http port "端口号"
gsettings set org.gnome.system.proxy.https host "192.168.*.*"
gsettings set org.gnome.system.proxy.https port "端口号"
gsettings set org.gnome.system.proxy.ftp host "192.168.*.*"
gsettings set org.gnome.system.proxy.ftp port "端口号"
gsettings set org.gnome.system.proxy.socks host "192.168.*.*"
gsettings set org.gnome.system.proxy.socks port "端口号"
gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8']"



#可以卸载的软件
sudo apt remove libreoffice-common unity-webapps-common

# 添加语言支持
# 进入 Language Support 添加简体中文的支持
# 添加后将 Keyboard input method system 改为 fcitx 后重启或重新登录
# 重启后通过右上角输入法图标可配置和添加中文输入法，如 Sunpinyin（推荐）、Shuangpin、Pinyin
# 如果不喜欢自带输入法也可安装其他输入法

#搜狗输入法
wget ***/sogoupinyin_2.1.0.0082_amd64.deb
sudo dpkg -i sogoupinyin_2.1.0.0082_amd64.deb
sudo apt install -f

#google拼音
sudo apt-get install fcitx-googlepinyin

#常用软件
sudo apt install -y git vim openssh-server aria2 ubuntu-restricted-extras ttf-mscorefonts-installer-

#google chrome
wget 网址/google-chrome-stable_57.0.2987.133_amd64.deb
sudo dpkg -i google-chrome-stable_57.0.2987.133_amd64.deb
sudo apt install -f

#WPS
#download wps and fonts
wget *****/ware/kingsoft/wps-office_10.1.0.5672~a21_amd64.deb
wget *****/wps_symbol_fonts.zip

#install wps fonts
unzip wps_symbol_fonts.zip -d wps_symbol_fonts
sudo cp wps_symbol_fonts/* /usr/share/fonts
sudo mkfontscale
sudo mkfontdir
sudo fc-cache

#install wps
sudo dpkg -i wps-office_10.1.0.5672~a21_amd64.deb
sudo apt install -f


#jdk + eclipse

cd /opt

#下载jdk
wget  *****/jdk-8u111-linux-x64.tar.gz
tar xzf jdk-8u111-linux-x64.tar.gz

#下载eclipse
wget *****/eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz
tar xzf eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz
mv eclipse eclipse-jee-neon-2-linux-gtk-x86_64

#设置eclipse所使用的jdk
cd eclipse-jee-neon-2-linux-gtk-x86_64
sed -i '1i -vm\n/opt/jdk1.8.0_111/bin' eclipse.ini

./eclipse


#VirtualBox
wget *****/VirtualBox/virtualbox-5.1_5.1.12-112440~Ubuntu~xenial_amd64.deb
sudo dpkg -i virtualbox-5.1_5.1.12-112440~Ubuntu~xenial_amd64.deb
sudo apt install -f
VirtualBox

#wine-qq
#安装wine
sudo su -
dpkg --add-architecture i386
add-apt-repository ppa:wine/wine-builds
apt-get update
apt-get install --install-recommends winehq-devel
exit

#安装wine-qq
cd
wget *****software/tencent/wineQQ8.9_19990.tar.xz
tar xf wineQQ8.9_19990.tar.xz








