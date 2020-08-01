#!/bin/bash
# 定义array
pattern_array=("deploy" "develop" "production" "basics")

for pattern in ${pattern_array[@]}
do
patternFile="${Path}/docker-compose-${pattern}.yml"
phpFpmPorts='"9000:9000"'
nginxPorts1='"443:443"'
nginxPorts2='"80:80"'
nginxPorts3='"8080:8080"'
mysqlPorts='"3306:3306"'
redisPorts='"6379:6379"'
networks='"dnmp-nat"'

echo "version: '3.3'
services:
  php-fpm:
    image: normphp/dnmp:php-fpm-${pattern}
    #build: ./php/
    ports:
      - ${phpFpmPorts}
   networks:
      - ${networks}
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
   networks:
      - ${networks}
    volumes:
      - /docker/normphp/dnmp/data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro
      - /docker/normphp/dnmp/data/nginx/logs/:/var/log/nginx/:rw
      - /docker/normphp/dnmp/data/nginx/conf/:/etc/nginx/conf/:ro
      - /docker/normphp/dnmp/data/nginx/logs/:/wwwlogs/:rw
      - /docker/normphp/dnmp/data/www/:/www/:rw
    ports:
      - ${nginxPorts1}
      - ${nginxPorts2}
      - ${nginxPorts3}
    restart: always
    command: nginx -g 'daemon off;'

  mysql-db:
    build: ./mysql
    ports:
      - ${mysqlPorts}
   networks:
      - ${networks}
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
      - ${redisPorts}
   networks:
      - ${networks}
    volumes:
      - /docker/normphp/dnmp/data/redis:/data
    restart: always" > $patternFile
    # 写入文件
done




