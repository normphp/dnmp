#!/bin/bash
# 使用的资源类型  cn  或者usa
export  dockerResourceType='cn'
# 是否开启中心服务 off  on   （总开关）
export  CentreServe='off'
# 中心服务器api地址（域名部分部分）
export  CentreServeAPI='http://dev.heil.red'
# 中心服务接受 docker 信息接口路由(这里默认配置的是normphp框架支持的api)
export  CentreServePostDockerInfoRouter='/normphp/dnmp/nowadays/dnmp-info.json'
# 中心服务接受 宿主机昨天 信息接口路由(这里默认配置的是normphp框架支持的api)
export  CentreServePostSystemInfoRouter='/normphp/dnmp/nowadays/dnmp-remote-api.json'