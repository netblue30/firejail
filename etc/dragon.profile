# Firejail profile for dragon
# Description: A multimedia player where the focus is on simplicity, instead of features
# This file is overwritten after every install/update
# Persistent local customizations
include dragon.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/dragonplayerrc
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/dragonplayer
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin dragon
private-dev
private-tmp

