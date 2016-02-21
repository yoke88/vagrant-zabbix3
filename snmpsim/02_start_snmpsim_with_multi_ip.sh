#!/bin/sh

#try to find the inet interface with ip 192.168.33.x
netcard=$(ip addr|grep '192.168.33'|grep -v 'secondary'|awk '{print $7}')

snapshots=(/vagrant/snmpsim/data/)
bindparam=""
for i in `seq 1 5`; do
  sudo ifconfig $netcard:$i down 2>/dev/null
  ip=192.168.33.$[i + 20]
  sudo ifconfig $netcard:$i $ip netmask 255.255.255.0 up
  bindparam=$bindparam'--agent-udpv4-endpoint='$ip':161 '
  #ln -s /vagrant/
done

# list current ip addr

ip addr|grep secondary


#https://sourceforge.net/p/snmpsim/mailman/snmpsim-users/thread/55F04915.9B2D9C.02749@m12-16.163.com/

sudo python /usr/bin/snmpsimd.py --data-dir=/vagrant/snmpsim/data \
--v2c-arch --process-user=nobody --process-group=nobody $bindparam \
--daemonize --logging-method=file:/var/log/snmpsimd.log \
--pid-file /tmp/snmpsimd.pid
