#! /bin/sh

sudo timedatectl set-timezone Asia/Shanghai


# beacause the network issues in china , change zabbix repo to aliyun
if [ ! -s /etc/yum.repos.d/zabbix.repo ] ; then
  sudo cp /vagrant/config/zabbix.repo /etc/yum.repos.d/zabbix.repo
fi

sudo yum install net-snmp-utils mariadb-server mariadb fping libssh2 zabbix-server-mysql zabbix-frontend-php zabbix-web-mysql zabbix-agent zabbix-get zabbix-sender  -y


sudo chown root:zabbix /usr/sbin/fping
sudo chmod ug+s /usr/sbin/fping
sudo mv /etc/my.cnf /etc/my.cnf.ori
sudo cp /vagrant/config/my.cnf /etc/my.cnf

sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service

#https://mariadb.com/kb/en/mariadb/mysql_secure_installation/


#change mysql default password

mysqladmin -uroot password 'topsecret'
echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"|mysql -u root -ptopsecret
echo "DELETE FROM mysql.user WHERE User='';"|mysql -u root -ptopsecret
echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"|mysql -u root -ptopsecret
echo "FLUSH PRIVILEGES;"|mysql -u root -ptopsecret
echo "create database zabbix;grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';" | mysql -u root -ptopsecret

# config Mysql for zabbix
cd /usr/share/doc/zabbix-server-mysql-3.0.0
zcat create.sql.gz | mysql -uzabbix -pzabbix zabbix


sudo sed -i 's/# DBPassword=/DBPassword=zabbix/g' /etc/zabbix/zabbix_server.conf
sudo systemctl enable zabbix-server
sudo systemctl start zabbix-server


#httpd
sudo sed -i 's|# php_value date.timezone Europe/Riga|php_value date.timezone Asia/Chongqing|g' /etc/httpd/conf.d/zabbix.conf
sudo sed -i 's|Alias /zabbix /usr/share/zabbix|DocumentRoot /usr/share/zabbix|g' /etc/httpd/conf.d/zabbix.conf
sudo cp /vagrant/config/zabbix.conf.php  /etc/zabbix/web/zabbix.conf.php
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

# zabbix agent config

# add mysql client configure for zabbix client to monitor mysql.you need link mysql app template to zabbix_server to enable mysql monitor
sudo mkdir /var/lib/zabbix
sudo cp /vagrant/config/.my.cnf /var/lib/zabbix/
sudo chown -R zabbix:zabbix /var/lib/zabbix


sudo sed -i "s/Hostname=Zabbix server/Hostname=`hostname`/" /etc/zabbix/zabbix_agentd.conf
sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent


#firewall settings
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=10050/tcp
sudo firewall-cmd --permanent --add-port=10051/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo systemctl restart firewalld
