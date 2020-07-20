#!/bin/bash
# 定义array
pattern_array=("deploy" "develop" "production" "basics")

for pattern in ${pattern_array[@]}
do
patternFile="docker-compose-${pattern}.yml"
echo "version: '3.3'
services:
  php-fpm:
    image: normphp/dnmp:php-fpm-${pattern}
    #build: ./php/
    ports:
      - ‘9000:9000‘
    links:
      - mysql-db:mysql-db
      - redis-db:redis-db
    volumes:
      - /docker/normphp/dnmp/data/www/:/www/:rw
      - /docker/normphp/dnmp/data/php/php-${pattern}.ini:/usr/local/etc/php/php.ini:ro
      - /docker/normphp/dnmp/data/php/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro
      - /docker/normphp/dnmp/data/php/php-fpm.d/:/usr/local/etc/php-fpm.d/:ro
      - /docker/normphp/dnmp/data/logs/php-fpm:/var/log/php-fpm:rw
    restart: always
    command: php-fpm

  nginx:
    build: ./nginx
    depends_on:
      - php-fpm
    links:
      - php-fpm:php-fpm
    volumes:
      - /docker/normphp/dnmp/data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro
      - /docker/normphp/dnmp/data/nginx/conf/:/etc/nginx/conf/:ro
      - /docker/normphp/dnmp/data/www/:/www/:rw
      - /docker/normphp/dnmp/data/nginx/logs/:/wwwlogs/:rw
    ports:
      - ‘443:443‘
      - ‘80:80‘
      - ‘8080:8080‘
    restart: always
    command: nginx -g 'daemon off;'

  mysql-db:
    build: ./mysql
    ports:
      - ‘3306:3306‘
    volumes:
      - /docker/normphp/dnmp/data/mysql:/var/lib/mysql:rw
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      MYSQL_DATABASE: zphaldb
      MYSQL_USER: zphal
      MYSQL_PASSWORD: zphal123
    restart: always
    command: ‘--character-set-server=utf8‘

  redis-db:
    build: ./redis
    ports:
      - ’6379:6379‘
    volumes:
      - /docker/normphp/dnmp/data/redis:/data
    restart: always" >> $patternFile
done


# 写入文件

