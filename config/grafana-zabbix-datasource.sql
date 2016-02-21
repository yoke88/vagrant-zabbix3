BEGIN TRANSACTION;
INSERT INTO "data_source" VALUES(2,1,0,'zabbix','grafana-zabbix.org','direct','http://192.168.33.10/api_jsonrpc.php','','','',0,'','',1,'{"password":"grafana-ro","trends":true,"username":"grafana"}','2016-02-06 10:01:10','2016-02-06 10:06:00');
COMMIT;
