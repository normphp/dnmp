#!/bin/bash
node(){
  #这里的-f参数判断$myFile是否存在
  # 写入dev版本的 docker-node.yml
  nodeFile="${root_dir}/build/docker-compose/docker-node-${2}-build.yml"
  setPHPNodeBuildYML $nodeFile $*
  echo "$nodeFile"
  dockerNodeCli="docker-compose -f ${nodeFile} run --rm -w  /data/build/${3} node-${2}-build  ${4} ${5} ${6} ${7} ${8} ${9}"

  dockerNodeVCli="docker-compose -f ${nodeFile} run --rm -w  /data/build/  node-${2}-build  node -v"
  $dockerNodeVCli

  echo $dockerNodeCli
  echo "Local run path /docker/normphp/dnmp/data/build/${3}"
  echo "***************************************************"
  $dockerNodeCli

}


# 写入 Build
setPHPNodeBuildYML(){
  sudo mkdir -p ${root_dir}/build/docker-compose/node/${3}
  nodeversion="node-"${3}
  echo $nodeversion
  # 写入Dockerfile
echo 'FROM  node:'"'${3}-alpine3.9'"'
MAINTAINER pizepei "pizepei@pizepei.com"
#更新安装依赖包和PHP核心拓展
# set timezome
RUN apk update && apk add curl bash tree tzdata \
        && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime \
        && echo -ne '"'Alpine Linux 3.4 image. (`uname -rsv`)\n'"' >> /root/.built \
&& npm install gulp -g \
&& mkdir /data
WORKDIR /data' > ${root_dir}/build/docker-compose/node/${3}/Dockerfile
  # 写入compose配置文件
  # ssh 有安全隐患（暂时先用构建机器的配置）
echo "version: '3.3'
services:
  ${nodeversion}-build:
    env_file:
    - .env
    build: ./node/${3}
    #    ports:
    #  - "9000:9000"
    networks:
     - dnmpNat
    volumes:
      - /docker/normphp/dnmp/data/build/:/data/build/:rw
      - ~/.ssh/:/root/.ssh/:ro
    restart: always
networks:
  dnmpNat:" > ${1}
}
