#!/bin/bash
# dnmp 版本号
dnmpVersions="1.0";
# 基本路径

# 快捷docker-compose命令
compose(){
  #可快速执行对应环境的compose命令   up   exec    build   down
  composeFile="${dir_path}/build/docker-compose/docker-compose-${1}.yml"
  dockerComposeCli="docker-compose -f ${composeFile} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9}"
  $dockerComposeCli
}
# 选择php-fpm版本
phpFpmVersions(){
 # 选择php-fpm版本
  while true;do
  stty -icanon min 0 time 100
  echo -n -e '\033[32m
  1、PHP 7.1
  2、PHP 7.3
  3、PHP 7.4
  4、PHP 8.0
  \033[0m
  请输入序号选择选择PHP版本? \033[5m (10s无操作默认1): \033[0m'
  read Arg
  case $Arg in
  1)
  export phpFpmVersions='php-fpm-7.1'
    break;;
  2)
  export phpFpmVersions='php-fpm-7.3'
    break;;
  3)
  export phpFpmVersions='php-fpm-7.4'
    break;;
  4)
  export phpFpmVersions='php-fpm-8.0'
    break;;
  "")  #Autocontinue
  export phpFpmVersions='php-fpm-7.1'
    break;;
  esac
  done
  echo '*****************************'
  echo -e "\033[32m 使用：${phpFpmVersions}\033[0m"
  echo '*****************************'
  return $phpFpmVersions
}
#选择环境版本
phpFpmPattern(){

   # 选择环境版本
  while true;do
  stty -icanon min 0 time 100
  echo -n -e '\033[32m
  1、universal  通用版[只含gd、pdo、redis扩展]
  2、swoole     swoole版[通用版基础上增加swoole扩展]
  3、full       整版[通用版基础上增加ssh2、xdebug、swoole、MongoDB扩展]
  4、diy        DIY
  \033[0m
  请输入序号选择环境版本? \033[5m (10s无操作默认1): \033[0m'
  read Arg
  case $Arg in
  1)
  export phpFpmPattern='universal'
    break;;
  2)
  export phpFpmPattern='swoole'
    break;;
  3)
  export phpFpmPattern='full'
    break;;
  "")  #Autocontinue
  export phpFpmPattern='universal'
    break;;
  esac
  done

  echo '*****************************'
  echo -e "\033[32m 使用：${phpFpmPattern}\033[0m"
  echo '*****************************'
}
phpFpmCompose(){
  phpFpmVersions
  phpFpmPattern

  composeFile="${dir_path}/build/docker-compose/docker-compose-${phpFpmVersions}-${phpFpmPattern}.yml"
# 写入配置文件
echo "version: '3.3'
services:
  ${phpFpmVersions}:
    env_file:
    - .env
    image: normphp/dnmp-php:"${phpFpmVersions}-${phpFpmPattern}"
    #    ports:
    #  - "9000:9000"
    networks:
     - dnmpNat
    volumes:
      - /docker/normphp/dnmp/data/www/:/www/:rw
      - /docker/normphp/dnmp/data/php/etc/"${phpFpmVersions}"/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro
      - /docker/normphp/dnmp/data/php/etc/"${phpFpmVersions}"/php.ini-development:/usr/local/etc/php/php.ini:ro
      - /docker/normphp/dnmp/data/php/etc/"${phpFpmVersions}"/php-fpm.d/:/usr/local/etc/php-fpm.d/:ro
      - /docker/normphp/dnmp/data/logs/"${phpFpmVersions}":/var/log/php-fpm:rw
    restart: always
    command: php-fpm
networks:
  dnmpNat:" > $composeFile

  echo $composeFile
  #可快速执行对应环境的compose命令   up   exec    build   down
  dockerComposeCli="docker-compose -f ${composeFile} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9}"
  $dockerComposeCli
}
# 快捷获取目录
composeFile(){
  echo -e "\033[32m dnmp 目录  \033[0m"
  echo -e "\033[32m ${dir_path}/initialize/dnmp.sh \033[0m"
  echo -e "\033[32m dnmp docker-compose 目录  \033[0m"
  echo -e "\033[32m ${dir_path}/build/docker-compose/docker-compose-*.yml \033[0m"
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
      if [ ${dockerResourceType}x = "CN"x ];then
        echo -e "\033[32m cn 源安装docker \033[0m"
        # cn 使用阿里云
        curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
      elif [ ${dockerResourceType}x = "USA"x ];then
        # usa 使用docker官方
        echo -e "\033[32m usa 使用docker官方源安装docker \033[0m"
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
tlsInit(){
  # 执行acme.sh命令判断命令是否存在、不存在执行安装命令、并且注册快捷命令
  grep 'acme.sh' ~/.bashrc
  if [  $? -eq 0  ] ;then
    echo -e "\033[32m 已安装acme.sh  \033[0m"
  else
    echo -e "\033[31m 没有安装acme.sh 现在进行安装 \033[0m"
    sudo yum -y install socat first
    curl  https://get.acme.sh | sh
  fi
  # 开始命令
  tlsManage $*
}
tlsManage(){
  #bash /root/.acme.sh/acme.sh
  # 进行命令拆分  add 域名
  # updateTls
  echo ${3}
  if [ ${3}x = "update-tls"x ];then
    # acme.sh更新tls时 触发的
    updateTls ${4} ${5} ${6} ${7} ${8} ${9}
  else
     echo -e "
      xxxxx
  "
  fi
}
updateTls(){
  echo ${1}${2}>>"${dir_path}/name.txt"
  echo date>>"${dir_path}/ccccc.txt"
  # docker exec -it nginx-upstream service nginx force-reload
  # acme.sh更新tls时 触发的
  # 创建文件夹
  # 复制文件到对应目录   写入日志文件
  # curl post 到对应的 服务中心

  # 由服务中心的php项目使用ssh2 链接跳板机 把证书 复制到对应的负载均衡服务上 并且执行命令重启负载均衡nginx
  #bash /root/.acme.sh/acme.sh

}
downloadPHPImages(){
  cpDockerfile='sudo cp -r dnmp-dockerfile-php-master/.  '${root_dir}'/build/docker-compose/php'
  echo $cpDockerfile
  wget https://github.com/normphp/dnmp-dockerfile-php/archive/master.tar.gz -O dnmp-dockerfile-php.tar.gz \
  && tar -zxvf dnmp-dockerfile-php.tar.gz \
  && rm -rf dnmp-dockerfile-php.tar.gz \
  && $cpDockerfile \
  && rm -rf dnmp-dockerfile-php-master
}
# POST 系统消息到一个服务中心  频率1s一次
postSystemInfo()
{
  # 系统运行时间
  uptime=`cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%d天%d时%d分%d秒",run_days,run_hour,run_minute,run_second)}'`
  redhatRelease=`cat /etc/redhat-release`
  unameM=`uname -m`
  hostname=`hostname`
  unameR=`uname -r`
  arch=`arch`
  cpu=`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`
  cpuLoad=`top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'`
  centosRelease=`cat /etc/centos-release`
  MemoryUsage=`free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'`
  Disk=`df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'`
cat > postSystemInfo.txt <<EOF
{"系统已运行":"${uptime}","cpu":"${cpu}","cpuLoad":"${cpuLoad}","Disk":"${Disk}","MemoryUsage":"${MemoryUsage}","centos-release":"${centosRelease}","arch":"${arch}","redhat-release":"${redhatRelease}","uname-m":"${unameM}","uname-r":"${unameR}","hostname":"${hostname}"}
EOF

  postSystemInfo=`cat postSystemInfo.txt`
#  curl -i -X POST -H 'Content-type':'application/json' -d {"BTime":""$btime""} http://api.baidu.com
  curl -i -X POST -H 'Content-type':'application/json' -d $postSystemInfo http://dev.heil.red/normphp/dome/route.json
  # 系统安装时间
}