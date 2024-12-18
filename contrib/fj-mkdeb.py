#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

# This script automates the creation of a .deb package.  It was originally
# created to work around https://github.com/netblue30/firejail/issues/772

import os, subprocess, sys


def run(srcdir, args):
    if srcdir: os.chdir(srcdir)

    if not (os.path.isfile('./mkdeb.sh')):
        print('Error: Not a firejail source tree?  Exiting.')
        return 1

    # Ignore unsupported arguments.
    for a in args[:]:
        if a.startswith('--prefix'):
            # prefix should ALWAYS be /usr here.  Discard user-set values
            args.remove(a)

    # Run configure to generate config.sh.
    first_config = subprocess.call(['./configure', '--prefix=/usr'] + args)
    if first_config != 0:
        return first_config

    # Create the dist file used by mkdeb.sh.
    make_dist = subprocess.call(['make', 'dist'])
    if make_dist != 0:
        return make_dist

    # Run mkdeb.sh with the custom configure options.
    return subprocess.call(['./mkdeb.sh'] + args)


if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == '--help':
        print('''Build a .deb of firejail with custom configure options

usage:
{script} [--fj-src=SRCDIR] [CONFIGURE_OPTIONS [...]]

 --fj-src=SRCDIR: manually specify the location of firejail source tree
                  as SRCDIR.  If not specified, looks in the parent directory
                  of the directory where this script is located, and then the
                  current working directory, in that order.
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
            if not (os.path.isfile(srcdir + '/mkdeb.sh')):
                # Script is probably installed.  Check the cwd.
                if os.path.isfile('./mkdeb.sh'):
                    srcdir = None
                else:
                    print(
                        'Error: Could not find the firejail source tree.  Exiting.'
                    )
                    sys.exit(1)
        sys.exit(run(srcdir, args))
