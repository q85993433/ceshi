Centos7下OpenVpn服务器搭建 


背景

项目实施过程中，远程访问服务器方式有windows远程桌面、VNC、盗版teamviewer，向日葵、anydesk，甚至还有qq远程桌面的，错综复杂，杂乱无章，项目上没有购置硬件vpn的预算，为了结束这一尴尬的局面，决定使用开源软件openvpn自建vpn环境。


系统环境

OS：CentOS Linux release 7.4.1708 (Core)
SELinux：disabled
firewalld：active
openvpn：2.4.7
easy-rsa：3.0.7

部署openvpn软件

安装openvpn & easy-rsa 软件

yum -y install epel-release
yum -y install openvpn easy-rsa
cp -r /usr/share/easy-rsa/ /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa/3.0.7
cp /usr/share/doc/easy-rsa-3.0.7/vars.example vars

创建证书

创建ca证书
source /vars
编辑vars文件，根据自己的环境配置

ps:这一步不是必须滴，不填写也可以
set_var EASYRSA_REQ_COUNTRY    "CN"
set_var EASYRSA_REQ_PROVINCE   "ShaanXi"
set_var EASYRSA_REQ_CITY       "Xi'an"
set_var EASYRSA_REQ_ORG        "islocal.cc"
set_var EASYRSA_REQ_EMAIL      "xx@islocal.cc"
set_var EASYRSA_REQ_OU         "My OpenVPN"

pwd 显示真实路径
进入/etc/openvpn/easy-rsa/3.0.7目录

目录初始化
./easyrsa init-pki
创建ca证书
./easyrsa build-ca nopass
回车

创建服务器证书和key

./easyrsa gen-req server nopass #生成下列两个文件
回车
 req: /etc/openvpn/easy-rsa/3.0.7/pki/reqs/server.req
key: /etc/openvpn/easy-rsa/3.0.7/pki/private/server.key

 
签约服务端证书

生成服务器证书文件
./easyrsa sign server server
yes
生成如下
1/etc/openvpn/easy-rsa/3.0.7/pki/issued/server.crt

生成vpn密钥协议交换文件

./easyrsa gen-dh #可以看到我们生成的是2048位的加密文件 生成下列文件
1./etc/openvpn/easy-rsa/3.0.7/pki/dh.pem

创建客户端证书
CD 到跟目录
拷贝easy-rsa到client目录下
cp -r /usr/share/easy-rsa/ /etc/openvpn/client/
cd /etc/openvpn/client/easy-rsa/3.0.7
初始化目录
./easyrsa init-pki   生成下列文件
/etc/openvpn/client/easy-rsa/3.0.7/pki

新建用户，创建客户端证书
./easyrsa gen-req ths nopass     
回车显示如下
req: /etc/openvpn/client/easy-rsa/3.0.7/pki/reqs/ths.req
key: /etc/openvpn/client/easy-rsa/3.0.7/pki/private/ths.key

签约客户端证书
注意：返回到服务器目录下操作！！！
cd /etc/openvpn/easy-rsa/3.0.7
./easyrsa import-req /etc/openvpn/client/easy-rsa/3.0.7/pki/reqs/ths.req ths 
./easyrsa sign client ths                
输入yes       
显示如下
/etc/openvpn/easy-rsa/3.0.7/pki/issued/ths.crt

整理一下所有证书
服务器端证书
mkdir /etc/openvpn/certs
cd /etc/openvpn/certs
cp /etc/openvpn/easy-rsa/3.0.7/pki/ca.crt .
cp /etc/openvpn/easy-rsa/3.0.7/pki/dh.pem .
cp /etc/openvpn/easy-rsa/3.0.7/pki/issued/server.crt .
cp /etc/openvpn/easy-rsa/3.0.7/pki/private/server.key .

客户端证书
mkdir /etc/openvpn/client/ths
cd /etc/openvpn/client/ths
cp /etc/openvpn/easy-rsa/3.0.7/pki/ca.crt .
cp /etc/openvpn/easy-rsa/3.0.7/pki/issued/ths.crt .
cp /etc/openvpn/client/easy-rsa/3.0.7/pki/private/ths.key .

配置:
cd /etc/openvpn/
vim server.conf 填入如下内容
服务器端配置文件
local 192.168.6.23		#填写自己的openvpn服务器局域网ip地址，默认侦听服务器上所有的ip
port 11094				#侦听端口，默认为1194，据说网上会过滤1194端口流量，我这里修改为11094
proto tcp				#端口协议，默认udp，开启tcp方便映射转发
dev tun					#创建一个路由ip隧道,路由模式有tun/tap
ca /etc/openvpn/certs/ca.crt	#根证书路径
cert /etc/openvpn/certs/server.crt	#证书
key /etc/openvpn/certs/server.key	#私钥文件（保密）
dh /etc/openvpn/certs/dh.pem		#协议交换文件
ifconfig-pool-persist /etc/openvpn/ipp.txt #记录客户端和虚拟ip的对应关系。当重启OpenVPN时，再次连接的客户端将分配到与上一次分配相同的虚拟IP地址
server 10.66.66.0 255.255.255.0		#设置服务器端模式，并提供一个VPN子网，以便于从中为客户端分配IP地址。服务器会获取10.66.66.1 
push "route 192.168.6.0 255.255.255.0"	#推送路由信息到客户端，以允许客户端能够连接到服务器背后的其他私有子网。
#push "redirect-gateway def1 bypass-dhcp" 
# 启用该指令，所有客户端的默认网关都将重定向到VPN，这将导致诸如web浏览器、DNS查询等所有客户端流量都经过VPN。
push "dhcp-option DNS 223.5.5.5"	
push "dhcp-option DNS 223.6.6.6"
client-to-client		#允许拨号连接vpn的客户端之间相互通信
keepalive 10 120	# 默认每10秒钟ping一次，如果120秒内都没有收到对方的回复，则表示远程连接已经关闭
comp-lzo		# 在VPN连接上启用压缩。如果你在此处启用了该指令，那么也应该在每个客户端配置文件中启用它。
#duplicate-cn	#打开后允许多个客户端使用同一个帐号连接
user openvpn
group openvpn
max-clients 100
persist-key		
persist-tun		#通过keepalive检测vpn超时后，当重新启动vpn后，保持tun或者tap设备自动连接状态
status openvpn-status.log	# 状态日志
log-append  openvpn.log
verb 1	#指定日志文件冗余
# 为日志文件设置适当的冗余级别(0~9)。冗余级别越高，输出的信息越详细。
# 0 表示静默运行，只记录致命错误。
# 4 表示合理的常规用法。
# 5 和 6 可以帮助调试连接错误。
# 9 表示极度冗余，输出非常详细的日志信息。
mute 20	#相同类别的信息只有前20条会输出到日志文件中。


启动openvpn服务
systemctl start openvpn@server
启动服务器后，我们可以监控/etc/openvpn/openvpn.log日志，如果有异常，可根据日志排查。
我们查看一下ip地址，可以看到tun0获取到的是10.66.66.1

设置开机自启动服务
systemctl enable openvpn@server

防火墙策略
开启内核路由转发
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
sysctl -p

开放vpn监听端口
firewall-cmd --zone=public --add-port=11094/tcp --permanent
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=10.66.66.0/24 masquerade'
firewall-cmd --reload

客户端测试
安装Windows客户端
https://build.openvpn.net/downloads/releases/openvpn-install-2.4.7-I607-Win7.exe
https://build.openvpn.net/downloads/releases/openvpn-install-2.4.7-I607-Win10.exe
将/etc/openvpn/client/ths目录下的ca.crt、ths.crt、ths.key复制到“C:\Program Files\OpenVPN\config”目录下
在此目录下新建一个client.ovpn文件

client   
proto tcp  
dev tun    
remote 192.168.6.23 11094              #填写外网的地址
ca ca.crt   
cert ths.crt
key ths.key      
resolv-retry infinite
nobind
mute-replay-warnings
keepalive 20 120
comp-lzo
#user openvpn
#group openvpn
persist-key
persist-tun
status openvpn-status.log
log-append openvpn.log
verb 3
mute 20



server 
reneg-sec 0 : 禁止openvpn证书自动过期，以便用户保持连接。

duplicate-cn : 允许一个用户从多个PC端同时保持连接。

client
reneg-sec 0

注意：IPtables规则是在openvpn服务器进行配置的，而不是openvpn客户端。

IPtables NAT规则如下：
实体机
sudo iptables -t nat -A POSTROUTING -s 10.66.66.0/24 -o eth0 -j MASQUERADE

sudo iptables -nL -t nat
vagrant openvpn 虚拟机
iptables -t nat -A POSTROUTING -s 10.66.66.0/24 -o eth1 -j MASQUERADE