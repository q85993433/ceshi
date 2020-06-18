centos开机自动启动命令


在centos7中,/etc/rc.d/rc.local文件的权限被降低了,没有执行权限,需要给它添加可执行权限。

chmod +x /etc/rc.d/rc.local

然后就可以在里面添加你要开机自启的命令了

vi /etc/rc.d/rc.local

 

#开机挂载共享目录

sudo vmhgfs-fuse .host:/ /mnt/hgfs -o nonempty -o allow_other

#开放3306端口
iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
service iptables save #保存iptables规则



注意：IPtables规则是在openvpn服务器进行配置的，而不是openvpn客户端。

IPtables NAT规则如下：
实体机
sudo iptables -t nat -A POSTROUTING -s 10.66.66.0/24 -o eth0 -j MASQUERADE

sudo iptables -nL -t nat
vagrant openvpn 虚拟机
iptables -t nat -A POSTROUTING -s 10.66.66.0/24 -o eth1 -j MASQUERADE