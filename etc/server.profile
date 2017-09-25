# Firejail profile for server
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/server.local
# Persistent global definitions
include /etc/firejail/globals.local

# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
# depending on your usage, you can enable some of the commands below:

blacklist /tmp/.X11-unix

noblacklist /sbin
noblacklist /usr/sbin
# noblacklist /var/opt

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps
no3d
nodvd
nosound
notv
novideo
seccomp

# netfilter /etc/firejail/webserver.net

# disable-mnt
private
# private-bin program
private-dev
# private-etc none
# private-lib
private-tmp

# memory-deny-write-execute
# noexec ${HOME}
# noexec /tmp
