#!/usr/bin/env sh

curl https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv > ./dump.csv
curl https://raw.githubusercontent.com/grelleum/supernets/master/supernets.py > ./supernets.py

iconv -f CP1251 ./dump.csv | python ./dump2nets.py | python ./supernets.py | python ./nets2ipset.py | ipset restore
