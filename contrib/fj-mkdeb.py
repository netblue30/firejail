#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

# This script automates the workaround for https://github.com/netblue30/firejail/issues/772

import os, shlex, subprocess, sys


def run(srcdir, args):
    if srcdir: os.chdir(srcdir)

    if not (os.path.isfile('./mkdeb.sh.in')):
        print('Error: Not a firejail source tree?  Exiting.')
        return 1

    dry_run = False
    escaped_args = []
    # We need to modify the list as we go.  So be sure to copy the list to be iterated!
    for a in args[:]:
        if a.startswith('--prefix'):
            # prefix should ALWAYS be /usr here.  Discard user-set values
            args.remove(a)
        elif a == '--only-fix-mkdeb':
            # for us, not configure
            dry_run = True
            args.remove(a)
        else:
            escaped_args.append(shlex.quote(a))

    # Run configure to generate mkdeb.sh.
    first_config = subprocess.call(['./configure', '--prefix=/usr'] + args)
    if first_config != 0:
        return first_config

    # Fix up dynamically-generated mkdeb.sh to include custom configure options.
    with open('mkdeb.sh', 'rb') as f:
        sh = str(f.read(), 'utf_8')
    with open('mkdeb.sh', 'wb') as f:
        f.write(bytes(sh.replace('./configure $CONFIG_ARGS',
                                 './configure $CONFIG_ARGS ' + (' '.join(escaped_args))), 'utf_8'))

    if dry_run: return 0

    return subprocess.call(['make', 'deb'])


if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == '--help':
        print('''Build a .deb of firejail with custom configure options

usage:
{script} [--fj-src=SRCDIR] [--only-fix-mkdeb] [CONFIGURE_OPTIONS [...]]

 --fj-src=SRCDIR: manually specify the location of firejail source tree
                  as SRCDIR.  If not specified, looks in the parent directory
                  of the directory where this script is located, and then the
                  current working directory, in that order.
 --only-fix-mkdeb: don't run configure or make after modifying mkdeb.sh
 CONFIGURE_OPTIONS: arguments for configure
'''.format(script=sys.argv[0]))
        sys.exit(0)
    else:
        # Find the source directory
        srcdir = None
        args = sys.argv[1:]
        for a in args:
            if a.startswith('--fj-src='):
                args.remove(a)
                srcdir = a[9:]
                break
        if not (srcdir):
            # srcdir not manually specified, try to auto-detect
            srcdir = os.path.dirname(os.path.abspath(sys.argv[0] + '/..'))
            if not (os.path.isfile(srcdir + '/mkdeb.sh.in')):
                # Script is probably installed.  Check the cwd.
                if os.path.isfile('./mkdeb.sh.in'):
                    srcdir = None
                else:
                    print(
                        'Error: Could not find the firejail source tree.  Exiting.'
                    )
                    sys.exit(1)
        sys.exit(run(srcdir, args))
