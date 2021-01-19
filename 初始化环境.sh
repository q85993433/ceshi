#!/bin/bash
CentOS 7
必须语言英文
Centos 7 而改为使用/etc/locale.conf这个来进行语言配置。使用vim命令进去，vim /etc/locale.conf，把zh_CN.UTF-8""替换成"en_US.UTF-8" 
echo -e "export LC_ALL=en_US.UTF-8 \n export LANGUAGE=en_US.UTF-8" >> /etc/profile && source /etc/profile      重定向语言
vi /etc/sysconfig/network-scripts/ifcfg-ens33
1）bootproto=static
（2）onboot=yes
（3）在最后加上几行，IP地址、子网掩码、网关、dns服务器（DNS可设可不设，我这里不设置）
IPADDR=192.168.136.150
NETMASK=255.255.255.0
GATEWAY=192.168.136.1
DNS1=114.114.114.114
DNS2=8.8.8.8

3，重启网卡
service network restart
或者
systemctl restart network
重启network后可以联网访问
systemctl restart network

ping www.baidu.com


yum -y install wget      -y自动选择
yum -y install vim wget lsof ntpdate

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

或

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

CentOS 7

wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

4、清理缓存并生成新的缓存

yum clean all
yum makecache 

>>>关闭防火墙
firewall-cmd --state   查看防火墙状态
systemctl stop firewalld.service            #停止firewall
systemctl disable firewalld.service        #禁止firewall开机启动

临时关闭selinux
[root@localhost ~]# getenforce
[root@localhost ~]# setenforce 0
[root@localhost ~]# getenforce

1.3 关闭selinux
vi /etc/selinux/config
修改SELINUX=disabled
时间同步
yum -y install  ntpdate
ntpdate ntp1.aliyun.com
date

计算机名字
hostnamectl --static set-hostname xiaojiejie
cat /etc/hostname
vim /etc/hosts
......
IP xiaojiejie

设置时区  [[ $(date|grep -o CST)  ]]  || sudo  \cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime