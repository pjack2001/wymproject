
An automatic configuration program for vim


安装
Mac OS X
安装HomeBrew

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
安装vimplus

git clone https://github.com/chxuan/vimplus.git ~/.vimplus
cd ~/.vimplus
./install.sh

Ubuntu
版本要求

ubuntu16.04及其以上系统。

安装vimplus(建议在普通用户下安装)

git clone https://github.com/chxuan/vimplus.git ~/.vimplus
cd ~/.vimplus
./install.sh
Centos
版本要求

centos7及其以上系统。

安装vimplus(建议在普通用户下安装)

git clone https://github.com/chxuan/vimplus.git ~/.vimplus
cd ~/.vimplus
./install.sh
ArchLinux
安装vimplus

git clone https://github.com/chxuan/vimplus.git ~/.vimplus
cd ~/.vimplus
./install.sh
个性化
修改 ~/.vimrc.local 文件内容，以启用个性化定制，可覆盖 ~/.vimrc 中的设置。

插件列表
插说明
cpp-mode提供生成函数实现、函数声明/实现跳转、.h .cpp切换等功能(I'm authorsmile)
vim-edit方便的文本编辑插件(I'm authorsmile)
change-colorscheme随心所欲切换主题(I'm authorsmile)
prepare-code新建文件时，生成预定义代码片段(I'm authorsmile)
vim-buffervim缓存操作(I'm authorsmile)
vimplus-startifyvimplus开始页面(修改自mhinz/vim-startify)
tagbar使用majutsushi/tagbar的v2.3版本，taglist的替代品，显示类/方法/变量
vim-plug比Vundle下载更快的插件管理软件
YouCompleteMe史上最强大的基于语义的自动补全插件，支持C/C++、C#、Python、PHP等语言
NerdTree代码资源管理器
vim-nerdtree-syntax-highlightNerdTree文件类型高亮
nerdtree-git-pluginNerdTree显示git状态
vim-devicons显示文件类型图标
Airline可以取代powerline的状态栏美化插件
auto-pairs自动补全引号、圆括号、花括号等
LeaderF比ctrlp更强大的文件的模糊搜索工具
ack强大的文本搜索工具
vim-surround自动增加、替换配对符的插件
vim-commentary快速注释代码插件
vim-repeat重复上一次操作
vim-endwiseif/end/endif/endfunction补全
tabular代码、注释、表格对齐
vim-easymotion强大的光标快速移动工具，强大到颠覆你的插件观
incsearch.vim模糊字符搜索插件
markdown-previewmarkdown实时预览
vim-fugitive集成Git
gv显示git提交记录
vim-slash优化搜索，移动光标后清除高亮
echodoc补全函数时在命令栏显示函数签名
vim-smooth-scroll让翻页更顺畅
clever-f.vim强化f和F键
github-complete.vimEmojidog补全
快捷键
以下是部分快捷键，更详细的快捷键请查阅vimplus帮助文档。

快捷说明
,Leader Key
<leader>n打开/关闭代码资源管理器
<leader>t打开/关闭函数列表
<leader>a.h .cpp 文件切换
<leader>u转到函数声明
<leader>U转到函数实现
<leader>o打开include文件
<leader>y拷贝函数声明
<leader>p生成函数实现
<leader>w单词跳转
<leader>f搜索~目录下的文件
<leader>F搜索当前目录下的文本
<leader>g显示git仓库提交记录
<leader>G显示当前文件提交记录
<leader>gg显示当前文件在某个commit下的完整内容
<leader>ff语法错误自动修复(FixIt)
<c-p>切换到上一个buffer
<c-n>切换到下一个buffer
<leader>d删除当前buffer
<leader>D删除当前buffer外的所有buffer
vim运行vim编辑器时,默认启动开始页面
<F5>显示语法错误提示窗口
<F7>启用markdown实时预览
<F8>关闭markdown实时预览
<F9>显示上一主题
<F10>显示下一主题
<leader>l按竖线对齐
<leader>=按等号对齐
Ya复制行文本到字母a
Da剪切行文本到字母a
Ca改写行文本到字母a
rr替换文本
<leader>r全局替换，目前只支持单个文件
gcc注释代码
gcap注释段落
vif选中函数内容
dif删除函数内容
cif改写函数内容
vaf选中函数内容（包括函数名 花括号）
daf删除函数内容（包括函数名 花括号）
caf改写函数内容（包括函数名 花括号）
fa查找字母a，然后再按f键查找下一个
<c-x><c-o>Emojidog补全
Q & A
安装vimplus后Airline等插件有乱码，怎么解决？

linux和mac系统需设置终端字体为Droid Sans Mono Nerdo Font。键件

xshell连接远程主机不能使用vim-devicons或乱码。

windows系统安装Nerd Font字体后并更改xshell字体即可。

安装vimplus会经常失败，安装了几次都不成功！！！

vimplus安装时需要访问外国网站，由于网络原因，可能会失败，安装成功也要1个多小时，ycm插件有200M左右，下载比较耗时，这里有下载好的YouCompleteMe.tar.gz文件，下载后解压到~/.vim/plugged/目录，并进入YouCompleteMe目录，linux用户执行./install.py --clang-completer，mac用户执行./install.py --clang-completer --system-libclang即可安装。

使用第三方库时怎么让ycm补全第三方库API？

vimplus安装完毕之后，~目录下将会生成两个隐藏文件分别是.vimrc和.ycm_extra_conf.py，其中.vimrc是vim的配置文件，.ycm_extra_conf.py是ycm插件的配置文件，当你需要创建一个project时，需要将.ycm_extra_conf.py拷贝到project的顶层目录，通过修改该配置文件里面的flags变量来添加你的第三方库路径。

安装vimplus完成后ycm不能够工作！！！

这里的原因可能就有很多了，可能每个人遇到的问题不一样，但vimplus尽最大努力不让用户操心，需要注意的是ycm插件只支持64位的系统，更多信息请访问ycm官网。

在aaa用户下安装了vimplus，在bbb用户下不能使用？

目前vimplus是基于用户的，如果你想在其他用户下也能使用vimplus，也需要单独安装。

在Archlinux环境下不能使用ycm怎么办？(缺少libtinfo.so.5)

在Archlinux下可以试着使用pkgfile命令搜索依赖的文件具体在什么包内，目前找到的包含libtinfo.so.5的包是ncurses5-compat-libs(AUR)或者32位的lib32-ncurses5-compat-libs(AUR)，安装后即可正常使用。

以上没有我遇到的问题怎么办？

您可以通过上网找解决方法，或提Issues，也可以通过发邮件方式787280310@qq.com一起讨论解决方法。

vimplus用起来真的太棒了，怎么办？

那就麻烦您打赏一颗starstar吧，给予我继续维护的动力。



