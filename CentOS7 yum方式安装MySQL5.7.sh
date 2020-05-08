CentOS7 yum方式安装MySQL5.7 
在CentOS中默认安装有MariaDB，这个是MySQL的分支，但为了需要，还是要在系统中安装MySQL，而且安装完成之后可以直接覆盖掉MariaDB。

1 下载并安装MySQL官方的 Yum Repository
[root@localhost ~]# wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm

[root@localhost ~]# yum -y install mysql57-community-release-el7-10.noarch.rpm

[root@localhost ~]# yum -y install mysql-community-server

至此MySQL就安装完成了，然后是对MySQL的一些设置。

2 MySQL数据库设置

  首先启动MySQL

[root@localhost ~]# systemctl start  mysqld.service

  查看MySQL运行状态，运行状态如图：

[root@localhost ~]# systemctl status mysqld.service

此时MySQL已经开始正常运行，不过要想进入MySQL还得先找出此时root用户的密码，通过如下命令可以在日志文件中找出密码：
[root@localhost ~]# grep "password" /var/log/mysqld.log     找出日志密码
如下命令进入数据库：

[root@localhost ~]# mysql -uroot -p

  输入初始密码，此时不能做任何事情，因为MySQL默认必须修改密码之后才能操作数据库：

mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'new password';

  这里有个问题，新密码设置的时候如果设置的过于简单会报错：
ERROR 1819 

但此时还有一个问题，就是因为安装了Yum Repository，以后每次yum操作都会自动更新，需要把这个卸载掉：

[root@localhost ~]# yum -y remove mysql57-community-release-el7-10.noarch
此时才算真的完成了

CentOS 7下面的mysql的命令
systemctl stop|start|status|restart mysql

导出整个数据库
mysqldump -uroot -prootpwd -h127.0.0.1 -P3306 db_name > db_name.sql

参数解释如下：

 -u:  使用root用户
 -p:  使用root用户的密码
 -h：指定访问主机
 -P：指定端口号
 db_name : 指定导出的数据库名称
 db_name.sql : 指定导入存储的数据文件

只导出表结构：
mysqldump -uroot -prootpwd -h127.0.0.1 -P3306 --add-locks -q -d db_name> db_name_table.sql 
 -h：指定访问主机
 -P：指定端口号
 -q：不缓冲查询，直接导出至标准输出
 --add-locks ：导出过程中锁定表，完成后回解锁。
 -d ：只导出表结构，不含数据


导入数据库
导入单个库之前，首先需要创建数据库，不然会报错。

[root@ibmserver10 sql]# mysql -uroot -prootpwd db_name  < db_name.sql 
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1049 (42000): Unknown database 'db_name'
创建好数据库之后，则选择这个库，进行数据导入。

[root@ibmserver10 sql]# mysql -uroot -prootpwd db_name  < db_name.sql 
mysql: [Warning] Using a password on the command line interface can be insecure.

刷新权限
如果是导入所有数据库的数据之后，需要flush一下数据库。因为mysql库是包含用户的，如果不flush权限，则会导致这些导入的用户无法登陆使用。

flush PRIVILEGES;



mysqldump 是文本备份还是二进制备份

它是文本备份，如果你打开备份文件你将看到所有的语句，可以用于重新创建表和对象。它也有 insert 语句来使用数据构成表。
mysqldump 的语法是什么？

 mysqldump -u [uname] -p[pass] –databases [dbname][dbname2] > [backupfile.sql]
使用 mysqldump 怎样备份所有数据库？

mysqldump -u root -p –all-databases > backupfile.sql
使用 mysqldump 怎样备份指定的数据库？

mysqldump -u root -p –databases school hospital > backupfile.sql
使用 mysqldump 怎样备份指定的表？

mysqldump –user=root –password=mypassword -h localhost databasename table_name_to_dump table_name_to_dump_2 > dump_only_two_tables_file.sql
我不想要数据，怎样仅获取 DDL？

mysqldump -u root -p –all-databases –no-data > backupfile.sql
一次 mysqldump 备份花费多长时间？

这依赖于数据库大小，100 GB 大小的数据库可能花费两小时或更长时间
怎样备份位于其他服务器的远程数据库？

mysqldump -h 172.16.25.126 -u root -ppass dbname > dbname.sql
–routines 选项的含义是什么？

通过使用 -routines 产生的输出包含 CREATE PROCEDURE 和 CREATE FUNCTION 语句用于重新创建 routines。如果你有 procedures 或 functions 你需要使用这个选项
怎样列出 mysqldump 中的所有选项？

mysqldump –help
mysqldump 中常用的选项是？

All-databases
Databases 
Routines
Single-transaction （它不会锁住表） – 一直在 innodb databases 中使用
Master-data – 复制 （现在忽略了）
No-data – 它将 dump 一个没有数据的空白数据库
默认所有的 triggers 都会备份吗？

是的
single transaction 选项的含义是什么？

–singletransaction 选项避免了 innodb databases 备份期间的任何锁，如果你使用这个选项，在备份期间，没有锁
使用 mysqldump 备份的常用命令是什么？

nohup mysqldump –socket=mysql.sock –user=user1 –password=pass –single-transaction –flush-logs –master-data=2 –all-databases –extended-insert –quick –routines > market_dump.sql 2> market_dump.err &
使用 mysqldump 怎样压缩一个备份？

注意: 压缩会降低备份的速度
Mysqldump [options] | gzip > backup.sql.gz
mysqldump 备份大数据库是否是理想的？

依赖于你的硬件，包括可用的内存和硬盘驱动器速度，一个在 5GB 和 20GB 之间适当的数据库大小。 虽然有可能使用  mysqldump 备份 200GB 的数据库，这种单一线程的方法需要时间来执行。
怎样通过使用 mysqldump 来恢复备份？

使用来源数据的方法

Mysql –u root –p < backup.sql

在恢复期间我想记录错误到日志中，我也想看看恢复的执行时间？Time Mysql –u root –p < backup.sql > backup.out 2>&1怎样知道恢复是否正在进行？显示完整的进程列表如果数据库是巨大的，你不得不做的事情是？使用 nohup 在后台运行它我是否可以在 windows 上使用 mysqldump 备份然后在 linux 服务器上恢复？是的我怎么传输文件到目标服务器上去？

使用 scp

使用 sftp

使用 winscp

如果我使用一个巨大的备份文件来源来恢复会发生什么？如果你的一个数据库备份文件来源，它可能需要很长时间运行。处理这种情况更好的方式是使用 nohup 来在后台运行。也可使用在 unix 中的 screen 代替默认情况下，mysqldump 包含 drop 数据库吗？你需要添加 –add-drop-database 选项怎样从一个多数据库备份中提取一个数据库备份（假设数据库名字是 test）？sed -n '/^-- Current Database: `test`/,/^-- Current Database: `/p' fulldump.sql > test.sql






