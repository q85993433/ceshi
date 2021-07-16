#zabbix配置钉钉报警+钉钉安全设置自定义关键词
cd /usr/lib/zabbix/alertscripts
vi dingding.sh
#!/bin/bash
to=$1
subject=$2
text=$3

#此处的 xxxxx 就是刚刚复制存留的 api 接口地址。
curl -i -X POST \
'https://oapi.dingtalk.com/robot/send?access_token=499ba9de071def977df11c864b103beb9d1a77ec6e20d43761a0e01072dbc9b0' \
-H 'Content-type':'application/json' \
-d '
{
  "msgtype": "text",
     "text": {
        "content": "'监控报警：''"$text"'"
        },
  "at":{
    "atMobiles":[
      "'"$1"'"
      ],
  "isAtAll":false
   } 
}'

#1、授予文件执行权限：
chmod o+x dingding.sh
#测试：
./dingding.sh 监控报警 test "监控报警"


#脚本参数添加3个：
{ALERT.SENDTO}
{ALERT.SUBJECT}
{ALERT.MESSAGE}


zabbix故障{TRIGGER.STATUS},服务器:{HOSTNAME1}发生: {TRIGGER.NAME}故障!
故障{TRIGGER.STATUS},服务器:{HOSTNAME1}发生: {TRIGGER.NAME}故障!
告警主机:{HOSTNAME1}
主机地址:{HOST.IP}    
告警时间:{EVENT.DATE} {EVENT.TIME}
告警等级:{TRIGGER.SEVERITY}
告警信息: {TRIGGER.NAME}
告警项目:{TRIGGER.KEY1}
问题详情:{ITEM.NAME}:{ITEM.VALUE}
当前状态:{TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID:{EVENT.ID}

故障{TRIGGER.STATUS},服务器:{HOSTNAME1}:{TRIGGER.NAME}已恢复!
故障{TRIGGER.STATUS},服务器:{HOSTNAME1}: z{TRIGGER.NAME}已恢复!
告警主机:{HOSTNAME1}
主机地址:{HOST.IP}
告警时间:{EVENT.DATE} {EVENT.TIME}
告警等级:{TRIGGER.SEVERITY}
告警信息: {TRIGGER.NAME}
告警项目:{TRIGGER.KEY1}
问题详情:{ITEM.NAME}:{ITEM.VALUE}
当前状态:{TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID:{EVENT.ID}

服务器:{HOST.NAME}: 报警确认！
确认信息：“{ACK.MESSAGE}”
服务器：{HOST.NAME}发生: {TRIGGER.NAME}故障!
主机地址:{HOST.IP}
确认人：{USER.FULLNAME}
时间：{ACK.DATE} {ACK.TIME}
当前的问题是: {TRIGGER.NAME}
时间ID：{EVENT.ID}