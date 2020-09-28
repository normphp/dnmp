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

