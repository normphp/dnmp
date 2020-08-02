#!/bin/bash
# dnmp 版本号
dnmpVersions="1.0";
# 基本路径

# 快捷docker-compose命令
compose(){
  #可快速执行对应环境的compose命令   up   exec    build   down
  composeFile="${1}/build/docker-compose/docker-compose-${2}.yml"
  dockerComposeCli="docker-compose -f ${composeFile} ${3} ${4} ${5} ${6} ${7} ${8} ${9}"
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
    echo -e "\033[32m Linux OS \033[0m"
    cat /etc/redhat-release
}
# 安装docker
installDocker(){
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

}
# 设置启动任务
startTask(){
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
}