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
  dockerComposeVCli="docker-compose -f ${composeFile} run --rm -w  /data/build/  php-fpm-${2}-build  composer -V"
  $dockerComposeVCli
  echo $dockerComposeCli
  echo "Local run path /docker/normphp/dnmp/data/build/${3}"
  echo "***************************************************"
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
  sudo mkdir -p ${root_dir}/build/docker-compose/php/${3}

  phpversion="php-fpm-"${3}

  # 写入Dockerfile
echo 'FROM normphp/dnmp-php:"'${phpversion}'-full'${archInfo}'"
MAINTAINER pizepei "pizepei@pizepei.com"
#更新安装依赖包和PHP核心拓展
RUN apk add --update --no-cache git
WORKDIR /data
' > ${root_dir}/build/docker-compose/php/${3}/Dockerfile
  # 写入compose配置文件
  # ssh 有安全隐患（暂时先用构建机器的配置）
echo "version: '3.3'
services:
  ${phpversion}-build:
    env_file:
    - .env
    build: ./php/${3}
    #image: normphp/dnmp-php:"${phpversion}-full${archInfo}"
    #    ports:
    #  - "9000:9000"
    networks:
     - dnmpNat
    volumes:
      - /docker/normphp/dnmp/data/build/:/data/build/:rw
      - ~/.ssh/:/root/.ssh/:ro
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
