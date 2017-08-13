# Firejail profile for lxmusic
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lxmusic.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/xmms2
noblacklist ~/.config/xmms2

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
notv
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
