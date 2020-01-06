#!/bin/bash

iplocal=$(ip a  | grep eth | awk '{print $2}'| cut -d':' -f1 | sort -nr| head -n 1|cut -d'/' -f1)
eth=$(netstat -i | grep eth | awk '{print $1}')
ipproxy=
port=

function nat {

/sbin/ip addr add "$ipproxy"/32 dev "$eth":1
echo /sbin/ip addr add "$ipproxy"/32 dev "$eth":1 >> /etc/rc.local

iptables -t nat -A PREROUTING -d "$iplocal"/32 -p tcp -m tcp --dport "$port" -j DNAT --to-destination "$ipproxy"

iptables-save > /etc/sysconfig/iptables

}


function main()
{

echo "Nhap IP proxy: "
read ipproxy
echo ""
echo "Nhap port can nat: "
read port
nat

}
main
