yum安装Nginx
1.配置源码
sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
2.yum 安装
sudo yum install -y nginx

启动
sudo systemctl start nginx  
停止  
sudo systemctl stop nginx

查看状态
sudo systemctl status nginx

开机启动
sudo systemctl enable nginx

开放80端口
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload

卸载
sudo yum remove nginx

配置信息说明

网站文件存放默认目录

/usr/share/nginx/html

网站默认站点配置

/etc/nginx/conf.d/default.conf
自定义Nginx站点配置文件存放目录

/etc/nginx/conf.d/

Nginx全局配置
/etc/nginx/nginx.conf

Nginx启动
nginx -c nginx.conf