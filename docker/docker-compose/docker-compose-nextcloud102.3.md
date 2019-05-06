version: '3.1'

services:
  db:
    image: mariadb:10.4
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
      - MYSQL_DATABASE=ncdb
      - MYSQL_USER=ncuser

  adminer:
    image: adminer:4.7
    restart: always
    container_name: adminer_w
    hostname: adminer_w
    ports:
      - 8005:8080

  nextcloud:
    image: nextcloud:15.0.5-apache
    restart: always
    container_name: nextcloud_w
    hostname: nextcloud_w
    volumes:
      - ./html/nextcloud:/var/www/html
    ports:
      - 8006:80
    links:
      - db
