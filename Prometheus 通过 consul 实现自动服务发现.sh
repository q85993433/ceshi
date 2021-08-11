Prometheus 通过 consul 实现自动服务发现
#安装1
wget https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip
unzip consul_1.6.1_linux_amd64.zip
./consul agent -dev   -client 0.0.0.0 -http-port 8500   
#安装2 docker
docker run --name consul -d -p 8500:8500 consul
#重启后   docker start ID
#实测   创建文件 vim ss.json
{
  "ID": "dushao1",
  "Name": "dushao",
  "Tags": [
    "dushao-xiaojj-exporter"
  ],
  "Address": "192.168.22.186",
  "Port": 9100,
  "Meta": {
    "wuyifan": "wuqian"
  },
  "EnableTagOverride": false,
  "Check": {
    "HTTP": "http://192.168.22.186:9100/metrics",
    "Interval": "10s"
  },
  "Weights": {
    "Passing": 10,
    "Warning": 1
  }
}

vim /usr/local/prometheus/prometheus.yml

- job_name: 'consul-dushao-xiaojj-exporter'
    consul_sd_configs:
      - server: '192.168.22.181:8500'
        services: []
    relabel_configs:
      - source_labels: [__meta_consul_tags]
        regex: .*dushao-xiaojj-exporter.*         #关联上面的Tags
        action: keep
      - regex: __meta_consul_service_metadata_(.+)     #关联上面Meta  吴亦凡
        action: labelmap

#注册                                                  #服务器
curl --request PUT --data @ss.json http://127.0.0.1:8500/v1/agent/service/register?replace-existing-checks=1

#取消注册                                                      客户端id唯一
curl -X PUT http://127.0.0.1:8500/v1/agent/service/deregister/dushao1
curl -X PUT http://127.0.0.1:8500/v1/agent/service/deregister/dushao2

#荣少笔记
{
  "ID": "hzr1",   #唯一的  不能重复
  "Name": "hzr",  # 组别 可以重复  在x.x.x.x:8500里面会显示同一个组别
  "Tags": [
    "dushao-xiaojj-exporter"  #标签  就是第一步regex: .*dushao-xiaojj-exporter.* 
  ],
  "Address": "192.168.22.186",    #node的ip
  "Port": 9100,  
  "Meta": {
    "app": "docker",   #这三行是新创建的组别 可以任意  方便后期发展
    "team": "cloudgroup",
    "project": "docker-service"
  },
  "EnableTagOverride": false,
  "Check": {
    "HTTP": "http://192.168.22.186:9100/metrics",
    "Interval": "10s"
  },
  "Weights": {
    "Passing": 10,
    "Warning": 1
  }
