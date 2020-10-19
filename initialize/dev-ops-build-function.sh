#!/bin/bash
# 初始化构建主机的ssh key
ifBuildSshKey()
{
  cat ~/.ssh/id_rsa.pub >>null
  if [ $? -ne 0 ];then
    echo "构建主机没有SSH keys 进行创建"
    yum install -y expect
    # expect垃圾
    which expect
    /usr/bin/expect <<EOF
    set timeout 5
    spawn ssh-keygen -t rsa -C "$sshKeyEmail"
    expect {
        "id_rsa):" { send "\n";exp_continue }
        "passphrase):" { send "$password\n";exp_continue }
        "passphrase again:" { send "$password\n" }
    }
    expect eof
EOF
  fi
}
# 安装Nodejs
installNodejs()
{
    node -v
    if [ $? -ne 0 ];then
        echo "构建主机没有Nodejs 进行安装"
        curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
        yum install -y nodejs
        node -v
        if [ $? -ne 0 ];then
          echo "构建主机安装 Nodejs 失败"
        fi
  fi
}
# app ssh授权
appSSHKYEMandate()
{
  # 检查ssh key
  ifBuildSshKey
  echo -e "\033[31m app ssh授权 \033[0m"
  # 执行
/usr/bin/expect <<EOF
    set timeout 5
    spawn  ssh-copy-id -i /root/.ssh/id_rsa.pub root@${2} -p ${3}
    expect {
        "Host key verification failed." { send "sed -i -e '/${2}/d' /root/.ssh/known_hosts && ssh-copy-id -i /root/.ssh/id_rsa.pub root@${2} -p ${3} \n" }
        "connecting (yes/no)?" { send "yes\n";exp_continue }
        "password:" { send "${4}\n" }
    }
    spawn ssh root@${2} -p ${3}
    expect {
        "continue connecting (yes/no)?" { send "echo'授权失败'" }
        "]#" { send "ifconfig -a |grep inet |grep -v 127.0.0.1 |grep -v inet6 && hostname && exit \n" }
    }
    expect eof
EOF
  hostname
      #sed -i -e "/${2}/d" /root/.ssh/known_hosts
}
devOpsDocument()
{
  echo '
  1、文件结构：
    1）、nginx配置/docker/normphp/dnmp/data/nginx/conf/default_devops.conf
    2）、项目代码目录/docker/normphp/dnmp/data/devops/code/devops-admin/[resource为前端资源,normphp为php项目资源]
    3）、使用独立MySQL、Redis时数据目录/docker/normphp/dnmp/data/devops/data/
  2、Mysql相关：
    1）、ROOT密码：默认使用dnmp-master/build/docker-compose/.env文件（注意.env为隐藏文件可以使用ls -l 查看隐藏文件）的MYSQL_ROOT_PASSWORD变量控制（只有第一次执行启动命令时从会有效）
    2）、默认会创建一个normphp账号 密码为normphp 所有ip可访问
      a）、默认创建账号为.env 中的MYSQL_USER变量定义 密码为MYSQL_PASSWORD变量定义
      b）、如需要修改控制ip访问可执行如下命令
        进入容器 连接mysql  根据提示输入root密码
        docker exec -it docker-compose_devops-mysql_1  mysql -u root -p
        选择数据库 mysql
        use mysql
        select user, host from user;
        update user set host = '%' where user = 'root' and host = '%';
  ';




}

