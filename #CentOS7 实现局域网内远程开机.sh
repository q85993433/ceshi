#CentOS7 实现局域网内远程开机

原理：
远程开机的大致原理是关机后仍保持网卡供电，然后客户端通过向目标服务器的网卡发送一串固定的唤醒指令，进而由网卡触发开机。
条件：
远程开机需要硬件支持，如果硬件支持则可以在主板BIOS设置上找到对应的设置，不同的主板BIOS系统其配置方式也不相同，这里无法给出具体的BIOS设置步骤，只给出关键字：网络唤醒、网卡唤醒、wake。
远程开机仅可在局域网内进行
配置方法：
查看网卡名和MAC地址
ifconfig

1、编辑配置文件，保证重启后自动支持远程开机
vi /etc/sysconfig/network-scripts/ifcfg-[网卡名]

在文件的最后增加以下内容：
ETHTOOL_OPTS="wol g"

2.执行命令，让本次关机也支持远程开机
ethtool -s [网卡名] wol g

3、查看现在是否支持唤醒
ethtool [网卡名]| grep -i wake-on
Supports Wake-on: pumbg
Wake-on: g

Wake-on为g代表已经支持。

4、关机
init 0

在某台内网centos主机上测试目标服务器的远程开机：
1、安装wol：
yum install -y wol

2、执行远程开机命令
wol [目标服务器的网卡MAC地址]
