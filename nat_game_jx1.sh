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

function nat_them_port {
  #statements
  iptables -t nat -A PREROUTING -d "$iplocal"/32 -p tcp -m tcp --dport "$port" -j DNAT --to-destination "$ipproxy"

  iptables-save > /etc/sysconfig/iptables
}

function nat_them_nhieu_port {
  #statements
  iptables -t nat -I PREROUTING -d  "$iplocal"/32 -m tcp -p tcp -m multiport --dports "$port" -j DNAT --to-destination "$ipproxy"
  iptables-save > /etc/sysconfig/iptables

}
function main()
{

  echo "chon mot trong cac tuy chon:  "
	read option
	case "$option" in
    "1")
      echo "Nhap IP proxy: "
      read ipproxy
      echo ""
      echo "Nhap port Jx_server_y: "
      read port
      nat
      ;;
      "2")
        echo "Nhap IP proxy: "
        read ipproxy
        echo ""
        echo "Nhap port Jx_server_y: "
        read port
        nat_them_port
        ;;
        "3")
          echo "Nhap IP proxy: "
          read ipproxy
          echo ""
          echo "Nhap port Jx_server_y: "
          read port
          nat_them_nhieu_port
          ;;

      *)
           echo "1) nat một port khi mới setup game jx"
           echo "2) nat thêm một port"
           echo "3) nat nhieu port lien tiep nhau:  (6660:6669)"

  esac
}
main
