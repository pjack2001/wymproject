https://github.com/kubernetes-sigs/kubespray

https://www.kubernetes.org.cn/5012.html



## Ansible实际安装
```

zsh不支持，切换到 #bash

# git clone https://github.com/kubernetes-sigs/kubespray
# pwd
/home/y/vagrant/

# cd kubespray
# sudo pip install -r requirements.txt
# cp -rfp inventory/sample inventory/mycluster

# cd inventory/mycluster
# pwd
/home/y/vagrant/kubespray/inventory/mycluster

# declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
# CONFIG_FILE=/home/y/vagrant/kubespray/inventory/mycluster/hosts.ini python /home/y/vagrant/kubespray/contrib/inventory_builder/inventory.py ${IPS[@]}

# cd /home/y/vagrant/kubespray/
# cat /home/y/vagrant/kubespray/inventory/mycluster/group_vars/all/all.yml
# cat /home/y/vagrant/kubespray/inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

# ansible-playbook -i /home/y/vagrant/kubespray/inventory/mycluster/hosts.ini --become --become-user=root cluster.yml



```


## Ansible官方

```
Ansible版本

由于ansible / ansible / issues / 46600， Ansible v2.7.0失败和/或产生意外结果

用法
# Install dependencies from ``requirements.txt``
sudo pip install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
CONFIG_FILE=inventory/mycluster/hosts.ini python3 contrib/inventory_builder/inventory.py ${IPS[@]}


# Review and change parameters under ``inventory/mycluster/group_vars``
cat inventory/mycluster/group_vars/all/all.yml
cat inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `-b` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without -b the playbook will fail to run!
ansible-playbook -i inventory/mycluster/hosts.ini --become --become-user=root cluster.yml
Note: When Ansible is already installed via system packages on the control machine, other python packages installed via sudo pip install -r requirements.txt will go to a different directory tree (e.g. /usr/local/lib/python2.7/dist-packages on Ubuntu) from Ansible's (e.g. /usr/lib/python2.7/dist-packages/ansible still on Ubuntu). As a consequence, ansible-playbook command will fail with:

ERROR! no action detected in task. This often indicates a misspelled module name, or incorrect module path.
probably pointing on a task depending on a module present in requirements.txt (i.e. "unseal vault").

One way of solving this would be to uninstall the Ansible package and then, to install it via pip but it is not always possible. A workaround consists of setting ANSIBLE_LIBRARY and ANSIBLE_MODULE_UTILS environment variables respectively to the ansible/modules and ansible/module_utils subdirectories of pip packages installation location, which can be found in the Location field of the output of pip show [package] before executing ansible-playbook.







```






## vagrant官方

```
对于Vagrant，我们需要为配置任务安装python依赖项。检查是否安装了Python和pip：

python -V && pip -V
如果这返回了软件的版本，那么你很高兴。如果没有，请从此处下载并安装Python https://www.python.org/downloads/source/ 安装必要的要求

sudo pip install -r requirements.txt
vagrant up

```