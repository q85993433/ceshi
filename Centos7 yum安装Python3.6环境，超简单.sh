Centos7 yum安装Python3.6环境，超简单


配置好Python3.6和pip3
安装EPEL和IUS软件源

yum install epel-release -y
yum install https://centos7.iuscommunity.org/ius-release.rpm -y
安装Python3.6

yum install python36u -y
创建python3连接符

ln -s /bin/python3.6 /bin/python3
安装pip3

yum install python36u-pip -y
创建pip3链接符

ln -s /bin/pip3.6 /bin/pip3

pip3 install polysh    安装polysh
服务器
vim /etc/hosts                        ip   hostname
polysh av{1,2}

