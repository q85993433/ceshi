#Prometheus基于Alertmanager实现钉钉告警
wget https://github.com/timonwong/prometheus-webhook-dingtalk/releases/download/v0.3.0/prometheus-webhook-dingtalk-0.3.0.linux-amd64.tar.gz
tar -zxf prometheus-webhook-dingtalk-0.3.0.linux-amd64.tar.gz -C /opt/
mv /opt/prometheus-webhook-dingtalk-0.3.0.linux-amd64 /opt/prometheus-webhook-dingtalk


3.启动钉钉插件dingtalk
vim /etc/systemd/system/prometheus-webhook-dingtalk.service
#添加如下内容
[Unit]
Description=prometheus-webhook-dingtalk
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/opt/prometheus-webhook-dingtalk/prometheus-webhook-dingtalk --ding.profile=ops_dingding=自己钉钉机器人的Webhook地址

[Install]
WantedBy=multi-user.target

#命令行启动
systemctl daemon-reload
systemctl start prometheus-webhook-dingtalk
ss -tnl | grep 8060
systemctl enable prometheus-webhook-dingtalk

#alertmanager系列：alertmanager安装配置
wget https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
tar zxvf alertmanager-0.21.0.linux-amd64.tar.gz
vim/opt/alertmanager/alertmanager.yml
#vim /usr/local/prometheus/alertmanager-0.21.0.linux-amd64/alertmanager.yml
  global:
    resolve_timeout: 1m
  route:
    group_by: ['severity']  # 根据报警规则的 rules文件 severity标签进行分类
    group_wait: 10s  # 组告警等待时间。也就是告警产生后等待10s，如果有同组告警一起发出
    group_interval: 10s # 两组告警的间隔时间
    repeat_interval: 5h ## 重复告警的间隔时间，减少相同邮件的发送频率
    receiver: 'webhook'
  receivers: # 接受者，可以是邮箱，wechat或者web接口等等
  - name: 'webhook'
    webhook_configs:
    - url: http://127.0.0.1:8060/dingtalk/ops_dingding/send
      send_resolved: true

#命令行启动
cd /opt/alertmanager/
#cd /usr/local/prometheus/alertmanager-0.21.0.linux-amd64/
./alertmanager --config.file=alertmanager.yml &
netstat -anput | grep 9093

5.#关联Prometheus并配置报警规则
vi /opt/prometheus/rules/node_down.yml 
groups:
- name: Node_Down
  rules:
  - alert: Node实例宕机
    expr: up == 0
    for: 10s
    labels:
      user: prometheus
      severity: warning
    annotations:
      summary: "{{ $labels.instance }} 服务宕机warning"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been Down warning."
#修改Prometheus配置文件
cat /opt/prometheus/prometheus.yml
# 修改以下内容
# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
- targets: ["127.0.0.1:9093"]
rule_files:
  - "/opt/prometheus/rules/node_down.yml"  

  #重启
systemctl restart prometheus

#测试钉钉报警功能
#关闭node_exporter
systemctl stop node_exporter