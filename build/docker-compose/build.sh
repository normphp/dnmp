#!/bin/bash
echo -e "\033[32m *******build  images******* \033[0m"

echo -e "\033[32m *******build php images******* \033[0m"
cd php && docker build -t normphp:php7.4-fpm .
cd ..
echo -e "\033[32m *******build mysql-5.7 images******* \033[0m"
cd mysql && docker build -t mysql:mysql-5.7 .
cd ..
echo -e "\033[32m *******build redis-5 images******* \033[0m"
cd redis && docker build -t redis:redis-5 .
cd ..
echo -e "\033[32m *******build nginx-5 images******* \033[0m"
cd nginx && docker build -t nginx:nginx .
cd ..