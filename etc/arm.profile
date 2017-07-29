# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/arm.local

# Firejail profile for arm

noblacklist ${HOME}/.arm

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.arm
whitelist ${HOME}/.arm
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
#private-bin arm,tor,sh,python2,python2.7,ps,lsof,ldconfig
private-dev
private-etc tor,passwd
private-tmp

noexec ${HOME}
noexec /tmp
