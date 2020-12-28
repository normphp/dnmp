#!/bin/bash

composer(){
  #这里的-f参数判断$myFile是否存在
if [ ! -f "/docker/normphp/dnmp/data/composer/composer.phar" ]; then
  downloadComposerPhar()
fi
  # 写入dev版本的 docker-compose.yml
  composeFile="${root_dir}/build/docker-compose/docker-compose-${1}-build.yml"
  setPHPComposerBuildYML() $composeFile $*
}
downloadComposerPhar(){
  wget https://install.phpcomposer.com/composer.phar -O /docker/normphp/dnmp/data/composer/composer.phar
}
# 写入 Build
setPHPComposerBuildYML(){
  archInfo=`arch`
  if [ ${archInfo}x = "x86_64"x ];then
    archInfo=''
    echo ${archInfo}
  elif [ ${archInfo}x = "aarch64"x ];then
    echo ${archInfo}
    archInfo='-arm'
  else
    echo ${archInfo}
    echo '只支持x86_64、aarch64'
    exit
  fi
  # 写入配置文件
echo "version: '3.3'
services:
  ${3}-build:
    env_file:
    - .env
    image: normphp/dnmp-php:"${3}-${full}${archInfo}"
    #    ports:
    #  - "9000:9000"
    networks:
     - dnmpNat
    volumes:
      - /docker/normphp/dnmp/data/build/:/data/:rw
      - /docker/normphp/dnmp/data/composer/composer.phar:/usr/local/bin/composer:ro
      - /docker/normphp/dnmp/data/php/etc/"${3}"/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro
      - /docker/normphp/dnmp/data/php/etc/"${3}"/php.ini-development:/usr/local/etc/php/php.ini:ro
      - /docker/normphp/dnmp/data/php/etc/"${3}"/php-fpm.d/:/usr/local/etc/php-fpm.d/:ro
      - /docker/normphp/dnmp/data/logs/"${3}":/var/log/php-fpm:rw
    restart: always
    command: php-fpm
networks:
  dnmpNat:" > $composeFile
}