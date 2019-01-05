# wymproject

## 常用命令


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
