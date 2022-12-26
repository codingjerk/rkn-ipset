#!/usr/bin/env sh

if [ ! -f /tmp/dump.csv ] ||  [ $(find /tmp/dump.csv -mmin +60 -print) ]; then
	curl -z /tmp/dump.csv https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv > /tmp/dump.csv
fi
if [ ! -f ./supernets.py ]; then
	curl -z ./supernets.py https://raw.githubusercontent.com/grelleum/supernets/master/supernets.py > ./supernets.py
fi

if [ ! -f /tmp/iconv ] || [ $(find /tmp/iconv -mmin +60 -print) ]; then
	echo "Converting encoding from CP1251 to Unicode..."
	iconv -f CP1251 /tmp/dump.csv > /tmp/iconv
else
	echo "Found freshly converted dump.csv, skipping..."
fi

if [ ! -f /tmp/nets ] || [ $(find /tmp/nets -mmin +60 -print) ]; then
	echo "Converting dump.csv to nets..."
	cat /tmp/iconv | python3 ./dump2nets.py > /tmp/nets
else
	echo "Found freshly computed nets, skipping..."
fi

if [ ! -f /tmp/supernets ] || [ $(find /tmp/supernets -mmin +60 -print) ]; then
	echo "Converting nets to supernets..."
	cat /tmp/nets | python3 ./supernets.py > /tmp/supernets
else
	echo "Found freshly computed supernets, skipping..."
fi

if [ ! -f /tmp/ipset ] || [ $(find /tmp/ipset -mmin +60 -print) ]; then
	echo "Converting supernets to ipset rules..."
	cat /tmp/supernets | python3 ./nets2ipset.py > /tmp/ipset
else
	echo "Found freshly computed ipset rules, skipping..."
fi

if [ $(sudo ipset list | grep blocked) ]; then
	echo "Ipset already created, skipping..."
else
	echo "Creating ipsets blocked & blocked6"
	sudo ipset create blocked hash:ip
	sudo ipset create blocked6 hash:ip family inet6
	sudo ipset create blocked-list list:set
fi

echo "Populating ipset rules..."
cat /tmp/ipset | sudo ipset restore

