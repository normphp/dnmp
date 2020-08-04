#!/bin/bash
Path=$(readlink -f "$(dirname "$0")")
# Docker Compose 的当前稳定版本
echo -e "init Docker Compose"
sudo docker-compose version
if [ $? -ne 0 ]; then
  echo "docker-Compose 的当前稳定版本"
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  # 国内源
  # curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -snf   /usr/local/bin/docker-compose /usr/bin/docker-compose
  docker-compose --version
  if [ $? -ne 0 ]; then
     echo -e "\033[31m 安装Docker-Compose失败尝试pip方式安装 \033[0m"
      sudo yum -y install  epel-release python-pip \
      && sudo pip --version \
      && sudo pip install --upgrade pip \
      && sudo pip install   docker-compose requests cryptography==2.9.2 \
      && sudo pip uninstall -y  urllib3 chardet \
      && docker-compose version
      if [ $? -ne 0 ]; then
            echo -e "\033[31m 安装Docker-Compose失败 \033[0m" && exit
     fi
  fi
else
    echo "已安装Docker Compose"
fi

echo "********************************************************"
# 创建目录 /normphp/dnmp/
sudo mkdir -p /docker/normphp/dnmp/data/{redis,mysql,php}
echo "创建目录：{conf,conf.d,html,logs}"
sudo mkdir -p /docker/normphp/dnmp/data/nginx/{conf,conf.d,html,logs}
echo "创建目录：{default,view,php}"
sudo mkdir -p /docker/normphp/dnmp/data/www/{default,view,php}
sudo mkdir -p /docker/normphp/dnmp/data/www/default/normphp/public
# 配置文件都在/docker/normphp/dnmp/data/nginx/conf目录下
echo "创建目录：{normphp,jt,general,tpl,snippets,ssl_certificate}"
#sudo mkdir -p /docker/normphp/dnmp/data/nginx/conf/{normphp,jt,general,tpl,snippets,ssl_certificate}

# 复制当前目录下的目录nginx.conf配置到对应运行目录
echo "复制当前目录下的目录nginx.conf、default.conf配置到对应运行目录/docker/data/nginx/"
if [ "x${cur_dir}" != "x" ];then
Path=$cur_dir
fi
echo $Path;
# 处理nginx配置文件
nginx_conf="sudo cp -r ${Path}/nginx/conf/. /docker/normphp/dnmp/data/nginx/conf"
$nginx_conf
# 处理php配置文件
`sudo cp -r ${Path}/php/etc/php/php.ini-development /docker/normphp/dnmp/data/php/php-develop.ini`
`sudo cp -r ${Path}/php/etc/php/php.ini-development /docker/normphp/dnmp/data/php/php-basics.ini`
`sudo cp -r ${Path}/php/etc/php/php.ini-production /docker/normphp/dnmp/data/php/php-deploy.ini`
`sudo cp -r ${Path}/php/etc/php/php.ini-production /docker/normphp/dnmp/data/php/php-production.ini`
`sudo cp -r ${Path}/php/etc/php/php.ini-development /docker/normphp/dnmp/data/php/php-diy.ini`

`sudo cp -r ${Path}/php/etc/php-fpm.conf /docker/normphp/dnmp/data/php/php-fpm.conf`
`sudo cp -r ${Path}/php/etc/php-fpm.conf.default /docker/normphp/dnmp/data/php/php-fpm.conf.default`
`sudo cp -r ${Path}/php/etc/php-fpm.d/ /docker/normphp/dnmp/data/php/php-fpm.d/`

echo "复制当前目录下的目录index.html等文件到对应运行目录/docker/normphp/dnmp/data/www/"

`sudo cp ${Path}/nginx/html/index.html /docker/normphp/dnmp/data/www/default/index.html`
`sudo cp ${Path}/nginx/html/404.html /docker/normphp/dnmp/data/www/default/404.html`
`sudo cp ${Path}/nginx/html/index.php /docker/normphp/dnmp/data/www/default/normphp/public/index.php`
`sudo cp ${Path}/nginx/html/phpinfo.php /docker/normphp/dnmp/data/www/default/phpinfo.php`
#自动生成docker-compose文件
echo -e "\033[32m *****************自动生成docker-compose文件*************** \033[0m"

export Path
echo $Path
#chmod_compose="sudo chmod +x   ${Path}/compose.sh"
#$chmod_compose
#cli="${Path}/compose.sh"
#source  $cli
sudo docker network ls
