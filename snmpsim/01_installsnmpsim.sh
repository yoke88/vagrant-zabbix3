#!/bin/sh


# install gcc and python-devel to compile and install snmpsim

sudo yum install gcc python-devel -y

# download snmpsim sourcefile from sourceforge

wget http://snmpsim.cvs.sourceforge.net/viewvc/snmpsim/?view=tar -O ~/snmpsim.tar.gz
cd ~ &&tar zxf ~/snmpsim.tar.gz
cd ~/snmpsim/snmpsim/
sudo python setup.py install
# install snmp mib files
sudo easy_install pysnmp-mibs
