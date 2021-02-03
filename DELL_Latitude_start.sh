#!/bin/bash

echo "upgrade start"
apt update -y
apt upgrade -y

echo "install vim"
apt install -y vim

echo "install ssh"
ssh_var1="#PermitRootLogin .*"
ssh_var2="PermitRootLogin no"
apt install -y openssh-server
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
sed -i -e "s/$ssh_var1/$ssh_var2/g" /etc/ssh/sshd_config
systemctl enable ssh
systemctl restart ssh

echo "set HandleLidSwitch"
hand_var1="#HandleLidSwitch=suspend"
hand_var2="HandleLidSwitch=ignore"
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.orig
sed -i -e "s/$hand_var1/$hand_var2/g" /etc/systemd/logind.conf
systemctl restart systemd-logind

echo "install RDP"
rdp_var1="unset DBUS_SESSION_BUS_ADDRESS"
rdp_var2="exec mate-session"
apt install -y xserver-xorg-core
apt install -y xorgxrdp
apt install -y xrdp
cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.orig
sed -i -e "32i $rdp_var1" /etc/xrdp/startwm.sh
sed -i -e "33i $rdp_var2" /etc/xrdp/startwm.sh
systemctl restart xrdp

echo "install VirtulBox"
apt install -y openjdk-11-jdk
apt install -y virtualbox virtualbox-guest-additions-iso virtualbox-dkms virtualbox-qt

echo "install Docker"
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
apt-get update -y
apt-get install -y docker-ce

echo "install docker-compose"
curl -L https://github.com/docker/compose/releases/download/1.26.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "install vscode"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt-get update -y
apt-get install -y code
