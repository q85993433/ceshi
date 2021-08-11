#!/bin/bash
#普罗米修斯安装实测

#1.安装go环境
wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz
tar -C /usr/local/ -xvf go1.12.linux-amd64.tar.gz
vim /etc/profile    //配置环境变量
在文件的最后添加如下内容：
export PATH=$PATH:/usr/local/go/bin
source  /etc/profile //刷新配置
go version//查看是否安装成功

#二.安装prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.24.1/prometheus-2.24.1.linux-amd64.tar.gz
tar -C /usr/local/ -xvf prometheus-2.24.1.linux-amd64.tar.gz
ln -sv /usr/local/prometheus-2.24.1.linux-amd64/ /usr/local/prometheus     //做个软链接
/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml &   //启动验证是否安装成功

#浏览器打开： http://ip:9090/   查看是否正常进行验证


#三.安装Grafana做数据展现

wget https://dl.grafana.com/oss/release/grafana-5.4.2-1.x86_64.rpm

rpm -ivh --nodeps grafana-5.4.2-1.x86_64.rpm

sudo /bin/systemctl daemon-reload

sudo /bin/systemctl enable grafana-server.service

sudo /bin/systemctl start grafana-server.service

#ip:3000   admin admin


#centos7 客户端
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
tar -xvf node_exporter-0.17.0.linux-amd64.tar.gz -C /usr/local/
nohup /usr/local/node_exporter-0.17.0.linux-amd64/node_exporter &     #不停运行
/usr/local/node_exporter-0.17.0.linux-amd64/node_exporter       #单次运行
#服务器添加普罗米修斯配置文件添加监控项
vim /usr/local/prometheus/prometheus.yml

#默认node-exporter端口为9100
    - job_name: 'agent'
    static_configs:
    - targets: ['192.168.0.102:9100']
      labels:
        instance: Prometheus


#windows客户端   https://github.com/prometheus-community/windows_exporter/releases
vim /usr/local/prometheus/prometheus.yml
默认wmi-exporter端口为9182

  - job_name: 'windows'
    static_configs:
    - targets: ['192.168.0.102:9182']

#改完配置文件后,重启服务。是服务器重新运行这个命令，这个是很重要的
pkill prometheus
/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml &
sudo /bin/systemctl restart grafana-server.service


#重启电脑后
先运行 

cd /usr/local/prometheus/alertmanager-0.21.0.linux-amd64/
./alertmanager --config.file=alertmanager.yml &
/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml &
sudo /bin/systemctl restart grafana-server.service    #service grafana-server restart
systemctl restart prometheus-webhook-dingtalk