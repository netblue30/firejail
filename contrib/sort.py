#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2020 Firejail Authors
# License GPL v2
"""
Sort the items of multi-item options in profiles, the following options are supported:
  private-bin, private-etc, private-lib, caps.drop, caps.keep, seccomp.drop, seccomp.drop, protocol

Usage:
    $ ./sort.py /path/to/profile [ /path/to/profile2 /path/to/profile3 ... ]
Keep in mind that this will overwrite your profile(s).

Examples:
    $ ./sort.py MyAwesomeProfile.profile
    $ ./sort.py new_profile.profile second_new_profile.profile
    $ ./sort.py ~/.config/firejail/*.{profile,inc,local}
    $ sudo ./sort.py /etc/firejail/*.{profile,inc,local}

Exit-Codes:
  0: No Error; No Profile Fixed.
  1: Error, one or more profiles were not processed correctly.
  101: No Error; One or more profile were fixed.
"""

# Requirements:
#  python >= 3.6
from sys import argv


def sort_alphabetical(raw_items):
    items = raw_items.split(",")
    items.sort(key=lambda s: s.casefold())
    return ",".join(items)


def sort_protocol(protocols):
    """sort the given protocole into this scheme: unix,inet,inet6,netlink,packet,bluetooth"""
    # shortcut for common protocol lines
    if protocols in ("unix", "unix,inet,inet6"):
        return protocols
    fixed_protocols = ""
    present_protocols = {
        "unix": False,
        "inet": False,
        "inet6": False,
        "netlink": False,
        "packet": False,
        "bluetooth": False,
    }
    for protocol in protocols.split(","):
        if protocol == "unix":
            present_protocols["unix"] = True
        elif protocol == "inet":
            present_protocols["inet"] = True
        elif protocol == "inet6":
            present_protocols["inet6"] = True
        elif protocol == "netlink":
            present_protocols["netlink"] = True
        elif protocol == "packet":
            present_protocols["packet"] = True
        elif protocol == "bluetooth":
            present_protocols["bluetooth"] = True
    if present_protocols["unix"]:
        fixed_protocols += "unix,"
    if present_protocols["inet"]:
        fixed_protocols += "inet,"
    if present_protocols["inet6"]:
        fixed_protocols += "inet6,"
    if present_protocols["netlink"]:
        fixed_protocols += "netlink,"
    if present_protocols["packet"]:
        fixed_protocols += "packet,"
    if present_protocols["bluetooth"]:
        fixed_protocols += "bluetooth,"
    return fixed_protocols[:-1]


def fix_profile(filename):
    with open(filename, "r+") as profile:
        lines = profile.read().split("\n")
        was_fixed = False
        fixed_profile = []
        for line in lines:
            if line[:12] in ("private-bin ", "private-etc ", "private-lib "):
                fixed_line = f"{line[:12]}{sort_alphabetical(line[12:])}"
            elif line[:13] in ("seccomp.drop ", "seccomp.keep "):
                fixed_line = f"{line[:13]}{sort_alphabetical(line[13:])}"
            elif line[:10] in ("caps.drop ", "caps.keep "):
                fixed_line = f"{line[:10]}{sort_alphabetical(line[10:])}"
            elif line[:8] == "protocol":
                fixed_line = f"protocol {sort_protocol(line[9:])}"
            elif line[:8] == "seccomp ":
                fixed_line = f"{line[:8]}{sort_alphabetical(line[8:])}"
            else:
                fixed_line = line
            if fixed_line != line:
                was_fixed = True
            fixed_profile.append(fixed_line)
        if was_fixed:
            profile.seek(0)
            profile.truncate()
            profile.write("\n".join(fixed_profile))
            profile.flush()
            print(f"[ Fixed ] {filename}")
            return 101
        return 0


def main(args):
    exit_code = 0
    for filename in args:
        try:
            if exit_code not in (1, 101):
                exit_code = fix_profile(filename)
            else:
                fix_profile(filename)
        except FileNotFoundError:
            print(f"[ Error ] Can't find `{filename}'")
            exit_code = 1
        except PermissionError:
            print(f"[ Error ] Can't read/write `{filename}'")
            exit_code = 1
        except:
            print(f"[ Error ] An error occurred while processing `{filename}'")
            exit_code = 1
    return exit_code


if __name__ == "__main__":
    exit(main(argv[1:]))
