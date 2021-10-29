#apt install sudo -y && apt install zip -y && apt install wget -y

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

cp server.conf /etc/openvpn/server.conf

cp sysctl.conf /etc/sysctl.conf

sudo sysctl -p
