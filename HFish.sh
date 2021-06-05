#HFISH docker
docker pull imdevops/hfish
docker run -d --name hfish -p 21:21 -p 22:22 -p 23:23 -p 69:69 -p 3306:3306 -p 5900:5900 -p 6379:6379 -p 8080:8080 -p 8081:8081 -p 8989:8989 -p 9000:9000 -p 9001:9001 -p 9200:9200 -p 11211:11211 --restart=always imdevops/hfish:latest
#21 为 FTP 端口
#22 为 SSH 端口
#23 为 Telnet 端口
#3306 为 Mysql 端口
#6379 为 Redis 端口
#8080 为 暗网 端口
#8989 为 插件 端口
#9000 为 Web 端口
#9001 为 系统管理后台 端口
#11211 为 Memcache 端口
#69 为 TFTP 端口
#5900 为 VNC端口
#8081 为 HTTP代理池 端口
#9200 为Elasticsearch端口
#以上端口根据实际需要决定是否打开，并注意端口冲突。

#解决方法：
#（1）给容器换一个名字, 比如说 docker run -it --name=mycentos2 centos:7 /bin/bash, 可以解决问题.
#（2）将原来的容器删除

#查询当前容器：
docker container ls -all
#删除当前容器：
docker container rm ID

#无法进入容器
docker exec -it ID /bin/sh
or
docker exec -it ID bash
or
docker exec -it ID sh