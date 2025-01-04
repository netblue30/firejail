#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# Requirements:
#  python >= 3.6
from os import path
from sys import argv, exit as sys_exit, stderr

__doc__ = f"""\
Strip whitespace and sort the arguments of commands in profiles.

Usage: {path.basename(argv[0])} [-h] [-i] [-n] [--] [/path/to/profile ...]

The following commands are supported:

    private-bin, private-etc, private-lib, caps.drop, caps.keep, seccomp,
    seccomp.drop, seccomp.keep, protocol

Note that this is only applicable to commands that support multiple arguments.

Trailing whitespace is removed in all lines (that is, not just in lines
containing supported commands) and other whitespace is stripped depending on
the command.

Options:
    -h  Print this message.
    -i  Edit the profile file(s) in-place (this is the default).
    -n  Do not edit the profile file(s) in-place.
    --  End of options.

Examples:
    $ {argv[0]} MyAwesomeProfile.profile
    $ {argv[0]} new_profile.profile second_new_profile.profile
    $ {argv[0]} ~/.config/firejail/*.{{profile,inc,local}}
    $ sudo {argv[0]} /etc/firejail/*.{{profile,inc,local}}

Exit Codes:
  0: Success: No profiles needed fixing.
  1: Error: One or more profiles could not be processed correctly.
  2: Error: Invalid or missing arguments.
  101: Info: One or more profiles were fixed.
"""


def sort_alphabetical(original_items):
    items = original_items.split(",")
    items = set(map(str.strip, items))
    items = filter(None, items)
    items = sorted(items)
    return ",".join(items)


def sort_protocol(original_protocols):
    """
    Sort the given protocols into the following order:

        unix,inet,inet6,netlink,packet,bluetooth
    """

    # remove all whitespace
    original_protocols = "".join(original_protocols.split())

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
        original_profile_str = profile.read()
        if not original_profile_str:
            return

        lines = original_profile_str.split("\n")
        was_fixed = False
        fixed_profile = []
        for lineno, original_line in enumerate(lines, 1):
            line = original_line.rstrip()
            if line[:12] in ("private-bin ", "private-etc ", "private-lib "):
                line = f"{line[:12]}{sort_alphabetical(line[12:])}"
            elif line[:13] in ("seccomp.drop ", "seccomp.keep "):
                line = f"{line[:13]}{sort_alphabetical(line[13:])}"
            elif line[:10] in ("caps.drop ", "caps.keep "):
                line = f"{line[:10]}{sort_alphabetical(line[10:])}"
            elif line[:8] == "protocol":
                line = f"protocol {sort_protocol(line[9:])}"
            elif line[:8] == "seccomp ":
                line = f"{line[:8]}{sort_alphabetical(line[8:])}"
            if line != original_line:
                was_fixed = True
                print(
                    f"{filename}:{lineno}:-'{original_line}'\n"
                    f"{filename}:{lineno}:+'{line}'"
                )
            fixed_profile.append(line)

        fixed_profile_str = "\n".join(fixed_profile)
        stripped_profile_str = fixed_profile_str.strip() + "\n"
        while "\n\n\n" in stripped_profile_str:
            stripped_profile_str = stripped_profile_str.replace("\n\n\n", "\n\n")

        if stripped_profile_str != fixed_profile_str:
            was_fixed = True
            print(f"{filename}:(fixed whitespace)")

        if was_fixed:
            if overwrite:
                profile.seek(0)
                profile.truncate()
                profile.write(stripped_profile_str)
                profile.flush()
                print(f"[ Fixed ] {filename}")
            return 101
        return 0


def main(args):
    overwrite = True
    while len(args) > 0:
        if args[0] == "-h":
            print(__doc__)
            return 0
        elif args[0] == "-i":
            overwrite = True
            args.pop(0)
        elif args[0] == "-n":
            overwrite = False
            args.pop(0)
        elif args[0] == "--":
            args.pop(0)
            break
        elif args[0][0] == "-":
            print(f"[ Error ] Unknown option: {args[0]}", file=stderr)
            return 2
        else:
            break

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
