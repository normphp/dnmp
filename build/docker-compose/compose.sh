#!/bin/bash
# 定义array
pattern_array=("php-fpm-7.1-universal" "php-fpm-7.3-universal" "php-fpm-7.4-universal" "php-fpm-7.1-swoole"  "php-fpm-7.1-swoole"  "php-fpm-7.1-swoole"  "php-fpm-7.1-full" "php-fpm-7.3-full" "php-fpm-7.4-full" "php-fpm-8.0-universal" )


for pattern in ${pattern_array[@]}
do
patternFile="${Path}/docker-compose-${pattern}.yml"

echo "version: '3.3'
services:
  php-fpm:
    image: "'${'"${pattern}_PHP_FPM_IMAGE}
  env_file:
    - .env
    ports:
      - "'"9000:${'"${pattern}_PHP_FPM_PORTS}"'"'"
    networks:
     - "'${'"${pattern}_PHP_FPM_NETWORKS}
     - dnmpNat
    volumes:
      - /docker/normphp/dnmp/data/www/:/www/:rw
      - /docker/normphp/dnmp/data/php/php-${pattern}.ini:/usr/local/etc/php/php.ini:ro
      - /docker/normphp/dnmp/data/php/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro
      - /docker/normphp/dnmp/data/php/php-fpm.d/:/usr/local/etc/php-fpm.d/:ro
      - /docker/normphp/dnmp/data/logs/php-fpm:/var/log/php-fpm:rw
    restart: always
    command: php-fpm
networks:
  dnmpNat:" > $patternFile
    # 写入文件
done




