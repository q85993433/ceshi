Centos7 用户登录失败N次后锁定用户禁止登陆
针对linux上的用户，如果用户连续3次登录失败，就锁定该用户，几分钟后该用户再自动解锁。Linux有一个pam_tally2.so的PAM模块，来限定用户的登录失败次数，如果次数达到设置的阈值，则锁定用户。
1、限制用户远程登录
在#%PAM-1.0的下面，即第二行，添加内容，一定要写在前面，如果写在后面，虽然用户被锁定，但是只要用户输入正确的密码，还是可以登录的！

vim /etc/pam.d/sshd
#%PAM-1.0 

auth required pam_tally2.so deny=3 unlock_time=300 even_deny_root root_unlock_time=10
各参数解释
even_deny_root 也限制root用户；
deny 设置普通用户和root用户连续错误登陆的最大次数，超过最大次数，则锁定该用户
unlock_time 设定普通用户锁定后，多少时间后解锁，单位是秒；
root_unlock_time 设定root用户锁定后，多少时间后解锁，单位是秒；
此处使用的是 pam_tally2 模块，如果不支持 pam_tally2 可以使用 pam_tally 模块。另外，不同的pam版本，设置可能有所不同，具体使用方法，可以参照相关模块的使用规则。
2、限制用户从tty登录
在#%PAM-1.0的下面，即第二行，添加内容，一定要写在前面，如果写在后面，虽然用户被锁定，但是只要用户输入正确的密码，还是可以登录的！

vim /etc/pam.d/login
#%PAM-1.0  

auth required pam_tally2.so deny=3 lock_time=300 even_deny_root root_unlock_time=10 
同样是增加在第2行！
3、查看用户登录失败次数

#cd /etc/pam.d/
[root@node100 pam.d]# pam_tally2 --user root  

Login Failures Latest failure From  

root 7 07/16/12 15:18:22 tty1  
4、解锁指定用户

[root@node100 pam.d]# pam_tally2 -r -u root  
Login Failures Latest failure From  




查看状态：

systemctl status sshd.service
启动服务：

systemctl start sshd.service
重启服务：

systemctl restart sshd.service
开机自启：

systemctl enable sshd.service




cat /var/log/secure |grep "Failed password"      撞我密码


 lsof -i |grep ^trojan     查看连接


 pstree -p `ps aux| grep 进程名字 | grep -v grep| awk '{print$2}'`

crontab -e   定时任务

系统管理员若想知道某一时刻用户的行为，只需要输入命令w即可
当登陆系统用户很多的时候，可以在W后面加上某个用户名，则会查看该用户执行任务的情况
last命令  查看用户登录历史

history  查看历史命令


安全建议
1.禁用root
2.用户名和密码尽量复杂
3.修改ssh的默认22端口
4.安装denyhosts防暴力破解软件
5.禁用密码登录，使用RSA公钥登录

redis
1.禁用公网IP监听，包括0.0.0.0
2.使用密码限制访问redis
3.使用较低权限账号运行redis


先停crond  再清crond       