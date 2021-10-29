#!/bin/bash

#docker run --name ubu161 -dit --cap-add=NET_ADMIN ubuntu:16.04
#apt update && apt install sudo -y && apt install zip -y && apt install wget -y && apt install iptables

location=$(pwd)

sudo apt-get update
sudo apt-get install openvpn easy-rsa -y
make-cadir ~/openvpn-ca
cd ~/openvpn-ca

cp vars ~/openvpn-ca

cd ~/openvpn-ca
source vars

./clean-all
./build-ca

./build-key-server server

./build-dh

openvpn --genkey --secret keys/ta.key

cd ~/openvpn-ca
source vars
./build-key client1

cd ~/openvpn-ca/keys
sudo cp ca.crt server.crt server.key ta.key dh2048.pem /etc/openvpn

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

cd $location

sudo cp rc.local /etc/rc.local
sudo chmod 755 /etc/rc.local

cp sysctl.conf /etc/sysctl.conf
sudo sysctl -p

cp server.conf /etc/openvpn/server.conf


#sudo systemctl start openvpn@server
#sudo systemctl status openvpn@server
#sudo systemctl enable openvpn@server

mkdir -p ~/client-configs/files
chmod 700 ~/client-configs/files

cp base.conf ~/client-configs/base.conf

cp make_config.sh ~/client-configs/make_config.sh
chmod 700 ~/client-configs/make_config.sh

cd ~/client-configs
./make_config.sh client1
