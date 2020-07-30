#!/bin/bash
# 更新
cat /etc/redhat-release
# yum -y update
yum  -y -q install vim wget openssl

#******************安装decker ******************
sudo docker -v
if [ $? -ne 0 ]; then
    echo '安装docker' \
    & curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    #wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.1.el7.x86_64.rpm \
    #&& sudo yum -y install ./containerd.io-1.2.13-3.1.el7.x86_64.rpm && rm -rf containerd.io-1.2.13-3.1.el7.x86_64.rpm \
    # curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    docker -v
    if [ $? -ne 0 ]; then
      dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
      if [ $? -ne 0 ]; then
        echo -e "\033[31m 安装Dockers失败 \033[0m" && exit
      fi
    else
        echo -e "\033[32m 安装Docker成功 \033[0m"
    fi
    echo '启动docker' \
    &&  sudo systemctl start docker \
    &&  echo '设置开机启动' \
    &&  sudo systemctl enable docker.service \
    &&  sudo systemctl is-enabled docker \
    &&  docker -v
    Path=$(readlink -f "$(dirname "$0")")
    echo "创建目录：/docker/normphp/dnmp/rc" \
    && sudo mkdir -p /docker/normphp/dnmp/rc  \
    && `sudo cp -r ${Path}/rc.sh /docker/normphp/dnmp/rc/rc.sh`
else
    echo "已安装Docker"
fi
# 设置开机执行 rc.sh
if [ `grep "/docker/normphp/dnmp/rc/rc.sh" /etc/rc.local  &>> error.txt` ] ;then
  echo -e "\033[32m 已存在设置开机执行rc.sh配置  \033[0m"
  cat /etc/rc.local
else
  echo 'no error find in file.txt'
    echo "设置开机执行sudo bash /docker/normphp/dnmp/rc/rc.sh" \
    && sudo echo "sudo bash /docker/normphp/dnmp/rc/rc.sh" >> /etc/rc.local \
    && sudo chmod +x  /etc/rc.local \
    && sudo chmod 755 /etc/rc.local
fi

#******************docker-compose ******************
echo '初始化 docker-compose'
cur_dir="$(dirname $(pwd))/build/docker-compose"
export cur_dir
echo $cur_dir
`sudo chmod +x   ${cur_dir}/ini.sh`
cli="${cur_dir}/ini.sh"
source  $cli
