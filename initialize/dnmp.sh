#!/bin/bash
Path=$(readlink -f "$(dirname "$0")")
echo "创建目录：/docker/normphp/dnmp/rc"
sudo mkdir -p /docker/normphp/dnmp/rc
`sudo cp -r ${Path}/rc.sh /docker/normphp/dnmp/rc/rc.sh`
echo “设置开机执行sudo bash /docker/normphp/dnmp/rc/rc.sh”
sudo echo "sudo bash /docker/normphp/dnmp/rc/rc.sh" >> /etc/rc.local
sudo chmod +x  /etc/rc.local
sudo chmod 755 /etc/rc.local