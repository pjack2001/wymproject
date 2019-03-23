version: '3.1'

services:
  db:
    image: mariadb:10.4
    command: [--transaction-isolation=READ-COMMITTED --binlog-format=ROW,--default-authentication-plugin=mysql_native_password]
    restart: always
    volumes:
      - type: bind
        source: ./mydata
        target: /var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=newcapecwym
      - MYSQL_PASSWORD=newcapecwym
      - MYSQL_DATABASE=nextclouddb
      - MYSQL_USER=nextcloud

  adminer:
    image: adminer:4.7
    restart: always
    ports:
      - 8005:8080

  nextcloud:
    image: nextcloud:15.0.5-apache
    ports:
      - 8006:80
    links:
      - db
    volumes:
      - type: bind
        source: ./html
        target: /var/www/html
    restart: always

  wordpress:
    image: wordpress:5.1.1
    restart: always
    volumes:
      - type: bind
        source: ./html
        target: /var/www/html
    ports:
      - 8007:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: worduser
      WORDPRESS_DB_PASSWORD: wordpass
      WORDPRESS_DB_NAME: wordpressdb

