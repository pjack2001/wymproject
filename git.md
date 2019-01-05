# wymproject

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
