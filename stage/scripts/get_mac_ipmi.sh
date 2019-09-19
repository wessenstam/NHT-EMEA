#!/bin/bash
for i in 48 112 91 92 85 73 2 100
do
	echo "10.42.$i.33,$(ipmitool -U ADMIN -P ADMIN -H 10.42.$i.36 raw 0x30 0x21 | tail -c 18 | sed 's/ /:/g')"
	echo "10.42.$i.34,$(ipmitool -U ADMIN -P ADMIN -H 10.42.$i.35 raw 0x30 0x21 | tail -c 18 | sed 's/ /:/g')"
	echo "10.42.$i.35,$(ipmitool -U ADMIN -P ADMIN -H 10.42.$i.34 raw 0x30 0x21 | tail -c 18 | sed 's/ /:/g')"
	echo "10.42.$i.36,$(ipmitool -U ADMIN -P ADMIN -H 10.42.$i.33 raw 0x30 0x21 | tail -c 18 | sed 's/ /:/g')"
done