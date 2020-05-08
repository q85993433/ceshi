为centos7 开启ROOT远程链接 及 重置ROOT密码

允许root用户远程登陆

# vim /etc/ssh/sshd_config
修改参数为
PermitRootLogin yes     去掉#
PasswordAuthentication yes
使用之前的非ROOT账号密码链接服务器
临时切换ROOT

sudo su
重置 ROOT 密码

passwd root
重启 sshd 服务使配置修改生效

systemctl restart sshd

可以使用root/刚设置的密码 链接服务器登陆了
