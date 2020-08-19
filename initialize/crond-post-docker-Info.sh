#!/bin/bash
export root_dir=$(dirname $(pwd))

source ${root_dir}/initialize/config.sh
source ${root_dir}/initialize/dnmp-function.sh
# 判断是否开启
if [ ${CentreServe}x = "on"x ];then
  if [ ${CentreServePostDockerInfoRouter}x != ""x ];then
      # 循环请求 5s  10n
      dint=1
      while(( $dint<=10 ))
      do
          # 开始 获取信息
          curl --unix-socket /var/run/docker.sock 'http:/containers/json?all=1&size=1'  >dockerContainers.txt
          dockerInfo=`cat dockerContainers.txt`;
          # 进行请求
          curl  -X POST -H 'Content-type':'application/json' -d "${dockerInfo}" "$CentreServeAPI$CentreServePostDockerInfoRouter"
          # 进行计数
          echo
          echo $dint
          let "dint++"
          sleep 5
      done
  fi
fi
