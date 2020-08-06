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

downloadPHPImages

yum  -y  install vim wget openssl
sudo
if [ $? -ne 0 ]; then
  yum  -y install  sudo
fi

#*********安装decker**********
installDocker ${1}
# 设置开机执行 rc.sh
startTask

#******************docker-compose ******************
echo '*********初始化 docker-compose*************'
cur_dir="$root_dir/build/docker-compose"
export cur_dir
dockerComposeBuild="${cur_dir}/ini.sh"
dockerComposeBuildChmdo="sudo chmod +x   ${dockerComposeBuild}"
$dockerComposeBuildChmdo

source  $dockerComposeBuild
# 初始化命令行
iniComposeCli $root_dir
pwd





