# Firejail profile for lxmusic
# Description: LXDE music player
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lxmusic.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/xmms2
noblacklist ${HOME}/.config/xmms2
noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

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
