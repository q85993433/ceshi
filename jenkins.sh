荣少秒射咖啡佬
 wget  -c  ccr.ccs.tencentyun.com/hzrdockerfile/jenkinslts   下载

docker  load < jenkinsnew222.tar    运行

docker run -p 8080:8080  --name jenkins  --privileged    jenkinsnew222     端口8080

docker restart jenkins    重启
docker  logs  jenkins    查日志  密码   deb335188ab946f8bddb0ade9c70e60b
1.无插件安装  
2.admin账号
3.设置改掉密码
admin217
关机后
要重启jenkins
docker start jenkins



docker run -it  --name=dushaoxihuanxiaojj   -p 8080:8080 ccr.ccs.tencentyun.com/hzrdockerfile/jenkinslts