#!/bin/bash
########################################################
# File Name: SystemToolScript
# Author: Henson
# Created Time: 2016-06-19
# Email:605998410@qq.com
########################################################

clear
. /etc/init.d/functions

#设置颜色
green="\033[32;1m"
green_back="\033[42;1m"
red="\033[31;1m"
red_back="\033[41;1m"
blue="\033[34;1m"
blue_back="\033[44;1m"
yellow="\033[33;1m"
yellow_back="\033[43;1m"
purple="\033[35;1m"
end="\033[0m"

tags="${purple}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${end}"

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export LANG=en_US.UTF-8


#traps(){
#trap 'echo -e "
#${green}
#######################################################################
##                        ${end} ${red} Author: Henson${end}${green}                            #
##               Welcome to use the script ,thanks,Bye!               #
#######################################################################
#${end}"
#' EXIT;
#}

#echo

#if [ $(id -u) -ne 0 ]
#then
#    echo
#    echo -e "${red}Error: You must use [ROOT] to run this script!${red}"
#    exit 255
#    echo
#fi

####################################################
#显示系统开机时间
Uptime() {
    echo -e $tags
    #系统开机时间
    echo -e "${green}System boot time online:${end} ${red}$(date -d "$(awk '{printf("%d\n",$1~/./?int($1)+1:$1)}' /proc/uptime) second ago" +"%F %T")${end}"
    #系统已经运行时间
    awk '{D=$1/86400;H=($1%86400)/3600;M=($1%3600)/60;S=$1%60;printf("\33[32;1mOnline system running time:\33[0m \33[31;1m%d Day %d:%d:%d\33[0m\n",D,H,M,S)}' /proc/uptime
    echo -e $tags
}

####################################################
#cpu型号
Cpuinfo() {
    #CPU型号
    awk -F':[ ]' '/model name/{printf ("CPU型号:%s\n",$2);exit}' /proc/cpuinfo|column -t
    #CPU详情
    awk -F':[ ]' '/physical id/{a[$2]++}END{for(i in a)printf ("%s号CPU\t线程数:%s\n",i+1,a[i]);printf("CPU总颗数:%s\n",i+1)}' /proc/cpuinfo|column -t
    #CPU频率
    awk '/model name/{print "CPU频率: "$NF;exit}' /proc/cpuinfo |column -t
}

#Meminfo() {
#    #内存大小
#    echo
#    free -h |ccze -A
#    echo
#}

free_info(){
    if [[ $(sudo cat /etc/redhat-release |grep -o 6.5) == "6.5" ]];then
        free -m
    else
        free -h
    fi
}

#######################################################
#硬盘信息
Diskinfo() {
    echo -e $tags
    echo -e "${red_back}Disk Info:${end}"
    sudo fdisk -l | awk '/(Disk )?\/dev\//'
    echo
    echo -e "${red_back}Disk file system Info:${end}"
    df -hTP
    #df -hTP|grep "^[/|F]"|awk '{print $1,$2,$3,$4,$5,$6,$7}'|column -t

    echo
    echo -e "${red_back}Disk Inodes Info:${end}"
    df -ihTP
    #df -ihTP |grep "^[/|F]"|awk '{print $1,$2,$3,$4,$5,$6,$7}'|column  -t

    echo
    echo -e "${red_back}Memory Info:${end}"
    free_info
#    if [ $(cat /etc/redhat-release |grep -o 6.5) == "6.5" ];then
#        free -m
#    else
#        free -h
#    fi

    echo
    echo -e "${red_back}crontab info: ${end}"
    $(which crontab) -l

    echo
    echo -e "${red_back}/etc/rc.local info: ${end}"
    grep -vE '^(#|$)' /etc/rc.local

    echo
    echo -e "${red_back}/etc/hosts info: ${end}"
    cat /etc/hosts

    echo
    echo -e "${red_back}/etc/yum.repos.d info: ${end}"
    ls /etc/yum.repos.d/

    echo
    echo -e "${red_back}"/etc/hosts.deny info: ${end}
    grep -vnE --color '^(#|$|;)' /etc/hosts.deny

    echo
    echo -e "${red_back}"/etc/hosts.allow info: ${end}
    grep -vnE --color '^(#|$|;)' /etc/hosts.allow

    echo
    echo -e $tags
}

#判断Selinux机制开启没有
Selinux_info(){
    if [ $(getenforce) == "Disabled" ]
    then
        echo "[ Off ]"
    else
        echo "[ On ]"
    fi
}

######################################################
#判断防火墙开启还是关闭
Iptables_info(){
    if [ $(sudo iptables -S |wc -l) -le 3 ]
    then
        echo "[ Off ]"
    else
        echo "[ On ]"
    fi
}



######################################################
#查看系统基本信息情况，对排错很有帮助
Systeminfo() {
    release=$(cat /etc/redhat-release)
    username=$(whoami)
    name=$(hostname)
    #addr1=$(ifconfig eth0 |grep "inet addr:" |awk -F "[ :]+"  '{print $4}')
    addr1=$(printenv |awk '/SSH_CONNECTION/{print $3}')
    ssh_port=$(printenv |awk '/SSH_CLIENT/{print $NF}')
    ssh_connection=$(printenv SSH_CONNECTION |awk '{print $1}')
    #addr2=$(curl -sSL ipinfo.io|awk '/ip/{print $2}'|xargs -d'"'|awk 'NR==1{print $1}')
    #addr2=$(curl -sSL ipinfo.io/ip)
    cpu=$(awk -F: '/model name/{print $2}' /proc/cpuinfo|awk 'NR==1'|sed 's/^ //')
    cores=$(cat /proc/cpuinfo |grep processor |wc -l)
    freq=$(awk -F: '/cpu MHz/{print $2}' /proc/cpuinfo |awk 'NR==1'| sed 's/^ //')
    mem_total=$(free_info | awk '/Mem/ {print $2}')
    mem_used=$(free_info | awk '/buffers\/cache/ {print $3}')
    mem_free=$(free_info | awk '/buffers\/cache/ {print $4}')
    swap_total=$(free_info | awk '/Swap/ {print $2}')
    swap_used=$(free_info | awk '/Swap/ {print $3}')
    swap_free=$(free_info | awk '/Swap/ {print $4}')
    start=$(echo -e "\e[31;1m$(date -d "$(awk '{printf("%d\n",$1~/./?int($1)+1:$1)}' /proc/uptime) second ago" +"%F %T")\e[0m")
    up=$(awk '{D=$1/86400;H=($1%86400)/3600;M=($1%3600)/60;S=$1%60;printf("%d day %d:%d:%d \33[0m\n",D,H,M,S)}' /proc/uptime)
    arch=$( uname -m )
    lbit=$( getconf LONG_BIT )
    kern=$( uname -r )
    load=$(uptime |awk '{print $(NF-2),$(NF-1),$NF}')
    #disk=$(df -hTP|grep "^[/|F]"|awk '{print $1,$2,$3,$4,$5,$6,$7}'|column  -t)

    #兼容centos7和6系统
    #linking=$(netstat -antp |grep -v "established"|awk '{print $6}'|sort |uniq -c|sort -rn|xargs)
    #linking=$(ss -anp|awk '{print $1}'|sort|uniq -c|sort -rn|xargs)
    if [[ $(cat /etc/redhat-release |awk '{print $4}'|cut -d. -f1) == '7' ]]
    then
        linking=$(ss -ant|awk '{print $2}'|sort|uniq -c|sort -rn|xargs)
        #Cpu_Utilization=$(top -n 1|awk -F '[, %]+' 'NR==3 {print 100-$12}')
    else
        linking=$(ss -ant|awk '{print $1}'|sort|uniq -c|sort -rn|xargs)
        #Cpu_Utilization=$(top -n 1|awk -F '[, %]+' 'NR==3 {print 100-$11}')
    fi

    logon_count=$(w |grep pts|wc -l)
    network_card=$(ifconfig |awk -F"[ ]" '{print $1}'|xargs |column -t)
    Limit_prot=$(ulimit -n)

    #兼容centos7和6系统
    #Cpu_Utilization=$(top -n 1|awk -F '[, %]+' 'NR==3 {print 100-$11}')
    #if [[ $(cat /etc/redhat-release |awk '{print $4}'|grep -o 7) == '7' ]]
    #then
    #   Cpu_Utilization=$(top -n 1|awk -F '[, %]+' 'NR==3 {print 100-$12}')
    #else
    #   Cpu_Utilization=$(top -n 1|awk -F '[, %]+' 'NR==3 {print 100-$11}')
    #fi

    Disk_Utilization=$(df -h|awk -F '[ %]+'  '/\/$/{print $5}')

    echo -e "${purple}+++++++++++++++++++++++++${end}${green}Computer Info:${end}${purple}++++++++++++++++++++++++++${end}"
    #echo
    #echo -e "${green}Computer Info: ${end}"
    echo -e "Version              : ${red}$release ${end}"
    echo -e "Username             : ${red}$username ${end}"
    echo -e "Hostname             : ${red}$name ${end}"
    echo -e "Local IP             : ${red}$addr1 [ $ssh_port ] ${end}"
    echo -e "SSH Connection       : ${blue_back}$ssh_connection${end}"
    #echo -e "Internet IP          : ${red}$addr2 ${end}"
    echo -e "CPU model            : ${red}$cpu ${end}"
    echo -e "Arch                 : ${red}$arch ($lbit Bit) ${end}"
    echo -e "Kernel               : ${red}$kern ${end}"
    echo -e "Number of cores      : ${red}$cores ${end}"
    echo -e "CPU frequency        : ${red}$freq MHz ${end}"
    echo -e "Mem usage            : ${blue_back}Total=${mem_total}\tUsed=${mem_used}\tFree=${mem_free}${end}"
    echo -e "Swap usage           : ${red}Total=${swap_total}\tUsed=${swap_used}\tFree=${swap_free}${end}"
    echo -e "SystemStartingTime   : ${red}$start ${end}"
    echo -e "SystemRunningTime    : ${red}$up${end}"
    echo -e "Load average         : ${blue_back}$load${end}"
    echo -e "Linking count        : ${blue_back}$linking${end}"
    echo -e "SSH logon count      : ${red}[ $logon_count ] ${end}"
    echo -e "Network card         : ${red}[ $network_card ] ${end}"
    echo -e "Selinux              : ${red}$(Selinux_info)${end}"
    echo -e "Iptables             : ${red}$(Iptables_info)${end}"
    echo -e "Limit port           : ${red}[ $(ulimit -n) ] ${end}"
    #echo -e "Cpu usage            : ${red}[ ${Cpu_Utilization}% ] ${end}"
    echo -e "Disk / usage         : ${red}[ ${Disk_Utilization}% ] ${end}"
    echo -e $tags
}

##################################################
#跟ll命令一样查看信息
Show_ll(){
    #echo
    #echo -e "${purple}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${end}"
    #if [ -e /usr/bin/ccze ]
    #then
    #    stat -c "%a(%A) %U %G %s %n" *|column  -t |ccze -A
    #else
    #    stat -c "%a(%A) %U %G %s %n" *|column  -t
    #fi
    #echo -e "${purple}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${end}"

    echo
    echo -e "${purple}++++++++++++++++++++${end}${green}[ Super ll Command ]${end}${purple}+++++++++++++++++++++++++${end}"
    echo
    if [ -e /usr/bin/ccze ]
    then
        ls -alhF --time-style=long-iso --sort=size $2 | awk '{k=0;s=0;for(i=0;i<=8;i++ ){k+=((substr($1,i+2,1)~/[rwxst]/)*2^(8-i))}j=4;for(i=4;i<=10;i+=3){s+=((substr($1,i,1)~/[stST]/)*j);j/=2}if(k){printf("%0o%0o ",s,k)}print}' |sort|ccze -A
    else
        ls -alhF --time-style=long-iso --sort=size | awk '{k=0;s=0;for(i=0;i<=8;i++ ){k+=((substr($1,i+2,1)~/[rwxst]/)*2^(8-i))}j=4;for(i=4;i<=10;i+=3){s+=((substr($1,i,1)~/[stST]/)*j);j/=2}if(k){printf("%0o%0o ",s,k)}print}'|sort
    fi
    echo;echo -e $tags
}

##################################################
#查看LVS状态
lvs_info(){
    echo
    echo -e "${blue}+-------------------------------------------------+${end}"
    echo -e "${blue}|----------------- check LVS info ----------------|${end}"
    echo -e "${blue}|-------------------------------------------------|${end}"
    echo -e "${blue}|       [1] Show Real-time view LVS info          |${end}"
    echo -e "${blue}|       [2] Show LVS links info                   |${end}"
    echo -e "${blue}|       [q] exit                                  |${end}"
    echo -e "${blue}|-------------------------------------------------|${end}"

    lvs_watch(){
        sudo watch -n 0.1 ipvsadm -Ln
    }
    lvs_links(){
        echo;echo -e $tags
        sudo ipvsadm -Lcn |awk '{print $3}'|sort  |uniq -c |sort -rn
        echo;echo -e $tags
        sudo ipvsadm -Ln --timeout
        echo
    }

    read -p "$(echo -e "${green}Please enter ([m] Menu info) ==> ${end}")" num
    while [[ ${num} != 'q' ]]
    do
        case ${num} in
            1)
                lvs_watch;;
            2)
                lvs_links;;
            m)
                echo -e "${yellow}+-------------------------------------------------+${end}"
                echo -e "${yellow}|----------------- check LVS info ----------------|${end}"
                echo -e "${yellow}|-------------------------------------------------|${end}"
                echo -e "${yellow}|       [1] Show Real-time view LVS info          |${end}"
                echo -e "${yellow}|       [2] Show LVS links info                   |${end}"
                echo -e "${yellow}|       [q] exit                                  |${end}"
                echo -e "${yellow}|-------------------------------------------------|${end}"
                echo;;
            *)
                echo -e "${red}Error，Please input again! ${end}"
                echo;;
        esac
           read -p "$(echo -e "${green}Please enter ([m] Menu info) ==> ${end}")" num
           echo
    done
}


##################################################
#查看网站的响应时间
Website_response_time() {
    echo
    echo -e "${blue}+-------------------------------------------------+${end}"
    echo -e "${blue}|----------Check website response time------------|${end}"
    echo -e "${blue}|-------------------------------------------------|${end}"
    echo -e "${blue}|       [web/1] Check website response time       |${end}"
    echo -e "${blue}|        [ip/2] Show ip address area              |${end}"
    echo -e "${blue}|       [lvs/3] Show lvs info [ ipvsadm ]         |${end}"
    echo -e "${blue}|          [q] exit                               |${end}"
    echo -e "${blue}|-------------------------------------------------|${end}"

    WEB() {
        echo;echo -e $tags
        echo -e "${red_back}Check website response time:${end}"
        if read -t30 -p "$(echo -e "${green}Please input the website ${end}${red}[www.qq.com] ['q'=exit] ==> ${end}")" web
        then
            [ ${web} == 'q' ] && exit 1
        else
            echo -e "${red}Sorry , you input too slow! ${end}"
            break
            echo
        fi
        site=$(curl -Io /dev/null -s -w %{http_code} "${web}"|grep -E "(200|301)" |wc -l)
        if [ ${site} -eq 1 ]
        then
            action "${web}" /bin/true
            echo
            echo -e "${red}Start to...${end}"
            $(which curl) -o /dev/null -s -w "time_connect: %{time_connect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n" "$web" |column -t |ccze -A
            echo
            $(which curl) -sSLI ${web} |awk '{print " " $0}'|ccze -A
        else
            action "${web}" /bin/false
            echo -e "${red}Website not exists!${end}"
            echo
            $(which curl) -sSLI ${web} |awk '{print " " $0}'|ccze -A
        fi
        #echo
        host ${web} |ccze -A
        echo;echo -e $tags
    }
##############################################################################

    read -p "$(echo -e "${green}Please enter ([m] Menu info) ==> ${end}")" num
    while [[ ${num} != 'q' ]]
    do
        case ${num} in
            web|1)
                WEB;;
            ip|2)
                Show_ip_area;;
            lvs|3)
                lvs_info;;
            m)
                echo -e "${yellow}+-------------------------------------------------+${end}"
                echo -e "${yellow}|----------Check website response time------------|${end}"
                echo -e "${yellow}|-------------------------------------------------|${end}"
                echo -e "${yellow}|        [web/1] Check website response time      |${end}"
                echo -e "${yellow}|         [ip/2] Show ip address area             |${end}"
                echo -e "${yellow}|        [lvs/3] Show lvs info [ ipvsadm ]        |${end}"
                echo -e "${yellow}|          [q] exit                               |${end}"
                echo -e "${yellow}|-------------------------------------------------|${end}"
                echo;;
            *)
                echo -e "${red}Error，Please input again! ${end}"
                echo;;
        esac
           read -p "$(echo -e "${green}Please enter ([m] Menu info) ==> ${end}")" num
           echo
    done
}

##############################################
#查看有什么用户有权限可以登录系统
User(){
    echo -e $tags
    echo
    echo -e "${red_back}See which user can logon${end} ${green}$(hostname):${end}"
    while read line
    do
    #filter out the user who use bash
        Bashuser=$(echo $line | awk -F: '{print $1,$NF}' | grep 'bash' | awk '{print $1}')
        #jugement Bashuser is null or not and print the user who use bash shell
        if [ ! -z ${Bashuser} ];then
            action "$(echo -e ${red}$Bashuser${end} use bash shell)" /bin/true
        #echo "$Bashuser use bash shell"
        fi
    done < "/etc/passwd"
    echo;echo -e $tags
}

######################################################
#使用命令ss都开了什么服务和端口
Ss() {
    echo -e $tags
    #echo
    echo -e "${red_back}Process service info:${end}"
    sudo ss -tanlp |awk '{print $1,$4,$6}'|column -t
    echo
    echo -e $tags
}

######################################################
#使用命令netstat都开了什么服务和端口
Netstat(){
    echo -e $tags
    #echo
    echo -e "${red_back}Process service info:${end}"
    sudo netstat  -tnlp |awk '!/Active/{print $1,$4,$6,$NF}'|column -t
    echo
    echo -e $tags
}

######################################################
FOR(){
    echo -ne "${red}Please wait${end}"
    #a="."
    while :
    do
        for i in $(seq 6)
        do
            i="."
            echo -ne "${red}$i${end}"
            sleep 0.1
        done
        break
    done
    success; echo
#echo
}

######################################################
#安装常用的一些软件包
Tools() {
    echo
    echo -e "${purple}+++++++++++++++++++++++++++${end}${green}TOOLS MEUN${end}${purple}+++++++++++++++++++++++++++${end}"
    echo
    echo -e "${green}(1)${end} Install yum source [ centos6 epel.repo ] "
    echo -e "${green}(2)${end} Install yum source [ centos7 epel.repo ] "
    echo -e "${green}(3)${end} Install [ ccze dstat tmux sysstat iftop htop tree nc lrzsz ]"
    echo -e "${green}(4)${end} Update [free]"
    echo -e "${green}(5)${end} Set [ccze] configuration file"
    echo -e "${green}(6)${end} Install pyenv and virtualenv"
    echo -e "${green}(7)${end} Set [pip] file ,quick installation"
    echo -e "${green}(8)${end} Install system tools script [/bin/s]"
    echo -e "${green}(9)${end} monitor command"
    echo -e "${green}(10)${end} setting [bashrc] configuration file"
    echo -e "${green}(q)${end} Exit"
    echo

    #Install pyenv and virtualenv tools
    pyenv_virtualenv(){
        [ $(which git) ] || yum -q -y install git
        sudo git clone https://github.com/pyenv/pyenv.git ~/.pyenv
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
        echo 'eval "$(pyenv init -)"' >> ~/.bash_profile

        sudo git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
        echo "[ source ~/.bash_profile ] Activating it!"
        exec $SHELL
    }

    #setting pip file, quick installation
    pip_file(){
        sudo mkdir -p /root/.pip/
        cat >/root/.pip/pip.conf <<EOF
[global]
timeout = 6000
index-url = https://pypi.douban.com/simple/
[install]
use-mirrors = true
mirrors = https://pypi.douban.com/simple/
trusted-host = pypi.douban.com
EOF
    echo -en "Configuration pip file"
    success; echo
    }

    #monitor user command
    monitor_command(){
        cat >> /etc/profile <<\EOF

export HISTORY_FILE=/var/log/monitorCommand.log
export PROMPT_COMMAND='{ date "+%Y-%m-%d %T ### $(who am i |awk "{print \$1\" \"\$2\" \"\$5}")  ### $(id|awk "{print \$1}") >> $(history 1 | { read x cmd; echo "$cmd"; })"; } >>$HISTORY_FILE'
EOF

    echo -en "Configuration monitor command"
    success; echo
    echo "update source /etc/profile"
    echo "chown root:nobody /var/log/monitorCommand.log"
    echo "chmod 622 /var/log/monitorCommand.log"
    echo
}
    # /etc/profile setting
    set_bashrc(){
        cat >> ~/.bashrc <<\EOF

alias grep='grep --color=auto'
alias cls='clear'
alias h='$(which htop)'
alias g='$(which glances)'
alias cc='ccze -A'
alias py='python'
EOF
    echo -en "Configuration ~/.bashrc file"
    success; echo
}

    #install system[/bin/s] work script
    get_script(){
        [ $(which git) ] || yum -q -y install git
        cd /tmp
        sudo git clone https://git.oschina.net/henson01/SuperShell
        sudo \cp -rf SuperShell/sh/s /bin/
        wc -l /bin/s
        sudo chmod 755 /bin/s
        echo
        md5sum /bin/s
        sudo rm -rf /tmp/SuperShell
    }

    echo -e $tags
    read -p "$(echo -e "${green}Please enter ([m] Tool Menu info) ==> ${end}")" num
    while [[ ${num} != 'q' ]]
    do
        case ${num} in
            1)
                FOR
                sudo rpm -ivh http://mirrors.sohu.com/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm
                ;;
            2)
                FOR
                sudo rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
                ;;
            3)
                FOR
                sudo yum -q -y install ccze dstat tmux sysstat iftop nload htop tree nc lrzsz &>/dev/null
                sudo rpm -qa ccze dstat tmux sysstat iftop nload htop tree lrzsz
                ;;
            4)
                FOR
                sudo yum -q -y update procps ; echo; free -V ;echo ; free -h;echo
                ;;
            5)
                sudo sed -i '/^httpcodes/s/bold white/bold red/' /etc/cczerc
                sudo sed -i '/^host/s/bold blue/bold red/' /etc/cczerc
                sudo sed -i '/^numbers/s/white/red/' /etc/cczerc
                sudo sed -i '/^size/s/bold white/red/' /etc/cczerc
                df -h |ccze -A
                echo;;
            6)
                pyenv_virtualenv
                ;;
            7)
                pip_file
                echo;;
            8)
                get_script
                echo;;
            9)
                monitor_command
                echo;;
            10)
                set_bashrc
                echo;;
            m)
                echo
                echo -e "${purple}+++++++++++++++++++++++++++${end}${green}TOOLS MEUN${end}${purple}+++++++++++++++++++++++++++${end}"
                echo
                echo -e "${red}(1)${end} Install yum source [ centos6 epel.repo ] "
                echo -e "${red}(2)${end} Install yum source [ centos7 epel.repo ] "
                echo -e "${red}(3)${end} Install [ ccze dstat tmux sysstat iftop htop tree nc lrzsz  ]"
                echo -e "${red}(4)${end} Update [free]"
                echo -e "${red}(5)${end} Set [ccze] configuration file"
                echo -e "${red}(6)${end} Install pyenv and virtualenv"
                echo -e "${red}(7)${end} Set [pip] file ,quick installation"
                echo -e "${red}(8)${end} Install system tools script [/bin/s] "
                echo -e "${red}(9)${end} monitor command"
                echo -e "${red}(10)${end} setting [bashrc] configuration file"
                echo -e "${red}(q)${end} exit"
                echo;;
            *)
                echo -e "${red}Error, Please input again!${end}"
                echo;;
        esac
            read -p "$(echo -e "${green}Please enter ([m] Tool Menu info) ==> ${end}")" num
            echo
    done
}

######################################################
#显示链接信息
Show_link_info(){
    echo -e $tags
    echo -e "${red_back}System TCP total info:${end}"
    #[ -e /usr/bin/ccze ] || sudo yum -q -y install ccze
    #sudo netstat -antp |grep -v "established"|awk '{print $6}'|sort |uniq -c|sort -rn|column -t
    sudo ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}'|column -t
    echo -e "${green}===============================${end}"
    #echo -e "${purple}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${end}";echo
    sudo ss -an |grep -i TIME-WAIT |awk -F"[: ]+" '{print $1,"\t" $(NF-2)}'|sort |uniq -c |sort -rn |head |column -t
    echo
    echo -e "${green}===============================${end}"
    sudo ss -ant |grep ESTAB |awk -F"[: ]+"  '{print $1,"\t" $(NF-2)}'|sort |uniq -c |sort -rn|head |column -t
    echo
    echo -e $tags
    #read -p "$(echo -e "${green}Please input the [port] ==> ${end}")" num
    while :
    do
        read -p "$(echo -e "${green}Please input the [port] ==> ${end}")" num
        if [[ ${num} == 'q' ]]
        then
            exit 2
        else
            echo
            echo -e "netstat command result:"
            sudo netstat  -anp |grep -i "$num" |awk -F' ' '{print $6}'|sort|uniq -c |sort -rn |head |column -t
            echo "--------------------------"
            echo -e "ss command result:"
            sudo ss -anp |grep -i "$num" |awk -F"[: ]+" '{print $1 "\t" $(NF-3)}'|sort |uniq -c |sort -rn |head |column -t
            echo
            echo -e $tags

        fi
    done



}

######################################################
#显示占程序前10
PS_aux() {
    echo -e $tags
    echo -e "${red_back}List the top 10 CPU:${end}"
    #sudo ps aux --sort=-%cpu | grep -m 11 -v whoami
    sudo ps aux|head -1;ps aux|grep -v PID|sort -rn -k +3|head
    echo;echo -e "${red_back}List the top 10 MEM:${end}"
    sudo ps aux|head -1;ps aux|grep -v PID|sort -rn -k +4|head

    #详细查看占用mem的进程
    echo;echo -e $tags
    echo -e "${red_back}Show [MEM]  occupancy process:${end}"
    echo -e "${green}PID\t   Mem\t\tProc_Name${end}"
    #printf "%-10s %-8s %13s\n" PID MEM Proc_Name

# 拿出/proc目录下所有以数字为名的目录（进程名是数字才是进程，其他如sys,net等存放的是其他信息）
for pid in `ls -l /proc | grep ^d | awk '{ print $NF }'| grep -v [^0-9]`
do
    if [ $pid -eq 1 ];then continue;fi
    grep -q "Rss" /proc/$pid/smaps 2>/dev/null
    if [ $? -eq 0 ];then
        swap=$(grep Rss /proc/$pid/smaps \
            | gawk '{ sum+=$2;} END{ print sum }')
        proc_name=$(ps aux | grep -w "$pid" | grep -v grep \
            | awk '{ for(i=11;i<=NF;i++){ printf("%s ",$i); }}')
        if [ $swap -gt 0 ];then
            echo -e "${pid}\t${swap}\t${proc_name}"
        fi
    fi
done | sort -k2 -rn |head | awk -F'\t' '{
    pid[NR]=$1;
    size[NR]=$2;
    name[NR]=$3;
}
END{
    for(id=1;id<=length(pid);id++)
    {
        if(size[id]<1024)
            printf("%-10s %1.2fKB \t%s\n",pid[id],size[id],name[id]);
        else if(size[id]<1048576)
            printf("%-10s %1.2fMB \t%s\n",pid[id],size[id]/1024,name[id]);
        else
            printf("%-10s %1.2fGB \t%s\n",pid[id],size[id]/1048576,name[id]);
    }
}'
    echo
}

######################################################
#占用cpu超过20~90%的进程
Top(){
    echo; echo -e $tags
    #echo -e "${red_back}Show the cpu programs:${end}"
    while :
    do
        echo -e "${red_back}Show the cpu programs:${end}"
        read -p "$(echo -e "${green}Please enter the cpu percentage [20~90] ['q'=exit] ==> ${end}")" num
        if [[ ${num} == '' ]]
        then
            echo "Not null";echo
            continue
        fi
        if [ ${num} == 'q' ]
        then
            exit 1
        fi
        echo -e "${red} PID  USER      PR  NI  VIRT  RES  SHR S %CPU %MEM   TIME+  COMMAND${end}"
        sudo top -b1 -n1 | sed '1,5d' | awk '{if($9>='${num}')print}'|cut -c 2-
        echo
    done
    echo -e $tags
}

######################################################
#查看文件大小
Check_file_size() {
    echo -e $tags
    #echo -e "${red_back}List the files before 10 takes up hard disk space:${end}"
    while :
    do
        echo
        echo -e "Current path: ${yellow}`pwd`${end}"
        echo -e "${red_back}List the files before [top10] takes up hard disk space:${end}"
        read -p "$(echo -e "${green}Please input the location [/]${end} ${purple}[q=exit] ['f'=check files size] ==> ${end}")" num
        if [[ ${num} == "q" ]]
        then
            echo -e "${red}Good bye!${end}"
            exit
        fi
        echo
        if [[ ${num} == "f" ]]
        then
            while ${1}
            do
                echo -e "Current path: ${yellow} ${pwd} ${end}"
                read -p "$(echo -e "${green}Please input the location and size${end} ${purple}['b'=back] [/opt 100000]: ${end}")" num1 num2
                echo
                if [[ ${num1} == 'b' ]]
                then
                    Check_file_size
                fi
                #find ${num1} -type f -size +${num2} |xargs ls -lh |awk '{print $NF" = "$5}' |column  -t |ccze -A
                sudo find ${num1} -printf "%k %p\n" |sort -g -k 1,1 |awk '{if($1 > '${num2}') print $2 " = " $1/1024 "MB" }'|column -t|ccze -A
                echo
            done
        fi
        #read -p "Please input the location (/) (q=exit): " num
        if [ -e /usr/bin/ccze ]
        then
            sudo /usr/bin/du -b --exclude=/proc --max-depth=1 ${num} |sort -rn |perl -pe 's{([0-9]+)}{sprintf"%.2f%s", $1>=2**30? ($1/2**30, "GB"): $1>=2**20? ($1/2**20, "MB"):$1>=2**10? ($1/2**10, "KB"): ($1, "")}e' |awk '{print $2 " = " $1}'|head |column -t |ccze -A
        else
            sudo /usr/bin/du -b --exclude=/proc --max-depth=1 ${num} |sort -rn |perl -pe 's{([0-9]+)}{sprintf"%.2f%s", $1>=2**30? ($1/2**30, "GB"): $1>=2**20? ($1/2**20, "MB"):$1>=2**10? ($1/2**10, "KB"): ($1, "")}e' |awk '{print $2 " = " $1}'|head |column -t
        fi
        echo
    done
}

######################################################
#查看登录用户的信息
Check_logon_ip(){
    echo -e $tags
    echo -e "${red_back}Current Logon IP Address:${end}"
    #[ -e /usr/bin/ccze ] || yum -q -y install ccze
    #$(which last) |grep "logged in"|ccze -A ;echo
    $(which last) |grep "logged in" ; echo
    echo -e "${red_back}Current Logon Top 10 IP Address:${end}"
    $(which last) |head  ;echo
    echo -e "${red_back}Before The Login IP Address:${end}"
    $(which last) |awk '{print $1,$2,$3}' |sort |uniq -c |sort -rn |head|column  -t
    echo
    echo -e $tags
}

Check_top_cpu_mem(){
    echo -e $tags
    echo -e "${red_back}Show top-cpu and top-mem -top-io info:${end}"
    [ ! $(which dstat ) ]  && yum -q -y install dstat
    $(which dstat) -tlcm --top-cpu --top-io  --top-mem  -dn --tcp
}

######################################################
#nmap command
Check_open_port(){
    echo -e $tags
    echo -e "${red_back}Show IP open port info:${end}"
    [ ! $(which nmap ) ]  && rpm -vhU https://nmap.org/dist/nmap-7.40-1.x86_64.rpm
    while :
    do
        read -p "$(echo -e "${green}Please input the PORT and IP${end} ${purple}[ 'q'=exit ] ['ip'=Online IP ] [ 1-65535 192.168.1.100 ]: ${end}")" num1 num2
        if [ $num1 == 'q' ];then
            exit;
        elif [ $num1 == 'ip' ];then
            while true
            do
                read -p "$(echo -e "${green}Please input the IP field ${end} ${purple}[ 'b'=back ]['q'=exit] [ 192.168.1.0 ]: ${end}")" count
                if [ ${count} == 'b' ]
                then
                    Check_open_port
                elif [ ${count} == 'q' ]
                then
                    echo "Good bye!"
                    exit 1
                fi
                echo
                $(which nmap) -PO -sP ${count}/24 |grep Nmap |ccze -A
                echo
            done
        else
            $(which nmap) -sV -p ${num1} -T4 -PO -A -v -n ${num2} |ccze -A
            echo
        fi
    done
}

######################################################
NC_info(){
    echo -e $tags
    echo -e "${red_back}Scan port:${end}"
    while :
    do
        read -p "$(echo -e "${green}Please input the IP and PORT${end} ${purple}[ 'q'=exit ] [192.168.1.100 80-90 ]: ${end}")" num1 num2
        if [ $num1 == 'q' ]; then
            echo "good bye!"
            exit;
        fi
        $(which nc) -w1 ${num1} -z ${num2} |ccze -A
        echo
    done
}

######################################################
Check_survive_ip(){
    echo -e $tags
    echo -e "${red_back}Check the host survival info :${end}"
    echo -en "${green}Please input the IP field [ 192.168.1 ]: ${end}"
    read IP

    check_ip(){
    for i in $(seq 255)
    do
        PING=$(echo -en "\e[34;1mping ${IP}.${i} \e[0m")
        test_ip=$(ping -fc1 -w1 ${IP}.${i} &>/dev/null)
        if [ $? -eq 0 ]
        then
            action "${PING}" /bin/true
        else
            action "${PING}" /bin/false >/dev/null 2&>1
        fi
    done
    }
    check_ip
    echo
    echo -e "${red}Start counting the host number, Please wait...${end}"
    #main &>/dev/null >/home/ping.txt

    #if ! which nmap >/dev/null 2>&1;then
    #    yum -y -q install nmap
    #fi
    [ ! $(which nmap) ] && yum -q -y install nmap

    #sum=$(cat /home/ping.txt |awk '/]/{print $NF}'|uniq -c|awk '{print $1}')
    sum=$(nmap -PO -sP ${IP}.0/24 |awk '/seconds/{print $6,$7,$8}')
    echo
    #echo -e "\e[31;1m检测完毕,在线主机=${sum}台!\e[0m"
    echo -en "${green} Online host= ${sum}${end}"
}

######################################################
#清除系统内存
Clean_system_cache(){
    echo -e $tags
    echo -en "${red_back}Clean system cache :${end}"
    success ; echo;echo
    echo -e "${green}------[ 清除前 ]------${end}"
    free -h;echo
    echo -e "${green}------[ 清除后 ]------${end}"
    sync && echo 3 >/proc/sys/vm/drop_caches && sleep 2 && echo 0 >/proc/sys/vm/drop_caches |free -h
    echo -e $tags
}

######################################################
Check_CpuLoad_and_DiskLoad(){
    #etho -e $tags
    #echo -en "${red_back}Check Cpu load and Disk load info :${end}";echo
    #[ ! $(which dstat ) ]  && yum -q -y install dstat
    #$(which dstat) -tc --top-cpu -m --top-mem  -dnl 1 6;echo
    #echo -e $tags
    #echo -en "${red_back}Check Cpu load and Disk load info [ vmstat ] :${end}";echo
    #$(which vmstat) 1 5;echo
    echo -e $tags
    echo -en "${red_back}Check Cpu load and Disk load info [ mpstat ]:${end}";echo
    [ ! $(which iostat) ] && yum -q -y install sysstat
    #$(which iostat) -kx 1 5|grep -A1 avg-cpu
    $(which mpstat) -P ALL 1 5
    echo
    echo -e $tags
    echo -en "${red_back}Check Cpu load and Disk load info [ iostat ]:${end}";echo
    $(which iostat) -d -x 1 5
    echo -en "${red_back}Check Cpu load and Disk load info [ pidstat ]:${end}";echo
    $(which pidstat) -urd -h 1 5
    echo -e $tags
    $(which pidstat) -d 1 5
    echo -e $tags
}

######################################################
#查看数据库信息
Check_mysql_info(){
    echo;echo -e $tags
    echo -en "${red_back}Check mysql info :${end}";echo
    sudo $(which mysql) -h127.0.0.1 -uroot -p -e "show databases;select user,host,password from mysql.user;select version();show processlist;show status like 'connections';SHOW STATUS LIKE 'slow_queries';show variables like 'slow_query%';show variables like 'long_query_time';show global variables like '%timeout%';"
}

######################################################
#删除乱码文件
del_messy_code_file(){
    echo -e $tags
    while :
    do
        ls -ialhF --time-style=long-iso; echo
        echo -e "${red_back}Del messy code file :${end}"
        read -p "$(echo -e "${green}Plese input the messy code file inodes number ['q'=exit] ==> ${end}")" num
        if [[ ${num} == 'q' ]]
        then
            echo "Good bye!"
            exit 1
        elif [[ ${num} == '' ]]
        then
            echo "not null"
            exit 2
        #find . -inum $num -execdir rm -rf {} \; >/dev/null 2>&1
        elif [[ ${num} == ${num} ]]
        then
            echo -e "${purple}=====[ Del ${num} ]=====${end}"
            echo -ne "${red_back}$(ls -ial |awk '/'${num}'/{print}')${end}"
            success; echo
            echo; echo -e $tags
            $(which find) . -inum $num -execdir sudo rm -rf {} \; >/dev/null 2>&1
        fi
        #ls -ial; echo
    done
}

######################################################
#查看被攻击的ip地址
Check_secure_info(){
    echo -e $tags
    echo -en "${red_back}查看被外网攻击IP地址 :${end}"
    echo
    if [ -e /usr/bin/ccze ]; then
        sudo cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c |sort -rn| awk '{print $2 " = " $1;}'|column  -t|head  |ccze -A
    else
        sudo cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c |sort -rn| awk '{print $2 " = " $1;}'|column  -t|head
    fi
    echo
    echo -e $tags
}

######################################################
#显示外网IP地址信息
Show_ip_area(){
    echo -e $tags
    #while true
    #do
        echo -e "${red_back}Show ip address area:${end}"
        read -p "$(echo -e "${green}Please input the IP address ${end} ${purple}['q'=exit] ==> ${end}")" IP
        if [[ ${IP} == 'q' ]]
        then
            echo "Good bye!"
            exit 2
        fi
        $(which curl) -sSL ipinfo.io/${IP} |ccze -A
        echo
    #done
    echo -e $tags
}


######################################################
#测试磁盘读写性能
Check_disk_read_write(){
    echo; echo -e $tags
    echo -e "${red_back}Check disk read and write IO info :${end}"
    read -p "$(echo -e "${green}Plese input the disk drive ${end} ${purple}[sda] ['q'=exit] ==> ${end}")" r
    if [[ ${r} == 'q' ]]
    then
        echo "Good bye!"
        exit 2
    fi
    echo;echo -e "${red}Check disk ${end}${green}[read]${end}${red} IO info :${end}"
    $(which dd) if=/dev/${r} of=/dev/null bs=8k count=256k
    sleep 2
    echo;echo -e "${red}Check disk ${end}${green}[write]${end}${red} IO info :${end}"
    $(which dd) if=/dev/zero of=/tmp/output.img bs=8k count=256k && \rm /tmp/output.img
    sleep 2
    echo;echo -e "${red}Check disk ${end}${green}[read and write]${end}${red} IO info :${end}"
    $(which dd) if=/dev/${r} of=/tmp/output.img bs=8k count=256k && \rm /tmp/output.img
    echo; echo -e $tags
}


######################################################
#显示iptables信息
    Show_iptable(){
        echo; echo -e $tags
        echo -e "${red_back}Show iptables info :${end}"
        $(which iptables) -S
        echo; echo -e $tags
        $(which iptables) -vnL
        echo; echo -e $tags
        echo -e "${red_back}Show iptables nat info :${end}"
        $(which iptables) -t nat -vnL --line
        echo
}

######################################################
#查看路由跟踪详细信息
Check_traceroute(){
    echo; echo -e $tags
    while [ 1 ]
    do
        echo -e "${red_back}Check traceroute IP info :${end}"
        read -p "$(echo -e "${green}Plese input the IP ${end} ${purple} ['q'=exit] ==> ${end}")" ip
        echo
        if [[ ${ip} == 'q' ]]
        then
            echo "Good bye!"
            exit 255
        fi

        [ ! $(which traceroute) ] && sudo yum -q -y install traceroute
        if [ -e /usr/bin/ccze ]
        then
            sudo $(which traceroute) -nd ${ip} |ccze -A
        else
            sudo $(which traceroute) -nd ${ip}
        fi
        echo
        echo -e $tags
        echo -e "${green}Test ping [ ${ip} ]...${end}"
        #$(which ping) -c5  ${ip} |head -6 |ccze -A
        $(which ping) -c5  ${ip} |head -5 |grep --color time=
        echo
    done
    echo
    echo -e $tags
}

######################################################
#PS1:提示字符的配置
Update_PS1(){
    #先判断网卡是否存在，我这边eth0是内网网卡
    ifconfig eth0 >/dev/null 2>&1
    if [[ $? -ne 0 ]];then
        echo 'interface eth0 not exsit!'
        exit 1
    fi

    #Centos/Redhat 7 ifconfig显示的结果不是 inet addr: 而是 inet 直接加IP，所以这里需要判断下:
    #release=$(cat /etc/redhat-release |grep -o "[0-9]"|awk 'NR==1{print $1}')
    #if [[ $release -eq 7 ]]; then
    #    #for centos 7
    #    eth0_IP=$(ifconfig eth0 |awk '/inet / {print $2}'|awk '{print $1}')
    #else
    #    eth0_IP=$(ifconfig eth0 |awk -F "[ :]+"  '/inet addr/{print $4}')
    #fi

    eth0_IP=$(printenv |grep SSH_CONNECTION |awk '{print $3}')

    #有颜色的PS1显示ip地址
    Export1(){
        #echo "export PS1='\e[31;1m[\u@\e[32;1m\h \e[35;1m\w \e[34;1m\A]\e[31m\\$\e[m '" >> ${1} && \
        echo "export PS1='\[\e[31;1m\][\u@\[\e[32;1m\]\h \[\e[35;1m\]\w \[\e[34;1m\]\A]\[\e[31m\]\\$\[\e[m\] '" >> ${1} && \
        echo;echo -e $tags
        echo -en "${green}Update ${end}${purple}[ ${1} ]${end} ${green}Success! Please relogin your system for refresh... ${end}"
    }

    #有颜色的PS1显示主机名
    Export2(){
        echo "export PS1='\e[31;1m[\u@\e[32;1m${eth0_IP} \e[35;1m\w \e[34;1m\A]\e[31m\\$\e[m '" >> ${1} && \
        echo;echo -e $tags
        echo -en "${green}Update ${end}${purple}[ ${1} ]${end} ${green}Success! Please relogin your system for refresh... ${end}"
    }

    #没有颜色的PS1
    Export3(){
        echo "export PS1='[\u@\h \w \A]\\$ '" >> ${1} && \
        echo;echo -e $tags
        echo -en "${green}Update ${end}${purple}[ ${1} ]${end} ${green}Success! Please relogin your system for refresh... ${end}"
    }

    home_env(){
        #有的用户可能会在家目录下自定义一些配置，即 .bash_proflie这个隐藏文件，所以也需要更新
        echo; echo -e $tags
        echo """Select PS1 item:
    [1] = Have the colour PS1 show hostname
    [2] = Have the colour PS1 show ip address
    [3] = No have the colour PS1 show ip address
        """
        read -p "please input the number ['q'=exit]: " num
        if [[ ${num} -eq 1 ]]
        then
            test -f $HOME/.bash_profile &&(
                sed -i '/export PS1=/d' $HOME/.bash_profile
                Export1  $HOME/.bash_profile
                )
            #exec $SHELL

        elif [[ ${num} -eq 2 ]]
        then
            test -f $HOME/.bash_profile &&(
                sed -i '/export PS1=/d' $HOME/.bash_profile
                Export2  $HOME/.bash_profile
                )
            #exec $SHELL

        elif [[ ${num} -eq 3 ]]
        then
            test -f $HOME/.bash_profile &&(
                sed -i '/export PS1=/d' $HOME/.bash_profile
                Export3  $HOME/.bash_profile
                )
            #exec $SHELL

        elif [[ ${num} == 'q' ]]
        then
            echo "Goodbye!"
            exit 1
        else
            exit 1
        fi
    }
    home_env
    bash="source $HOME/.bash_profile"
    eval $bash
}


######################################################
#测试网络宽带和每秒数据包
Network_test(){
    echo -e $tags
    echo -e "${red_back}Test network bandwidth and data package:${end}"
    network_card=$(ifconfig |awk -F"[ ]" '{print $1}'|xargs)
    #echo -e "The current network card "$network_card
    while ${1}
    do
        read -p "$(echo -e "${green}Please input the network card${end}${red} ['q'=exit] ['d'=Show data package] [${network_card}]: ${end}")" eth
        if [[ ${eth} == 'q' ]]
        then
            echo "Good bye!"
            exit 1

        elif [[ ${eth} == '' ]]
        then
            echo -e "${red}Can't input is empty${end}"
            echo
            continue

        elif [ -e /sys/class/net/${eth} ]
        then
            clear
            echo
            echo -e $tags
            echo -e "${green}date/time\t\t发送(TX)\t\t接收(RX)${end}"
            lines1=$(expr $(tput lines) - 5)
            lines2=$(tput lines)
            while [ 1 ]
            do
                for i in $(seq 1 $lines2)
                do
                    if [[ $i ==  $lines1 ]];then
                        echo -e $tags
                        echo -e "${green}date/time\t\t发送(TX)\t\t接收(RX)${end}"
                        continue
                    fi
                    #tput civis
                    R1=$(cat /sys/class/net/${eth}/statistics/rx_bytes)
                    T1=$(cat /sys/class/net/${eth}/statistics/tx_bytes)
                    sleep 1
                    R2=$(cat /sys/class/net/${eth}/statistics/rx_bytes)
                    T2=$(cat /sys/class/net/${eth}/statistics/tx_bytes)
                    TBPS=$(expr $T2 - $T1)
                    RBPS=$(expr $R2 - $R1)
                    TKBPS=$(expr $TBPS / 1024)
                    RKBPS=$(expr $RBPS / 1024)
                    echo -e "$(date +'%F %T') \t${blue}TX ${eth}:${end} ${red}$TKBPS kb/s${end} \t${blue}RX ${eth}:${end} ${red}$RKBPS kb/s${end}"
                done
            done

        elif [[ $eth == "d" ]]
        then
            while [ 1 ]
            do
                read -p "$(echo -e "${green}请输入网卡测试每秒数据包${end} ${red}['b'=back] [${network_card}]: ${end}")" eth1
                if [[ ${eth1} == b ]]
                then
                    Network_test
                elif [[ ${eth1} == '' ]]
                then
                    echo -e "${red}Can't input is empty${end}"
                    echo
                    continue
                elif [ -e /sys/class/net/${eth1} ]
                then
                    clear
                    echo
                    echo -e $tags
                    echo -e "${green}date/time\t\t发送(TX)\t\t接收(RX)${end}"
                    while [ 1 ]
                    do
                        for i in $(seq 1 $lines2)
                        do
                            if [[ $i ==  $lines1 ]];then
                                echo -e $tags
                                echo -e "${green}date/time\t\t发送(TX)\t\t接收(RX)${end}"
                                continue
                            fi
                            #tput civis
                            R1=$(cat /sys/class/net/$eth1/statistics/rx_packets)
                            T1=$(cat /sys/class/net/$eth1/statistics/tx_packets)
                            sleep 1
                            R2=$(cat /sys/class/net/$eth1/statistics/rx_packets)
                            T2=$(cat /sys/class/net/$eth1/statistics/tx_packets)
                            TXPPS=$(expr $T2 - $T1)
                            RXPPS=$(expr $R2 - $R1)
                            echo -e "$(date +'%F %T') \t${blue}TX ${eth1}:${end} ${red}$TXPPS pkts/s${end} \t${blue}RX ${eth1}:${end} ${red}$RXPPS pkts/s${end}"
                        done
                    done
                else
                    echo -e "${red}Error: /sys/class/net/${eth1} not exist!${end}"
                    echo
                fi
            done
        else
            echo -e "${red}Error: /sys/class/net/${eth} not exist!${end}"
            echo
        fi
    done
}

######################################################
#快速定位查找文件路径
Show_locate(){
    #echo; echo -e $tags
    while :
    do
        echo; echo -e $tags
        echo -e "${red_back}Speediness locate filename info:${end}"
        read -p "$(echo -e "${green}Please input the filename ['q'=exit] ==> ${end}")" file
        if [[ ${file} == '' ]]
        then
            echo "Not null"
            continue
        elif [ ${file} == 'q' ]
        then
            echo "GoodBye!"
            exit 255
        fi
        [ -f /usr/bin/updatedb ] || sudo yum -q -y install mlocate
        sudo updatedb
        sudo stat -c "%a(%A) %U %G %s %n" $(locate  -ib ${file} |grep ${file}$)| column -t |grep --color ${file}$
    done
}

######################################################
#查看文件或目录哪些加锁了
Lsattr_Chattr(){
    echo; echo -e $tags
    while :
    do
        echo -e "${green}PathName:${end} " $(pwd);echo
        lsattr -d *
        echo
        echo -e "${red_back}Use [chattr -i ] command deblocking FILE/DIR :${end}"
        read -p "$(echo -e "${green}Plese input the FILE/DIR ['+'=chattr +i]['q'=exit] ==> ${end}")" file
        #lsattr -d ${file}
        if [[ $file == 'q' ]]
        then
            echo "Goodbye!"
            exit 1
        elif [[ $file == '' ]]
        then
            echo -e "${red}not null${end}"
            continue
        elif [[ ${file} == '+' ]]
        then
            while :
            do
                echo;echo -e $tags
                echo -e "${green}PathName: ${end}" $(pwd);echo
                lsattr -d *
                echo
                echo -e "${red_back}Use [chattr +i ] command lock FILE/DIR :${end}"
                read -p "$(echo -e "${green}Plese input the FILE/DIR [b=back] ['q'=exit] ==> ${end}")" file1
                #lsattr -d *
                if [[ ${file1} == 'q' ]]
                then
                    echo "Goodbye!"
                    exit 1
                elif [[ ${file1} == '' ]]
                then
                    echo -e "${red}not null${end}"
                    continue
                elif [[ ${file1} == 'b' ]]
                then
                    Lsattr_Chattr
                elif [[ ${file1} == ${file1} ]]
                then
                    echo -e "${purple}=====[ chattr +i ${file1} ]=====${end}"
                    sudo chattr +i ${file1}
                    sudo lsattr -d ${file1}|grep --color "${file1}"
                fi
            done
        elif [[ ${file} == ${file} ]]
        then
            echo -e "${purple}=====[ chattr -i ${file} ]=====${end}"
            sudo chattr -i ${file}
            sudo lsattr -d ${file} | grep --color "${file}"
            echo
        fi
    done
}

######################################################
#输入命令反查看安装包名
rpm_info(){
    echo
    echo -e $tags
    read -p "$(echo -e "${green}Please input the package name ==> ${end}")" name
    rpm_name=$(which ${name})
    if [[ -n $rpm_name ]]
    then
        package=$(rpm -qf $rpm_name)
        echo -e "${red}Package name: ${end}" $package
        echo && rpm -ql ${package}
    else
        exit 1
    fi
    echo
    echo -e $tags
}

######################################################
#记录history时间,连接ip地址,用户信息 ,替换history命令
set_history(){
    echo
    echo -e $tags
    if test -f /etc/profile;then
        sudo sed -i '/export HISTTIMEFORMAT=/d' /etc/profile
        sudo cat >>/etc/profile <<\EOF
export HISTTIMEFORMAT="[%F %T] [$(printenv |awk -F'[=| ]+' '/SSH_CLIENT/{print $2}')] [$(whoami)] >> "
EOF
    fi

    while :;do
        echo -ne "${yellow}[ /etc/profile ] 已写输入全局变量中${end}"
        success; echo;echo
        grep --color "export HISTTIMEFORMAT" /etc/profile
        exit
    done
    f=/etc/profile
    source $f
}

######################################################
#以树状图的方式展现进程之间的派生关系
pstree_info(){
    echo
    echo -e "${blue}+-------------------------------------------------+${end}"
    echo -e "${blue}|----------------Check progress all---------------|${end}"
    echo -e "${blue}|-------------------------------------------------|${end}"
    echo -e "${blue}|        [all/a] Show progress all                |${end}"
    echo -e "${blue}|    [choice/ch] Choice progress name(nginx)      |${end}"
    echo -e "${blue}|            [q] exit                             |${end}"
    echo -e "${blue}|-------------------------------------------------|${end}"

    choice_pstree(){
        echo -e $tags
        read -p "$(echo -e "${green}Choice progress name(nginx,mysql)==> ${end} ")" str
        pstree -paul |grep -v grep |grep ${str}
        echo
    }

    read -p "$(echo -e "${green}Please enter ([m] Menu info) ==> ${end}")" str
    while [[ ${str} != 'q' ]]
    do
        case ${str} in
            'all'|'a')
                pstree -paul;;
            'choice'|'ch')
                choice_pstree;;
            m)
                echo -e "${yellow}+-------------------------------------------------+${end}"
                echo -e "${yellow}|----------------Check progress all---------------|${end}"
                echo -e "${yellow}|-------------------------------------------------|${end}"
                echo -e "${yellow}|        [all/a] Show progress all                |${end}"
                echo -e "${yellow}|    [choice/ch] Choice progress name(nginx)      |${end}"
                echo -e "${yellow}|            [q] exit                             |${end}"
                echo -e "${yellow}|-------------------------------------------------|${end}"
                echo;;
            *)
                echo -e "${red}Error，Please input again! ${end}"
                echo;;
        esac
            read -p "$(echo -e "${green}Please enter ([m] Menu info) ==> ${end}")" str
            echo
    done

}


######################################################
#通用端口查找出进程所在目录及执行程序的绝对路径
Port_path(){
    echo;echo -e $tags
    echo -e "${red_back}General port directory to find out the process:${end}"
    read -p "$(echo -e "${green}Please input the process [PID] ==> ${end}")" num
    if test ${num} == 'q'
    then
        echo "goodbye!"
        exit 255
    fi
    sudo ls -l /proc/${num} | grep --color -E "cwd|exe|environ|fd"


}

######################################################
#查看占用mem的进程


######################################################

traps(){
trap 'echo -e "
${green}
######################################################################
#                        ${end} ${red} Author: Henson${end}${green}                            #
#               Welcome to use the script ,thanks,Bye!               #
######################################################################
${end}"
' EXIT;
}

MYDATE=$(date '+%Y-%m-%d')
THIS_HOST=$(hostname)
USER=$(whoami)

Usage () {
    cat <<EOF
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       User:${green}$USER${end}        Host:${green}$THIS_HOST${end}        Date:${green}$MYDATE${end}
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
${purple}
Usage:system [OPTIONS]
  -d, -disk           Show [ disk crontab hosts yum.repos.d ] info
  -s, -sys            Show system info
  -ll                 Show file info and (ls -lh commands) the same
  -ss                 Show all progress/port info
  -n, -netstat        Show all progress/port info
  -up, -uptime        Show system uptime info
  -u,  -user          Show user login info
  -w , -web           Test website response time
  -to , -tool         Install software tools and other thing
  -l , -last          Current/Before login user and IP
  -li, -link          Show system link info
  -p, -ps             List the top 10 programs
  -t, -top            Show cpu programs
  -du                 List the files before 10 takes up hard disk space and Check file size
  -ds,-dstat          Show top-cpu and top-mem -top-io info
  -nm, -nmap          Show IP open port And online ip info
  -nc                 Scan open port info
  -sy, -sync          Clean system cache
  -io, -iostat        Use [ vmstat,mpstat,iostat ] check cpu load and disk load info
  -m, -mysql          Check mysql info:[ version, databases,account and host]
  -del                Del messy code file [ ????.txt ]
  -se,-secure         Show /var/log/secure "Failed" IP
  -ip                 Show the ip area
  -ipt,-iptables      Show iptables info
  -dd                 Show disk read and write IO info
  -tr,-traceroute     Show traceroute IP info
  -ps1                Update PS1 info
  -net                Test network bandwidth(RX,TX) and Show network data package
  -cat, -locate       Speediness locate filename info
  -ls, -lsattr        Show lsattr and chattr file info
  -r, -rpm            Show install package name info
  -his, -history      Detailed record history command
  -pt, pstree         Show process all info
  -pr, proc           General port directory to find out the process
${end}
EOF
    exit 1
}

#while [ $1 ];do
case "$1" in
    '-web'|'-w')
        Website_response_time;;
    '-s'|'-sys')
        Systeminfo
        traps;;
    '-ll')
        #Show_ll;;
        echo
        echo -e "${purple}++++++++++++++++++++${end}${green}[ Super ll Command ]${end}${purple}+++++++++++++++++++++++++${end}"
        echo
        if [ -e /usr/bin/ccze ]
        then
            ls -alhF --time-style=long-iso --sort=size $2 | awk '{k=0;s=0;for(i=0;i<=8;i++ ){k+=((substr($1,i+2,1)~/[rwxst]/)*2^(8-i))}j=4;for(i=4;i<=10;i+=3){s+=((substr($1,i,1)~/[stST]/)*j);j/=2}if(k){printf("%0o%0o ",s,k)}print}' |sort|ccze -A
        else
            ls -alhF --time-style=long-iso --sort=size $2 | awk '{k=0;s=0;for(i=0;i<=8;i++ ){k+=((substr($1,i+2,1)~/[rwxst]/)*2^(8-i))}j=4;for(i=4;i<=10;i+=3){s+=((substr($1,i,1)~/[stST]/)*j);j/=2}if(k){printf("%0o%0o ",s,k)}print}'|sort
        fi
        echo;echo -e $tags;;
    '-ss')
        Ss;;
    '-netstat'|'-n')
        Netstat;;
    '-uptime'|'-up')
        Uptime ;;
    '-user'|'-u')
        User;;
    '-disk'|'-d')
        Diskinfo;;
        #traps;;
    '-to'|'-tool')
        Tools;;
    '-g'|'-grep')
        echo -e $tags; echo
        grep -vnE --color '^(#|$|;)' $2
        echo; echo -e $tags;;
    '-wat'|'-watch')
        #echo -e $tags; echo
        #watch -d -n0.1 ls -l $2;;
        watch -d -n0.1 "ls -alF --time-style=long-iso --sort=size $2";;
    '-li'|'-link')
        Show_link_info;;
    '-t'|'-top')
        Top;;
    '-p'|'-ps')
        PS_aux;;
    '-du')
        Check_file_size;;
    '-l'|'-last')
        Check_logon_ip;;
    '-ds'|'-dstat')
        Check_top_cpu_mem;;
    '-nm'|'-nmap')
        Check_open_port;;
    '-nc')
        NC_info;;
    '-ip')
        Show_ip_area;;
    '-ipt'|'-iptables')
        Show_iptable;;
    '-sy'|'-sync')
        Clean_system_cache;;
    '-io'|'-iostat')
        Check_CpuLoad_and_DiskLoad;;
    '-m'|'-mysql')
        Check_mysql_info;;
    '-del')
        del_messy_code_file;;
    '-se'|'-secure')
        Check_secure_info;;
    '-dd')
        Check_disk_read_write;;
    '-tr'|'-traceroute')
        Check_traceroute;;
    '-ps1')
        Update_PS1;;
    '-net')
        Network_test;;
    '-cat'|'-locate')
        Show_locate;;
    '-ls'|'-lsattr')
        Lsattr_Chattr;;
    '-r'|'-rpm')
        rpm_info;;
    '-his'|'-history')
        set_history;;
    '-pt'|'-pstree')
        pstree_info;;
    '-pr'|'-proc')
        Port_path;;
    '-log')
        echo;echo -e $tags
        echo -e "${red_back}Access nginx log IP in the top 15:${end}"
        cat $2 |awk '{a[$1]++} END {for(b in a) print b"\t"a[b]}' | sort -k2 -r | head -n 15|column -t
        echo;echo -e $tags
        echo -e "${red_back}Statistics log client IP total traffic order:${end}"
        awk '{a[$1]+=$10} END{for(i in a) print i,a[i]/1024/1024 "MB"}' $2 |sort -k2 -nr|head -n 15|column -t
        echo
        ;;
    '-help'|'-h')
        echo -en "$(Usage)"
        traps;;
    *)
        echo -en $"${red}Usage: {-help|-uptime|-user|-ss|-netstat|-disk|-sysinfo|-web|-ps|du|last}${end}"
        #echo
        exit
esac
#    sleep 2
#done
