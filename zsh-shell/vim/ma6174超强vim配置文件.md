
超强vim配置文件
Build Status

运行截图
screenshot.png

简易安装方法：
打开终端，执行下面的命令就自动安装好了：

wget -qO- https://raw.github.com/ma6174/vim/master/setup.sh | sh -x

或者自己手动安装：(以ubuntu为例)
安装vim sudo apt-get install vim
安装ctags：sudo apt-get install ctags
安装一些必备程序：sudo apt-get install xclip vim-gnome astyle python-setuptools
python代码格式化工具：sudo easy_install -ZU autopep8
sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
clone配置文件：cd ~/ && git clone git://github.com/ma6174/vim.git
mv ~/vim ~/.vim
mv ~/.vim/.vimrc ~/
clone bundle 程序：git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
打开vim并执行bundle程序:BundleInstall
重新打开vim即可看到效果

了解更多vim使用的小技巧：
tips.md


vim-deprecated/tips.md
fe0e188  on 2 Oct 2013
@ma6174 ma6174 增加快速注释插件
    
30 lines (20 sloc)  961 Bytes
vim 使用tip
编写python程序
自动插入头信息：
#!/usr/bin/env python
# coding=utf-8
输入.或按TAB键会触发代码补全功能
:w保存代码之后会自动检查代码错误与规范
按F6可以按pep8格式对代码格式优化
按F5可以一键执行代码
多窗口操作
使用:sp + 文件名可以水平分割窗口
使用:vs + 文件名可以垂直分割窗口
使用Ctrl + w可以快速在窗口间切换
编写markdown文件
编写markdown文件(*.md)的时候，在normal模式下按 md 即可在当前目录下生成相应的html文件
生成之后还是在normal模式按fi可以使用firefox打开相应的html文件预览
当然也可以使用万能的F5键来一键转换并打开预览
如果打开过程中屏幕出现一些混乱信息，可以按Ctrl + l来恢复
快速注释
按\ 可以根据文件类型自动注释


查看更新日志：
update_log.md

vim-deprecated/update_log.md
681553a  on 27 Feb 2017
@jiahao42 jiahao42 fix obsolete link
@ma6174 @jiahao42
    
97 lines (69 sloc)  3 KB
更新日志

2013年6月10日更新
增加javascript插件
增加常见的dict
完善<F6>对javascript的支持

2013年5月31日更新
增加400多种主题，可以在colors目录中找到
可以在这里预览 http://vimcolors.com/
将color ron中的ron换成你喜欢的主题名字即可
重新打开vim生效

2013年5月30日更新
为方便大家安装，特地写了setup.sh脚本，可以通过下面的命令一键安装：
wget https://raw.github.com/ma6174/vim/master/setup.sh && bash setup.sh

2013年5月26日更新
完善NERDTree的用法：
打开vim时不加文件名自动打开NERDTree
关闭文件时没有其他文件自动退出NERDTree
<F3>可以快速打开和关闭vim
增加syntastic，在保存代码时自动检查代码中的错误

2013年5月24日更新
增加covim团队协作工具
开启方法：:CoVim start [port] [name]
连接服务器：:CoVim connect [host address / 'localhost'] [port] [name]
退出：Quit Vim or :CoVim disconnect

2013年5月18日更新
增加代码格式优化功能
按F6可以格式化C/C++/python/perl/java/jsp/xml/代码

2013年5月17日更新
增加高亮显示列功能
增加缩进自动提示功能(indentLine)
默认关闭taglist

2013年5月10日更新
修复关闭html一直提示"Processing... % (ctrl+c to stop)bug
修改zencoding快捷键，ctrl+k展开
增加javascript插件

2013年4月3日更新
完善安装方法，修复bundle问题

2013年3月22日更新：
修复bundle插件问题
修复ctags问题

2013年3月17日更新：
增加go语言插件
增加bundle支持
修复小bug

2012年7月28日更新：
增加vimim输入法
增加多个pyhon插件,目前支持编码检测,自动增加文件头,自动补全,错误检测,一键执行python脚本
增加taglist
增加文件目录列表
增加日历功能
精简了一些没用的.vimrc 配置

2012年8月4日更新：
增加markdown插件
新建markdown文件自动添加表头"charset="utf-8"
按 md 直接生成对应的html文件，如a.md将生成a.md.html
按 fi 将在浏览器里面打开刚生成的页面进行预览

2012年8月27日更新：
增加zconding插件
增加graphviz插件，并设置F5自动执行
早期版本：
按F5可以直接编译并执行C、C++、java代码以及执行shell脚本，按“F8”可进行C、C++代码的调试
自动插入文件头 ，新建C、C++源文件时自动插入表头：包括文件名、作者、联系方式、建立时间等，读者可根据需求自行更改
映射“Ctrl + A”为全选并复制快捷键，方便复制代码
按“F2”可以直接消除代码中的空行
“F3”可列出当前目录文件，打开树状文件目录
支持鼠标选择、方向键移动
代码高亮，自动缩进，显示行号，显示状态行
按“Ctrl + P”可自动补全
[]、{}、()、""、' '等都自动补全



