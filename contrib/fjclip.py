#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

import sys
import subprocess
import fjdisplay

usage = """fjclip.py src dest. src or dest can be named firejails or - for stdin or stdout.
firemon --x11 to see available running x11 firejails. firejail names can be shortened
to least ambiguous. for example 'work-libreoffice' can be shortened to 'work' if no
other firejails name starts with 'work'.
warning: browsers are dangerous. clipboards from browsers are dangerous.  see
https://github.com/dxa4481/Pastejacking
fjclip.py strips whitespace from both
ends, but does nothing else to protect you.  use a simple gui text editor like
gedit if you want to see what your pasting."""

if len(sys.argv) != 3 or sys.argv == '-h' or sys.argv == '--help':
    print(usage)
    exit(1)

if sys.argv[1] == '-':
    clipin_raw = sys.stdin.read()
else:
    display = fjdisplay.getdisplay(sys.argv[1])
    clipin_raw = subprocess.check_output(['xsel', '-b', '--display', display])

clipin = clipin_raw.strip()

if sys.argv[2] == '-':
    print(clipin)
else:
    display = fjdisplay.getdisplay(sys.argv[2])
    clipout = subprocess.Popen(['xsel', '-b', '-i', '--display', display],
                               stdin=subprocess.PIPE)
    clipout.communicate(clipin)
