#!/bin/bash
# 开启alias扩展功能
shopt -s  expand_aliases
root_dir=$(dirname $(pwd))
# 注册docker-compose 相关命令
iniComposeCli(){
echo '#!/bin/bash
export dir_path='${root_dir}'
cd "${dir_path}/build/docker-compose/"
source ${dir_path}/initialize/dnmp-function.sh
if [ ${1}x = "deploy"x ];then
  compose $dir_path $*
elif [ ${1}x = "dome"x ];then
 compose $dir_path $*
elif [ ${1}x = "deploy"x ];then
 compose $dir_path $*
elif [ ${1}x = "develop"x ];then
 compose $dir_path $*
elif [ ${1}x = "upstream"x ];then
 compose $dir_path $*
elif [ ${1}x = "redis"x ];then
 compose $dir_path $*
elif [ ${1}x = "diy-php-fpm"x ];then
 compose $dir_path $*
elif [ ${1}x = "mysql"x ];then
 compose $dir_path $*
elif [ ${1}x = "-f"x ];then
 composeFile $dir_path $*
elif [ ${1}x = "-v"x ];then
 versions $dir_path $*
elif [ ${1}x = "tls"x ];then
  tlsInit $dir_path $*
elif [ ${1}x = "update"x ];then
  update $dir_path $*
else
   echo -e "
  dnmp是一个代替[docker-compose -f docker-compose-xxx.yml]部分命令的快捷命令
  第一个参数是需要操作的环境：

  \033[32m dome \033[0m                     一个快速而简单示例dome[只包含nginx+php-fpm]

  \033[32m php-fpm-7.1-universal\033[0m     通用版[通用的]
  \033[32m php-fpm-7.3-universal\033[0m     通用版[包含swoole扩展]
  \033[32m php-fpm-7.4-universal\033[0m     通用版[包含swoole扩展]
  \033[32m php-fpm-7.1-swoole\033[0m        swoole版[包含swoole扩展]
  \033[32m php-fpm-7.3-swoole\033[0m        swoole版[包含swoole扩展]
  \033[32m php-fpm-7.4-swoole\033[0m        swoole版[包含swoole扩展]
  \033[32m php-fpm-7.1-full\033[0m          完整版[包含ssh2、xdebug、swoole、MongoDB扩展]
  \033[32m php-fpm-7.3-full\033[0m          完整版[包含ssh2、xdebug、swoole、MongoDB扩展]
  \033[32m php-fpm-7.4-full\033[0m          完整版[包含ssh2、xdebug、swoole、MongoDB扩展]

  \033[32m upstream \033[0m      负载均衡服务[只包含nginx 通常做反向代理负载均衡]
  \033[32m redis \033[0m         Redis[只包含Redis]
  \033[32m mysql \033[0m         Redis[只包含Mysql]
  \033[32m diy-php-fpm \033[0m   diy-php-fpm[只包含php-fpm]

  \033[32m tls \033[0m           https tls 管理[在acme.sh的基础上实现主要用在自动化跨服务器管理]

  \033[32m update \033[0m        更新dnmp[只更新sh脚本其他文件不更新]
  \033[32m -f \033[0m            docker-compose-xxx.yml文件所在路径
  \033[32m -v \033[0m            当前各软件版本

  后面的参数与与docker-compose命令完全一致：
  dnmp dome up
  相当于：docker-compose -f docker-compose-dome.yml up
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

