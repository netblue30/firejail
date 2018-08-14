# Firejail profile for deadbeef
# Description: A GTK+ audio player for GNU/Linux
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/deadbeef.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/deadbeef
noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
