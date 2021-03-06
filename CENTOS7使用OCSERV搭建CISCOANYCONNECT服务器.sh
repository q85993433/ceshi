CENTOS7使用OCSERV搭建CISCOANYCONNECT服务器
最近这段时间我朝的墙是越来越猛，有点赶尽杀绝的意思，也不知道是有什么重要日子？

对于搭自用梯子的话，目前有一个比较好的方案可以非常有效的“防封”，就是今天要给大家介绍的Ocserv（OpenConnect）以下简称Ocserv。

因为Anyconnect是思科开发出来的，众所周知思科的网络设备天下第一，很多大型的企业都是用思科的设备，包括Anyconnect这种VPN解决方案，所以墙不敢随便封这种协议的梯子。

但是由于思科只允许Anyconnect运行在思科的设备上，所以就有了今天的Ocserv服务端。Ocserv诞生的主要目的就是可以让任何设备都能安装上Anyconnect而不在局限于思科。

因为最近墙实在是太鸡儿猛了，所以没办法才用Anyconnect的，一般情况下这玩意我都不想碰，毕竟搭建和配置都比较麻烦，而且也不是很好配合其他的加速软件，所以就一直没想写这方面的文章，今天就详细写一下吧。

为了教程更简便，这里我直接用EPEL源安装Ocserv，可以省去麻烦的编译过程。首先安装EPEL源：

yum -y install epel-release
然后就可以直接YUM安装Ocserv了：

yum -y install ocserv
新建一个目录，用来存放SSL证书相关文件，然后进入到这个目录内：

mkdir ssl
cd ssl
新建一个证书模板：

vi ca.tmpl
写入：

cn = "LALA"
organization = "LALA.IM"
serial = 1
expiration_days = 9999
ca
signing_key
cert_signing_key
crl_signing_key
注：LALA和LALA.IM可以根据自己的需要更改，反正都是自签证书，随便瞎鸡儿写也没关系。。。

然后生成私钥和CA证书：

certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem
接着来生成服务器证书，还是老样子新建一个证书模板：

vi server.tmpl
写入：

cn = "你的服务器IP"
organization = "LALA.IM"
expiration_days = 9999
signing_key
encryption_key
tls_www_server
注：cn后面的值改成你的服务器公网IP。

然后生成私钥和证书：

certtool --generate-privkey --outfile server-key.pem
certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem
然后我们把证书文件用移动到Ocserv默认的目录下：

cp server-cert.pem /etc/pki/ocserv/public/
cp server-key.pem /etc/pki/ocserv/private/
cp ca-cert.pem /etc/pki/ocserv/cacerts/
现在编辑ocserv的配置文件（需要改动的地方很多，如果vi不好用就自己用SFTP把这个文件下载到本地用专业的编辑器编辑）：

vi /etc/ocserv/ocserv.conf
让我们一起来看看需要改哪些地方：

1、auth也就是验证方式要改为：

auth = "plain[passwd=/etc/ocserv/ocpasswd]"
如图所示：



2、默认的监听端口为443，如果你的服务器上跑着HTTPS的WEB站点，那么443端口肯定是被占用了的，所以如果有需求的话，可以更改下面的值：

# TCP and UDP port number
tcp-port = 443
udp-port = 443
如图所示：



3、Anyconnect有一个设置连接欢迎信息的功能，也就是你在连接的时候会弹出一个提示框，提示框的内容就可以自行设置，如有需要可以更改下面的值：

# A banner to be displayed on clients
banner = "Welcome LALA.IM"
如图所示：



4、Anyconnect可以限制最大允许连接的设备数量，如有需要可以更改下面这两个值：

max-clients = 16
max-same-clients = 2
如图所示：



5、更改服务器证书以及私钥的路径为我们刚才移动的路径：

server-cert = /etc/pki/ocserv/public/server-cert.pem
server-key = /etc/pki/ocserv/private/server-key.pem
如图所示：



6、更改CA证书的路径为我们刚才移动的路径：

ca-cert = /etc/pki/ocserv/cacerts/ca-cert.pem
如图所示：



7、取消如下几个参数的注释（去掉#号就是去掉注释）：

ipv4-network
ipv4-netmask
如图所示：



8、去掉如下参数的注释以及设置DNS服务器地址：

tunnel-all-dns = true
dns = 8.8.8.8
dns = 8.8.4.4
如图所示：



确定你已经修改好上面的内容，然后保存即可。

现在来创建一个VPN用户：

ocpasswd -c /etc/ocserv/ocpasswd lala
盲输两遍密码即可。如果不想让这个用户继续使用了，可以执行下面的命令删除指定的用户：

ocpasswd -c /etc/ocserv/ocpasswd -d lala
现在我们开启机器的IPV4转发功能：

echo 1 > /proc/sys/net/ipv4/ip_forward
然后启动CentOS7的Firewalld防火墙：

systemctl start firewalld.service
放行Anyconnect的端口（我这里之前设置的是默认的443端口，如果你修改了端口，那么这里也要对应）：

firewall-cmd --permanent --zone=public --add-port=443/tcp
firewall-cmd --permanent --zone=public --add-port=443/udp
设置转发：

firewall-cmd --permanent --add-masquerade
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -o eth0 -j MASQUERADE
注：eth0是你的公网网卡名字，每个机器的名字可能都不一样，自己用ifconfig命令查一下就行了。

重加载，让新的配置生效：

firewall-cmd --reload
现在就可以尝试运行一下Ocserv了：

ocserv -f -d 1
如果一切正常，回显的内容大致如下图所示：



确定正常后按键盘组合键Ctrl+C退出运行，现在我们就可以直接用systemctl来管理Ocserv的进程。

设置Ocserv开机启动：

systemctl enable ocserv
启动Ocserv：

systemctl start ocserv

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE

记得设置开机自动启动命令
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE