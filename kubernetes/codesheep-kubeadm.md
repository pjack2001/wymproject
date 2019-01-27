# 利用Kubeadm部署 Kubernetes 1.13.1集群实践录

https://www.codesheep.cn/2018/12/27/kubeadm-k8s1-13-1/

## 节点规划
本文准备部署一个 一主两从 的 三节点 Kubernetes集群，整体节点规划如下表所示：

主机名	IP	角色
k8s-master	192.168.102.20	k8s主节点	
k8s-node-1	192.168.102.4	k8s从节点	
k8s-node-2	192.168.102.14	k8s从节点

下面介绍一下各个节点的软件版本：

操作系统：CentOS-7.4-64Bit
Docker版本：1.13.1
Kubernetes版本：1.13.1
所有节点都需要安装以下组件：

Docker：不用多说了吧
kubelet：运行于所有 Node上，负责启动容器和 Pod
kubeadm：负责初始化集群
kubectl： k8s命令行工具，通过其可以部署/管理应用 以及CRUD各种资源
准备工作
所有节点关闭防火墙
1
2
systemctl disable firewalld.service 
systemctl stop firewalld.service
禁用SELINUX
1
2
3
4
setenforce 0

vi /etc/selinux/config
SELINUX=disabled
所有节点关闭 swap
1
swapoff -a
设置所有节点主机名
1
2
3
hostnamectl --static set-hostname  k8s-master
hostnamectl --static set-hostname  k8s-node-1
hostnamectl --static set-hostname  k8s-node-2
所有节点 主机名/IP加入 hosts解析
编辑 /etc/hosts文件，加入以下内容：

1
2
3
192.168.39.79 k8s-master
192.168.39.77 k8s-node-1
192.168.39.78 k8s-node-2

echo "192.168.102.20 k8s-master" >> /etc/hosts
echo "192.168.102.4 k8s-node1" >> /etc/hosts
echo "192.168.102.14 k8s-node2" >> /etc/hosts


```

```

## 

```

```


## 

```

```


## 

```

```



## 

```

```


## 

```

```




