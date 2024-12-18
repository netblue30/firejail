#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

import sys
import fjdisplay
import subprocess

usage = """usage: fjresize.py firejail-name displaysize
resize firejail xephyr windows.
fjdisplay.py with no other arguments will list running named firejails with
displays.
fjresize.py with only a firejail name will list valid resolutions.
names can be shortened as long as it's unambiguous.
note: you may need to move the xephyr window for the resize to take effect
example:
    fjresize.py browser 1280x800
"""

if len(sys.argv) == 2:
    out = subprocess.check_output(
        ['xrandr', '--display',
         fjdisplay.getdisplay(sys.argv[1])])
    print(out)
elif len(sys.argv) == 3:
    out = subprocess.check_output([
        'xrandr', '--display',
        fjdisplay.getdisplay(sys.argv[1]), '--output', 'default', '--mode',
        sys.argv[2]
    ])
    print(out)
else:
    print(usage)
