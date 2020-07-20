#!/bin/bash
# 查看系统信息
cat /etc/redhat-release
yum update
yum  -y install vim git gcc automake autoconf libtool cmake git  \
        libfreetype6-dev libjpeg62-turbo-dev  \
        openssl libpng-dev  libssl-dev
# 临时修改参数
# 更多优化配置请参考https://blog.csdn.net/junchow520/article/details/103030867
ulimit -n
ulimit -n 65535
# ******************一下需要人工自行根据需要配置******************
# 增加虚拟内存（注意：1、开启虚拟内存会增加cpu压力。2、硬盘io在100m/s下不建议开启）
# 基本安全配置    修改ssh端口  防火墙
#******************安装decker ******************
#  curl -sSL https://get.daocloud.io/docker | sh
#  curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
curl -sSL https://get.daocloud.io/docker | sh
sudo systemctl start docker
docker -v