#!/bin/bash
# 开启alias扩展功能
# 注册docker-compose 相关命令
iniComposeCli(){
echo '#!/bin/bash
export root_dir='${1}'
cd "${root_dir}/build/docker-compose/"
source ${root_dir}/initialize/config.sh
source ${root_dir}/initialize/dnmp-function.sh
source ${root_dir}/initialize/dnmp-composer.sh
source ${root_dir}/initialize/dev-ops-build-function.sh
if [ ${1}x = "dome"x ];then
  compose  $*
elif [ ${1}x = "php-fpm"x ];then
  #php-fpm版本选择器
 phpFpmCompose  $*
elif [ ${1}x = "nginx"x ];then
 compose $*
 elif [ ${1}x = "deploy"x ];then
 deployDocker $*
elif [ ${1}x = "systemInfo"x ];then
 postSystemInfo  $*
elif [ ${1}x = "upstream"x ];then
 compose  $*
elif [ ${1}x = "redis"x ];then
 compose  $*
elif [ ${1}x = "diy-php-fpm"x ];then
 compose  $*
elif [ ${1}x = "mysql"x ];then
 compose  $*
elif [ ${1}x = "postgresql"x ];then
 compose  $*
elif [ ${1}x = "config"x ];then
 getConfig  $*
elif [ ${1}x = "ifBuildSshKey"x ];then
 ifBuildSshKey  $*
elif [ ${1}x = "installNodejs"x ];then
 installNodejs  $*
elif [ ${1}x = "appSSHKYEMandate"x ];then
 appSSHKYEMandate  $*
elif [ ${1}x = "-f"x ];then
 composeFile $root_dir $*
elif [ ${1}x = "-v"x ];then
 versions $root_dir $*
elif [ ${1}x = "tls"x ];then
  tlsInit $root_dir $*
elif [ ${1}x = "updateDnmp"x ];then
  updateDnmpSh $root_dir
elif [ ${1}x = "startDevOps"x ];then
  startDevOps $root_dir   $*
elif [ ${1}x = "initDevOps"x ];then
  initDevOps $root_dir   $*
elif [ ${1}x = "stopDevOps"x ];then
  stopDevOps $root_dir   $*
elif [ ${1}x = "devOpsDocument"x ];then
  devOpsDocument $root_dir   $*
elif [ ${1}x = "composer"x ];then
  composer  $*
elif [ ${1}x = "update"x ];then
update  $root_dir $*
else
   echo -e "
  dnmp是一个代替[docker-compose -f docker-compose-xxx.yml]部分命令的快捷命令
  第一个参数是需要操作的环境：

  \033[32m nginx \033[0m          nginx[常规nginx]
  \033[32m php-fpm \033[0m        php-fpm[php-fpm]
  \033[32m upstream \033[0m       负载均衡服务[只包含nginx 通常做反向代理负载均衡]

  \033[32m deploy \033[0m         快速部署[在config.sh中deployDocker配置的容器集合]

  \033[32m redis \033[0m          Redis[只包含Redis]
  \033[32m mysql \033[0m          Mysql[只包含Mysql]
  \033[32m postgresql \033[0m          PostgreSql[只包含PostgreSql]

  \033[32m diy-php-fpm \033[0m   diy-php-fpm[只包含php-fpm]

  \033[32m -f \033[0m            docker-compose-xxx.yml文件所在路径
  \033[32m -v \033[0m            当前各软件版本
  \033[32m update \033[0m        更新dnmp[只更新sh脚本其他文件不更新]
  \033[32m systemInfo \033[0m    查看当前系统服务状态
  \033[32m config \033[0m        查看配置可选参数[dnmp|compose]

  后面的参数与与docker-compose命令完全一致：
  dnmp dome up
  相当于：docker-compose -f docker-compose-dome.yml up

  composer 命令
  \033[32m composer [phpVersions] [cli] \033[0m
    如使用php7.4执行composer ：
      dnmp composer 7.4 [.PATH] install
      [.PATH]为/docker/normphp/dnmp/data/build/下的相对路径
  DevOps 服务命令

  \033[32m devOpsDocument\033[0m DevOps服务文档
  \033[32m initDevOps \033[0m    初始化DevOps服务
  \033[32m startDevOps \033[0m   启动DevOps服务
  \033[32m stopDevOps \033[0m    停止DevOps服务

  其他服务
  \033[32m tls \033[0m           https tls 管理[在acme.sh的基础上实现主要用在自动化跨服务器管理]
"
fi
# 返回上一次目录
cd - >>null
' > ${root_dir}/initialize/dnmp.sh
  shopt expand_aliases
  shopt -s  expand_aliases
  sudo chmod +x ./dnmp.sh
  sudo chmod +x ./dnmp-function.sh
  sudo chmod +x ./cli-register.sh

  # source ~/.bashrc
  echo -e "\033[32m 开始注册dnmp快捷命令  \033[0m"
  grep '/dnmp.sh' ~/.bashrc
  if [ $? -eq 0 ];then
      echo -e "\033[32m 已经注册dnmp快捷命令  \033[0m"
      source ~/.bashrc
  else
    echo '未注册dnmp快捷命令！现在进行注册'
    sudo echo "alias dnmp='sudo bash ${root_dir}/initialize/dnmp.sh'">>~/.bashrc
    # alias dnmp='cd '${root_dir}'/initialize && sudo bash ./dnmp.sh'
    source ~/.bashrc
  fi
}

