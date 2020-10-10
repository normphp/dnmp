#!/bin/bash
# 临时修改参数
# 更多优化配置请参考https://blog.csdn.net/junchow520/article/details/103030867
cat /etc/redhat-release
ulimit -n
ulimit -n 65535
# ******************一下需要人工自行根据需要配置******************
# 增加虚拟内存（注意：1、开启虚拟内存会增加cpu压力。2、硬盘io在100m/s下不建议开启）
# 基本安全配置    修改ssh端口  防火墙
root_dir=$(dirname $(pwd))
export root_dir
echo $root_dir
# 引入文件包含
source ${root_dir}'/initialize/dnmp-function.sh'
source  ${root_dir}'/initialize/cli-register.sh'
# 选择phpImages文件
downloadPHPImages
# 设置开机执行 rc.sh
startTask
# 初始化命令行
iniComposeCli $root_dir
setCrond
pwd


