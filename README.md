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
* dnmp目前只支持CentOS 6-7
* dnmp环境：php-fpm
    * 版本：目前支持php-fpm版本：
        * php7.1、php7.3、php7.4、基础版php8.0
    * 类型：环境主要区分在PHP扩展安装上，其中包括如下版本：
        * 新版本中标准环境中不再包含mysql、redis，如需使用执行：dnmp redis up 即可
        * 生产环境[universal] 简单的PHP环境只安装pdo等必要扩展
        * 开发环境[swoole] universal基础上安装了swoole扩展
        * 部署环境[full] universal基础安装了可能用得上的PHP扩展[ssh2、xdebug、swoole、MongoDB]
        * 具体参考build\docker-compose\php\README.md
    * 如需自定义构建自己的php-fpm 可自行编辑build/docker-compose/php/diy/Dockerfile，然后使用dnmp diy-php-fpm build 进行DIY构建测试
* dnmp环境：nginx
    * nginx分两个类型服务：
        * 负载均衡服务：build/docker-compose/docker-compose-nginx.yml
            * 常规nginx http服务 
        * 负载均衡服务：build/docker-compose/docker-compose-upstream.yml   
            * 为使负载均衡服务器性能最优故docker-compose-upstream只build一个nginx images并只启动nginx容器，因此如和正常dnmp服务使用相同nginx配置会导致无法启动负载均衡nginx会提示无法找到fastcgi_pass php-fpm:9000
            * 具体参考：
                * build/docker-compose/nginx/conf/vhost_upstream/README.md
                * build/docker-compose/nginx/conf/upstream/README.md
* 环境配置信息目录：/docker/normphp/dnmp/data/
    * 每一个重要目录下都有一个README.md文件对当前目录进行详细的解释。
* 使用过程中常见问题：
    * 访问IP没有效果请使用 up 命令查看是否有error错误
    * 检查服务器防火墙、云服务商网络安全组是否开放对应[80 443  8080]端口
##### 开始下载安装
    # 执行下面的代码会自动 初始化基础环境、安装docker和docker-compose、构建生成docker-compose.yml文件、注册快捷命令和定时任务
    # 注意：
    #    如果重复执行会对dnmp-master/目录内容进行覆盖  检查sudo 命令是否可用
    rm -rf dnmp-master  master.tar.gz
    # 检查sudo 命令是否可用
    sudo
    # 开始
    yum -y -q install wget tar \
    && wget https://github.com/normphp/dnmp/archive/master.tar.gz -O master.tar.gz && tar -zxvf master.tar.gz \
    && cd dnmp-master/initialize/  \
    && bash build.sh  && source ~/.bashrc \
    && cd ../build/docker-compose/
##### 开始下载安装
    # 配置文件config.sh
    # 配置文件在：dnmp-master/initialize/ 目录下
    
    # 是否开启中心服务 off  on   （总开关）
    export  CentreServe='on'
    # 中心服务器api地址（域名部分部分）
    export  CentreServeAPI='http://dev.heil.red'
    # 中心服务接受 docker 信息接口路由(这里默认配置的是normphp框架支持的api)
    export  CentreServePostDockerInfoRouter='/normphp/dnmp/nowadays/dnmp-remote-api.json'
    # 中心服务接受 宿主机昨天 信息接口路由(这里默认配置的是normphp框架支持的api)
    export  CentreServePostSystemInfoRouter='/normphp/dnmp/nowadays/dnmp-info.json'
    # 配置环境容器
    # 配置使用dnmp  deploy [up -d]启动的 容器组合，注意先后顺序
    export deployDocker=("nginx" "php-fpm-7.4-full" "redis" "mysql");
##### docker-compose 构建与运行[标准环境]    
* 注意：
    * 标准环境不开与负载均衡环境在同一物理机器上（如需要在同一个机器上做实验必须修改标准环境的服务端口docker-compose.yml文件中修改）
    * 一个机器建议中运行一个版本的标准环境
* 在《开始下载安装》章节中我们已经执行了对应的命令行对环境进行了初始化
* 快捷命令(推荐使用)

      # 快捷启动
      dnmp deploy up [-d]
      # 快捷关闭删除
      dnmp deploy down
##### docker-compose 构建与运行[负载均衡环境]    
* 注意：
    * 标准环境不开与负载均衡环境在同一物理机器上（如需要在同一个机器上做实验必须修改标准环境的服务端口docker-compose.yml文件中修改）
    * 负载均衡环境的nginx配置不能拿来就用需要有一定的nginx配置知识再对配置进行简单的修改（下文会进行简单的介绍）。
* 在《开始下载安装》章节中我们已经执行了对应的命令行对环境进行了初始化。
* 简单配置快捷命令(推荐使用)  


      # 快捷构建
      dnmp upstream build
      # 快捷启动 (启动后访问服务器ip你会发现自动负载均衡反代到了百度官网，具体的配置前到nginx配置中查看)
      dnmp upstream up [-d]
      # 快捷关闭删除
      dnmp upstream down  
      # nginx与配置检查
      dnmp upstream exec  nginx-upstream  nginx -t 
      dnmp upstream exec  nginx-upstream service nginx restart   
      # 进入容器
      dnmp upstream exec  nginx-upstream  bash
      # 命令解释：dnmp [环境标识如upstream] exec [服务标识如nginx、redis、php-fpm]  [bash 直接进入容器内、其他命令不进入容器只向容器方式命令行并返回结果]  退出容器按ctrl+d
      # 其他compose服务可参考这里，如不清楚具体的容器服务名称可：
      dnmp upstream ps 
      # 或者查看对应的docker-compose.yml文件中services的下一级就是对应的服务名称
##### docker-compose 构建与运行[应用与服务] 
* 由于考虑到不同应用场景需要的服务不一样新版本的dnmp基础环境不再直接包含mysql、redis等容器服务。
* 不同容器之间的通讯怎么解决？
    * 以docker-compose-redis.yml无例通过定义networks:dnmpNat设置把redis加入到dnmpNat网络然后其他的docker-compose配置文件中也设置了同样的网络，这样就只需要用对应的服务名代替ip地址来连接对应服务就可以了比如连接redis只需要在主机地址上填写nginx就可以连接（原理类型修改系统host文件）
* 简单示例
        

    dnmp redis up -d
    dnmp mysql up -d
    dnmp diy-php-fpm up -d
##### docker-compose 构建与运行[基础知识]
* 本章节只是对基础命令进行解释【不建议执行其中的示例】，具体快捷执行命令请看上面章节


      # -f 代表需要使用的docker-compose.yml文件以及路径
      # 构建项目环境 可选择生成环境[deploy]、开发环境[develop]、生产环境[production]、基础环境[basics]
      docker-compose -f docker-compose-[deploy|develop|production|basics].yml build 
      # 示例：
      docker-compose -f docker-compose-develop.yml build 
      # up 命令为启动环境  up -d 为守护进程启动环境 更多命令请自行网上搜索docker-compose命令
      docker-compose -f docker-compose-[deploy|develop|production|basics].yml up
      # 开发环境构建命令参考[示例]
      docker-compose -f docker-compose-develop.yml build && docker-compose -f docker-compose-develop.yml up
      # 可以访问：[服务器ip]   查看效果
      # 关闭容器、并且删除容器实例
      docker-compose -f docker-compose-[deploy|develop|production|basics].yml down
      ************************docker-compose nginx 服务操作*********************************
      # 检测nginx配置是否正确【注意自行替换-f 参数的文件路径】
      docker-compose -f ~root/dnmp-master/build/docker-compose/docker-compose-[deploy|develop|production|basics].yml  exec nginx -t
      # 重启nginx容器服务【注意自行替换-f 参数的文件路径】
      docker-compose -f ~root/dnmp-master/build/docker-compose/docker-compose-[deploy|develop|production|basics].yml  exec nginx service nginx restart
      # 其他容器服务也可参考使用，命令的最后一个参数 就是需要在容器里面执行的命令行
      #示例：
      docker-compose -f ~root/dnmp-master/build/docker-compose/docker-compose-develop.yml  exec  nginx nginx -t
#####常规docker-composer 命令[基础知识]
     # 下面是常用命令  更多命令请自行网上搜索docker-compose命令
     docker-compose restart [serviceName]: 重启服务
     docker-compose config：验证和查看compose文件
     docker-compose images：列出所用的镜像
     docker-cpmpose scale：设置服务个数 Eg：docker-compose scale web=2 worker=3
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
   
    # 如果使用中心服务 处理acme.sh 更新 查看所有下面命令复制
    # reloadcmd 内容是 执行dnmp.sh tls update-tls  【当前域名】 
    # 原理是acme.sh在更新ssl时会这些 reloadcmd 设置的命令
    # dnmp.sh tls update-tls 会处理完成并且签名post 信息到服务中心的php项目，php使用ssh2链接跳板机把证书复制到对应的负载均衡服务上并且执行命令重启负载均衡nginx 
    # post请求计划请求只支持normphp框架的部署中心，不过好有post请求的文档不使用normphp框架可自行根据文档开发api适配
    acme.sh --install-cert -d normphp.hk.heil.red \
        --key-file       /docker/normphp/dnmp/data/nginx/conf/ssl_certificate/normphp.hk.heil.red/key.pem  \
        --fullchain-file /docker/normphp/dnmp/data/nginx/conf/ssl_certificate/normphp.hk.heil.red/fullchain.pem \
        --reloadcmd     "bash  /root/dnmp-master/initialize/dnmp.sh tls update-tls normphp.hk.heil.red"
    
    # Nginx 的配置 ssl_certificate 使用 /etc/nginx/ssl/fullchain.cer ，而非 /etc/nginx/ssl/<domain>.cer ，否则 SSL Labs 的测试会报 Chain issues Incomplete 错误
#### 一些建议
#####恰到好处的增加虚拟内存
    free -h # 查看当前内存状态
    # 查看磁盘IO
        磁盘读取 速度测试 time dd if=/dev/sda2 of=/dev/null bs=8k count=83886080
        磁盘写入 速度测试 dd if=/dev/zero of=test bs=6M count=300 oflag=dsync
    # 磁盘IO低于100不建议使用虚拟内存同时注意虚拟内存会消耗一定的CPU性能
    
        
