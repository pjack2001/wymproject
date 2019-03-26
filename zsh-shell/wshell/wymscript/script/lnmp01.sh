 #!/bin/bash

#================================================================
#   Copyright (C) 2017  All rights reserved.
#   
#   File：：lnmp_install.sh
#   Author：LuoJiandong
#   Date：2017/06/18
#   Description：install nginx,mysql,php
#
#================================================================

dir=/data
nginx_download_path="http://nginx.org/download/nginx-1.12.0.tar.gz"
nginx_install_dir="/usr/local/nginx"
mysql_download_path="https://cdn.mysql.com//Downloads/MySQL-5.5/mysql-5.5.56-linux-glibc2.5-x86_64.tar.gz"
mysql_install_dir="/usr/local/mysql"
php_download_path="http://jp2.php.net/distributions/php-5.5.38.tar.gz"
php_install_path="/usr/local/php"
nginx_name="nginx-1.12.0.tar.gz"
mysql_name="mysql-5.5.56-linux-glibc2.5-x86_64.tar.gz"
php_name="php-5.5.38.tar.gz"

[ -f /etc/init.d/functions ] && . /etc/init.d/functions || exit 1

# create file download dir
create_dir(){
  if [ ! -e $dir ]
    then
      mkdir $dir
  else
    echo "file download dir is exit!"
  fi
}


# install nginx 1.12.0
install_nginx(){
  # yum install something
  wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
  yum install -y pcre pcre-devel openssl openssl-devel gcc make gcc-c++
  # download nginx
  [ -e $dir ] && cd $dir
  wget $nginx_download_path
  if [ -f $nginx_name ]
    then
      echo 'nginx download success'
      # tar nginx
      tar zxf $nginx_name && cd nginx-1.12.0
      # add user nginx
      useradd nginx -s /sbin/nologin -M
      # install nginx
      ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
      [ $(echo $?) -eq 0 ] && make && make install
      [ $(echo $?) -eq 0 ] && echo "nginx install success"    
  fi
}
# start nginx
start_nginx(){
 # check syntax
 $nginx_install_dir/sbin/nginx -t 
 # start
 if [ $(echo $?) -eq 0 ]
   then
     $nginx_install_dir/sbin/nginx
     if [ $(netstat -lutnp|grep 80|wc -l) -eq 1 ]
       then
         action "nginx starting success..."  /bin/true
     else
         echo "nginx starting fail,plaese check the service!"
     fi
 fi
}
# install mysql 5.5.56
install_mysql(){
  # yum install something
  yum install -y ncurses-devel automake autoconf bison libtool-ltdl-devel
  # download mysql
  [ -e $dir ] && cd $dir
  wget $mysql_download_path
  if [ -f $mysql_name ]
    then
      echo 'mysql download success'
      # tar mysql
      echo "just wait a moment,mysql is Extracting..."
      tar zxf mysql-5.5.56-linux-glibc2.5-x86_64.tar.gz
      # rename
      mv mysql-5.5.56-linux-glibc2.5-x86_64 mysql-5.5.56
      # mkdir dir mysql
      if [ ! -d $mysql_install_dir ]
        then
          mkdir -p $mysql_install_dir
      fi
      # move file to mysql_install_dir
      mv mysql-5.5.56/* /usr/local/mysql/
      # add user mysql
      useradd mysql -s /sbin/nologin -M
      # chown
      chown -R mysql.mysql /usr/local/mysql
      # change dir
      cd $mysql_install_dir
      # install mysql
      ./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data
      # mv my.cnf
      [ $(echo $?) -eq 0 ] && \cp support-files/my-medium.cnf /etc/my.cnf
      # mv mysql.server
      cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
      # chmod +x
      chmod +x /etc/init.d/mysqld
      # add to boot auto launch
      chkconfig --add mysqld
      chkconfig mysqld on
      # add to PATH
      PATH=$PATH:/usr/local/mysql/bin/
      echo "export PATH=$PATH:/usr/local/mysql/bin/" >>/etc/profile
      source /etc/profile
  fi   
}

# start mysql_server
start_mysql(){
  # start
  /etc/init.d/mysqld start   
  if [ $(netstat -lutnp|grep 3306|wc -l) -eq 1 ]
    then
      action "mysql starting success..."  /bin/true
  else
      echo "mysql starting fail,plaese check the service!"
  fi
}

# install php5.5.38
install_php(){
  # yum install something
  yum install zlib-devel openssl-devel openssl libxml2-devel libjpeg-devel libjpeg-turbo-devel libiconv-devel freetype-devel libpng-devel gd-devel libcurl-devel libxslt-devel libxslt-devel libmcrypt-devel mcrypt mhash -y
  # download php
  [ -e $dir ] && cd $dir
  wget $php_download_path
  if [ -f $php_name ]
    then
      echo 'php download success'
      # tar file
      tar zxf $php_name  && cd php-5.5.38
      # install php
      echo "Please hold on!The configure output message is so large so that I hide the output message!..."
      ./configure --prefix=/usr/local/php --with-mysql=/usr/local/mysql --with-iconv-dir=/usr/lcoal/libiconv --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --enable-short-tags --enable-zend-multibyte --enable-static --with-xsl --with-xsl --with-fpm-user=nginx --with-fpm-user=nginx --enable-ftp --enable-opcache=no >> /dev/null 2>&1
      [ $(echo $?) -eq 0 ] && ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib64/ && touch ext/phar/phar.phar
      make >> /dev/null 2>&1
      make install
      # copy php.ini
      cp php.ini-development /etc/php.ini
      # copy php-fpm
      cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
      cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm    
      # chmod +x
      chmod +x /etc/init.d/php-fpm  
      # add to PATH
      PATH=$PATH:/usr/local/php/bin/
      echo "export PATH=$PATH:/usr/local/php/bin/" >>/etc/profile
      source /etc/profile
      # add to boot auto launch
      chkconfig --add php-fpm
      chkconfig php-fpm  on
 fi
}

# start php-fpm
start_phpfpm(){
  # start
  /etc/init.d/php-fpm start
  if [ $(netstat -lutnp|grep 9000|wc -l) -eq 1 ]
    then
      action "php-fpm starting success..." /bin/true
  else
      echo "php-fpm starting fail,plaese check the service!"
  fi

}

# main function
main(){
   #create dir
   create_dir
   # install
   install_nginx
   sleep 3
   install_mysql
   sleep 3
   install_php
   # start
   start_nginx
   sleep 2
   start_mysql
   sleep 2
   start_phpfpm
}
main
