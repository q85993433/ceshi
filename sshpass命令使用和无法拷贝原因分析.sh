sshpass命令使用和无法拷贝原因分析

一、sshpass安装

yum install sshpass

sshpass -V

二、sshpass命令使用

1、直接远程连接某主机
sshpass -p {密码} ssh {用户名}@{主机IP}

2、远程连接指定ssh的端口
sshpass -p {密码} ssh -p ${端口} {用户名}@{主机IP} 

3、从密码文件读取文件内容作为密码去远程连接主机
sshpass -f ${密码文本文件} ssh {用户名}@{主机IP} 

4、从远程主机上拉取文件到本地
sshpass -p {密码} scp {用户名}@{主机IP}:${远程主机目录} ${本地主机目录}

5、将主机目录文件拷贝至远程主机目录
sshpass -p {密码} scp ${本地主机目录} {用户名}@{主机IP}:${远程主机目录} 

sshpass -p "密码" scp -r  /var/www/html/test.txt  root@ip地址:/web/website/Test/


6、远程连接主机并执行命令
sshpass -p {密码} ssh -o StrictHostKeyChecking=no {用户名}@{主机IP} 'rm -rf /tmp/test'

-o StrictHostKeyChecking=no ：忽略密码提示

7、将远程目录拷贝至本地主机目录

sshpass -p {密码} scp -r {用户名}@{主机IP}:${远程主机目录} ${本地主机目录}

 sshpass -p "密码" scp -r  /var/www/html/test/  root@ip地址:/web/website/Test/
 

避坑注意：

本人首次使用的时候，一直无法把文件转移到指定目录，也没有任何报错，后来使用了

scp -r {用户名}@{主机IP}:${远程主机目录} ${本地主机目录}        即把scp前面的先去掉，然后输入远程目标主机的密码，然后就可以使用了sshpass -p {密码} scp -r了。。。。。

大家引以为戒。
————————————————
将远程目录拷贝至本地主机目录
sshpass -p admin217 scp -r root@192.168.122.6:/etc/openvpn/certs /root/certs
sshpass -p admin217 scp -r root@192.168.122.6:/etc/openvpn/client/ths /root/ths

将主机目录文件拷贝至远程主机目录
sshpass -p {密码} scp ${本地主机目录} {用户名}@{主机IP}:${远程主机目录} 

sshpass -p "密码" scp -r  /var/www/html/test.txt  root@ip地址:/web/website/Test/
————————————————
sshpass -p admin217 scp -r /root/jiaoben root@192.168.122.11:/home/vagrant/