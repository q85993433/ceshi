#!/bin/bash
if [ ! $1 ]; then
  echo "下次输入你的间隔时间"
  exit 1
fi
while true
do
     echo "杜少喜欢大姐姐" && sleep $1 && echo "一不小心啪了$1秒"
     
done


while true
do
echo "姐姐创业"
sleep 86400       #一天有86400秒
done

nohup sh 脚本 &


nohup 用途:不挂断地运行命令


while true
do
ifconfig eth0 up
sleep 7200         #2 小时
done


while true
do
ping -c 192.168.1.1
if [$? != 0 ]; then
     ifconfig eth0 up
fi
done     