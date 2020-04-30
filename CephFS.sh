不得不说，GlusterFS部署真的超级简单，相比CephFS来说顺畅太多了（捂脸~~~）。

前置准备

# yum search centos-release-gluster
# yum install centos-release-gluster41

步骤一：至少准备两台节点

首先你需要准备两台节点（如果你只有一台的话，我建议你直接用nfs）
• 都是CentOS 7的操作系统；
• 网络必须互通。

步骤二：安装GlusterFS

两台节点都需要执行：

# yum install glusterfs glusterfs-libs glusterfs-server

安装完成后启动GlusterFS管理守护进程：

# systemctl enable glusterd
# systemctl start glusterd
# systemctl status glusterd


步骤三：开放相关端口

默认情况下，glusterd守护进程将监听“tcp/24007”，但仅打开该端口是不够的，因为你每添加一个卷时，它都会打开一个新端口（可通过“gluster volume status”命令查看卷的端口占用情况），所以你有以下几种选择：
1. 针对节点ip开放所有端口；
2. 开放一个足够大的端口段；
3. 每加一个卷就开一个端口；
4. 直接关闭防火墙。

我的倾向是选择前三种。

步骤四：GlusterFS节点探测

假设你的两台节点分别是“server1”和“server2”。

在“server1”上执行：

# gluster peer probe server2

在“server2”上执行：

# gluster peer probe server1

这两句命令的作用是建立GlusterFS节点信任池，一旦信任池建立后，只有在信任池中的节点才能添加新服务器信任池中，这一步是为了下一步做准备（听不懂的话就直接跳过，奸笑ing~）。

步骤五：创建数据卷

准备了这么久，终于可以入正题了，我们先准备一个目录来存放卷（两台节点都需要执行）：

# mkdir /opt/storage_volumes

最推荐的其实是你能用独立的盘来存放卷，当然如果没有空余的盘也不影响使用。

然后在任意一台节点上执行以下命令：

# gluster volume create storage_volumes replica 2 server1:/opt/storage_volumes server2:/opt/storage_volumes
# gluster volume start storage_volumes

第一句命令是创建卷，第二句命令是启动卷，其中storage_volumes就是在GlusterFS中的卷名，我一般直接用目录名。

查看下是否启动成功：

# gluster volume info
Volume Name: storage_volumes
Type: Replicate
Volume ID: d44544b0-c31b-4095-ae86-2eb1176fa508
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: server1:/opt/storage_volumes
Brick2: server2:/opt/storage_volumes
Options Reconfigured:
performance.client-io-threads: off
nfs.disable: on
transport.address-family: inet

注意：GlusterFS支持多种存储类型，不同的类型存储数据的方式是不同的，我这里使用的是Replicate，即两台节点机器存储内容完全一致。这样做的好处是，如果出现单机故障，那么另一台节点上也有完整数据。

存储类型介绍详见：Setting Up Volumes - Gluster Docs

步骤六：测试GlusterFS卷（可选）

至此，GlusterFS已经安装完成了，我们可以将卷挂载到操作系统的某个目录进行读写测试：

# mount -t glusterfs server1:/storage_volumes /mnt
# for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done

检查挂载点：

# ls -lA /mnt | wc -l

你应该看到有100个文件，接下来，去检查每台节点上的GlusterFS卷目录：

# ls -lA /opt/storage_volumes

如果你在两台节点上都看到有100个文件，那么恭喜你成功了~~~🎉🎉🎉
