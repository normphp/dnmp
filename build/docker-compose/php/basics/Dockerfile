FROM php:7.4-fpm
MAINTAINER pizepei "pizepei@pizepei.com"
ENV COMPOSER_HOME /root/composer
#设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone  \
#更新安装依赖包和PHP核心拓展
&& apt-get update  \
#重新安装 libzip
#删除重新安装 libzip
#RUN apt-get remove libzip
#重新安装 libzip 编译需要 make
&& apt-get -y install  gcc automake autoconf libtool cmake  \
        libfreetype6-dev libjpeg62-turbo-dev  \
        openssl libpng-dev  libssl-dev \
#更新安装依赖包和PHP核心拓展
&& docker-php-ext-install pdo_mysql \
&& docker-php-ext-install opcache \
#&& docker-php-ext-install mysqli \
#将预先下载好的拓展包从宿主机拷贝进去
&& pecl install igbinary && printf "yes\nyes\n" |  pecl install redis-5.3.1 \
&& docker-php-ext-enable  redis  \
# 清除不需要的数据
&&  printf "y" |  apt-get remove --purge  cmake automake autoconf libtool \
&& rm -rf /var/lib/apt/lists/* \
       && rm -rf /home/* \
       && apt-get clean \
       && printf "y" | apt-get autoclean \
       && printf "y" | apt-get autoremove \
       && dpkg -l |grep ^rc|awk '{print $2}' | xargs dpkg -P
WORKDIR /data
# Write Permission
RUN usermod -u 1000 www-data