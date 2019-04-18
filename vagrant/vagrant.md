# vagrant

##

```yml

centos7.4.1708.box
https://vagrantcloud.com/centos/boxes/7/versions/1708.01/providers/virtualbox.box

centos7.6.1811.box
https://vagrantcloud.com/centos/boxes/7/versions/1901.01/providers/virtualbox.box

下载目录：
/media/xh/f/linux/iSO/vagrantbox



https://download.virtualbox.org/virtualbox/5.2.24/virtualbox-5.2_5.2.24-128163~Ubuntu~bionic_amd64.deb

vagrant_2.2.3_x86_64.deb
https://releases.hashicorp.com/vagrant/2.2.3/vagrant_2.2.3_x86_64.deb




```

## 

```yml
启动虚拟机时，提示如下，然后就开始升级内核，从7.4升级到了最新，而我想用7.4版本

==> centos7.41: Machine booted and ready!
[centos7.41] No Virtualbox Guest Additions installation found.


安装插件，还是提示并升级
vagrant plugin install vagrant-vbguest

最后在Vagrantfile里加上如下参数，不再升级内核了
  config.vbguest.auto_update = false

```

## 

```yml


```

## 

```yml


```

## 

```yml


```

## 

```yml


```

## 

```yml


```




