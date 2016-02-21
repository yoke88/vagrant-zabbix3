#!/bin/sh

# -------------------------------------------------
# Add zabbix user for grafana
# -------------------------------------------------

python /vagrant/zabbix_script/create-grafana-user.py

# -------------------------------------------
# download and install grafana and grafana-zabbix plugin
# ------------------------------------------

echo "start to install grafana"

if [ ! -s /vagrant/grafana-2.5.0-1.x86_64.rpm ]
  then
    cd /vagrant
    wget https://grafanarel.s3.amazonaws.com/builds/grafana-2.5.0-1.x86_64.rpm
fi


sudo yum install fontconfig git -y
sudo rpm -ivh /vagrant/grafana-2.5.0-1.x86_64.rpm
cd /usr/share/grafana/public/app/plugins/datasource
sudo tar -zxvf /vagrant/grafana-zabbix-v2.5.1.tar.gz
if [ ! -d zabbix ]; then
  sudo mkdir zabbix
else
  sudo rm -rf zabbix && sudo mkdir zabbix
fi
sudo mv grafana-zabbix-2.5.1/zabbix/* zabbix/
sudo rm grafana-zabbix-2.5.1 -rf


# -----------------------------------------
# config grafana-server service
# ----------------------------------------
sudo systemctl enable grafana-server
sudo systemctl restart grafana-server

sudo firewall-cmd --permanent --add-port=3000/tcp
sudo systemctl restart firewalld

# sleep 20 seconds to wait database init

sleep 20

# inject grafana datasource (zabbix datasource)
echo ".read /vagrant/config/grafana-zabbix-datasource.sql"|sudo sqlite3 /var/lib/grafana/grafana.db
