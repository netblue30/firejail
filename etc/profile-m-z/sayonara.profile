# Firejail profile for sayonara player
# This file is overwritten after every install/update
# Persistent local customizations
include sayonara.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Sayonara
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin sayonara
private-dev
private-tmp

