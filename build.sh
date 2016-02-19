#! /bin/sh
if [ ! -s /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX ] ; then
  sudo cp /vagrant/config/RPM-GPG-KEY-ZABBIX /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
fi


# beacause the network issues in china , change zabbix repo to aliyun
if [ ! -s /etc/yum.repos.d/zabbix.repo ] ; then
  sudo cp /vagrant/config/zabbix.repo /etc/yum.repos.d/zabbix.repo
fi

sudo yum install net-snmp-utils mariadb-server mariadb fping libssh2 zabbix-server-mysql zabbix-frontend-php zabbix-web-mysql zabbix-agent zabbix-get zabbix-sender  -y

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


sed -i 's/# DBPassword=/DBPassword=topsecret/g' /etc/zabbix_server.conf
sudo systemctl start zabbix-server


#httpd
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Chongqing/g' /etc/httpd/conf.d/zabbix.conf
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

# zabbix agent config
sudo sed -i "s/Hostname=Zabbix server/Hostname=`hostname`/" /etc/zabbix/zabbix_agentd.conf
sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent


#firewall settings

sudo firewall-cmd --permanent --add-port=10050/tcp
sudo firewall-cmd --permanent --add-port=10051/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo systemctl restart firewalld
