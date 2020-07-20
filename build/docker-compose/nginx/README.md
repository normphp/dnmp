# docker nginx:
## docker 环境的安装
#### 使用国内 daocloud 一键安装命令<br>
    curl -sSL https://get.daocloud.io/docker | sh
#### 启动docker
    sudo systemctl start docker
## build normphp:nginx
    cd nginx # 进入git 项目目录
#### 第一次执行进行 images 构建
    bash build.sh [port]     # 容器端口映射到主机的 监听port 默认8081
    此命令会自动构建images normphp:nginx 命名为normphp-nginx 并启动运行 
    相关配置文件挂载到本地主机/docker/data/nginx/目录
    脚本服务目录挂载到本地主机/docker/www/目录
    重复运行此命令会自动删除之前构建的 normphp:nginx  images 再重新构建
#### 容器 restart
    bash restart.sh
#### 容器 start
    bash start.sh
#### 容器 delete
    bash delete.sh
#### 容器 stop
    bash stop.sh