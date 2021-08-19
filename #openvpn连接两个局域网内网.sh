#openvpn连接两个局域网内网
#环境说明：
#1、上海公司内网的网段为192.168.0.0/24，客户端的ip地址为192.168.0.180
#2、厦门公司内网的网段为192.168.20.0/24，服务端的ip地址为192.168.20.20
#3、两个公司内网都可以进行互联网访问
#需求说明：
#1、现需要两个内网互相能够进行访问
#服务器说明：
#服务端和客户端都是戴尔主机，重装为Linux系统，具体为服务端是centos6.5，客户端是centos7.2
#步骤简介：
#1、服务端安装openvpn、easy-rsa
#2、配置服务端和客户端证书
#3、配置服务端文件和客户端文件
#4、客户端安装openvpn，然后进行连接测试
#具体步骤如下

1、服务端安装openvpn、easy-rsa

#cd /etc/yum.repos.d/

#wget http://mirrors.163.com/.help/CentOS6-Base-163.repo

#wget http://mirrors.aliyun.com/repo/Centos-6.repo

#yum makecache

更新软件包

#yum -y update

#yum -y install epel-release

安装openvpn和easy-rsa

#yum install -y openvpn easy-rsa

#cp -r /usr/share/easy-rsa/ /etc/openvpn/easy-rsa

#cd /etc/openvpn/easy-rsa/

# \rm 3 3.0

#cd 3.0.6/

#find / -type f -name "vars.example" | xargs -i cp {} . && mv vars.example vars

2、配置服务端和客户端证书

创建一个新的 PKI 和 CA

# ./easyrsa init-pki

创建新的CA，不使用密码

# ./easyrsa build-ca nopass

Common Name (eg: your user, host, or server name) [Easy-RSA CA]: 回车

CA creation complete and you may now import and sign cert requests.

Your new CA certificate file for publishing is at:

/etc/openvpn/easy-rsa/3.0.6/pki/ca.crt

创建服务端证书

# ./easyrsa gen-req server nopass

Common Name (eg: your user, host, or server name) [server]: 回车

Keypair and certificate request completed. Your files are:

req: /etc/openvpn/easy-rsa/3.0.6/pki/reqs/server.req

key: /etc/openvpn/easy-rsa/3.0.6/pki/private/server.key

签约服务端证书

#./easyrsa sign server server

Type the word 'yes' to continue, or any other input to abort.

Confirm request details: yes

Certificate created at: /etc/openvpn/easy-rsa/3.0.6/pki/issued/server.crt

创建 Diffie-Hellman

# ./easyrsa gen-dh

整理证书

# cd /etc/openvpn

# cp easy-rsa/3.0.6/pki/dh.pem .

# cp easy-rsa/3.0.6/pki/ca.crt .

# cp easy-rsa/3.0.6/pki/issued/server.crt .

# cp easy-rsa/3.0.6/pki/private/server.key .

创建客户端证书

#mkdir Dana

# cp -r /usr/share/easy-rsa/ /etc/openvpn/Dana

# cd /etc/openvpn/Dana/easy-rsa/

# \rm 3 3.0

# cd 3.0.6/

# find / -type f -name "vars.example" | xargs -i cp {} . && mv vars.example vars

生成客户端证书

#./easyrsa init-pki #创建新的pki

# ./easyrsa gen-req Dana nopass #客户证书名，无密码，如果需要密码就不写nopass

Common Name (eg: your user, host, or server name) [Dana]: 回车

Keypair and certificate request completed. Your files are:

req: /etc/openvpn/Dana/easy-rsa/3.0.6/pki/reqs/Dana.req

key: /etc/openvpn/Dana/easy-rsa/3.0.6/pki/private/Dana.key

签约客户端证书

# cd /etc/openvpn/easy-rsa/3.0.6/

# pwd

/etc/openvpn/easy-rsa/3.0.6

#./easyrsa import-req /etc/openvpn/Dana/easy-rsa/3.0.6/pki/reqs/Dana.req Dana

# ./easyrsa sign client Dana

Confirm request details: yes

整理证书

# cd /etc/openvpn/Dana

# cp /etc/openvpn/easy-rsa/3.0.6/pki/ca.crt .

# cp /etc/openvpn/easy-rsa/3.0.6/pki/issued/Dana.crt .

# cp /etc/openvpn/Dana/easy-rsa/3.0.6/pki/private/Dana.key .

3、配置服务端文件和客户端文件

服务端配置文件

# vim /etc/openvpn/server.conf

port 1194

proto udp

dev tun

ca /etc/openvpn/ca.crt

cert /etc/openvpn/server.crt

key /etc/openvpn/server.key

dh /etc/openvpn/dh.pem

ifconfig-pool-persist /etc/openvpn/ipp.txt

server 10.8.0.0 255.255.255.0

push "route 192.168.20.0 255.255.255.0" #向客户端声明服务端的路由

push "redirect-gateway def1 bypass-dhcp"

push "dhcp-option DNS 114.114.114.114"

push "dhcp-option DNS 8.8.8.8"

client-config-dir ccd

client-to-client

route 192.168.0.0 255.255.255.0 #向服务端声明客户端的路由

keepalive 20 120
  
comp-lzo

max-clients 100

user openvpn

group openvpn

persist-key

persist-tun

status openvpn-status.log

log-append openvpn.log

verb 3

mute 20

explicit-exit-notify 1

#mkdir /etc/openvpn/ccd

#vim client

ifconfig-push 10.8.0.14 255.255.255.0

iroute 192.168.0.0 255.255.255.0

客户端配置文件

# vim /etc/openvpn/Dana/Dana.ovpn

client

remote 服务端对外的公网IP 公网端口

proto udp

dev tun

comp-lzo

ca ca.crt

cert Dana.crt

key Dana.key

redirect-gateway def1

dhcp-option DNS 8.8.8.8

verb 3

服务端启动openvpn和配置端口转发

#service openvpn start

开启转发

# vim /etc/sysctl.conf

net.ipv4.ip_forward = 1

# sysctl -p

# iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE

# iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE

#iptables-save

4、客户端安装openvpn，然后进行连接测试

#yum -y update

#yum -y install epel-release

#yum -y install openvpn

把服务端的ca.crt、Dana.ovpn、Dana.key、Dana.crt拷贝到客户端的/etc/openvpn/目录下

# yum -y install iptables iptables-services

# systemctl restart iptables.service

# iptables -F

# iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE

# iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE

#iptables-save

# vim /etc/sysctl.conf

net.ipv4.ip_forward = 1

# sysctl -p

启动客户端vpn

#cd /etc/openvpn

#openvpn Dana.ovpn

#ping 192.168.20.20