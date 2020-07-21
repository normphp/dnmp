#!/bin/bash
echo "创建目录：/docker/normphp/dnmp/rc"
sudo mkdir -p /docker/normphp/dnmp/rc
sudo cp -r ./rc.sh /docker/normphp/dnmp/rc/rc.sh
echo “设置开机执行sh”
sudo echo "sudo bash /docker/normphp/dnmp/rc/rc.sh" >> /etc/rc.local