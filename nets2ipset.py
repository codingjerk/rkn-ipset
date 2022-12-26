#!/usr/bin/env python

import fileinput
from re import compile

ipv4 = compile("^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$")

for net in fileinput.input():
    stripped_net = net.strip()
    if ipv4.search(stripped_net):
        print(f"add blocked {stripped_net} -exist")
    else:
        print(f"add blocked6 {stripped_net} -exist")

