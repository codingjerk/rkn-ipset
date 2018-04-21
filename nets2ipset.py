#!/usr/bin/env python

import fileinput

for net in fileinput.input():
    print("add blocked %s -exist" % net.strip())
