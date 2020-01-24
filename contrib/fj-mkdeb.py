#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2020 Firejail Authors
# License GPL v2

# This script automates the workaround for https://github.com/netblue30/firejail/issues/772

import os, re, shlex, subprocess, sys


def run(srcdir, args):
    if srcdir: os.chdir(srcdir)

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

    # Fix up mkdeb.sh to include custom configure options.
    with open('mkdeb.sh', 'rb') as f:
        sh = str(f.read(), 'utf_8')
    rx = re.compile(r'^\./configure\s.*$', re.M)
    with open('mkdeb.sh', 'wb') as f:
        f.write(
            bytes(
                rx.sub('./configure --prefix=/usr ' + (' '.join(escaped_args)),
                       sh), 'utf_8'))

    if dry_run: return 0

    # now run configure && make
    if subprocess.call(['./configure', '--prefix=/usr'] + args) == 0:
        subprocess.call(['make', 'deb'])

    return 0


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
