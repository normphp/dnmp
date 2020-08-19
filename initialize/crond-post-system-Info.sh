#!/bin/bash
export root_dir=$(dirname $(pwd))

source ${root_dir}/initialize/config.sh
source ${root_dir}/initialize/dnmp-function.sh
# 判断是否开启
if [ ${CentreServe}x = "on"x ];then
  if [ ${CentreServePostSystemInfoRouter}x != ""x ];then
      # 循环请求 5s  10n
      dint=1
      while(( ${dint}<=10 ))
      do
          # 开始 获取信息
          getSystemInfo
          postSystemInfo=`cat postSystemInfo.txt`
          # 进行请求
          curl  -X POST -H 'Content-type':'application/json' -d "${postSystemInfo}" "${CentreServeAPI}${CentreServePostSystemInfoRouter}"
          # 进行计数
          echo
          echo $dint
          let "dint++"
          sleep 5
      done
  fi
fi
