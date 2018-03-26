# This file is overwritten after every install/update.
# Persistent local customisations
include /etc/firejail/enpass.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

noblacklist ${HOME}/.config/Sinew Software Systems

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin sh,readlink,dirname
private-dev
private-opt Enpass
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
