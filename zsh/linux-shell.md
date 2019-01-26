# linux-shell 


## 搜集的shell命令

马哥2019-王晓春

$ df
$ df | tr -s " "|cut -d " " -f5|tr -d "%"
$ df -h | tr -s " "|cut -d " " -f4|tr -d "%"
$ df|tr -s " " % |cut -d % -f5


$ ifconfig wlp2s0 |grep -o "[0-9.]\{7,\}" |head -n1
192.168.31.116

$ nmap -v -sP 192.168.31.0/24 |grep -B1 "up"
$ nmap -v -sP 192.168.31.0/24 |grep -B1 "up" |grep scan |cut -d" " -f5


