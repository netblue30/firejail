# Firejail profile for barrier
# Description: Keyboard and mouse sharing application
# This file is overwritten after every install/update

# Persistent local customizations
include barrier.local

# Persistent global definitions
include globals.local 

noblacklist ${HOME}/.config/Debauchee/Barrier.conf
noblacklist ${HOME}/.local/share/barrier/SSL/Barrier.pem
noblacklist /etc/xdg/Debauchee/Barrier.conf

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-cache
private-tmp

memory-deny-write-execute
