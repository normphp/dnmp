# dnmp
适用normphp框架的dnmp环境（docker+nginx+mysql+php）
### 关于dnmp
适用normphp框架的dnmp环境（docker+nginx+mysql+php）
### 背景
适用normphp框架的dnmp环境（docker+nginx+mysql+php）
#### 应用场景
* PHP的特点：项目产品的快速实现更新迭代变现
* normphp框架适用性：低门槛学习成本、适用产品的快速实现更新迭代的框架（面向个人开发者、小规模团队）。
* 不考虑大规模集群自动化部署，dnmp只做更好的lnmp代替品，代码不集成在images中，挂载在本地主机上。
* 在部署时nginx 配置好对应的目录，发布模块项目新版本时直接修改目录的软连接到新代码上（事实上这个目录同时被dnmp容器挂载）
    *   按照正统容器的思想应该是业务代码+环境为一个完整容器，或者在容器构建时把代码copy到容器中。
#### 开始
    # 初始化基础环境、安装docker和docker-compose、构建生成docker-compose.yml文件
    
    yum -y -q install wget tar \
    && wget https://github.com/normphp/dnmp/archive/master.tar.gz && tar -zxvf master.tar.gz \
    && cd dnmp-master/initialize/ \
    && bash dnmp.sh \
    && cd ../build/docker-compose/  \
    && pwd
    
    ************************docker-compose 构建与运行 *******************************
    
    # -f 代表需要使用的docker-compose.yml文件以及路径
    
    # 构建项目环境 可选择生成环境[deploy]、开发环境[develop]、生产环境[production]、基础环境[basics]
    docker-compose -f docker-compose-[deploy|develop|production|basics].yml build 
    
    ### 示例 docker-compose -f docker-compose-develop.yml build 
    
    # up 命令为启动环境  up -d 为守护进程启动环境 更多命令请自行网上搜索docker-compose命令
    docker-compose -f docker-compose-[deploy|develop|production|basics].yml up
    # 开发环境构建命令参考[示例]
    docker-compose -f docker-compose-develop.yml build && docker-compose -f docker-compose-develop.yml up
    # 可以访问：[服务器ip]/index.php   查看效果
    
    # 关闭容器、并且删除容器实例
    docker-compose -f docker-compose-[deploy|develop|production|basics].yml down
    
    ************************docker-compose 服务操作*********************************
    
    # 检测nginx配置是否正确【注意自行替换-f 参数的文件路径】
    docker-compose -f ~root/dnmp-master/build/docker-compose/docker-compose-[deploy|develop|production|basics].yml  exec nginx -t
    # 重启nginx容器服务【注意自行替换-f 参数的文件路径】
    docker-compose -f ~root/dnmp-master/build/docker-compose/docker-compose-[deploy|develop|production|basics].yml  exec nginx service nginx restart
    # 其他容器服务也可参考使用，命令的最后一个参数 就是需要在容器里面执行的命令行
    
    ### 示例  docker-compose -f ~root/dnmp-master/build/docker-compose/docker-compose-develop.yml  exec  nginx nginx -t
    
    ***********************常规docker-composer 命令********************************
    
    # 下面是常用命令  更多命令请自行网上搜索docker-compose命令
    docker-compose restart [serviceName]: 重启服务
    
    docker-compose config：验证和查看compose文件
    
    docker-compose images：列出所用的镜像
    
    docker-cpmpose scale：设置服务个数 Eg：docker-compose scale web=2 worker=3 
    
    docker-compose pause [serviceName]：暂停服务
    
    docker-compose unpause [serviceName]：恢复服务
#### 安装 acme.sh管理https证书
###### acme.sh介绍
* acme.sh是一个自动化管理https证书的开源项目
* [https://github.com/acmesh-official/acme.sh/wiki/%E8%AF%B4%E6%98%8E]
###### 安装 acme.sh
    sudo yum -y install socat first    \
    && curl  https://get.acme.sh | sh    
###### 产生https证书
    acme.sh  --issue  -d [域名]  --webroot  [网站根目录]
    示例：acme.sh  --issue  -d normphp.hk.heil.red  --webroot  /docker/normphp/dnmp/data/www/php/
    如提示命令不存在：
    alias acme.sh=~/.acme.sh/acme.sh
###### 安装https证书到nginx目录
     acme.sh --install-cert -d [域名] \
     --key-file       [nginx配置key的绝对路径]/key.pem  \
     --fullchain-file [nginx配置fullchain的绝对路径]/fullchain.pem \
     --reloadcmd     "[复制完成配置后需要执行的命令行 如强制重启nginx]"
    ************************示例******************************
     acme.sh --install-cert -d normphp.hk.heil.red \
     --key-file       /docker/normphp/dnmp/data/nginx/conf/ssl_certificate/normphp.hk.heil.red/key.pem  \
     --fullchain-file /docker/normphp/dnmp/data/nginx/conf/ssl_certificate/normphp.hk.heil.red/fullchain.pem \
     --reloadcmd     "docker exec -it docker-compose_nginx_1 service nginx force-reload"
    
    # Nginx 的配置 ssl_certificate 使用 /etc/nginx/ssl/fullchain.cer ，而非 /etc/nginx/ssl/<domain>.cer ，否则 SSL Labs 的测试会报 Chain issues Incomplete 错误
#### 一些建议
#####恰到好处的增加虚拟内存
    free -h # 查看当前内存状态
    # 查看磁盘IO
    # 磁盘IO低于100不建议使用虚拟内存同时注意性能内存会消耗一定的CPU性能
    
        
