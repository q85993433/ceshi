#!/bin/bash# 新登录一台机检查

cat /etc/redhat-release  #查系统版本
uname -a  #查内核版本
uname -r   #查内核版本
uptime #负载
df -h            #查磁盘
hostnamectl #主机名     
临时修改主机名：hostname #临时主机名

#永久修改主机名：hostnamectl #永久主机名    是对/etc/hostname文件的内容进行修改
who   #谁登录
grep sh$ /etc/passwd   #谁有shell访问劝
w  #查看谁登录
pkill -kill  -t pts/0   #踢掉一个从某个终端连上的用户
last  #命令用于查看当前和过去登录系统用户的相关信息
ifconfig #网络
lsof -i     #端口              lsof-i:22   22端口
netstat -anp    #网络连接
rmp -qa #查看安装软件
ps-ef   ps aux    systemctl #显示进程和服务
dmesg | tail -20 #dmesg的最后20行日志
dmesg | head -20   #dmesg命令的前20行日志
dmesg | grep cpu    #只想查看关于CPU的信息