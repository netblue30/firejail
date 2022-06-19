# Firejail profile for songrec
# Description: An open-source Shazam client for Linux
# This file is overwritten after every install/update
# Persistent local customizations
include songrec.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/SongRec
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

nowhitelist ${PICTURES}

mkdir ${HOME}/.local/share/SongRec
whitelist ${HOME}/.local/share/SongRec
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
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
seccomp.block-secondary

disable-mnt
private-bin ffmpeg,songrec
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
