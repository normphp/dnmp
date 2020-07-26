# dnmp
适用normphp框架的dnmp环境（docker+nginx+mysql+php）
### 关于dnmp

###背景

####应用场景
* PHP的特点：项目产品的快速实现更新迭代变现
* normphp框架适用性：低门槛学习成本、适用产品的快速实现更新迭代的框架（面向个人开发者、小规模团队）。
* 不考虑大规模集群自动化部署，dnmp只做更好的lnmp代替品，代码不集成在images中，挂载在本地主机上。
* 在部署时nginx 配置好对应的目录，发布模块项目新版本时直接修改目录的软连接到新代码上（事实上这个目录同时被dnmp容器挂载）
    *   按照正统容器的思想应该是业务代码+环境为一个完整容器，或者在容器构建时把代码copy到容器中。
#### 开始
        # 初始化基础环境、安装docker和docker-compose、构建生成docker-compose.yml文件
        yum -y install wget \
        && wget https://github.com/normphp/dnmp/archive/master.tar.gz && tar -zxvf master.tar.gz \
        && cd dnmp-master/initialize/ \
        && bash dnmp.sh
        && cd ../build/docker-compose/ 
        && pwd
        
        # 构建项目环境 可选择生成环境[deploy]、开发环境[develop]、生产环境[production]、基础环境[basics]
        # up 命令为启动环境  up -d 为守护进程启动环境 更多命令请自行网上搜索docker-compose命令
        sl
        && docker-compose -f docker-compose-[deploy|develop|production|basics].yml build
        && docker-compose -f docker-compose-[deploy|develop|production|basics].yml up
#### 一些建议
#####恰到好处的增加虚拟内存
    free -h # 查看当前内存状态
        
