# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/Xephyr.local

#
# This profile will sandbox Xephyr server itself when used with firejail --x11=xephyr.
# To enable it, create a firejail-Xephyr  symlink in /usr/local/bin:
#
#    $ sudo ln -s /usr/bin/firejail /usr/local/bin/Xephyr
#
# or run "sudo firecfg"
#


# using a private home directory
private


caps.drop all
# Xephyr needs to be allowed access to the abstract Unix socket namespace.
#net none
nogroups
nonewprivs
# In noroot mode, Xephyr cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
shell none
seccomp
protocol unix

private-dev
private-tmp
#private-bin Xephyr,sh,xkbcomp,strace,bash,cat,ls
#private-bin Xephyr,sh,xkbcomp
#private-etc ld.so.conf,ld.so.cache,resolv.conf,host.conf,nsswitch.conf,gai.conf,hosts,hostname

blacklist /media
whitelist /var/lib/xkb
