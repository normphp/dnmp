#!/bin/bash
# 初始化构建主机的ssh key
ifBuildSshKey()
{
  cat ~/.ssh/id_rsa.pub
  if [ $? -ne 0 ];then
    echo "构建主机没有SSH keys 进行创建"
    yum install -y expect
    # expect垃圾
    which expect
    # 写入Expect授权文件 sshKeyEmail
    expectPath="${root_dir}/initialize/expect/"
    `cat ${expectPath}/sshAuthorizationExpect.sh`
      if [ $? -ne 0 ];then
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
' >sshAuthorizationExpect.sh
      fi
    # 执行授权文件
    /usr/bin/expect ./sshAuthorizationExpect.sh
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
  # 写入授权命令行
  echo 'ssss'

}