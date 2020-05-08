centos install vagrant with kvm

先检查一下是否支持KVM
cat /proc/cpuinfo | egrep 'vmx|svm'
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch epb cat_l3 cdp_l3 intel_ppin intel_pt tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm cqm rdt_a rdseed adx smap xsaveopt cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dtherm ida arat pln pt


安装kvm等环境
yum install qemu libvirt libvirt-devel ruby-devel gcc qemu-kvm

安装vagrant
wget https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.rpm
rpm -Uvh vagrant_2.2.4_x86_64.rpm


安装vagrant-libvirt插件
vagrant plugin install vagrant-libvirt

创建kvm
vagrant box add centos/7
2 回车
mkdir centos7
cd centos7
vagrant init centos/7


virsh list --all
vagrant destroy -f   关闭   删除全部
vagrant up  k8s1  开启


ssh vagrant@192.168.122.10  -i   /root/.vagrant.d/insecure_private_key                  
NAT网络


vagrant up          # 启动虚拟机
vagrant halt        # 关闭虚拟机
vagrant reload      # 重启虚拟机

vagrant destroy     # 销毁当前虚拟机
exit   退出虚拟机模式

https://www.vagrantup.com/docs/  官方文件

sudo passwd修改密码
虚拟机改了密码后再连接有错误  公钥更新     echo > /root/.ssh/known_hosts

echo xiaojj >   duxiao.txt  打印duxiao 文档的资料
echo > duxiao.txt   清空里面文档资料
那回顾一下这条命令echo > /root/.ssh/known_hosts
把空的资料  传到/root/.ssh/known_hosts
known_hosts这个文件是记录登录的信息  一旦变了，他就会警告，还有不让他进其他机器，
而为了让他不要警告，我们只能让他忘记之前有访问这台虚拟机，清空这个文件  是让他忘记最好方法
>表示覆盖   >>表示追加
先备份cp xiaojj  xiaojjbak  &&   echo peizhi>> peizhi.conf

config.vm.network "private_network", ip: "192.168.50.4"    私人
config.vm.network "public_network", ip: "192.168.1.120"    桥接

设置时区  [[ $(date|grep -o CST)  ]]  || sudo  \cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


第八章：Vagrantfile配置文件
一）配置版本
案例：
Vagrant.configure("2") do |config|

end

说明：
1）目前只支持两个版本1和2，“2”代表1.1+领先至2.0.x的配置（目前都用2）
2）在一个配置部分内，只能使用一个版本
3）你可以在同一个Vagrantfile中混合和匹配多个配置版本（一般不建议用）

二）虚拟机设置 config.vm

1)config.vm.box 配置使用哪个box
config.vm.box = "ubuntu16.04_louis"
（这里的box，必须通过vagrant box list可以查看到）
2）config.vm.hostname - 机器应该有的主机名
aa.vm.hostname = "aa.test.com"
3）config.vm.network- 在机器上配置网络
config.vm.network"forwarded_port",guest:80,host:8080
aa.vm.network "private_network", ip: "192.168.55.100"

4）config.vm.provider - 配置提供程序特定的配置，用于修改特定于某个 提供程序的设置
5）config.vm.provision-配置置备 在机器上，使软件可以自动安装并创建机器时配置
6）config.vm.synced_folder- 配置 机器上的同步文件夹

案例如下

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu16.04_louis"
  config.vm.define "master" do |aa|
        aa.vm.network :"forwarded_port", guest: 80, host: 8070,host_ip: "10.2.11.203"
        aa.vm.network "private_network", ip: "192.168.55.100"
        aa.vm.hostname = "aa.test.com"
        aa.vm.provider "virtualbox" do|vb|
                vb.memory = "256"
                vb.cpus = 1
                vb.name = "aa.test.com"
        end
   end
   config.vm.define "slave01" do|ab|
        ab.vm.network :"forwarded_port", guest: 80, host: 8060,host_ip: "10.2.11.203"
        ab.vm.network "private_network",ip: "192.168.55.101"
        ab.vm.hostname = "bb.test.com"
        ab.vm.provider "virtualbox" do|vc|
                vc.memory = "256"
                vc.cpus = 1
                vc.name = "bb.test.com"
        end
   end
   config.vm.synced_folder "/website","/opt/web",owner: "www",group: "www",type: "rsync"

end



