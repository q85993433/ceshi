sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install  -y docker-ce 
sudo systemctl start docker
sudo systemctl enable docker
docker version


samba 
docker run -it --name samba -p 139:139 -p 445:445 -v /opt:/mount -d dperson/samba -u "admin;123456" -s "shared;/mount/;yes;no;no;all;none"

suns:
因为你关机了
suns:
docker ps -a
suns:
docker start samba

百度docker容器自启   好像叫—restart  away

root@lch xxl-job-admin]# docker run -d -p 8180:8180 --restart=always --name xxl-job-admin-docker xxl-job-admin-docker

1.在使用docker run时，添加下面参数
--restart=always 

2.在运行docker的时候添加
docker update --restart=always 07fb7442f813

其中07fb7442f813是容器ID

docker restart jenkins    重启

docker run 的时候加入    -e TZ="Asia/Shanghai"

#查询当前容器：
docker container ls -all
#删除当前容器：
docker container rm ID

