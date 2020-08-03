#!/bin/bash
# 开启alias扩展功能
shopt -s  expand_aliases
root_dir=$(dirname $(pwd))
# 注册docker-compose 相关命令
iniComposeCli(){
echo '#!/bin/bash
dir_path='${root_dir}'
source ${dir_path}/initialize/dnmp-function.sh
if [ ${1}x = "deploy"x ];then
  compose $dir_path $*
elif [ ${1}x = "production"x ];then
 compose $dir_path $*
elif [ ${1}x = "deploy"x ];then
 compose $dir_path $*
elif [ ${1}x = "develop"x ];then
 compose $dir_path $*
elif [ ${1}x = "upstream"x ];then
 compose $dir_path $*
elif [ ${1}x = "redis"x ];then
 compose $dir_path $*
elif [ ${1}x = "mysql"x ];then
 compose $dir_path $*
elif [ ${1}x = "-f"x ];then
 composeFile $dir_path $*
elif [ ${1}x = "-v"x ];then
 versions $dir_path $*
else
   echo -e "
   dnmp是一个代替[docker-compose -f docker-compose-xxx.yml]部分命令的快捷命令

   第一个参数是需要操作的环境：
   \033[32m develop \033[0m       开发环境[只包含nginx+php-fpm]
   \033[32m deploy \033[0m        部署环境[只包含nginx+php-fpm]
   \033[32m upstream \033[0m      负载均衡服务[只包含nginx 通常做反向代理负载均衡]
   \033[32m production \033[0m    生产环境[只包含nginx+php-fpm]
   \033[32m basics \033[0m        基础环境[只包含nginx+php-fpm]
   \033[32m redis \033[0m         Redis[只包含Redis]
   \033[32m mysql \033[0m         Redis[只包含Mysql]
   \033[32m -f \033[0m            docker-compose-xxx.yml文件所在路径
   \033[32m -v \033[0m            当前各软件版本

   后面的参数与与docker-compose命令完全一致
"
fi
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

