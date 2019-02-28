# zsh等命令行用法

## zsh
sudo apt install zsh -y

chsh -s /bin/zsh

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc


ls .oh-my-zsh/themes

把.zshrc里面的theme改成ys，提示符变成这样：


安装自动提示插件

wget http://mimosa-pudica.net/src/incr-0.2.zsh
mkdir ~/.oh-my-zsh/plugins/incr
mv incr-0.2.zsh ~/.oh-my-zsh/plugins/incr
echo 'source ~/.oh-my-zsh/plugins/incr/incr*.zsh' >> ~/.zshrc
source ~/.zshrc
ok了，cd一下看看爽不爽。

安装autojump

我yum源没有autojump，直接下载安装

git clone git://github.com/joelthelion/autojump.git

autojump/install.py
安装完成在~/下面有.autojump目录，在.zshrc里面加一行

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh
妥了，可以使用j了。 

## vim





## tmux







