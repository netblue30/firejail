#!/usr/bin/env python3

# This script is automate the workaround for https://github.com/netblue30/firejail/issues/772

import os, re, shlex, subprocess, sys

def run(srcdir, args):
  os.chdir(srcdir)

  dry_run=False
  escaped_args=[]
  # We need to modify the list as we go.  So be sure to copy the list to be iterated!
  for a in args[:]:
    if a.startswith('--prefix'):
      # prefix should ALWAYS be /usr here.  Discard user-set values
      args.remove(a)
    elif a == '--only-fix-mkdeb':
      # for us, not configure
      dry_run=True
      args.remove(a)
    else:
      escaped_args.append(shlex.quote(a))

  # Fix up mkdeb.sh to include custom configure options.
  with open('mkdeb.sh', 'rb') as f:
    sh=str(f.read(), 'utf_8')
  rx=re.compile(r'^\./configure\s.*$', re.M)
  with open('mkdeb.sh', 'wb') as f:
    f.write(bytes(rx.sub('./configure --prefix=/usr '+(' '.join(escaped_args)), sh), 'utf_8'))

  if dry_run: return 0

  # now run configure && make
  if subprocess.call(['./configure', '--prefix=/usr']+args) == 0:
    subprocess.call(['make', 'deb'])

  return 0


if __name__ == '__main__':
  if len(sys.argv) == 2 and sys.argv[1] == '--help':
    print('''Build a .deb of firejail with custom configure options

usage: {script} [--only-fix-mkdeb] [CONFIGURE_OPTIONS [...]]

 --only-fix-mkdeb: don't run configure or make after modifying mkdeb.sh
 CONFIGURE_OPTIONS: arguments for configure
'''.format(script=sys.argv[0]))
    sys.exit(0)
  else:
    sys.exit(run(os.path.dirname(os.path.abspath(sys.argv[0]+'/..')), sys.argv[1:]))
