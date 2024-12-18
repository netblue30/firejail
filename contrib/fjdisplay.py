#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

import re
import sys
import subprocess

usage = """fjdisplay.py name-of-firejail
returns the display in the form of ':NNN'
"""


def getfirejails():
    output = subprocess.check_output(['firemon', '--x11'])
    firejails = {}
    name = ''
    for line in output.split('\n'):
        namematch = re.search('--name=(\w+\S*)', line)
        if namematch:
            name = namematch.group(1)
        displaymatch = re.search('DISPLAY (:\d+)', line)
        if displaymatch:
            firejails[name] = displaymatch.group(1)
    return firejails


def getdisplay(name):
    firejails = getfirejails()
    fjlist = '\n'.join(firejails.keys())
    namere = re.compile('^' + name + '.*', re.MULTILINE)
    matchingjails = namere.findall(fjlist)
    if len(matchingjails) == 1:
        return firejails[matchingjails[0]]
    if len(matchingjails) == 0:
        raise NameError("firejail {} does not exist".format(name))
    else:
        raise NameError("ambiguous firejail name")


if __name__ == '__main__':
    if '-h' in sys.argv or '--help' in sys.argv or len(sys.argv) > 2:
        print(usage)
        exit()
    if len(sys.argv) == 1:
        print(getfirejails())
    if len(sys.argv) == 2:
        print(getdisplay(sys.argv[1]))
