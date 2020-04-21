# Generic Firejail profile for servers started as root
#
# This profile is used as a default when starting the sandbox as root.
# Example:
#
#       $ sudo firejail
#       [sudo] password for netblue:
#       Reading profile /etc/firejail/server.profile
#       Reading profile /etc/firejail/disable-common.inc
#       Reading profile /etc/firejail/disable-passwdmgr.inc
#       Reading profile /etc/firejail/disable-programs.inc
#
#       ** Note: you can use --noprofile to disable server.profile **
#
#       Parent pid 5347, child pid 5348
#       The new log directory is /proc/5348/root/var/log
#       Child process initialized in 64.43 ms
#       root@debian:~#
#
# Customize the profile as usual. Examples: unbound.profile, fdns.profile.
# All the rules for regular user profiles apply with the exception of
# /usr/local/bin symlink redirection and firecfg tool. The redirection is disabled
# by default for root user.

# This file is overwritten after every install/update
# Persistent local customizations
include server.local
# Persistent global definitions
include globals.local

# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
# depending on your usage, you can enable some of the commands below:

noblacklist /sbin
noblacklist /usr/sbin
# noblacklist /var/opt

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

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

# dbus-user none
# dbus-system none

# memory-deny-write-execute
