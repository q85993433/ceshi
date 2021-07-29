配置supervisor实现进程守护

#安装supervisor
 yum install -y supervisor

 #启动服务
 supervisord -c /etc/supervisord.conf

 进入 cd /etc 目录 找到supervisord.conf 配置文件 和 supervisord.d 文件夹，使用vim编辑supervisord.conf文件，拉到最底部我们可以看到


 files = supervisord.d/*.ini 这句代码说明它会加载supervisord.d文件夹中的所有.ini配置文件


 编辑配置文件
随后我们在supervisord.d中创建一个delploy.ini文件并编辑如下
cd /etc/supervisord.d/
vim delploy.ini
[program:DeployLinux]   #DeployLinux  为程序的名称
command=dotnet DeployLinux.dll #需要执行的命令
directory=/home/publish #命令执行的目录
environment=ASPNETCORE__ENVIRONMENT=Production #环境变量
user=root #用户
stopsignal=INT
autostart=true #是否自启动
autorestart=true #是否自动重启
startsecs=3 #自动重启时间间隔（s）
stderr_logfile=/var/log/ossoffical.err.log #错误日志文件
stdout_logfile=/var/log/ossoffical.out.log #输出日志文件

重载配置文件
执行命令使用心得配置文件运行supervisor服务

supervisorctl reload  //重新加载配置文件
supervisor 配置完毕，使用supervisorctl reload 和supervisorctl update

启动Supervisor服务

　　supervisord -c /etc/supervisor/supervisord.conf

#问题一：在其他的博客上，laravel文档上的的启动命令是 sudo supervisorctl reread但是在centos上使用这个命令会报错error: <class 'socket.error'>, [Errno 2] No such file or directory: file: /usr/lib64/python2.7/socket.py line: 224

#解决办法：supervisord -c /etc/supervisor/supervisord.conf来启动
#centos上常用的命令
supervisorctl status：查看所有进程的状态
supervisorctl stop ：停止
supervisorctl start ：启动
supervisorctl restart 或者使用supervisorctl reload: 重启
supervisorctl update ：配置文件修改后可以使用该命令加载新的配置
supervisorctl reload: 重新启动配置中的所有程序　　

#如果出现报错unix:///tmp/supervisor.sock no such file 可以在尝试在上面所述命令后加上自己配置的supervisord例如 supervisorctl stop buy-order#（ 指令来映射你的队列连接 ）
#使用supervisorctl start 等命令报错Error: Server requires authentication
#问题的原因：因为我们在配置文件中配置了用户名，密码，所以，我们需要先进入supervisord，然后在执行status等命令
执行顺序：1、supervisord -u user
         2、账号、密码
         3、进入到了supervisord 然后在执行  status、stop等命令就可以了


