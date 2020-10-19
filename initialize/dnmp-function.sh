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

# 初始化  下载对应文件
initDevOps()
{
  # 删除历史遗留
  # 复制到 对应目录 处理压缩包
  # 下载前端文件
  rm -rf resource.zip resource /docker/normphp/dnmp/data/devops/code/devops-admin/resource/ \
  && sudo mkdir -p /docker/normphp/dnmp/data/devops/code/devops-admin/{resource,normphp} \
  && sudo mkdir -p /docker/normphp/dnmp/data/devops/data/{redis,mysql} \
  && wget http://nomphp.pizepei.com/DevOps/layuiAdmin/resource.zip \
  && unzip -o resource.zip \
  && sudo cp -r resource/. /docker/normphp/dnmp/data/devops/code/devops-admin/resource/ \
  && ls /docker/normphp/dnmp/data/devops/code/devops-admin/resource/

  # 下载后端文件
  cd ~ && rm -rf normphp.zip normphp /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/ \
  && sudo mkdir -p /docker/normphp/dnmp/data/devops/code/devops-admin/{resource,normphp} \
  && sudo mkdir -p /docker/normphp/dnmp/data/devops/data/{redis,mysql} \
  && wget wget -c "http://nomphp.pizepei.com/DevOps/layuiAdmin/normphp.zip?v=1" -O normphp.zip

  unzip -o normphp.zip \
  && sudo cp -r normphp/. /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/ \
  && chmod -R 707 /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/ \
  && ls /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/ \
  && ln -s ../config /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/config
  # 关于软连接 这里需要记录说明一下：
  #   比如说我们需要/docker/dnmp/devops-admin/config 源文件夹连接到 /docker/dnmp/devops-admin/下
  #   也就是在/docker/dnmp/devops-admin/normphp/下有 config文件夹
  #   但是软连接只是一个记录（/docker/dnmp/devops-admin/normphp/config 上记录了源文件地址），宿主机会容器实例的目录结构是不一致的，这样会导致在宿主机可以正常使用这个目录
  #   这个时候不能使用绝对路径，应该是先cd /docker/dnmp/devops-admin/normphp/ 到目标目录
  #   然后使用这个目录下的相对路径创建软连接 ln -s ../config   ./config  这个时候执行ll 或者ls -l命令就可以看到 config -> ../config 在容器里面也可以正常使用了
  #   绝对路径不是万能的

}
# 启动部署系统
startDevOps()
{
  #initDevOps
  setDevOps
}
setDevOps()
{
  # 确定端口
    while true;do
  stty -icanon min 0 time 100
  echo -n -e '\033[32m
  本运维部署系统后端为PHP开发、前端使用LayUiAdmin
  A、如果您只有当前一台服务器想在服务器上部署本运维部署系统同时又其他被部署的web项目也在当前服务器上建议您选择 第2选项
  （主要是http 80 443 端口冲突问题）
  B、如果您有N个服务器建议您选择第1选项
  *****************************************************************
  1、单独使用独立服务器安装运维部署系统（当前服务器不在部署其他web项目）
  2、我只有一台服务，运维部署系统和项目都不是在当前服务器
  \033[0m
  请输入数字序号选择选择模式? \033[5m (10s无操作默认1): \033[0m'
  read Arg
  case $Arg in
  1)
   pattern='1'
    break;;
  2)
   pattern='2'
    break;;
  "")  #Autocontinue
   pattern='1'
    break;;
  esac
  done
  echo '*****************************'
  echo -e "\033[32m 使用模式：${pattern}\033[0m"
  echo '*****************************'
  if [ ${pattern}x = "1"x ];then
    echo '';
  elif [ ${pattern}x = "2"x ];then

        while true;do
        stty -icanon min 0 time 100
        echo -n -e '请输入部署项目访问http端口(建议8000-8888)? \033[5m (10s无操作默认8888端口): \033[0m'
        read Arg
          case $Arg in
          "")  #Autocontinue
            nginxHttpPort=8888
            break;;
          esac
          nginxHttpPort=$Arg
          break;
        done


        while true;do
        stty -icanon min 0 time 100
        echo -n -e '\n由于https证书的配置问题设置好的端口配置在nginx中是暂时屏蔽的\n请输入部署项目访问https端口(建议4433-4488)? \033[5m (10s无操作默认4433端口): \033[0m'
        read Arg
        case $Arg in
        "")  #Autocontinue
          nginxHttpsPort=4433
          break;;
        esac
          nginxHttpsPort=$Arg
          break;
        done

        while true;do
        stty -icanon min 0 time 100
        echo -n -e '\n是否使用独立mysql容器? yes|no \033[5m (10s无操作默认yes): \033[0m'
        read Arg
        case $Arg in
        'yes')
         mysql='yes'
          break;;
        'no')
         mysql='no'
          break;;
        "")  #Autocontinue
         mysql='yes'
          break;;
        esac
        done

        while true;do
        stty -icanon min 0 time 100
        echo -n -e '\n请输入mysql端口(建议4306)? \033[5m (10s无操作默认4306端口): \033[0m'
        read Arg
        case $Arg in
        "")  #Autocontinue
          mysqlPort=4306
          break;;
        esac
          mysqlPort=$Arg
          break;
        done

    echo "模式：${pattern}"
    echo "http端口：${nginxHttpPort}"
    echo "https端口：${nginxHttpsPort}"
    echo "是否独立MySq：${mysql}"
    echo "MySq端口：${mysqlPort}"
  fi
  # nginx 配置
  echo "server {
    listen       ${nginxHttpPort};
    listen  [::]:${nginxHttpPort};
    #listen ${nginxHttpsPort} ssl;
    #listen  [::]:${nginxHttpsPort} ssl;
    index index.php index.html index.htm default.php default.htm default.html;
    # dnmp定义站点目录在/www/下，命名规范为/www/[项目代码|域名|系统代码]/[访问代码]
    root  /www/code/devops-admin/;
    # 域名：在负载均衡nginx上必须配置为真实域名，在负载均衡的下级服务nginx上必须配置为下文$ upstream_host变量对应的值
    # server_name  localhost;
    #********************** ssl https 配置 *****************************
    # ssl https 配置  如不需要开启请使用 # 屏蔽
    #include conf/snippets/ssl_certificate.conf;
    #include conf/snippets/ssl_certificate_path.conf;
    # 强制使用ssl
    #include conf/snippets/ssl_mandatory_usage.conf;
    #申请SSL证书验证目录相关设置完全允许访问.well-known/目录
    include conf/snippets/well_known.conf;
    #********************日志位置*******************************
    # 日志位置：命名规范为 域名.log | 域名.error.log
    access_log  /wwwlogs/localhost.log;
    error_log  /wwwlogs/localhost.error.log;
    location / {
        root   /www/code/devops-admin/;
        index  index.html index.htm;
    }
    #**********************pass服务*****************************
    #pass服务fastcgi_pass_php
    # 注意如单独启动nginx容器会提示php-fpm:9000不存在，应该屏蔽这个配置
    # 设置模式  jt  default
    set "'$frame_name'" 'default';
    # 设置运行环境模式 production  develop test
    set "'$run_mode'" production;
    location ~ [^/]\.php(/|$) {
         root   /www/code/devops-admin/;
        include conf/snippets/fastcgi_pass_php74_devops.conf;
    }
    #REWRITE-START URL重写规则引用（伪静态）,修改后将导致自动配置的伪静态规则失效
    include conf/rewrite/devops.conf;
    #********************默认配置一般情况下不需要修改*********************
    #禁止访问的文件或目录（这里是基础配置需要配置其他文件可以直接在对应的站点server中增加配置）
    include conf/snippets/forbid.conf;
    # Nginx 设置忽略favicon.ico文件的404错误日志(关闭favicon.ico不存在时记录日志)
    include conf/snippets/favicon.conf;
    # 错误页面 404  50x
    include conf/snippets/error_page.conf;
    # 静态资源 缓存配置
    include conf/snippets/static_cache.conf;

}" >/docker/normphp/dnmp/data/nginx/conf/default_devops.conf

mysqlTpl="  devops-mysql:
    env_file:
      - .env
    build: ./mysql
    ports:
      - "'"'"${mysqlPort}:3306"'"'"
    networks:
      - "'${NETWORKS}'"
    volumes:
      - /docker/normphp/dnmp/data/devops/data/mysql:/var/lib/mysql:rw
      - /docker/normphp/dnmp/data/devops/data/mysql-backups:/backups:rw
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    restart: always"

  if [ ${mysql}x = "no"x ];then
    mysqlTpl='';
  fi

  #docker-compose 文件
  echo "version: '3.3'
services:
  devops-php-fpm-7.4:
    env_file:
      - .env
    image: normphp/dnmp-php:php-fpm-7.4-full
    networks:
      - "'${NETWORKS}'"
    volumes:
      - /docker/normphp/dnmp/data/devops/:/www/:rw
      - /docker/normphp/dnmp/data/php/etc/php-fpm-7.4/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro
      - /docker/normphp/dnmp/data/php/etc/php-fpm-7.4/php.ini-development:/usr/local/etc/php/php.ini:ro
      - /docker/normphp/dnmp/data/php/etc/php-fpm-7.4/php-fpm.d/:/usr/local/etc/php-fpm.d/:ro
      - /docker/normphp/dnmp/data/logs/php-fpm-7.4:/var/log/php-fpm:rw
    restart: always
    command: php-fpm

  devops-nginx:
    env_file:
      - .env
    build: ./nginx
    depends_on:
      - devops-php-fpm-7.4
    networks:
      - "'${NETWORKS}'"
    volumes:
      - /docker/normphp/dnmp/data/nginx/conf/nginx_devops.conf:/etc/nginx/nginx.conf:ro
      - /docker/normphp/dnmp/data/nginx/logs/:/var/log/nginx/:rw
      - /docker/normphp/dnmp/data/nginx/conf/:/etc/nginx/conf/:ro
      - /docker/normphp/dnmp/data/nginx/logs/:/wwwlogs/:rw
      - /docker/normphp/dnmp/data/devops/:/www/:rw
    ports:
      - "'"'"${nginxHttpPort}:${nginxHttpPort}"'"'"
      - "'"'"${nginxHttpsPort}:${nginxHttpsPort}"'"'"
    restart: always
    command: nginx -g 'daemon off;'

  devops-redis:
    env_file:
      - .env
    build: ./redis
    networks:
      - "'${NETWORKS}'"
    volumes:
      - /docker/normphp/dnmp/data/redis:/data
    restart: always

${mysqlTpl}

networks:
  dnmpNat:">${root_dir}/build/docker-compose/docker-compose-devops.yml


}