zabbix 5.0 安装

https://www.zabbix.com/cn/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=apache
先安装mysql 

选择您Zabbix服务器的平台
a. 安装 数据库
产品手册
# rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
# yum clean all
b. Install Zabbix server and agent
# yum install zabbix-server-mysql zabbix-agent
c. Install Zabbix frontend
产品手册
Enable Red Hat Software Collections

# yum install centos-release-scl
编辑配置文件 /etc/yum.repos.d/zabbix.repo and enable zabbix-frontend repository.

[zabbix-frontend]
...
enabled=1
...
Install Zabbix frontend packages.

# yum install zabbix-web-mysql-scl zabbix-apache-conf-scl
d. 创建初始数据库
产品手册
在数据库主机上运行以下代码。

# mysql -uroot -p
password
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user zabbix@localhost identified by 'password';
mysql> grant all privileges on zabbix.* to zabbix@localhost;
mysql> quit;
导入初始架构和数据，系统将提示您输入新创建的密码。

# zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
e. 为Zabbix server配置数据库
编辑配置文件 /etc/zabbix/zabbix_server.conf

DBPassword=password
f. 为Zabbix前端配置PHP
编辑配置文件 /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf

php_value[date.timezone] = Asia/Shanghai
g. 启动Zabbix server和agent进程
启动Zabbix server和agent进程，并为它们设置开机自启：

# systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm
# systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm
h. 配置Zabbix前端
连接到新安装的Zabbix前端： http://server_ip_or_name/zabbix
根据Zabbix文件里步骤操作： Installing frontend
账号  Admin   密码zabbix   
Database host hostname 

database host 127.0.0.1     

安装有问题问题有缺少的需求 libmysqlclient.so.18()(64bit)

wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-libs-compat-5.7.25-1.el7.x86_64.rpm
rpm -ivh xxx


开始搭建：
开启邮件服务，设为自启：

systemctl start postfix
systemctl enable postfix
1
2
安装yum仓库：（server和agent端都要安装）也可以用5.0插件集合包地址，快速安装，就不用去官网下载了 点我跳转

rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
1
更新yum仓库：（server和agent端都需配置）

yum repolist 
1
先下个epel源：

yum -y install epel-release.noarch