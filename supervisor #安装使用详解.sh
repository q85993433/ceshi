supervisor #安装使用详解
yum -y install python-pip
yum install supervisor
supervisord -v   #查看安装的版本
supervisord -c /etc/supervisord.conf   #supervisor启动

#三、supervisor使用
#supervisor配置文件：/etc/supervisord.conf
#注：supervisor的配置文件默认是不全的，不过在大部分默认的情况下，上面说的基本功能已经满足。

#子进程配置文件路径：/etc/supervisord.d/
#注：默认子进程配置文件为ini格式，可在supervisor主配置文件中修改。

systemctl start supervisord.service     #启动supervisor并加载默认配置文件
systemctl enable supervisord.service    #将supervisor加入开机启动项



#常用命令

  supervisord -c /etc/supervisord.conf 	# 启动supervisord服务
  supervisorctl start program_name	# 启动进程
  supervisorctl start all 	# 启动所有进程
  supervisorctl stop program_name 	# 停止进程
  supervisorctl stop all 		# 停止所有进程
  supervisorctl restart program_name	# 重启进程
  supervisorctl update	# 更新配置文件有改动的进程
  supervisorctl reload	# 重新加载所有进程
  supervisorctl shutdown #关闭supervisor命令：
  supervisorctl status #查看supervisor所管理进程状态命令

  子进程配置文件说明：可以是 .conf 或 *.ini</pre> 
给需要管理的子进程(程序)编写一个配置文件，放在/etc/supervisor.d/目录下，以.ini作为扩展名（每个进程的配置文件都可以单独分拆也可以把相关的脚本放一起）。如任意定义一个和脚本相关的项目名称的选项组（/etc/supervisord.d/test.conf）：
#项目名
[program:blog]
#脚本目录
directory=/opt/bin
#脚本执行命令
command=/usr/bin/python /opt/bin/test.py

#supervisor启动的时候是否随着同时启动，默认True
autostart=true
#当程序exit的时候，这个program不会自动重启,默认unexpected，设置子进程挂掉后自动重启的情况，有三个选项，false,unexpected和true。如果为false的时候，无论什么情况下，都不会被重新启动，如果为unexpected，只有当进程的退出码不在下面的exitcodes里面定义的
autorestart=false
#这个选项是子进程启动多少秒之后，此时状态如果是running，则我们认为启动成功了。默认值为1
startsecs=1

#脚本运行的用户身份 
user = test

#日志输出 
stderr_logfile=/tmp/blog_stderr.log 
stdout_logfile=/tmp/blog_stdout.log 
#把stderr重定向到stdout，默认 false
redirect_stderr = true
#stdout日志文件大小，默认 50MB
stdout_logfile_maxbytes = 20MB
#stdout日志文件备份数
stdout_logfile_backups = 20



子进程配置示例：
#说明同上
[program:test] 
directory=/opt/bin 
command=/opt/bin/test
autostart=true 
autorestart=false 
stderr_logfile=/tmp/test_stderr.log 
stdout_logfile=/tmp/test_stdout.log 
#user = test  



[program:x] , 其中x为进程名, 必不可少的 
command , 项目要运行的命令, 必不可少的 
process_name , 进程名, 如果要启动多个进程, 则修改修改, 默认为 %(program_name)% 
numprocs , 启动多个项目实例 


# 文件名为 some-project.conf
[program:some-project] # program后跟着进程名是必须的
command =/data/apps/some-project/bin/python /data/apps/doraemon/some-project/main.py
autostart =true
autorestart =true# 服务挂掉会自动重启
loglevel =info# 输出日志级别
stdout_logfile =/data/log/supervisor/some-project-stdout.log
stderr_logfile =/data/log/supervisor/some-project-stderr.log
stdout_logfile_maxbytes =500MB
stdout_logfile_backups =50
stdout_capture_maxbytes =1MB
stdout_events_enabled =false