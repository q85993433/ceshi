定时任务  周期  contab 分时日月周
通过定时任务日志调试定时任务
Linux系统定时任务软件的种类:
at   适合仅执行一次就结束的调度命令,可以被crontab取代，
crontab   可以周期性的执行任务，需要开启crond服务 在生产工作中最常用到的命令
查看定时任务服务日志
yum -y update
yum -y install cronie yum-cron

查看crond.service的启动状态
systemctl status crond.service

开启crond.service服务命令
systemctl start crond.service

停止crond.service服务命令
systemctl stop crond.service


把cron服务加入linux开机自启动：
[root@localhost ~]# systemctl enable crond.service
[root@localhost ~]# systemctl is-enabled crond.service

放命令vi /etc/crontab

[root@localhost scripts]# tail -f /var/log/cron       -f 实时   尾部




放脚本
•给予文件/root/text.sh执行权限
chmod +x /root/text.sh


•首先打开vi /etc/crontab 定时任务的设置文件
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

*/30 8-20 * * * root /root/it.sh
# */30 代表每30分钟，8-20代表上午8点至晚上20点，后面三个星号，然后需要root的执行权限，后面的路径是脚本文件路径；
查看当前用户的crontab，输入 crontab -l  清空定时任务crontab，输入 crontab -r    

at 一次性任务       atq   或  at  -l    查计划列表
yum -y install at   安装
systemctl  start  atd   启动服务
重启at服务：systemctl restart atd   或   service atd restart
关闭at服务：systemctl stop atd   或   service atd stop
开机不启动at服务：systemctl disable atd   或   chkconfig atd off
开机启动at服务：systemctl enable atd   或   chkconfig atd on

at  20:00
echo  'xiaojiejie'  #  退出按ctl+d

1.今晚关机  shutdown -h 23:59    今晚重启shutdown -r  23:59      
2.at -f 脚本.sh 3/14/2020    
3. at 23:39 3/14/2020       shutdown   
4.查询atq 或at -l             
5.取消没执行atrm 编号 