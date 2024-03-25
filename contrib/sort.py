#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# Requirements:
#  python >= 3.6
from os import path
from sys import argv, exit as sys_exit, stderr

__doc__ = f"""\
Sort the arguments of commands in profiles.

Usage: {path.basename(argv[0])} [-i] [/path/to/profile ...]

The following commands are supported:

    private-bin, private-etc, private-lib, caps.drop, caps.keep, seccomp,
    seccomp.drop, seccomp.keep, protocol

Note that this is only applicable to commands that support multiple arguments.

Options:
    -i  Edit the profile file(s) in-place.

Examples:
    $ {argv[0]} -i MyAwesomeProfile.profile
    $ {argv[0]} -i new_profile.profile second_new_profile.profile
    $ {argv[0]} -i ~/.config/firejail/*.{{profile,inc,local}}
    $ sudo {argv[0]} -i /etc/firejail/*.{{profile,inc,local}}

Exit Codes:
  0: Success: No profiles needed fixing.
  1: Error: One or more profiles could not be processed correctly.
  2: Error: Missing arguments.
  101: Info: One or more profiles were fixed.
"""


def sort_alphabetical(original_items):
    items = original_items.split(",")
    items = filter(None, set(items))
    items = sorted(items)
    return ",".join(items)


def sort_protocol(original_protocols):
    """
    Sort the given protocols into the following order:

        unix,inet,inet6,netlink,packet,bluetooth
    """

    # shortcut for common protocol lines
    if original_protocols in ("unix", "unix,inet,inet6"):
        return original_protocols

    fixed_protocols = ""
    for protocol in ("unix", "inet", "inet6", "netlink", "packet", "bluetooth"):
        for prefix in ("", "-", "+", "="):
            if f",{prefix}{protocol}," in f",{original_protocols},":
                fixed_protocols += f"{prefix}{protocol},"
    return fixed_protocols[:-1]


def check_profile(filename, overwrite):
    with open(filename, "r+") as profile:
        lines = profile.read().split("\n")
        was_fixed = False
        fixed_profile = []
        for lineno, line in enumerate(lines, 1):
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
                print(
                    f"{filename}:{lineno}:-{line}\n"
                    f"{filename}:{lineno}:+{fixed_line}"
                )
            fixed_profile.append(fixed_line)

        if was_fixed:
            if overwrite:
                profile.seek(0)
                profile.truncate()
                profile.write("\n".join(fixed_profile))
                profile.flush()
                print(f"[ Fixed ] {filename}")
            return 101
        return 0


def main(args):
    overwrite = False
    if len(args) > 0 and args[0] == "-i":
        overwrite = True
        args.pop(0)

    if len(args) < 1:
        print(__doc__, file=stderr)
        return 2

    print(f"sort.py: checking {len(args)} profile(s)...")

    exit_code = 0
    for filename in args:
        try:
            if exit_code not in (1, 101):
                exit_code = check_profile(filename, overwrite)
            else:
                check_profile(filename, overwrite)
        except FileNotFoundError as err:
            print(f"[ Error ] {err}", file=stderr)
            exit_code = 1
        except PermissionError as err:
            print(f"[ Error ] {err}", file=stderr)
            exit_code = 1
        except Exception as err:
            print(
                f"[ Error ] An error occurred while processing '{filename}': {err}",
                file=stderr,
            )
            exit_code = 1
    return exit_code


if __name__ == "__main__":
    sys_exit(main(argv[1:]))
