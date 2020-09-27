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
    # 写入Expect授权文件 sshKeyEmail
    expectPath="${root_dir}/initialize/expect/"
    `cat ${expectPath}addSshKeyExpect.sh`
      if [ $? -ne 0 ];then
        echo "写入Expect授权文件 sshKeyEmail"
        echo '#!/usr/bin/expect
#用expect执行下面脚本
set timeout 10
# 执行添加
spawn  ssh-keygen -t rsa -C "'${sshKeyEmail}'"
#看到这样的文本时
expect "id_rsa):"
#输入默认
exp_send "\n"
expect  "passphrase):"
exp_send "'${sshKeyPassword}'"
expect "passphrase again:"
exp_send "'${sshKeyPassword}'"
#进入交互状态
interact
' >"${expectPath}addSshKeyExpect.sh"
      fi
    # 执行授权文件
    `/usr/bin/expect ${expectPath}addSshKeyExpect.sh`
    cat ~/.ssh/id_rsa.pub
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
  # 写入授权命令行
  expectPath="${root_dir}/initialize/expect/"
  cat ${expectPath}sshAuthorizationExpect.sh >>null

  echo "写入Expect授权文件 sshAuthorizationExpect"
   # ssh-copy-id -i ~/.ssh/id_rsa.pub root@【目标服务主机IP】 -p 【端口号】
  echo '#!/usr/bin/expect
#用expect执行下面脚本
set timeout 5
# 执行添加
spawn  ssh-copy-id -i /root/.ssh/id_rsa.pub root@'${2}' -p '${3}'
#看到这样的文本时
expect "connecting (yes/no)?"
#输入默认
exp_send "yes\n"
expect  "password:"
exp_send "'${4}'\n"
#进入交互状态
interact
' >"${expectPath}sshAuthorizationExpect.sh"
    # 执行授权文件
  echo `/usr/bin/expect ${expectPath}sshAuthorizationExpect.sh`
  rm -rf  ${expectPath}sshAuthorizationExpect.sh
}

