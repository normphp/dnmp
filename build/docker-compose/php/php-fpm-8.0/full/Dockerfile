FROM php:8.0-rc-fpm
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
&& apt-get -y install  gcc automake autoconf libtool cmake git  \
        libfreetype6-dev libjpeg62-turbo-dev  \
        openssl libpng-dev  libssl-dev \
#编译  libzip
&& cd /home/ && curl https://libzip.org/download/libzip-1.5.1.tar.gz >>libzip-1.5.1.tar.gz \
&& tar -zxvf libzip-1.5.1.tar.gz \
&& cd libzip-1.5.1 \
&& mkdir build \
&& cd build \
&& cmake .. \
&& make && make install \
#更新安装依赖包和PHP核心拓展
&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-install pdo_mysql \
&& docker-php-ext-install opcache \
&& docker-php-ext-install zip \
#将预先下载好的拓展包从宿主机拷贝进去
#安装 Composer
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# 清除不需要的数据
&&  printf "y" |  apt-get remove --purge gcc automake autoconf libtool \
&& cmake git libfreetype6-dev libjpeg62-turbo-dev libpng-dev libssl-dev \
&& rm -rf /var/lib/apt/lists/* \
       && rm -rf /home/* \
       && apt-get clean \
       && printf "y" | apt-get autoclean \
       && rm -rf /tmp/pear/*
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

WORKDIR /data
# Write Permission
RUN usermod -u 1000 www-data