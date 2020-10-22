#!/bin/bash
# 初始化构建主机的ssh key
ifBuildSshKey()
{
  cat ~/.ssh/id_rsa.pub >>null
  if [ $? -ne 0 ];then
    echo "构建主机没有SSH keys 进行创建"
    yum install -y expect
    # expect垃圾
    which expect
    /usr/bin/expect <<EOF
    set timeout 5
    spawn ssh-keygen -t rsa -C "$sshKeyEmail"
    expect {
        "id_rsa):" { send "\n";exp_continue }
        "passphrase):" { send "$password\n";exp_continue }
        "passphrase again:" { send "$password\n" }
    }
    expect eof
EOF
  fi
}
# 安装Nodejs
installNodejs()
{
    node -v
    if [ $? -ne 0 ];then
        echo "构建主机没有Nodejs 进行安装"
        curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
        yum install -y nodejs
        node -v
        if [ $? -ne 0 ];then
          echo "构建主机安装 Nodejs 失败"
        fi
  fi
}
# app ssh授权
appSSHKYEMandate()
{
  # 检查ssh key
  ifBuildSshKey
  echo -e "\033[31m app ssh授权 \033[0m"
  # 执行
/usr/bin/expect <<EOF
    set timeout 5
    spawn  ssh-copy-id -i /root/.ssh/id_rsa.pub root@${2} -p ${3}
    expect {
        "Host key verification failed." { send "sed -i -e '/${2}/d' /root/.ssh/known_hosts && ssh-copy-id -i /root/.ssh/id_rsa.pub root@${2} -p ${3} \n" }
        "connecting (yes/no)?" { send "yes\n";exp_continue }
        "password:" { send "${4}\n" }
    }
    spawn ssh root@${2} -p ${3}
    expect {
        "continue connecting (yes/no)?" { send "echo'授权失败'" }
        "]#" { send "ifconfig -a |grep inet |grep -v 127.0.0.1 |grep -v inet6 && hostname && exit \n" }
    }
    expect eof
EOF
  hostname
      #sed -i -e "/${2}/d" /root/.ssh/known_hosts
}
devOpsDocument()
{
  echo -n -e '
  1、文件结构：
    1）、nginx配置/docker/normphp/dnmp/data/nginx/conf/default_devops.conf
    2）、项目代码目录/docker/normphp/dnmp/data/devops/code/devops-admin/[resource为前端资源,normphp为php项目资源]
    3）、使用独立MySQL、Redis时数据目录/docker/normphp/dnmp/data/devops/data/
  2、Mysql相关：
    1）、ROOT密码：默认使用dnmp-master/build/docker-compose/.env文件（注意.env为隐藏文件可以使用ls -l 查看隐藏文件）的MYSQL_ROOT_PASSWORD变量控制（只有第一次执行启动命令时从会有效）
    2）、默认会创建一个normphp账号 密码为normphp 所有ip可访问
      a）、默认创建账号为.env 中的MYSQL_USER变量定义 密码为MYSQL_PASSWORD变量定义
      b）、如需要修改控制ip访问可执行如下命令
        进入容器 连接mysql  根据提示输入root密码
        docker exec -it docker-compose_devops-mysql_1  mysql -u root -p
        选择数据库 mysql
        use mysql
        # 列出数据库账号
        select user, host from user;
        # 设置user=normphp  host=% 的用户的host信息：host条件一定要加否则会变成add操作
        update user set host = '172.%' where user = 'normphp' and host = '%';
        # 如果需要对一个用户设置多host规则
        grant select,insert,update,create on normphp.* to normphp@'host规则' identified by '密码';
        # 增加超级管理员时
        grant all privileges on *.* to sroot@'host规则' identified by '密码';
        刷新权限  这个是必须的
        flush privileges;
    3)、注意细节：
      1）、容器与容器进行通信时请不要使用映射到宿主机的端口直接使用容器内部端口
    3、web socket：
      1）、默认监听9501端口
      2）、启动命令：cd /www/code/devops-admin/normphp/public && php index_cli.php --route /devops/server/web-socket &
      3）、web socket配置：/www/code/devops-admin/config/Deploy.php 常量 buildServer['WebSocketServer']
        a）、buildServer['WebSocketServer']['type'] 为socket是否为ssl加密（注意ssl加密需要域名配合）wss://为ssl加密
        b）、buildServer['WebSocketServer']['config'] 为ssl证书路径
        c）、buildServer['WebSocketServer']['hostName'] socket使用的域名（主要用来个客户端连接）
        d）、buildServer['WebSocketServer']['host'] socket使用的ip（主要用来个客户端连接）
        e）、buildServer['WebSocketServer']['port'] 本地接听端口（同时也是客户端连接端口）
    4、构建主机配置：
      1）、/www/code/devops-admin/config/Deploy.php 常量 buildServer 非WebSocketServer key的所有配置值
        a）、buildServer['host'] 构建主机ip
        b）、buildServer['port'] 构建主机ssh 端口
        c）、buildServer['username'] 构建主机ssh 账号
        d）、buildServer['password'] 构建主机ssh 账号密码
        c）、buildServer['ssh2_auth'] 构建主机ssh认证方式 password|pubkey
        d）、buildServer['pubkey'] 构建主机ssh 认证 pubkey路径
        e）、buildServer['pubkey'] 构建主机ssh 认证 pubkey路径
    5、部署程序数据库初始化：
      1）、什么时候进行数据库初始化：每次执行 dnmp startDevOps 时
      2）、执行命令
        a）、进入php容器：docker exec -it docker-compose_devops-php-fpm-7.4_1 bash
        b）、cd /www/code/devops-admin/normphp/public && php index_cli.php --route /deploy/cliDbInitStructure
        c）、第一次执行时间会比较长（5s左右）一般不需要手动执行每次执行 dnmp startDevOps时会执行
    6、关于文件权限问题
      1）、通过nginx 转发的php请求执行用户为容器内的www-data用户，因此为保证文件归属一致需要在宿主机创建一个www-data用户，然后在宿主机设置对应的php文件的归属
        a）、chmod -R 777  [目录]       设置目录权限  sudo -u www-data
        b）、chown -R www-data  [目录   设置用户
      2）、由于进入容器执行cil php 命令默认使用的是root 因此执行命令创建的文件也是root归属，这样是不建议的。
        a）、在执行cil php 命令时 需要使用sudo 命令
          1）、如果没有安装sudo 命令，先安装：
          2）、在需要这些的cil php命令前执前增加sudo -u www-data 如：sudo -u www-data sudo -u www-data php index_cli.php --route /deploy/cliDbInitStructure
';

}
# 启动部署系统
startDevOps()
{
  echo '启动容器';
  pwd
  docker-compose -f docker-compose-devops.yml up -d
  echo '进行项目数据库初始化、启动web-socket操作';
/usr/bin/expect <<EOF
    set timeout 60
    spawn  docker exec -it docker-compose_devops-php-fpm-7.4_1 bash
    expect {
        ":/data#" { send "sudo \n"; }
    }
    expect {
      "sudo: command not found" { send "apt-get update && apt-get install sudo \n";exp_continue }
      ":/data#" { send "echo '进行数据库初始化：大约需要等待10-20s' && cd /www/code/devops-admin/normphp/public && sudo -u www-data php index_cli.php --route /deploy/cliDbInitStructure \n";exp_continue }
      "normphp/public#" { send "echo '启动web-socket' && pwd && sudo -u www-data php index_cli.php --route /devops/server/web-socket & \n\n"; }
    }
    expect eof
EOF
  exit;

  echo -n '默认账号：normphp\n默认密码：88888888';

}
stopDevOps()
{
  docker-compose -f docker-compose-devops.yml stop
}
initDevOps()
{
  # 确定端口
  while true;do
  devOpsDocument
  echo -n -e '
  回车确认阅读文档！:'
  read Arg
  case $Arg in
  "")
    break;;
  esac
  done

  # 确定端口
  while true;do
  stty -icanon min 0 time 100
  echo -n -e '\033[32m
  本运维部署系统后端为PHP开发、前端使用LayUiAdmin

  A、如果您只有当前一台服务器想在服务器上部署本运维部署系统同时又其他被部署的web项目也在当前服务器上建议您可直接一路回车
  （主要是http 80 443 端口冲突问题 回车默认不使用80 443 3306）
  B、如果您有N个服务器建议您在提示时输入想要的端口
  *****************************************************************
  1、单独使用独立服务器安装运维部署系统（当前服务器不在部署其他web项目）
  2、我只有一台服务，运维部署系统和项目都不是在当前服务器

  \033[0m
  \033[5m (回车键确认阅读): \033[0m'
  read Arg
  case $Arg in
  1)
   pattern='1'
    break;;
  2)
   pattern='2'
    break;;
  "")  #Autocontinue
   pattern='2'
    break;;
  esac
  done
  pattern='2'
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

   initDevOpsFile

    # 输入当前服务器外部访问IP
    while true;do
    echo -n -e '\n \033[5m 输入当前服务器外部访问IP: \033[0m'
    read Arg
    hostIp=$Arg
    hostName=$Arg
      break;
    done

    while true;do
    echo -n -e '\n \033[5m 输入websocket端口（默认9501）: \033[0m'
    read Arg
        case $Arg in
        "")  #Autocontinue
            webSocketPort=9501
          break;;
        esac
          webSocketPort=$Arg
          break;
    done

    while true;do
    echo -n -e '\n \033[5m 输入当前服务器SSH外部访问端口（默认22）: \033[0m'
    read Arg
        case $Arg in
        "")  #Autocontinue
            hostPort=22
          break;;
        esac
        hostPort=$Arg
          break;
    done
    while true;do
    echo -n -e '\n初始化部署时输入的是root密码，后期开自行修改为使用密钥 或者其他用户 \033[5m 输入当前服务器root SSH密码: \033[0m'
    read Arg
    hostPassword=$Arg
      break;
    done

    sed -i "s/{{hostName}}/${hostName}/g"           /docker/normphp/dnmp/data/devops/code/devops-admin/config/Deploy.php
    sed -i "s/{{hostIp}}/${hostIp}/g"               /docker/normphp/dnmp/data/devops/code/devops-admin/config/Deploy.php
    sed -i "s/{{hostPort}}/${hostPort}/g"           /docker/normphp/dnmp/data/devops/code/devops-admin/config/Deploy.php
    sed -i "s/{{hostPassword}}/${hostPassword}/g"   /docker/normphp/dnmp/data/devops/code/devops-admin/config/Deploy.php
    sed -i "s/{{webSocketPort}}/${webSocketPort}/g"   /docker/normphp/dnmp/data/devops/code/devops-admin/config/Deploy.php

  archInfo=`arch`
  if [ ${archInfo}x = "x86_64"x ];then
    archInfo=''
    mysqlImages='./mysql'
    echo ${archInfo}
  elif [ ${archInfo}x = "aarch64"x ];then
    echo ${archInfo}
    archInfo='-arm'
    mysqlImages='./mysql/arm'
  else
    echo ${archInfo}
    echo '只支持x86_64、aarch64'
    exit
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
    build: ${mysqlImages}
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
    image: normphp/dnmp-php:php-fpm-7.4-full${archInfo}
    networks:
      - "'${NETWORKS}'"
    ports:
      - "'"'"${webSocketPort}:${webSocketPort}"'"'"
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

# 初始化  下载对应文件
initDevOpsFile()
{
  # useradd www-data
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
  && wget  -c "http://nomphp.pizepei.com/DevOps/layuiAdmin/v1.3/normphp.zip?v=1.1" -O normphp.zip \
  && unzip -o normphp.zip \
  && sudo cp -r normphp/. /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/ \
  && chmod -R 777 /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/ \
  && sudo cp -r ${root_dir}/build/devops/config  /docker/normphp/dnmp/data/devops/code/devops-admin/config/ \
  && chmod -R 777 /docker/normphp/dnmp/data/devops/code/devops-admin/config/ \
  && chown -R www-data /docker/normphp/dnmp/data/devops/code/devops-admin/ \
  && ls /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/ \
  && ln -s ../config /docker/normphp/dnmp/data/devops/code/devops-admin/normphp/config
  # && chown -R www-data /docker/normphp/dnmp/data/devops/code/devops-admin/ \
  # 关于软连接 这里需要记录说明一下：
  #   比如说我们需要/docker/dnmp/devops-admin/config 源文件夹连接到 /docker/dnmp/devops-admin/下
  #   也就是在/docker/dnmp/devops-admin/normphp/下有 config文件夹
  #   但是软连接只是一个记录（/docker/dnmp/devops-admin/normphp/config 上记录了源文件地址），宿主机会容器实例的目录结构是不一致的，这样会导致在宿主机可以正常使用这个目录
  #   这个时候不能使用绝对路径，应该是先cd /docker/dnmp/devops-admin/normphp/ 到目标目录
  #   然后使用这个目录下的相对路径创建软连接 ln -s ../config   ./config  这个时候执行ll 或者ls -l命令就可以看到 config -> ../config 在容器里面也可以正常使用了
  #   绝对路径不是万能的

}
