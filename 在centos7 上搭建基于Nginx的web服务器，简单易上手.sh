在centos7 上搭建基于Nginx的web服务器，简单易上手


Nginx 在开发过程中用得比较多的，无论是前端还是后端都离不了，Nginx的优点有很多，比如轻量、抗并发、支持反向代理、可进行负载均衡、稳定性强、支持热部署、启动速度快等；所以Nginx在企业开发中很流行；下面详细讲一下关于Nginx的安装和配置！

第一步、安装插件


1、安装 gcc 编译器
yum -y install gcc
2、安装 wget 下载器
yum -y install wget
3、安装 pcre、pcre-devel 正则表达式解析库
yum install -y pcre pcre-devel
4、安装 zlib 解压、压缩库
yum install -y zlib zlib-devel
5、安装openssl 保证通信安全
yum install -y openssl openssl-devel

在centos7 上搭建基于Nginx的web服务器，简单易上手
2021-08-30 15:07·来自火星的菜鸟
Nginx 在开发过程中用得比较多的，无论是前端还是后端都离不了，Nginx的优点有很多，比如轻量、抗并发、支持反向代理、可进行负载均衡、稳定性强、支持热部署、启动速度快等；所以Nginx在企业开发中很流行；下面详细讲一下关于Nginx的安装和配置！

第一步、安装插件


1、安装 gcc 编译器
yum -y install gcc
2、安装 wget 下载器
yum -y install wget
3、安装 pcre、pcre-devel 正则表达式解析库
yum install -y pcre pcre-devel
4、安装 zlib 解压、压缩库
yum install -y zlib zlib-devel
5、安装openssl 保证通信安全
yum install -y openssl openssl-devel

第二步、安装Nginx

1、下载nginx
wget http://nginx.org/download/nginx-1.20.1.tar.gz  
2、解压缩
tar -zxvf  nginx-1.20.1.tar.gz
3、切换到cd /root/nginx-1.20.1/下面
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module
make && make install
4、切换到/usr/local/nginx安装目录，编辑nginx.conf文件，配置端口
cd /usr/local/nginx/conf
vim nginx.conf
5、添加用户，防止启动nginx 出现 [emerg] getpwnam("nginx") failed 异常
useradd -s /sbin/nologin -M nginx
id nginx
6、启动nginx服务，切换目录到/usr/local/nginx/sbin下面
./nginx
7、查看nginx服务是否启动成功
ps -ef | grep nginx