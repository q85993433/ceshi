#global settings
pid file=/var/rsync/rsync.pid
port=873
lock file=/var/rsync/lock.log
log file=/var/rsync/rsync.log

[xiaojiejie]
path=/home/vagrant/xiaojiejie
use chroot=no
max connections=10
read only=yes
write only=no
list=no
uid=root
gid=root
strict modes=yes
hosts allow=192.168.122.11
hosts deny=*
ignore errors=yes
timeout=120 #秒
[nvyou]
path=/home/vagrant/nvyou
use chroot=no
max connections=10
read only=yes
write only=no
list=no
uid=root
gid=root
auth users=root
secrets file=/etc/rsync_server.pas
strict modes=yes
hosts allow=192.168.122.11
hosts deny=*
ignore errors=yes
timeout=120

cd /var
mkdir rsync

Linux rsync数据定时增量备份
一、安装rsync服务端
1.查看是否安装rsync
ps -ef | grep rsync
系统一般默认已安装，安装方法：yum -y install rsync（没有亲自验证）。

2.添加配置文件
rsync没有默认配置文件，需要手动创建/etc/rsyncd.conf

服务端配置文件/etc/rsyncd.conf 内容如下：

#global settings 
pid file=/var/rsync/rsync.pid
port=873
lock file=/var/rsync/lock.log
log file=/var/rsync/rsync.log

[mysql] 
path=/home/mysql_data_back/
use chroot=no 
max connections=10
read only=yes
write only=no
list=no
uid=root
gid=root
auth users=rsyncuser
secrets file=/etc/rsync_server.pas
strict modes=yes
hosts allow=27.223.26.74,192.168.1.2
hosts deny=*
ignore errors=yes 
timeout=120 #秒
参数说明：
[mysql] ：模块名，自己定义，可以在下方添加其它模块。须与客户端执行命令中的模块名一致。
path：要备份的服务端文件夹路径。
hosts allow：允许的客户端连接IP。
secrets file：服务端密码文件，内容格式为，用户名:密码。
auth users：有权限的用户名，与密码文件中用户名一致。

3.创建密码文件
在/etc中创建文件rsync_server.pas，加入用户名与密码，内容格式为：用户名:密码。
vi /etc/rsync_server.pas
例如，本例中rsync_server.pas文件内容为rsyncuser:123456

然后设置密码文件权限为600
chmod 600 /etc/rsync_server.pas
注意密码文件只有设置为600权限才可以使用，客户端的密码文件也必须为600。

4.启动rsync
/usr/bin/rsync --daemon --config=/etc/rsyncd.conf
附加：停止rsync

ps -ef | grep rsync
kill -9 进程号
rm -rf /var/rsync/rsync.pid
二、安装rsync客户端
1.查看是否安装rsync，系统一般默认已安装，安装方法：yum -y install rsync（同服务端）。
2.在/etc下创建密码文件rsync_client.pas，注意内容只有密码，且与服务端密码文件中的密码相同。
3.更改密码文件权限为600。

三、添加定时任务
在客户端中添加定时任务，每天凌晨执行命令从服务器端拉取数据，进行备份。
直接编辑/etc/crontab文件，添加一条定时任务即可，例如每天01:23以root身份执行下方的rsync命令，将远程服务器27.223.26.74中的mysql模块对应的文件夹（服务端/etc/rsyncd.conf文件中的[mysql]模块对应的文件夹路径 ）中的内容增量备份到当前服务器的/home/oa_daba_backup目录：

23 1 * * * root rsync -aqzrtopg --delete rsync://rsyncuser@27.223.26.74/mysql /home/oa_daba_backup --password-file=/etc/rsync_client.pas
命令中的rsyncuser为服务端密码文件中配置的用户名；mysql为服务端/etc/rsyncd.conf文件中的[mysql]模块名，rsync会通过模块名找到对应的备份文件路径；/home/oa_daba_backup当前服务器文件夹路径，远程服务器需要备份的文件夹里的内容会增量备份到这里，所以需要提前建好该目录；/etc/rsync_client.pas为当前服务器的密码文件。
当直接执行上方备份命令时，可以加入-v --progress参数， 即显示具体备份过程信息，定时任务中则不需要。

此外，使用crontab -e命令也可以直接配置定时任务，但与vi /etc/crontab不同，不同点如下：
1./etc/crontab中的为系统任务，只有root可以设定，而crontab -e设置的定时任务为用户任务，设定完成后会将任务自动写入/var/spool/cron/usename文件。
2./etc/crontab中的任务需要指定用户名，crontab -e不需要。

二者更多的不同请参考下面网址：
https://www.cnblogs.com/xd502djj/p/4292781.html

附：任务策略：
每天零点执行备份命令
00 00 * * * shell命令

每天零点和12点执行备份命令
00 00,12 * * * shell命令
00 00,12 * * * shell命令


