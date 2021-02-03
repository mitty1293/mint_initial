#!/bin/bash

echo upgrade_Log_start
apt update -y
apt upgrade -y

echo vim_Log_start
apt install -y vim

echo ssh_Log_start
ssh_var1="#PermitRootLogin .*"
ssh_var2="PermitRootLogin no"
apt install -y openssh-server
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
sed -i -e "s/$ssh_var1/$ssh_var2/g" /etc/ssh/sshd_config
systemctl enable ssh
systemctl restart ssh

echo HandleLidSwitch_Log_start
hand_var1="#HandleLidSwitch=suspend"
hand_var2="HandleLidSwitch=ignore"
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.orig
sed -i -e "s/$hand_var1/$hand_var2/g" /etc/systemd/logind.conf
systemctl restart systemd-logind

echo RDP_Log_start
rdp_var1="unset DBUS_SESSION_BUS_ADDRESS"
rdp_var2="exec mate-session"
apt install -y xserver-xorg-core
apt install -y xorgxrdp
apt install -y xrdp
cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.orig
sed -i -e "32i $rdp_var1" /etc/xrdp/startwm.sh
sed -i -e "33i $rdp_var2" /etc/xrdp/startwm.sh
systemctl restart xrdp

echo VirtulBox_Log_start
apt install -y openjdk-11-jdk
apt install -y virtualbox virtualbox-guest-additions-iso virtualbox-dkms virtualbox-qt

echo Docker_Log_start
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
apt-get update -y
apt-get install -y docker-ce
