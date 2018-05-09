# Firejail profile for qmmp
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qmmp.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.qmmp

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
# no3d
nodbus
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin qmmp
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
