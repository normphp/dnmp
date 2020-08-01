#!/bin/bash
# 临时修改参数
# 更多优化配置请参考https://blog.csdn.net/junchow520/article/details/103030867
cat /etc/redhat-release
ulimit -n
ulimit -n 65535
# ******************一下需要人工自行根据需要配置******************
# 增加虚拟内存（注意：1、开启虚拟内存会增加cpu压力。2、硬盘io在100m/s下不建议开启）
# 基本安全配置    修改ssh端口  防火墙

yum  -y  install vim wget openssl
sudo
if [ $? -ne 0 ]; then
  yum  -y install  sudo
fi
#******************安装decker ******************
sudo docker -v
if [ $? -ne 0 ]; then
    echo '安装docker'

    if [ ${1}x = "cn"x ];then
      # cn 使用阿里云
      curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    elif [ ${1}x = "usa"x ];then
      # usa 使用docker官方
      curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
    else
      # 默认使用阿里云
      curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    fi

    #wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.1.el7.x86_64.rpm \
    #&& sudo yum -y install ./containerd.io-1.2.13-3.1.el7.x86_64.rpm && rm -rf containerd.io-1.2.13-3.1.el7.x86_64.rpm \
    # curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    docker -v
    if [ $? -ne 0 ]; then
      sudo dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm \
      && curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
      if [ $? -ne 0 ]; then
        echo -e "\033[31m 安装Docker失败 \033[0m" && exit
      fi
    else
        echo -e "\033[32m *****************安装Docker成功*************** \033[0m"
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
grep '/docker/normphp/dnmp/rc/rc.sh' /etc/rc.local
if [  $? -eq 0  ] ;then
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
echo '*********初始化 docker-compose*************'
root_dir=$(dirname $(pwd))
cur_dir="$root_dir/build/docker-compose"
export cur_dir
dockerComposeBuild="${cur_dir}/ini.sh"
dockerComposeBuildChmdo="sudo chmod +x   ${dockerComposeBuild}"
dockerComposeBuildChmdo
source  $dockerComposeBuild
source  cli-register.sh
pwd





