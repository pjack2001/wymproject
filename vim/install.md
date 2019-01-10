## PegasusWang/vim-config

Install
1. Let's clone this repo! Clone to ~/.config/nvim, we'll also symlink it for Vim:

  mkdir ~/.config
  git clone git://github.com/rafi/vim-config.git ~/.config/nvim
  ln -s ~/.config/nvim ~/.vim

Note: If your system sets $XDG_CONFIG_HOME, use that instead of ~/.config in the code above. Nvim follows the XDG base-directories convention.

2. Almost done! You'll need a YAML interpreter, if you have Ruby installed - you can skip this step. OtherwisemZ either install yaml2json, or use Python:

pip3 install --user --upgrade PyYAML

3. If you are a first-time Neovim user, you need the python-neovim packages. Don't worry, run the script provided:

cd ~/.config/nvim
./venv.sh

4. Run make test to test your nvim/vim version and compatibility.


5. Run make to install all plugins.

Enjoy!


## ma6174 vim
超强vim配置文件
Build Status

运行截图
screenshot.png

简易安装方法：
打开终端，执行下面的命令就自动安装好了：

wget -qO- https://raw.github.com/ma6174/vim/master/setup.sh | sh -x

卸载 

./uninstall.sh

## vimplus
安装vimplus(建议在普通用户下安装)

git clone https://github.com/chxuan/vimplus.git ~/.vimplus
cd ~/.vimplus
./install.sh

卸载
./uninstall.sh


