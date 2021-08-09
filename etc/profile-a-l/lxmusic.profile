# Firejail profile for lxmusic
# Description: LXDE music player
# This file is overwritten after every install/update
# Persistent local customizations
include lxmusic.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/xmms2
noblacklist ${HOME}/.config/xmms2
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

