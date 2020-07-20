### docker-Dockerfile
#### 简单介绍
    简单的Dockerfile
#### 基础知识
    # 参考文档
    https://www.runoob.com/docker/docker-dockerfile.html
#### 目录结构
 ~~~
www  WEB部署目录（或者子目录）
├─admin           系统后台应用目录
├─basics          基础环境构建文件
│  ├─Dockerfile     构建时只安装 pdo_mysql、redis、opcachephp
├─deploy          生产部署环境构建文件
│  ├─Dockerfile     在基础basics构建基础上增加了ssh2、swoole、zip等php扩展和git、composer
├─develop          开发环境构建文件
│  ├─Dockerfile     在deploy构建基础上增加了调试xdebug php
├─production        简单的生产环境构建文件
│  ├─Dockerfile     不构建ssh2、swoole、zip等php扩展和git、composer
├─README.md           说明文档
注意：
1、这些构建文件已经有构建好的docker images 详情[https://hub.docker.com/r/normphp/dnmp]
2、如果需要在各基础环境上增加需要的扩展可参考并且修改对应Dockerfile文件自行构建
~~~    
#### 操作命令
##### docker build 构建php7.4-fpm 【单独构建】
build -t normphp:php7.4-fpm .
