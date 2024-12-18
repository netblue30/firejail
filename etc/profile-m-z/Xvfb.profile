# Firejail profile for Xvfb
# Description: Virtual Framebuffer 'fake' X server
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include Xvfb.local
# Persistent global definitions
include globals.local

#
# This profile will sandbox Xvfb server itself when used with firejail --x11=xvfb.
# The target program is sandboxed with its own profile. By default the this functionality
# is disabled. To enable it, create a firejail-Xvfb symlink in /usr/local/bin:
#
#    $ sudo ln -s /usr/bin/firejail /usr/local/bin/Xvfb
#
# We have this functionality disabled by default because it creates problems on
# some Linux distributions. Also, older versions of Xpra use Xvfb.
#

whitelist /var/lib/xkb
#include whitelist-common.inc # see #903

caps.drop all
# Xvfb needs to be allowed access to the abstract Unix socket namespace.
nodvd
nogroups
noinput
nonewprivs
# In noroot mode, Xvfb cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp

disable-mnt
# using a private home directory
private
#private-bin sh,xkbcomp,Xvfb
#private-bin bash,cat,ls,sh,strace,xkbcomp,Xvfb
private-dev
private-etc gai.conf,host.conf
private-tmp

restrict-namespaces
