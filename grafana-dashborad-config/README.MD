### 该目录文件说明

1. 为导出的grafana-zabbix dashboard模板，只需要在grafana中导入即可。这个模板我是根据官方的演示dashborad更改的，为了兼容性更强以及演示grafana本身的特性，我自定义了一些Annotation、另外使用了grafana模板。

2. 有些监控项目在导入后可能没有数据，比如内存free 百分比，这个是我自己加的item监控项目，默认的zabbix servers 的监控没有这个Item。另外类似mysql的监控数据，你需要在zabbix上对zabbis mysql服务器link mysql app template 进行监控（相应的配置文件我已经事先在vagrant 的build脚本中写好）
