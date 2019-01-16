# SpaceVIM

https://spacevim.org/cn/quick-start-guide/
https://spacevim.org/cn/documentation/

## 常用快捷键

SPC 空格
Leader \
    




s g 左右分屏
s v 上下分屏
Tab 切换

<Leader> 1  跳至标签栏序号 1
<Leader> 2  跳至标签栏序号 2



SPC t n  显示/隐藏行号



SPC l r 快速运行

SPC t u 行尾空格检查











## 安装
安装
在安装 SpaceVim 之前，你需要确保电脑上已经安装了 git 和 curl。这两个工具用来 下载插件以及字体。

如果在终端中使用 vim 或者 neovim，还需要设置终端的字体。

Linux 或 macOS
curl -sLf https://spacevim.org/cn/install.sh | bash

安装结束后，初次打开 vim 或者 gvim 时， SpaceVim 会自动下载并安装插件。

如果需要获取安装脚本的帮助信息，可以执行如下命令，包括定制安装、更新和卸载等。

curl -sLf https://spacevim.org/cn/install.sh | bash -s -- -h


## 配置python环境
https://spacevim.org/cn/use-vim-as-a-python-ide/

Blogs » 使用 Vim 搭建 Python 开发环境
SpaceVim 是一个模块化的 Vim IDE，针对 python 这一语言的支持主要依靠 lang#python 模块以及与之相关的其他模块。的这篇文章主要介绍如何使用 SpaceVim 搭建 Python 的开发环境，侧重介绍跟 python 开发相关使用技巧。在阅读这篇文章之前，可以先阅读《使用 Vim 搭建基础的开发环境》，对语言相关以外的功能有一个大致的了解。

安装模块
代码自动补全
语法检查
导入模块
工程文件跳转
快速运行
代码格式化
交互式编程
断点调试

安装模块
SpaceVim 初次安装时默认并未启用相关语言模块。首先需要启用 lang#python 模块, 通过快捷键 SPC f v d 打开配置文件，添加：

[[layers]]
  name = "lang#python"
  启用 lang#python 模块后，在打开 python 文件是，就可以使用语言专属快捷键，这些快捷键都是以 SPC l 为前缀的。

代码自动补全
  autocomplete 模块为 SpaceVim 提供了自动补全功能，该模块会根据当前环境自动在多种补全引擎之间选择合适的，默认的补全引擎有：deoplete、neocomplete、ycm、asyncomplete 以及 neocomplcache。几种自动补全引擎当中，要数 deoplete 的体验效果最好。

语法检查
  checkers 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 neomake 这一异步语法检查工具。对于 python 的支持，是通过异步调用 flake8 命令，因此需安装，可通过 pip 命令来完成：

  pip install --user flake8

导入模块
  在编辑 python 文件时，可以自动导入包、自动删除无用的包、排序格式化导包；需要安装 isort，可通过以下命令安装：

  pip install --user isort

工程文件跳转
  SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转alternate文件。

快速运行
  在编辑 python 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 SPC l r。按下后， 会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下， 这一功能是根据当前文件的路径调用相对应的 python 命令。因此，在执行这个快捷键之前，应当先保存一下该文件。

  code runner

代码格式化
  Python 代码格式化，主要依赖 format 模块，同时需要安装相关的后台命令 yapf：

[[layers]]
 name = "format"
  
安装 yapf：

  pip install --user yapf

交互式编程
 在编辑 python 代码时，经常需要执行代码中的某一行，或者某一段代码。这时候，就可以使用 SpaceVim 的交互式编程框架。首先需要启用一个后台进程， 可以是 python 命令，也可以是 ipython 命令，快捷键为 SPC l s i。 启动后效果图如下：

  之后，可以通过 SPC l s l 进行逐行发送，也可以选中区域后按 SPC l s s 发送选中的区域：

  断点调试
  首先，需要载入 debug 模块：
  
[[layers]]
  name = "debug"
  该模块提供了一套基本的调试快捷键，比如添加断点、单步执行等，更多的快捷键，可以参考 debug 模块文档。



## 
通过插件管理器更新

使用 :SPUpdate SpaceVim 这一命令，将会打开 SpaceVim 的插件管理器，更新 SpaceVim，具体进度会在插件管理器 buffer 中展示。

通过 git 进行更新

可通过在 SpaceVim 目录中手动执行 git pull，SpaceVim 在 Windows 下默认目录为 ~/vimfilers, 但在 Linux 下则可使用如下命令： git -C ~/.SpaceVim pull

更新插件
使用 :SPUpdate 这一命令将会更新所有插件，包括 SpaceVim 自身。当然这一命令也支持参数，参数为插件名称，可同时添加多个插件名称作为参数，同时可以使用 Tab 键来补全插件名称。

获取日志
使用 :SPDebugInfo! 这一命令可以获取 SpaceVim 运行时日志，同时，可以使用 SPC h I 使用打开问题模板。 可在这个模板中编辑问题，并提交。




