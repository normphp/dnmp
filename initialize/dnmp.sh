#!/bin/bash
# 更新
cat /etc/redhat-release
yum -y update
yum  -y install vim git gcc automake autoconf libtool cmake git  \
        libfreetype6-dev libjpeg62-turbo-dev  \
        openssl libpng-dev  libssl-dev

Path=$(readlink -f "$(dirname "$0")")
echo "创建目录：/docker/normphp/dnmp/rc"
sudo mkdir -p /docker/normphp/dnmp/rc
`sudo cp -r ${Path}/rc.sh /docker/normphp/dnmp/rc/rc.sh`
echo "设置开机执行sudo bash /docker/normphp/dnmp/rc/rc.sh"
sudo echo "sudo bash /docker/normphp/dnmp/rc/rc.sh" >> /etc/rc.local
sudo chmod +x  /etc/rc.local
sudo chmod 755 /etc/rc.local
#******************安装decker ******************
echo '安装docker'
# curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
curl -sSL https://get.daocloud.io/docker | sh
echo '启动docker'
sudo systemctl start docker
echo '设置开机启动'
sudo systemctl enable docker.service
sudo systemctl is-enabled docker
docker -v