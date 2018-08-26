# Firejail profile for Xvfb
# Description: Virtual Framebuffer 'fake' X server
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Xvfb.local
# Persistent global definitions
include /etc/firejail/globals.local

#
# This profile will sandbox Xvfb server itself when used with firejail --x11=xvfb.
# The target program is sandboxed with its own profile. By default the this functionality
# is disabled. To enable it, create a firejail-Xvfb  symlink in /usr/local/bin:
#
#    $ sudo ln -s /usr/bin/firejail /usr/local/bin/Xvfb
#
# We have this functionality disabled by default because it creates problems on
# some Linux distributions. Also, older versions of Xpra use Xvfb.
#

blacklist /media

whitelist /var/lib/xkb
include /etc/firejail/whitelist-common.inc

caps.drop all
# Xvfb needs to be allowed access to the abstract Unix socket namespace.
nodvd
nogroups
nonewprivs
# In noroot mode, Xvfb cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
notv
protocol unix
seccomp
shell none

# using a private home directory
private
# private-bin Xvfb,sh,xkbcomp
# private-bin Xvfb,sh,xkbcomp,strace,bash,cat,ls
private-dev
private-etc ld.so.conf,ld.so.cache,resolv.conf,host.conf,nsswitch.conf,gai.conf,hosts,hostname
private-tmp
