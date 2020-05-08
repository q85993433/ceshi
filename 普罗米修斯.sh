配置环境变量

添加/usr/loacl/go/bin目录到PATH变量中。添加到/etc/profile 或$HOME/.profile都可以

# vim /etc/profile
// 在最后一行添加
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
// wq保存退出后source一下
# source /etc/profile
执行go version，如果现实版本号，则Go环境安装成功。


prometheus整体搭建详细步骤

一.安装go环境

wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz     // 可以自行安装其他版本

tar -C /usr/local/ -xvf go1.12.linux-amd64.tar.gz

vim /etc/profile    //配置环境变量

source /etc/profile //刷新配置

go version //查看是否安装成功



 

二.安装prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.7.2/prometheus-2.7.2.linux-amd64.tar.gz  

tar -C /usr/local/ -xvf prometheus-2.7.2.linux-amd64.tar.gz

ln -sv /usr/local/prometheus-2.7.2.linux-amd64/ /usr/local/prometheus     //做个软链接

/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml &    启动验证是否安装成功

浏览器打开： http://ip:9090/   查看是否正常进行验证

 

三.安装Grafana做数据展现

wget https://dl.grafana.com/oss/release/grafana-5.4.2-1.x86_64.rpm

rpm -ivh --nodeps grafana-5.4.2-1.x86_64.rpm

sudo /bin/systemctl daemon-reload

sudo /bin/systemctl enable grafana-server.service

sudo /bin/systemctl start grafana-server.service

 

四.初始化grafana配置

1.安装完成后，默认为 http://ip:3000  服务的默认账号密码是 ：admin



2.选择 “Add data source” 进行数据源添加，选择Prometheus，选择“Prometheus 2.0 Stats”

3.Settings页面填写普罗米修斯地址并保存

4.保存，切换到首页就可以看到我们的效果了。


