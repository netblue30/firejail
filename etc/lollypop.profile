# Firejail profile for lollypop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lollypop.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/lollypop

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
notv
