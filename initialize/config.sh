#!/bin/bash
# 是否开启中心服务 off  on   （总开关）
export  CentreServe='on'
# 中心服务器api地址（域名部分部分）
export  CentreServeAPI='http://dev.heil.red'
# 中心服务接受 docker 信息接口路由(这里默认配置的是normphp框架支持的api)
export  CentreServePostDockerInfoRouter='/normphp/dnmp/nowadays/dnmp-remote-api.json'
# 中心服务接受 宿主机昨天 信息接口路由(这里默认配置的是normphp框架支持的api)
export  CentreServePostSystemInfoRouter='/normphp/dnmp/nowadays/dnmp-info.json'
# 配置环境容器
# 配置使用dnmp  deploy [up -d]启动的 容器组合，注意先后顺序  注意php-fpm 需要配置deployDockerPhpFpm
export deployDocker=("nginx" "php-fpm" "redis" "mysql")
#export deployDocker=("php-fpm")

# PHP版本 和扩展模式
export deployDockerPhpFpmVersions="php-fpm-7.4"
export deployDockerPhpFpmPattern="full"
