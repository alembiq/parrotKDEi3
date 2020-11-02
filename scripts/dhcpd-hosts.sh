#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
  echo "Converts IP vs hostnames from local DHCP server to /etc/hosts"
  echo "missing parameters: $0 /etc/dhcp/dhcpd.conf /etc/hosts" >&2
  exit 1
fi

GITOLITE=$1
GITLAB_URL=$2


my_hostsfile=$2 # /etc/hosts
my_dhcpfile=$1 # /etc/dhcp/dhcpd.conf

declare -A my_host_addr
declare my_hostname

while read line; do
  my_line=$(echo $line |sed 's/\s\+/ /g'|sed 's/^ //')
  echo $my_line | grep -q host
  if [[ "$?" -eq "0" ]]; then 
    my_hostname=$(echo $my_line | cut -d' ' -f2) 
    my_open=1
  fi
  if [[ "$my_open" -eq "1" ]]; then 
    echo $my_line | grep -q fixed-address
    if [[ "$?" -eq "0" ]]; then
     my_address=$(echo $my_line | cut -d' ' -f2|sed 's/;//')
     my_host_addr[$my_hostname]=$my_address
    fi
  fi
done < $my_dhcpfile 


for key_name in "${!my_host_addr[@]}"; do 
  #echo -e "aaa ${my_host_addr[$key_name]}\t${key_name}"
  grep -q "^.*\s${key_name}$" ${my_hostsfile}
  if [[ "$?" -eq "0" ]]; then
    #echo -e "aaa ${my_host_addr[$key_name]} $key_name"
    my_address=${my_host_addr[${key_name}]} 
    #echo $my_address
    sed -i "s/^.*${key_name}$/$my_address\t$key_name/" $my_hostsfile
  else 
    echo -e "${my_host_addr[$key_name]}\t${key_name}" >> $my_hostsfile
  fi
done
