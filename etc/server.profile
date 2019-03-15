# Firejail profile for server
# This file is overwritten after every install/update
# Persistent local customizations
include server.local
# Persistent global definitions
include globals.local

# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
# depending on your usage, you can enable some of the commands below:

blacklist /tmp/.X11-unix

noblacklist /sbin
noblacklist /usr/sbin
# noblacklist /var/opt

include disable-common.inc
# include disable-devel.inc
# include disable-exec.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# include disable-xdg.inc

caps
# ipc-namespace
# netfilter /etc/firejail/webserver.net
no3d
# nodbus
nodvd
# nogroups
# nonewprivs
# noroot
nosound
notv
nou2f
novideo
seccomp
# shell none

# disable-mnt
private
# private-bin program
# private-cache
private-dev
# private-etc alternatives
# private-lib
private-tmp

# memory-deny-write-execute
