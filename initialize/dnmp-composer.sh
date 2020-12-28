#!/bin/bash
composer(){
  #这里的-f参数判断$myFile是否存在
  # shellcheck disable=SC1035
    composerPharPATH="/docker/normphp/dnmp/data/composer/composer.phar"
    sudo chmod +x $composerPharPATH
    if [ ! -f $composerPharPATH ];then
       wget https://install.phpcomposer.com/composer.phar -O /docker/normphp/dnmp/data/composer/composer.phar
    fi
  # 写入dev版本的 docker-compose.yml
  composeFile="${root_dir}/build/docker-compose/docker-compose-${2}-build.yml"
  setPHPComposerBuildYML $composeFile $*
  echo $composeFile
  dockerComposeCli="docker-compose -f ${composeFile} run --rm -w  /data/build/${3} php-fpm-${2}-build  composer ${4} ${5} ${6} ${7} ${8} ${9}"
  echo $dockerComposeCli
  ##run --rm -w /root/  php-fpm-7.3-build pwd
  $dockerComposeCli

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
  phpversion="php-fpm-"${3}
  # 写入配置文件
echo "version: '3.3'
services:
  ${phpversion}-build:
    env_file:
    - .env
    image: normphp/dnmp-php:"${phpversion}-full${archInfo}"
    #    ports:
    #  - "9000:9000"
    networks:
     - dnmpNat
    volumes:
      - /docker/normphp/dnmp/data/build/:/data/build/:rw
      - /docker/normphp/dnmp/data/composer/composer.phar:/usr/local/bin/composer:rw
      - /docker/normphp/dnmp/data/php/etc/"${phpversion}"/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro
      - /docker/normphp/dnmp/data/php/etc/"${phpversion}"/php.ini-development:/usr/local/etc/php/php.ini:ro
      - /docker/normphp/dnmp/data/php/etc/"${phpversion}"/php-fpm.d/:/usr/local/etc/php-fpm.d/:ro
      - /docker/normphp/dnmp/data/logs/"${phpversion}":/var/log/php-fpm:rw
    restart: always
    command: php-fpm
networks:
  dnmpNat:" > ${1}
}
