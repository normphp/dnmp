#!/bin/bash
export dir_path=$(dirname $(pwd))

source ${dir_path}/initialize/config.sh
source ${dir_path}/initialize/dnmp-function.sh
# 判断是否开启
if [ ${CentreServe}x = "on"x ];then
  if [ ${CentreServePostSystemInfoRouter}x -ne ""x ];then
      # 循环请求 5s  10n
      int=1
      while(( ${int}<=5 ))
      do
          # 开始 获取信息
          getSystemInfo
          postSystemInfo=`cat postSystemInfo.txt`
          # 进行请求
          curl -i -X POST -H 'Content-type':'application/json' -d "${postSystemInfo}" $CentreServeAPI$CentreServePostSystemInfoRouter
          # 进行计数
          echo $int
          let "int++"
          sleep 5
      done
  fi
fi
