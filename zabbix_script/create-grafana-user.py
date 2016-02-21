from zabbix_api import ZabbixAPI
zapi=ZabbixAPI("http://localhost")
zapi.login("admin","zabbix")
newUser={
  "alias": "grafana",
  "passwd": "grafana-ro",
  "type" :"3",
  "usrgrps": [{"usrgrpid": "8"}],
  "user_medias": [
    {
        "mediatypeid": "1",
        "sendto": "",
        "active": 0,
        "severity": 63,
        "period": "1-7,00:00-24:00"
    }
  ]
}

try:
    user=zapi.user.create(newUser)
    print("Create user grafana (guest group) but with 'super admin' permisson  OK")
    exit(0)
except Exception as e:
    print("error:%s" % e)
    exit(1)
