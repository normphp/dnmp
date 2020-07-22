#!/bin/bash
Path=$(readlink -f "$(dirname "$0")")
# Docker Compose 的当前稳定版本
echo -e "init Docker Compose"
sudo docker-compose version
if [ $? -ne 0 ]; then
  echo "Docker Compose 的当前稳定版本"
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -snf   /usr/local/bin/docker-compose /usr/bin/docker-compose
  docker-compose --version
else
    echo "已安装Docker Compose"
fi

echo "********************************************************"
# 创建目录 /normphp/dnmp/
echo "创建目录：/docker/normphp/dnmp/data/nginx/{conf,conf.d,html,logs}"
sudo mkdir -p /docker/normphp/dnmp/data/nginx/{conf,conf.d,html,logs}
echo "创建目录：/docker/normphp/dnmp/data/www/{default,view,php}"
sudo mkdir -p /docker/normphp/dnmp/data/www/{default,view,php}
# 配置文件都在/docker/normphp/dnmp/data/nginx/conf目录下
echo "创建目录：/docker/normphp/dnmp/data/nginx/conf/{normphp,jt,general,tpl}"
sudo mkdir -p /docker/normphp/dnmp/data/nginx/conf/{normphp,jt,general,tpl}
sudo mkdir -p /docker/normphp/dnmp/data/{redis,mysql,php}

# 复制当前目录下的目录nginx.conf配置到对应运行目录
echo "复制当前目录下的目录nginx.conf、default.conf配置到对应运行目录/docker/data/nginx/"
if [ "x${cur_dir}" != "x" ];then
Path=$cur_dir
fi
echo $Path;
`sudo cp ${Path}/nginx/conf/nginx.conf /docker/normphp/dnmp/data/nginx/conf/nginx.conf`
`sudo cp ${Path}/nginx/conf/default.conf /docker/normphp/dnmp/data/nginx/conf/default.conf`
`sudo cp -r ${Path}/nginx/conf/vhost/jt /docker/normphp/dnmp/data/nginx/conf/`
`sudo cp -r ${Path}/nginx/conf/vhost/normphp /docker/normphp/dnmp/data/nginx/conf/`
`sudo cp -r ${Path}/nginx/conf/vhost/general /docker/normphp/dnmp/data/nginx/conf/`
`sudo cp -r ${Path}/nginx/conf/vhost/tpl /docker/normphp/dnmp/data/nginx/conf/`
# 处理php配置文件

`sudo cp -r ${Path}/php/etc/php/php.ini-development /docker/normphp/dnmp/data/php/php-develop.ini`
`sudo cp -r ${Path}/php/etc/php/php.ini-development /docker/normphp/dnmp/data/php/php-basics.ini`
`sudo cp -r ${Path}/php/etc/php/php.ini-production /docker/normphp/dnmp/data/php/php-deploy.ini`
`sudo cp -r ${Path}/php/etc/php/php.ini-production /docker/normphp/dnmp/data/php/php-production.ini`

`sudo cp -r ${Path}/php/etc/php-fpm.conf /docker/normphp/dnmp/data/php/php-fpm.conf`
`sudo cp -r ${Path}/php/etc/php-fpm.conf.default /docker/normphp/dnmp/data/php/php-fpm.conf.default`
`sudo cp -r ${Path}/php/etc/php-fpm.d/ /docker/normphp/dnmp/data/php/php-fpm.d/`

echo "复制当前目录下的目录index.html等文件到对应运行目录/docker/normphp/dnmp/data/www/\n"

`sudo cp ${Path}/nginx/html/index.html /docker/normphp/dnmp/data/www/default/index.html`
`sudo cp ${Path}/nginx/html/404.html /docker/normphp/dnmp/data/www/default/404.html`
`sudo cp ${Path}/nginx/html/index.php /docker/normphp/dnmp/data/www/default/index.php`

#自动生成docker-compose文件
echo "自动生成docker-compose文件"

export Path
echo $Path
`sudo chmod +x   ${Path}/compose.sh`

`source  ${Path}/compose.sh`

