#!/bin/bash
# 修改ssh端口为20022
ssh_Port=20022
sed -i s/"#Port 22"/"Port $ssh_Port"/g /etc/ssh/sshd_config

# 用户在线5分钟无操作则超时断开
echo 'TMOUT=300' >> /etc/profile
source /etc/profile


# 禁止root用户远程登陆
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# 登陆失败3次锁定1分钟
echo 'auth required pam_tally2.so deny=3 unlock_time=60 even_deny_root root_unlock_time=60' >> /etc/pam.d/login

# 历史命令只保留100条
sed -i s/"HISTSIZE="/c"HISTSIZE=100"/g /etc/profile

# 给系统的用户名密码存放文件加锁
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/gshadow
chattr +i /etc/group

# 安装iptables服务
yum -y install iptables-services


# 重启iptables
systemctl restart iptables
# 设置iptables开机自启
chkconfig iptables on
# 重启sshd服务
systemctl restart sshd
