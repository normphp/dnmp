#!/bin/bash
# dnmp 版本号
dnmpVersions="1.0";
# 基本路径

# 快捷docker-compose命令
compose(){
  #可快速执行对应环境的compose命令   up   exec    build   down
  composeFile="${root_dir}/build/docker-compose/docker-compose-${1}.yml"
  echo $composeFile
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
setDockerComposeYml()
{
  archInfo=`arch`
  if [ ${archInfo}x = "x86_64"x ];then
    archInfo=''
    echo ${archInfo}
  elif [ ${archInfo}x = "aarch64"x ];then
    echo ${archInfo}
    archInfo='-arm'
  else
    echo ${archInfo}
    echo '只支持x86_64、aarch64'
    exit
  fi
  # 写入配置文件
echo "version: '3.3'
services:
  ${phpFpmVersions}:
    env_file:
    - .env
    image: normphp/dnmp-php:"${phpFpmVersions}-${phpFpmPattern}${archInfo}"
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
  dnmpNat:" > ${1}
}
phpFpmCompose(){
  phpFpmVersions
  phpFpmPattern
  composeFile="${root_dir}/build/docker-compose/docker-compose-${phpFpmVersions}-${phpFpmPattern}.yml"
  setDockerComposeYml $composeFile
  echo $composeFile
  #可快速执行对应环境的compose命令   up   exec    build   down
  dockerComposeCli="docker-compose -f ${composeFile} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9}"
  $dockerComposeCli
}
# 快捷获取目录
composeFile(){
  echo -e "\033[32m dnmp 目录  \033[0m"
  echo -e "\033[32m ${root_dir}/initialize/dnmp.sh \033[0m"
  echo -e "\033[32m dnmp docker-compose 目录  \033[0m"
  echo -e "\033[32m ${root_dir}/build/docker-compose/docker-compose-*.yml \033[0m"
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
        #Centos6.8安装docker
        grep 'release 6.' /etc/redhat-release
        if [ $? -eq 0 ];then
            yum   -y  install  https://get.docker.com/rpm/1.7.1/centos-6/RPMS/x86_64/docker-engine-1.7.1-1.el6.x86_64.rpm
            docker -v
            if [ $? -ne 0 ]; then
                echo -e "\033[31m 安装Docker失败 \033[0m" && exit
            fi
        fi

        grep 'release 8.' /etc/redhat-release
        if [ $? -eq 0 ];then
          sudo dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm \
          && curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
          if [ $? -ne 0 ]; then
            echo -e "\033[31m 安装Docker失败 \033[0m" && exit
          fi
        fi
      else
          echo -e "\033[32m *****************安装Docker成功*************** \033[0m"
      fi

      registryMirrors='{
  "registry-mirrors" : [
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn",
    "http://hub-mirror.c.163.com",
    "https://cr.console.aliyun.com/"
  ]
}'
     echo ${registryMirrors}>/etc/docker/daemon.json


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
  echo ${1}${2}>>"${root_dir}/name.txt"
  echo date>>"${root_dir}/ccccc.txt"
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
# 获取新系统信息
getSystemInfo(){
  uptime=`cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%d天%d时%d分%d秒",run_days,run_hour,run_minute,run_second)}'`
  redhatRelease=`cat /etc/redhat-release`
  unameM=`uname -m`
  hostname=`hostname`
  unameR=`uname -r`
  arch=`arch`
  cpu=`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`
  cpuLoad=`top -n1 | awk '/Cpu/{print $2}'`
  cpuId=`dmidecode -t 4 | grep ID |sort -u |awk -F': ' '{print $2}'`
  # 物理cpu数量
  cpuPhysicalCount=`cat /proc/cpuinfo | grep 'physical id' | sort | uniq | wc -l`
  cpuProcessorCount=`cat /proc/cpuinfo | grep 'processor' | wc -l`
  centosRelease=`cat /etc/centos-release`
  #MemoryUsage=`free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'`
  MemoryUsed=`free -m | awk 'NR==2{printf "%s", $3 }'`
  MemoryAll=`free -m | awk 'NR==2{printf "%s", $2 }'`
  MemoryRatio=`free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }'`
  Disk=`df -h | awk '$NF=="/"{printf "%d", $5}'`
  DiskAll=`df -h | awk '$NF=="/"{printf "%d", $2}'`
  DiskUsed=`df -h | awk '$NF=="/"{printf "%d", $3}'`
  dateR=`date -R`

cat > postSystemInfo.txt <<EOF
{"dateR":"$dateR","DiskAll":"${DiskAll}","DiskUsed":"${DiskUsed}","uptime":"${uptime}","cpu":"${cpu}","MemoryUsed":"${MemoryUsed}","MemoryAll":"${MemoryAll}","MemoryRatio":"${MemoryRatio}","cpuProcessorCount":"${cpuProcessorCount}","cpuPhysicalCount":"${cpuPhysicalCount}","cpuId":"${cpuId}","cpuLoad":"${cpuLoad}","Disk":"${Disk}","centos_release":"${centosRelease}","arch":"${arch}","redhat_release":"${redhatRelease}","uname_m":"${unameM}","uname_r":"${unameR}","hostname":"${hostname}"}
EOF

}
# POST 系统消息到一个服务中心  频率1s一次
postSystemInfo()
{

  if [ ${CentreServe}x = "off"x ];then
    echo '未开启服务'
  else
    # 系统运行时间
    getSystemInfo
    postSystemInfo=`cat postSystemInfo.txt`
    curl -i -X POST -H 'Content-type':'application/json' -d "${postSystemInfo}" $CentreServeAPI
  fi
}
# 选择安装资源
setResourceType(){

if [ ${1}x = "CN"x ];then
  export  dockerResourceType='CN'
elif [ ${1}x = "USA"x ];then
  export  dockerResourceType='USA'
else
  while true;do
  stty -icanon min 0 time 100
  echo -n -e '\033[32m
  1、China（CN）
  2、America(USA)
  \033[0m
  请输入序号选择安装源类型? \033[5m (10s无操作默认1): \033[0m'

  read Arg
  case $Arg in
  1)
  export  dockerResourceType='CN'
    break;;
  2)
  export  dockerResourceType='USA'
    break;;
  "")  #Autocontinue
  export  dockerResourceType='CN'
    break;;
  esac
  done
fi
  echo '*****************************'
  echo -e"\033[16m 使用${dockerResourceType}安装源\033[0m"
  echo '*****************************'
}
# 增加设置
setConfig()
{
    grep 'dockerResourceType' ${root_dir}/initialize/config.sh
    if [ $? -ne 0 ];then
      sudo echo '# 使用的资源类型  cn  或者usa' >>${root_dir}/initialize/config.sh

      sudo echo 'export  dockerResourceType="'$dockerResourceType'"' >> ${root_dir}/initialize/config.sh
    fi

    grep 'root_dir' ${root_dir}/initialize/config.sh
    if [ $? -ne 0 ];then
      sudo echo '# 脚本目录root_dir ' >>${root_dir}/initialize/config.sh

      sudo echo 'export  root_dir="'$root_dir'"' >> ${root_dir}/initialize/config.sh
    fi
    sudo chmod +x ${root_dir}/initialize/config.sh
}
# 设置定时任务
setCrond(){

  # 判断是否已经设置开机启动crond
  grep 'crond' /etc/rc.local
  if [ $? -eq 0 ];then
      echo -e "\033[32m 已经设置开机启动crond  \033[0m"
  else
    echo '没有设置开机启动crond'
    sudo echo "/bin/systemctl start crond.service">>/etc/rc.local
  fi

  # 判断是否已经设置
  grep 'crond-hour.sh' /var/spool/cron/root
  if [ $? -eq 0 ];then
      echo -e "\033[32m 已经设置crond-hour \033[0m"

  else
    echo '没有设置crond-hour：正在设置'
    sudo echo "* * * * * cd ${root_dir}/initialize/ && sudo bash crond-hour.sh">>/var/spool/cron/root
  fi

  grep 'crond-minute.sh' /var/spool/cron/root
  if [ $? -eq 0 ];then
      echo -e "\033[32m 已经设置crond-minute.sh \033[0m"

  else
    echo '没有设置crond-minute：正在设置'
    sudo echo "* * * * * cd ${root_dir}/initialize/ && sudo bash crond-minute.sh">>/var/spool/cron/root
  fi


  grep 'crond-post-docker-Info.sh' /var/spool/cron/root
  if [ $? -ne 0 ];then
    sudo echo "* * * * * cd ${root_dir}/initialize/ && sudo bash crond-post-docker-Info.sh">>/var/spool/cron/root
  fi

  grep 'crond-post-system-Info.sh' /var/spool/cron/root
  if [ $? -ne 0 ];then
    echo '没有设置crond-minute：正在设置'
    sudo echo "* * * * * cd ${root_dir}/initialize/ && sudo bash crond-post-system-Info.sh">>/var/spool/cron/root
    grep 'crond-post-system-Info.sh' /var/spool/cron/root
  fi

  # 重新启动配置
  # /bin/systemctl reload crond
  # 重新启动 crond
  /bin/systemctl start crond
}
postDockerInfo(){
  info=`curl --unix-socket /var/run/docker.sock http:/info`
}
# 快速部署配置中的容器集合
deployDocker(){
  for pattern in ${deployDocker[@]}
  do
      echo "操作容器${pattern} ${2}"
      # 判断是否是php-fpm  是就生成yml文件
      if [ ${pattern}x == "php-fpm"x ]; then

          composeFile="${root_dir}/build/docker-compose/docker-compose-${deployDockerPhpFpmVersions}-${deployDockerPhpFpmPattern}.yml"
          export phpFpmPattern=$deployDockerPhpFpmPattern
          export phpFpmVersions=$deployDockerPhpFpmVersions
          setDockerComposeYml $composeFile
          pattern=${deployDockerPhpFpmVersions}-${deployDockerPhpFpmPattern}
      fi
      compose $pattern  ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9}
  done
}

# 获取配置文件
getConfig()
{
  config_dir="${root_dir}/initialize/config.sh"
  env_dir="${root_dir}/build/docker-compose/.env"

if [ ${1}x = "dnmp"x ];then
  echo -e "\033[32m ************* $config_dir ************* \033[0m"
  `cat ${config_dir}`
elif [ ${1}x = "compose"x ];then
  echo -e "\033[32m ************* $env_dir ************* \033[0m"
  `cat ${env_dir}`
else
  echo -e "\033[32m ************* $config_dir ************* \033[0m"
  cat ${config_dir}
  echo -e "\033[32m ************* $env_dir ************* \033[0m"
  cat ${env_dir}
fi

}
# 更新dnmp.sh
updateDnmpSh()
{
  echo $root_dir
  source  ${root_dir}'/initialize/cli-register.sh'
  iniComposeCli ${root_dir}
}


