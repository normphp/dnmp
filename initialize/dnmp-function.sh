#!/bin/bash
# dnmp 版本号
dnmpVersions="1.0";
# 基本路径

# 快捷docker-compose命令
compose(){
  #可快速执行对应环境的compose命令   up   exec    build   down
  composeFile="${1}/build/docker-compose/docker-compose-${2}.yml"
  dockerComposeCli="docker-compose -f ${composeFile} ${3}"
  $dockerComposeCli
}
# 快捷获取目录
composeFile(){
  echo -e "\033[32m dnmp 目录  \033[0m"
  echo -e "\033[32m ${1} \033[0m"
  echo -e "\033[32m dnmp docker-compose 目录  \033[0m"
  echo -e "\033[32m ${1}/build/docker-compose/docker-compose-*.yml \033[0m"
}
# 快捷获取版本号
versions(){
    echo -e "\033[32m docker \033[0m"
    sudo docker -v
    echo -e "\033[32m docker-compose \033[0m"
    sudo docker-compose --version
    echo -e "\033[32m dnmp \033[0m"
    echo $dnmpVersions
}