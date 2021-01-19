centos7下yum安装python3完整版

因为centos7.6不自带python3,所以需要自己安装python3.

更新一下yum
sudo yum -y update
该 -y 标志用于提醒系统我们知道我们正在进行更改，免去终端提示我们要确认再继续

安装yum-utils
【一组扩展和补充yum的实用程序和插件】
sudo yum -y install yum-utils

安装CentOS开发工具
【用于允许您从源代码构建和编译软件】
sudo yum -y groupinstall development

安装EPEL：
sudo yum -y install epel-release

安装IUS软件源：
sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm

安装Python3.6：
sudo yum -y install python3.6

安装pip3：
sudo yum -y install python3.6-pip

检查一下安装情况，分别执行命令查看：
python3.6 -V
pip3.6 -V

添加软链接
使用python3去使用Python3.6：
ln -s /usr/bin/python3.6 /usr/bin/python3
复制代码pip3.6同理：
ln -s /usr/bin/pip3.6 /usr/bin/pip3

