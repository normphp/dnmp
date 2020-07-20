FROM nginx
MAINTAINER pizepei pizepei@pizepei.com
ENV VERSION 0.1
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && mkdir -p /wwwlogs/ && mkdir -p /www/
