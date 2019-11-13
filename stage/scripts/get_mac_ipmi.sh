#!/bin/bash
for i in 48 112 91 92 85 73 2 100
do
	echo "10.42.$i.33,$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.33 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "10.42.$i.34,$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.34 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "10.42.$i.35,$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.35 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "10.42.$i.36,$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.36 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "-----"
done
