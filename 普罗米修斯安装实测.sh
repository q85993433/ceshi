#!/bin/bash
#普罗米修斯安装实测



#1.安装go环境
wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz
tar -C /usr/local/ -xvf go1.12.linux-amd64.tar.gz
vim /etc/profile    //配置环境变量
export PATH=$PATH:/usr/local/go/bin
source /etc/profile //刷新配置
go version//查看是否安装成功

#二.安装prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.24.1/prometheus-2.24.1.linux-amd64.tar.gz
tar -C /usr/local/ -xvf prometheus-2.24.1.linux-amd64.tar.gz
ln -sv /usr/local/prometheus-2.24.1.linux-amd64/ /usr/local/prometheus     //做个软链接
/usr/local/Prometheus/prometheus --config.file=/usr/local/Prometheus/prometheus.yml &   //启动验证是否安装成功

#浏览器打开： http://ip:9090/   查看是否正常进行验证


#三.安装Grafana做数据展现

wget https://dl.grafana.com/oss/release/grafana-5.4.2-1.x86_64.rpm

rpm -ivh --nodeps grafana-5.4.2-1.x86_64.rpm

sudo /bin/systemctl daemon-reload

sudo /bin/systemctl enable grafana-server.service

sudo /bin/systemctl start grafana-server.service