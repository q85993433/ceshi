centos7免密码登录ssh

1、为什么要面密码登录ssh呢
第一，方便使用
第二，在云环境中，新加入的主机，要实现自动部署，则要由控制节点进行免密码管理，比如ceph中新节点的加入。

2、免密码登录的原理是什么呢
ssh登录有两种方式，密码和密钥文件，既然免密码，那么可以使用密钥文件来实现登录。

3、那么如何实现呢
在这里，我们有两台服务器。
server01 ，地址是192.168.0.131
server02， 地址是192.168.0.132
我们经过如下几步，可实现server01免密码登录server02

第一步
在server01，创建密钥对，只有一条命令，后面直接回车就好

[root@server01 ~]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:OY18ZQDBLOgxHv2fpKwEWT7m6iLtDH5mKs6/7wqxNiE root@server01
The key's randomart image is:
+---[RSA 2048]----+
| o ooo. |
| = + o . |
| o B o o |
| = +..+.o |
|Eo + oS+o. |
|. + o ooo |
|. o . |
|o=+. . |
|oBO**o |
+----[SHA256]-----+

第二步，将产生的公钥，发送到目标主机，这里暂时还要输入一次密码
[root@server01 ~]# ssh-copy-id -i root@192.168.0.132
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.0.132 (192.168.0.132)' can't be established.
ECDSA key fingerprint is SHA256:sXdoFk4lfiKs2dlk2QNwbxzWZbKEchhyoYRKcFqnjkY.
ECDSA key fingerprint is MD5:9b:5f:c7:28:ac:3b:9c:6d:00:25:49:91:62:60:b7:b6.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.0.132's password:

Number of key(s) added: 1

Now try logging into the machine, with: "ssh 'root@192.168.0.132'"
and check to make sure that only the key(s) you wanted were added.

第三步：测试，已经可以免密码登录server02主机了
[root@server01 ~]# ssh root@192.168.0.132
Last login: Sun Aug 11 10:02:48 2019
[root@server02 ~]#

是不是很容易
