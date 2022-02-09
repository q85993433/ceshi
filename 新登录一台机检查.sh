#!/bin/bash# 新登录一台机检查

cat /etc/redhat-release  #查系统版本
uname -a  #查内核版本
uname -r   #查内核版本
uptime #负载
df -h            #查磁盘占用的空间 查看当前文件系统信息，包括容量大小、使用情况、挂载点等
fdisk -l     #查看当前的磁盘分区信息(主要是分区表信息)
hostnamectl #主机名     永久修改主机名：hostnamectl set-hostname永久主机名 是对/etc/hostname文件的内容进行修改
临时修改主机名:hostname #临时主机名

#永久修改主机名：hostnamectl #永久主机名    是对/etc/hostname文件的内容进行修改
who   #谁登录
grep sh$ /etc/passwd   #谁有shell访问劝
w  #查看谁登录
pkill -kill  -t pts/0   #踢掉一个从某个终端连上的用户
last  #命令用于查看当前和过去登录系统用户的相关信息
ifconfig #网络
lsof -i     #端口              lsof-i:22   22端口
netstat -anp    #网络连接 yum install -y net-tools
rpm -qa #查看安装软件
ps -ef   ps aux    systemctl #显示进程和服务
ps -ef | grep        #查看某个程序的进程
kill -9  #杀掉进程 
dmesg | tail -20 #dmesg的最后20行日志
dmesg | head -20   #dmesg命令的前20行日志
dmesg | grep cpu    #只想查看关于CPU的信息
free -m   #查看内存
top     #查看进程
crontab -l   # 查看当前用户的计划任务
crontab -e   #定时任务 
systemctl list-unit-files  # 列出所有系统服务 
systemctl list-unit-files | grep enable #过滤查看启动项如下 使用 PageUp 或 PageDown 翻页，查看完毕后按q退出
systemctl enable redis #设置开机自启项
systemctl start nginx.service #启动nginx
systemctl stop nginx.service #结束nginx
systemctl restart nginx.service #重启nginx
systemctl status nginx.service #查看指定服务项状态
systemctl list-dependencies <服务项名称> #查看服务项的依赖关系
systemctl list-units --state failed  #查看出错的服务
systemctl reload <服务项名称> #重新读取配置文件 如果该服务不能重启，但又必须使用新的配置，这条命令会很有用
#服务文件的位置
#我们自己建立的服务文件直接放在 /etc/systemd/system/ 里面就好了。服务文件要使用 .service 后缀名。
#日 志 文 件 说    明 
/var/log/messages #系统启动后的信息和错误日志，是Red Hat Linux中最常用的日志之一 
/var/log/secure #与安全相关的日志信息 
/var/log/maillog #与邮件相关的日志信息 
/var/log/cron #与定时任务相关的日志信息 
/var/log/spooler #与UUCP和news设备相关的日志信息 
/var/log/boot.log #守护进程启动和停止相关的日志消息

#centos开机自动启动命令
#在centos7中,/etc/rc.d/rc.local文件的权限被降低了,没有执行权限,需要给它添加可执行权限。
chmod +x /etc/rc.d/rc.local
#然后就可以在里面添加你要开机自启的命令了
vi /etc/rc.d/rc.local

cat /var/log/secure |grep "Failed password"  #撞我密码
lsof -i |grep trojan     #查看连接
#Centos7系统查看某个端口被哪个进程占用
1.安装netstat工具
yum install net-tools
2.查看服务器所有被占用的端口
netstat -anp
3.验证某个端口是否被占用
netstat -tlnup|grep 7002
4.查看所有监听端口号
netstat -tlnup

5.按照名字查找 find -name 文件名称
find / -name httpd.conf

6.查CPU 型号
dmidecode -s processor-version

7.
