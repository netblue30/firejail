# Firejail profile for globaltime
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/globaltime.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/globaltime

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
