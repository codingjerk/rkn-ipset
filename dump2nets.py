#!/usr/bin/env python

import fileinput

for line in fileinput.input():
    cols = line.split(";")
    if len(cols) <= 1: continue

    ips = cols[0].split("|")
    
    for ip in ips:
        print(ip.strip())
