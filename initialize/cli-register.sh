#!/bin/bash
# 开启alias扩展功能
shopt -s  expand_aliases
root_dir=$(dirname $(pwd))
# 注册docker-compose 相关命令
iniCompose(){
echo '#!/bin/bash
source dnmp-function.sh
dir_path='${root_dir}'
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
elif [ ${1}x = "-f"x ];then
 composeFile $dir_path $*
elif [ ${1}x = "-v"x ];then
 versions $dir_path $*
else
   echo "第一个命令是需要操作的环境：
   develop      开发环境
   deploy       部署环境
   upstream     负载均衡服务
   production   生产环境
   basics       基础环境
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
  grep '/initialize/dnmp.sh' ~/.bashrc
  if [ $? -eq 0 ];then
      echo -e "\033[32m 已经注册dnmp快捷命令  \033[0m"
      source ~/.bashrc
  else
    echo '未注册dnmp快捷命令！现在进行注册'
    sudo echo "alias dnmp='cd ${root_dir}/initialize/ && sudo bash ./dnmp.sh'">>~/.bashrc
    alias dnmp='cd '${root_dir}'/initialize && sudo bash ./dnmp.sh'
    source ~/.bashrc
  fi
}
# 开启alias扩展功能
iniCompose $root_dir
