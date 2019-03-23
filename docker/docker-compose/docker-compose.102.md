version: '3.1'

services:
  db:
    image: mariadb:10.4
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    container_name: mariadb_w
    hostname: mariadb_w
    ports:
      - 8306:3306
    volumes:
      - ./mydata/mysqldata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=newcapecwym
      - MYSQL_PASSWORD=newcapecwym
      - MYSQL_DATABASE=nextclouddb
      - MYSQL_USER=ncuser
      - MYSQL_DATABASE=wordpressdb
      - MYSQL_USER=wpuser

  adminer:
    image: adminer:4.7
    restart: always
    container_name: adminer_w
    hostname: adminer_w
    ports:
      - 8005:8080

  nextcloud:
    image: nextcloud:15.0.5-apache
    container_name: nextcloud_w
    hostname: nextcloud_w
    ports:
      - 8006:80
    links:
      - db
    volumes:
      - ./html/nextcloud:/var/www/html
    restart: always

  wordpress:
    image: wordpress:5.1.1
    restart: always
    container_name: wordpress_w
    hostname: wordpress_w
    volumes:
      - ./html/wordpress:/var/www/html
    ports:
      - 8007:80
    environment:
      WORDPRESS_DB_PASSWORD: newcapecwym