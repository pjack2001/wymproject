# kubernetes



## 收集

```
https://blog.csdn.net/villare/article/details/79332549

kubernetes环境搭建（Rancher篇）
2018年02月17日 17:38:20 villare 阅读数：5413
 版权声明：本文为博主原创文章，未经博主允许不得转载。	https://blog.csdn.net/villare/article/details/79332549
主要内容
1.Rancher介绍
2.通过Rancher部署kubernetes环境（国内加速）
3.问题分析
4.总结
1.Rancher介绍
中文官网：https://www.cnrancher.com/ 
官方简介：http://rancher.com/docs/rancher/v1.6/zh/ 
- 容器管理平台 
- 一套解决容器平台网络、存储、负载均衡等的基础设施服务 
- 集成主流的容器编排工具Docker Swarm， Kubernetes， 和Mesos，基本实现一键部署 
- 应用商城，方便添加常用第三方开源工具 
- 企业级权限管理 
- 部署便捷，提供官方开源容器镜像和RancherOS

2.通过Rancher部署kubernetes环境（国内加速）
准备工作： 
1.关闭防火墙，启动iptables，清空iptables规则 
2.修改host配置主机名（放在hosts文件开始，首先被匹配），/etc/rc.d/init.d/network restart 
3.删除可能相关的容器，镜像可以保留 
4.删除相关文件 
5.启用ipv4转发

2和4可参考https://www.cnrancher.com/optimizing-rancher-k8s-use-experience-in-china/，慎用！！！

2.1.安装Rancher
Rancher2.0 release 将在近期发布(目前alpha)，提供大量新的特性并且对于kubernetes将会提供更友好的支持，本文使用上一个稳定版1.6.12

sudo docker run -d --restart=unless-stopped -p 28080:8080 rancher/server:1.6.12
2.2.配置管理员登录密码
通过用户名密码的方式

等待server容器启动完成，进入UI，启用local权限控制，配置管理员登录名/密码；

2.3.设置国内加速kubernetes环境模板
应为Rancher默认从gcr.io下载kubernetes环境所需要的镜像，然而由于墙的原因并不能； 
这里提供Rancher官方群里一位大神（anjia0532）同步在dockerhub上的镜像（https://hub.docker.com/u/anjia0532/）

进入 环境–》环境管理，点击添加环境模板

这里写图片描述

配置环境模板基本信息，选择“Kubernetes”作为编排工具，点击“编辑设置”，修改环境默认镜像地址；

这里写图片描述

仅修改如下几个选项的配置：

Private Registry for Add-Ons and Pod Infra Container Image：docker.io
Image namespace for Add-Ons and Pod Infra Container Image：anjia0532
Image namespace for kubernetes-helm Image：anjia0532
Pod Infra Container Image：anjia0532/pause-amd64:3.0

```
