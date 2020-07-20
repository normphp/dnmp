### docker-compose
#### 基础命令
    # 参考文档
    https://www.cnblogs.com/phpk/p/11205467.html
#### 基础操作
    # 构建新容器包
    docker-compose build 
    # 运行容器  -d 为后台运行
    docker-compose up -d
    
    # 关闭容器、并且删除容器实例
    docker-compose down
    
### docker-compose 内使用     composer
    # -w /www/php/test/ 容器内的需要执行composer命令的目录 容器内/www/对应宿主机/docker/data/www/   php-fpm 是docker-compose.yml中定义的容器名称
    docker-compose run --rm -w /www/php/test/  php-fpm composer install