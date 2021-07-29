监控插件node_exporter的安装部署和自动启动

vi /etc/systemd/system/node_exporter.service

[Unit]
Description=node_exporter
Documentation=https://prometheus.io/
After=network.target
[Service]
ExecStart=/usr/local/node_exporter-0.17.0.linux-amd64/node_exporter
Restart=on-failure
[Install]
WantedBy=multi-user.target

systemctl daemon-reload && systemctl
systemctl start node_exporter
systemctl enable node_exporter

