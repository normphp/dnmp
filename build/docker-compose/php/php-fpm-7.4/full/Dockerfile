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
#安装 libssh2  curl -sS https://www.libssh2.org/download/libssh2-1.9.0.tar.gz && tar -zxvf libssh2-1.9.0.tar.gz && cd libssh2-1.9.0/
&& cd /home/ \
&& curl  https://www.libssh2.org/download/libssh2-1.9.0.tar.gz >>libssh2-1.9.0.tar.gz  \
&& tar -zxvf libssh2-1.9.0.tar.gz && cd libssh2-1.9.0/  \
&& ./configure && make && make install \
#安装 PECL 拓展，这里我们安装的是Redis ssh2  http://pecl.php.net/get/ssh2-1.2.tgz
&& pecl install igbinary && printf "yes\nyes\n" |  pecl install redis-5.3.1 \
&& pecl install ssh2-1.2 \
&& pecl install xdebug-2.9.6 \
&& printf "y\y\y" | pecl install swoole \
&& pecl install mongodb \
&& docker-php-ext-enable igbinary ssh2 xdebug redis swoole mongodb \
#安装第三方拓展，这里是 Phalcon 拓展
#安装 Composer
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# 清除不需要的数据
&&  printf "y" |  apt-get remove --purge gcc automake autoconf libtool \
    cmake git libfreetype6-dev libjpeg62-turbo-dev libpng-dev libssl-dev \
&& rm -rf /var/lib/apt/lists/* \
       && rm -rf /home/* \
       && apt-get clean \
       && printf "y" | apt-get autoclean \
#       && printf "y" | apt-get autoremove \
#       && dpkg -l |grep ^rc|awk '{print $2}' | xargs dpkg -P \
       && rm -rf /tmp/pear/* \
&& php -m \
&& php -v
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

WORKDIR /data
# Write Permission
RUN usermod -u 1000 www-data