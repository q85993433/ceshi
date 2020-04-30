sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install  -y docker-ce 
sudo systemctl start docker
sudo systemctl enable docker
docker version


samba 
docker run -it --name samba -p 139:139 -p 445:445 -v /opt:/mount -d dperson/samba -u "admin;123456" -s "shared;/mount/;yes;no;no;all;none"   

关机了
docker ps -a
docker start samba
百度docker容器自启   好像叫—restart  away