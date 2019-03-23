# tmux命令

## 快捷键


tmux常用命令
 

Ctrl+b  激活控制台；此时以下按键生效

系统操作  

? 列出所有快捷键；按q返回
d 脱离当前会话；这样可以暂时返回Shell界面，输入tmux attach能够重新进入之前的会话
D 选择要脱离的会话；在同时开启了多个会话时使用
Ctrl+z  挂起当前会话
r 强制重绘未脱离的会话
s 选择并切换会话；在同时开启了多个会话时使用
: 进入命令行模式；此时可以输入支持的命令，例如kill-server可以关闭服务器
[进¥复制模式；此时的操作与vi/emacs相同，按q/Esc退出
~列出提示信息缓存；其中包含了之前tmux返回的各种提示信息

窗口操作

c  创建新窗口
& 关闭当前窗口
数字键  切换至指定窗口
p 切换至上一窗口
n 切换至下一窗口
l 在前后两个窗口间互相切换
w 通过窗口列表切换窗口
, 重命名当前窗口；这样便于识别
. 修改当前窗口编号；相当于窗口重新排序
f 在所有窗口中查找指定文本

面板操作  
” 将当前面板平分为上下两块
% 将当前面板平分为左右两块
x 关闭当前面板
! 将当前面板置于新窗口；即新建一个窗口，其中仅包含当前面板
Ctrl+方向键 以1个单元格为单位移动边缘以调整当前面板大小
Alt+方向键  以5个单元格为单位移动边缘以调整当前面板大小
Space 在预置的面板布局中循环切换；依次包括even-horizontal、even-vertical、main-horizontal、main-vertical、tiled
q 显示面板编号
o 在当前窗口中选择下一面板
方向键  移动光标以选择面板
{ 向前置换当前面板
} 向后置换当前面板
Alt+o 逆时针旋转当前窗口的面板
Ctrl+o  顺时针旋转当前窗口的面板]


同步窗格
这么做可以切换到想要的窗口，输入 Tmux 前缀和一个冒号呼出命令提示行，然后输入：
:setw synchronize-panes
你可以指定开或关，否则重复执行命令会在两者间切换。 这个选项值针对某个窗口有效，不会影响别的会话和窗口。 完事儿之后再次执行命令来关闭。帮助


调整窗格尺寸
如果你不喜欢默认布局，可以重调窗格的尺寸。虽然这很容易实现，但一般不需要这么干。这几个命令用来调整窗格：

PREFIX : resize-pane -D          当前窗格向下扩大 1 格
PREFIX : resize-pane -U          当前窗格向上扩大 1 格
PREFIX : resize-pane -L          当前窗格向左扩大 1 格
PREFIX : resize-pane -R          当前窗格向右扩大 1 格
PREFIX : resize-pane -D 20       当前窗格向下扩大 20 格
PREFIX : resize-pane -t 2 -L 20  编号为 2 的窗格向左扩大 20 格