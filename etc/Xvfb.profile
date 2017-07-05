# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/xvfb.local

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


# using a private home directory
private

caps.drop all
# Xvfb needs to be allowed access to the abstract Unix socket namespace.
nogroups
nonewprivs
# In noroot mode, Xvfb cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
shell none
seccomp
protocol unix

private-dev
private-tmp
private-etc ld.so.conf,ld.so.cache,resolv.conf,host.conf,nsswitch.conf,gai.conf,hosts,hostname
#private-bin Xvfb,sh,xkbcomp,strace,bash,cat,ls
#private-bin Xvfb,sh,xkbcomp

blacklist /media
whitelist /var/lib/xkb
