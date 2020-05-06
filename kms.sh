Linux 快速搭建 KMS 激活服务器，让 PC 激活 Windows 和 Office 并自动续期，告别网上的来路不明的激活工具，防止意外中毒。

One key KMS
虽然目前已经有各种 PC 用的 KMS 激活程序，例如KMSAuto或者KMS VL ALL之类的，但是他们都会被 Windows Defender 或者普通的杀毒软件认为是病毒。
 虽然你“相信”这些软件被报毒是很正常的，直接加入白名单了事，然而你确实不知道你从网上搜索下载的这些激活程序是不是真的经过别人的改造植入了病毒……

因此，我们可以利用自己的 Linux VPS 搭建 KMS 激活服务器给自己的 PC 使用，这样既安全无毒又不怕激活丢失。
1.下载脚本并运行，根据提示键入y开始安装 ◦CentOS / Redhat / Fedora
wget https://raw.githubusercontent.com/dakkidaze/one-key-kms/master/one-key-kms-centos.sh && chmod +x one-key-kms-centos.sh &&./one-key-kms-centos.sh

2.下载这个作者写的配套脚本来控制启动/停止/重启等
#下载脚本
wget https://raw.githubusercontent.com/dakkidaze/one-key-kms/master/kms.sh && chmod +x kms.sh
#启动 KMS 服务
./kms.sh start
#这个脚本可以使用的参数：
# start | stop | restart | status

3.如果你的防火墙默认 DROP，那么需要手动放行1688端口
iptables -I INPUT -p tcp --dport 1688 -j ACCEPT

再次提醒，只能激活 VL 版的系统

开机自启

如果只是想简单的让 KMS 服务在 Linux 上开机自启，那么编辑/etc/rc.local文件，在exit 0（如果有）前面加上一句
#假设之前下载的那个 kms.sh 脚本位于 /root/kms.sh
/root/kms.sh start

守护进程

如果你有很高的要求，想让 KMS 服务以守护进程的方式运行，防止服务意外终止
 #Debian / Ubuntu / Mint 使用 apt-get 来安装 supervisor
#CentOS / Redhat / Fedora 使用 yum 来安装 supervisor
#这里以 Debian 系统为例
apt-get install supervisor -y
echo "[program:kms]
command=/usr/local/kms/vlmcsd -L 0.0.0.0:1688
autorestart=true
autostart=true
user=root" > /etc/supervisor/conf.d/kms.conf
/etc/init.d/supervisor restart
如果你使用守护进程方式运行 KMS 服务，那么就不需要在/etc/rc.local中写入开机启动命令


