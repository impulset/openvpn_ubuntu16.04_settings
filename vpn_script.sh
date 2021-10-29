sudo apt-get update
sudo apt-get install openvpn easy-rsa
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

cp server.conf /etc/openvpn/server.conf

cp sysctl.conf /etc/sysctl.conf

sudo sysctl -p
