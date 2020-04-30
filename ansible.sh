yum -y install ansible

ls /etc/ansible
ansible.cfg hosts roles

# ansible.cfg 是 Ansible 工具的配置文件；hosts 用来配置被管理的机器；roles 是一个目录，playbook 将使用它


密钥
ssh-keygen -t rsa
ssh-copy-id root@agent_host_ip     #ssh-copy-id root@192.168.122.10

vim /etc/ansible/hosts
添加被管理主机
[Client]
angent_host_ip_1
angent_host_ip_2

ansible Client -m ping


shell > vim /etc/ansible/hosts

www.abc.com     # 定义域名

192.168.1.100   # 定义 IP

192.168.1.150:37268   # 指定端口号

[WebServer]           # 定义分组

192.168.1.10
192.168.1.20
192.168.1.30

[DBServer]            # 定义多个分组

192.168.1.50
192.168.1.60

Monitor ansible_ssh_port=12378 ansible_ssh_host=192.168.1.200   # 定义别名

# ansible_ssh_host 连接目标主机的地址

# ansible_ssh_port 连接目标主机的端口，默认 22 时无需指定

# ansible_ssh_user 连接目标主机默认用户

# ansible_ssh_pass 连接目标主机默认用户密码

# ansible_ssh_connection 目标主机连接类型，可以是 local 、ssh 或 paramiko

# ansible_ssh_private_key_file 连接目标主机的 ssh 私钥

# ansible_*_interpreter 指定采用非 Python 的其他脚本语言，如 Ruby 、Perl 或其他类似 ansible_python_interpreter 解释器

[webservers]         # 主机名支持正则描述

www[01:50].example.com

[dbservers]

db-[a:f].example.com
ansible常用命令
ansible Client -m ping

ansible Client -m command -a "free -m"  

ansible Client -m script -a "/home/test.sh"

vim /etc/ansible/hosts
[Client]
192.168.122.10 ansible_ssh_user=vagrant ansible_ssh_private_key_file=/root/.vagrant.d/insecure_private_key
192.168.122.11 ansible_ssh_user=vagrant ansible_ssh_private_key_file=/root/.vagrant.d/insecure_private_key
192.168.122.12 ansible_ssh_user=vagrant ansible_ssh_private_key_file=/root/.vagrant.d/insecure_private_key
