升级centos7内核
在 CentOS 7 上启用 ELRepo 仓库，运行如下命令：

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org#导入该源的秘钥

rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm#启用该源仓库

yum --disablerepo="*" --enablerepo="elrepo-kernel" list available#查看有哪些内核版本可供安装

yum --enablerepo=elrepo-kernel install kernel-lt -y #安装的长期稳定版本，稳定可靠

安装完毕后，重启机器

为了让新安装的内核成为默认启动选项，你需要如下修改 GRUB 配置：

打开并编辑 vim /etc/default/grub 并设置 GRUB_DEFAULT=0。意思是 GRUB 初始化页面的第一个内核将作为默认内核。

执行命令：grub2-mkconfig -o /boot/grub2/grub.cfg
安装完毕后，重启机器
yum update -y