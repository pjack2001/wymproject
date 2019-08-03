# wymproject

## 常用命令

```yml
查看远程仓库地址命令：
# git remote -v

查看提交历史
在提交了若干更新，又或者克隆了某个项目之后，你也许想回顾下提交历史。完成这个任务最简单而又有效的工具是
# git log
# git log --stat

已经push的回滚方法，执行一次，回滚一个版本
# git reset --hard HEAD^


Git 远程推送被拒绝的一种解决方案
今天在推送的时候发生了如下错误信息：


error: 无法推送一些引用到 'https://gitee.com/von_w/demo_app.git'
提示：更新被拒绝，因为您当前分支的最新提交落后于其对应的远程分支。
提示：再次推送前，先与远程变更合并（如 'git pull ...'）。详见
提示：'git push --help' 中的 'Note about fast-forwards' 小节。

解决方案：git push -u origin +master​


```


```
Git中撤销提交
Git的几种状态
未修改
       原始内容
已修改    ↓   
       工 作 区
已暂存    ↓    git add
       暂 存 区
已提交    ↓    git commit
       本地仓库
已推送    ↓    git push
       远程仓库
注意：下面所有命令每一个代码段是相互独立的，为了解决一个问题，请不要使用多个代码段。所有命令均经过本人测试，由于测试环境是简单的Git仓库没有过多的数据，可能在复杂环境回出现错误。如发现问题请直接评论区指出。请仔细分析使用情况，丢失数据与本人无关。

已修改 未暂存
已经修改了文件，还未进行git add。
即工作区的内容不想要了。

恢复方法
使用以下任意命令

git checkout .
git checkout -- <FILENAME>
git reset --hard
已暂存 未提交
已经进行了git add，还未进行git commit
即暂存区的内容不想要了

恢复方法
使用以下任意命令

git reset
git checkout .
git reset --hard
git reset HEAD
git reset HEAD -- <FILENAME>
已提交 未推送
已经进行了git commit，还未进行git push

恢复方法
使用远程仓库覆盖本地仓库

git reset --hard origin/master
已推送
已经进行了git push

恢复方法
回滚本地仓库，强制推送覆盖远程仓库

git reset --hard HEAD^
git push -f
其他情况
丢弃某个节点后的全部提交
即HEAD指针指向该节点

git reset --hard <COMMITID>

```






### ssh方式
git@github.com:pjack2001/wymproject.git

git clone git@github.com:pjack2001/wymproject.git

### https方式
git clone https://github.com/pjack2001/wymproject.git

### other
git config --list

git config --global push.default simple


## 【转】git 免输用户名和密码上传代码到GitHub

```
https://blog.csdn.net/inthuixiang/article/details/79734245
首先要知道，为什么会出现每次上传代码都要输入用户名和密码呢？

原因在于：在clone 项目的时候，使用了 HTTPS方式，而不是ssh方式。 
因为默认clone 方式就是HTTPS方式，所以你点击“Clone or download”时首先出现的会是HTTPS方式， 

在git上输入 git remote -v 查看clone的地址 
可以看出，目前使用的是HTTPS方式

原因知道了，下面是解决方法 
（1） 使用 git remote rm origin 命令移除HTTPS的方式，
（2） 使用命令 git remote add origin git地址 （git地址是上面复制的内容），新添加上SSH方式
（3） 还是使用 git remote -v 命令，再次查看clone的地址，会发现git使用的方式变成了SSH方式，如图4 
（4） 还没完，如果现在就去push的话，它会出现如图5所示警告 
（5） 先使用 ssh -T git@github.com 测试一下，会有图6所示结果 
可以明显地看出，是因为还没有设置公钥
（6） 使用 ssh-keygen -t rsa -C "kivet-h" 命令生成公钥，“kivet-h”是我的GitHub用户名，每个人的都不一样，如图7 
（7） 使用 cat /c/Users/kivet/.ssh/id_rsa.pub 命令查看key，如图8，并复制下来， 
注意：cat后面的文件路径是（6）步骤生成的保存公钥的路径，每个人的保存路径不一样 
（8） 进入GitHub，直接按照下面图片步骤做， 
（9） 
（10） 
（11） 
（12）点击“Add SSH key”后，会提示输入自己的密码，输入点确定后就行了 
（13） 现在去使用git想GitHub上传代码，就不会再提示你输入用户名和密码了， 

```

## 菜鸟教程
```
配置Git
首先在本地创建ssh key；

$ ssh-keygen -t rsa -C "your_email@youremail.com"
后面的your_email@youremail.com改为你在github上注册的邮箱，之后会要求确认路径和输入密码，我们这使用默认的一路回车就行。成功的话会在~/下生成.ssh文件夹，进去，打开id_rsa.pub，复制里面的key。

回到github上，进入 Account Settings（账户配置），左边选择SSH Keys，Add SSH Key,title随便填，粘贴在你电脑上生成的key。

github-account
为了验证是否成功，在git bash下输入：

$ ssh -T git@github.com
如果是第一次的会提示是否continue，输入yes就会看到：You've successfully authenticated, but GitHub does not provide shell access 。这就表示已成功连上github。

接下来我们要做的就是把本地仓库传到github上去，在此之前还需要设置username和email，因为github每次commit都会记录他们。

$ git config --global user.name "your name"
$ git config --global user.email "your_email@youremail.com"
进入要上传的仓库，右键git bash，添加远程地址：

$ git remote add origin git@github.com:yourName/yourRepo.git



```
## 在github建立仓库
git clone https://github.com/pjack2001/wymproject.git


https://github.com/pjack2001/wymproject.git
Get started by creating a new file or uploading an existing file. We recommend every repository include a README, LICENSE, and .gitignore.

## 命令行操作
…or create a new repository on the command line
echo "# wymproject" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/pjack2001/wymproject.git
git push -u origin master

## 命令行
…or push an existing repository from the command line
git remote add origin https://github.com/pjack2001/wymproject.git
git push -u origin master




```yml
$ history | cut -c 8-|grep clone
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/powerline/fonts
git clone git://github.com/joelthelion/autojump.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-syntax-highl
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone git://github.com/iptux-src/iptux.git
git clone git://github.com/rafi/vim-config.git ~/.config/nvim
git clone --recursive git://github.com/kevinw/pyflakes-vim.git
git clone git@gitlab.newcapec.net:wangyuming/wymproject.git
git clone git@gitlab.newcapec.net:wangyuming/wymproject01.git
git clone https://github.com/TeamStuQ/skill-map.git
git clone git@github.com:pjack2001/wymproject.git
git clone https://github.com/kubernetes-sigs/kubespray
git clone https://github.com/gjmzj/kubeasz.git
git clone https://github.com/ansiblebook/ansiblebook.git
git clone https://github.com/oneinstack/oneinstack.git
git clone https://github.com/Liuhaiyuan/tests_sh.git
git clone https://github.com/Liuhaiyuan/os_windows_health_check.git
git clone https://github.com/Liuhaiyuan/OS-Linux-health-check.git
git clone https://github.com/Liuhaiyuan/os_windows_health_check.git
git clone https://github.com/Liuhaiyuan/haproxy_sh.git
git clone https://github.com/Liuhaiyuan/Linux_LVS_Ipvsadm.git
git clone https://github.com/bluekk935/ToyoDAdoubi.git
git clone https://github.com/nginxinc/docker-nginx.git
git clone https://github.com/osixia/docker-keepalived.git
git clone https://github.com/clangcn/onekey-install-shell.git
git clone https://github.com/DingGuodong/LinuxBashShellScriptForOps.git
git clone https://github.com/teddysun/across.git
git clone https://github.com/licess/lnmp.git
git clone https://github.com/MeowLove/Linux-Remote-Desktop-Environment.git
git clone https://github.com/MeowLove/Network-Reinstall-System-Modify.git
git clone https://github.com/0oVicero0/zhao.git
git clone https://github.com/MoeClub/MoeClub.github.io.git
git clone git@gitlab.newcapec.net:wangyuming/wymgit.git
git clone https://github.com/PacktPublishing/Linux-Shell-Scripting-Cookbook-Third-Edition.git
git clone git@gitee.com:pjack2001/wokishell.git
git clone git@gitee.com:aqztcom/kjyw.git
git clone https://github.com/MeowLove/Network-Reinstall-System-Modify
git clone https://github.com/MeowLove/Network-Reinstall-System-Modify
git clone https://github.com/rancher/rancher.git
git clone https://github.com/dbafree/dstat.git
git clone https://github.com/opsnull/follow-me-install-kubernetes-cluster.git
git clone https://github.com/PacktPublishing/Linux-Shell-Scripting-Cookbook-Third-Edition.git
git clone https://github.com/rancher/k3os.git
git clone https://github.com/jlevy/the-art-of-command-line.git
git clone https://github.com/MeowLove/Network-Reinstall-System-Modify.git
git clone https://github.com/cheat/cheat.git
git clone https://github.com/LeCoupa/awesome-cheatsheets.git
git clone https://github.com/openthings/kubernetes-tools.git
git clone https://github.com/koalaman/shellcheck.git
git clone https://github.com/oneinstack/oneinstack.git
git clone https://github.com/Liuhaiyuan/tests_sh.git
git clone https://github.com/idcos/Cloudboot.git
git clone https://github.com/bluekk935/ToyoDAdoubi.git
git clone https://github.com/clangcn/onekey-install-shell.git
git clone https://github.com/DingGuodong/LinuxBashShellScriptForOps.git
git clone https://github.com/baskerville/bin.git
git clone https://github.com/openthings/kubernetes-tools.git
git clone https://github.com/MeowLove/Linux-Remote-Desktop-Environment.git
git clone https://github.com/zerotier/ZeroTierOne.git
git clone https://github.com/sayem314/serverreview-benchmark.git
git clone https://github.com/MeowLove/Linux-Remote-Desktop-Environment.git
git clone https://github.com/zerotier/ZeroTierOne.git
git clone https://github.com/openthings/kubernetes-tools.git
git clone https://github.com/sayem314/serverreview-benchmark.git
git clone https://github.com/teddysun/across.git
git clone https://github.com/afaqurk/linux-dash.git
git clone https://github.com/ilmarkerm/ansible-oracle-home-mgmt.git
git clone https://github.com/sysco-middleware/oracle-docker-images.git
git clone https://github.com/sysco-middleware/ansible-role-oracle-database.git
git clone https://github.com/sysco-middleware/ansible-role-oracle-database-instance.git
git clone https://github.com/sysco-middleware/ansible-role-oracle-database-instant-client.git
git clone https://github.com/robertdebock/ansible-tester.git
git clone https://github.com/viasite-ansible/ansible-role-zsh.git
git clone https://github.com/lorin/ansible-quickref.git
git clone https://github.com/lean-delivery/ansible-role-oracle-db.git
git clone https://github.com/klewan/ansible-role-oracle-manage-patches.git
git clone https://github.com/klewan/ansible-role-oracle.git
git clone https://github.com/KeKe-Li/kubernetes-tutorial.git
git clone https://github.com/KeKe-Li/book.git
git clone https://github.com/rootsongjc/cloud-native-sandbox.git
git clone https://github.com/sysco-middleware/oracle-docker-images.git
git clone https://github.com/rootsongjc/kubernetes-vagrant-centos-cluster.git
git clone https://github.com/rootsongjc/kubernetes-handbook.git
git clone https://github.com/feiskyer/kubernetes-handbook.git
git clone https://github.com/xiaotian45123/ansible-k8s10x_and_k8s11x.git
git clone https://github.com/ContainerSolutions/k8s-deployment-strategies.git
git clone https://github.com/cnych/kubernetes-learning.git
git clone https://github.com/cnych/qikqiak.com.git
git clone https://github.com/grycap/ansible-role-kubernetes.git
git clone https://github.com/liumiaocn/easypack.git
git clone https://github.com/juju/juju.git
git clone https://github.com/thoughtbot/dotfiles.git
git clone https://github.com/gpakosz/.tmux.git
git clone https://github.com/opsnull/follow-me-install-kubernetes-cluster.git
git clone https://github.com/SpaceVim/SpaceVim.git
git clone https://github.com/shadowsocksrr/shadowsocksr-android.git
git clone https://github.com/teddysun/shadowsocks_install.git
git clone https://github.com/shadowsocks/shadowsocks-android.git
git clone https://github.com/shadowsocks/go-shadowsocks2.git
git clone https://github.com/ToyoDAdoubi/doubi.git
git clone https://github.com/ansistrano/deploy.git
git clone https://github.com/shadowsocks/shadowsocks-manager.git
git clone https://github.com/FelisCatus/SwitchyOmega.git
git clone https://github.com/trimstray/the-book-of-secret-knowledge.git
git clone https://github.com/Abelief/kubeasz.git
git clone https://github.com/yunabe/lgo.git
git clone https://github.com/chusiang/automate-with-ansible.git
git clone https://github.com/William-Yeh/docker-ansible.git
git clone https://github.com/dev-sec/ansible-os-hardening.git
git clone https://github.com/scottslowe/learning-tools.git
git clone https://github.com/ansible/molecule.git
git clone https://github.com/easzlab/kubeasz.git
git clone https://github.com/rundeck/rundeck.git
git clone https://github.com/anmoel/ansible-role-kubernetes.git
git clone https://github.com/wsdjeg/vim-galore-zh_cn.git
git clone https://github.com/PegasusWang/python-web-guide.git
git clone https://github.com/PegasusWang/vim-config.git
git clone https://github.com/freeCodeCamp/devdocs.git
git clone https://github.com/skywind3000/awesome-cheatsheets.git
git clone https://github.com/robbyrussell/oh-my-zsh.git
git clone https://github.com/shadowsocks/shadowsocks-qt5.git
git clone https://github.com/PegasusWang/vim-config.git
git clone https://github.com/robbyrussell/oh-my-zsh.git
git clone https://github.com/kubernetes/minikube.git
git clone https://github.com/jobbole/awesome-python-cn.git
git clone https://github.com/hengyunabc/jenkins-ansible-supervisor-deploy.git
git clone https://github.com/kubernetes-sigs/kubespray.git
git clone https://github.com/leucos/ansible-tuto.git
git clone https://github.com/geerlingguy/ansible-role-jenkins.git
git clone https://github.com/ansible/ansible-examples.git
git clone https://github.com/turkenh/ansible-interactive-tutorial.git
git clone https://github.com/geerlingguy/ansible-for-devops.git
git clone https://github.com/geerlingguy/ansible-vagrant-examples.git
git clone https://github.com/dennyzhang/devops_public.git
git clone https://github.com/freeCodeCamp/devdocs.git
git clone https://github.com/fagiani/shellstack.git
git clone https://github.com/chenzhiwei/linux.git
git clone https://github.com/dennyzhang/devops_public.git
git clone https://github.com/freeCodeCamp/devdocs.git
git clone https://github.com/licess/lnmp.git
git clone https://github.com/ansible/ansible-examples.git
git clone https://github.com/drone/drone.git
git clone https://github.com/yeasy/docker_practice.git
git clone https://github.com/chenzhiwei/linux.git
git clone https://github.com/licess/lnmp.git
git clone https://github.com/chenzhiwei/linux.git
git clone https://github.com/ansible/ansible-examples.git
git clone https://github.com/jessfraz/dockerfiles.git
git clone https://github.com/licess/lnmp.git
git clone https://github.com/wsargent/docker-cheat-sheet.git
git clone https://github.com/chenzhiwei/linux.git
git clone https://github.com/geekcomputers/Python.git
git clone https://github.com/ansible/ansible-examples.git
git clone https://github.com/openshift/openshift-ansible.git
git clone https://github.com/StreisandEffect/streisand.git
git clone https://github.com/wsargent/docker-cheat-sheet.git
git clone https://github.com/openshift/openshift-ansible.git
git clone https://github.com/ansible/ansible-examples.git
git clone https://github.com/jessfraz/dockerfiles.git
git clone https://github.com/StreisandEffect/streisand.git
git clone https://github.com/ansible/ansible-examples.git
git clone https://github.com/slimm609/checksec.sh.git
git clone git@gitee.com:aqztcom/kjyw.git
git clone git@gitee.com:licess/lnmp.git
git clone git@gitee.com:kennylee/install-docker.git
git clone git@gitee.com:xiaocheng2014/simple_shell.git
git clone git@gitee.com:khs1994-docker/ci.git
git clone git@gitee.com:khs1994-docker/docker_practice.git
git clone git@gitee.com:henson01/SuperShell.git
git clone git@gitee.com:wbqss/doubi.git
git clone git@gitee.com:zhangtianjie/ShellManageSoftware.git
git clone git@gitee.com:xbug_xyz/dockercomposes.git
git clone git@gitee.com:rancococ-code/docker-oracle11g.git
git clone git@gitee.com:ruzuojun/Lepus.git
git clone git@gitee.com:acidrain/sshnopasswd.git
git clone git@gitee.com:ppabc/system_status.git
git clone https://github.com/aqzt/kjyw.git
git clone https://github.com/aqzt/boyurl.git
git clone git@gitee.com:pjack2001/wymgitee.git
git clone https://github.com/kubernetes/website.git
git clone https://github.com/kubernetes/website.git
git clone https://github.com/kubernetes/examples.git
git clone https://github.com/kubernetes/website
git clone https://github.com/kubernetes/website.git
git clone https://github.com/zhangguanzhang/Kubernetes-ansible.git
git clone https://github.com/easzlab/kubeasz.git
git clone https://github.com/c-bata/kube-prompt.git
git clone https://github.com/derailed/k9s.git
git clone https://github.com/derailed/k9s.git
git clone https://github.com/c-bata/kube-prompt/releases/download/v1.0.6/kube-prompt_v1.0.6_linux_amd64.zip
git clone git@gitee.com:mirrors/lazydocker.git
git clone https://github.com/easzlab/kubeasz.git
history|grep clone


```