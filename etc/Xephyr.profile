# Firejail profile for Xephyr
# This file is overwritten after every install/update
# Persistent local customizations
quiet
include Xephyr.local
# Persistent global definitions
include globals.local

#
# This profile will sandbox Xephyr server itself when used with firejail --x11=xephyr.
# To enable it, create a firejail-Xephyr symlink in /usr/local/bin:
#
#    $ sudo ln -s /usr/bin/firejail /usr/local/bin/Xephyr
#
# or run "sudo firecfg"
#

whitelist /var/lib/xkb
include whitelist-common.inc

caps.drop all
# Xephyr needs to be allowed access to the abstract Unix socket namespace.
nodvd
nogroups
nonewprivs
# In noroot mode, Xephyr cannot create a socket in the real /tmp/.X11-unix.
# noroot
nosound
notv
nou2f
protocol unix
seccomp
shell none

disable-mnt
# using a private home directory
private
# private-bin sh,Xephyr,xkbcomp
# private-bin bash,cat,ls,sh,strace,Xephyr,xkbcomp
private-dev
#private-etc alternatives,bumblebee,dbus-1,drirc,glvnd,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,passwd,xdg
#private-tmp
