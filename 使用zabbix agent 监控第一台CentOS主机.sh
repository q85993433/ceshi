#!/bin/bash
#使用zabbix agent 监控第一台CentOS主机
#zabbix服务器和监控主机需在同一个网络下
#1.安装并配置agent
rpm -Uvh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm 
yum clean all
yum install -y zabbix-agent
# 配置
vim /etc/zabbix/zabbix_agentd.conf

# zabbix 服务端地址
Server=10.10.2.60
# zabbix活动服务器地址
ServerActive=10.10.2.60
# 主机名，填本机IP
Hostname=客户端IP

#启动zabbix-agent
systemctl enable zabbix-agent.service
systemctl start zabbix-agent.service