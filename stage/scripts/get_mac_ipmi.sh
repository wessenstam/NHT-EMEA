#!/bin/bash
for i in 113 105 107 83
do
	echo "POC$i Cluster"
	echo "$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.33 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.34 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.35 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "$(ipmitool -I lanplus -U ADMIN -P ADMIN -H 10.42.$i.36 lan print1 | grep "MAC Address" | tr -s " " | cut -d " " -f4)"
	echo "-----"
done
