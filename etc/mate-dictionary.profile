# Firejail profile for mate-dictionary
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mate-dictionary.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mate/mate-dictionary

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
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
