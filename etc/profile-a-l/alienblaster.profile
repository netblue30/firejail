# Firejail profile for alienblaster
# Persistent local customizations
include alienblaster.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.alienblaster
noblacklist ${HOME}/.alienblaster_highscore

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.alienblaster_highscore
whitelist ${HOME}/.alienblaster_highscore
mkdir ${HOME}/.alienblaster
whitelist ${HOME}/.alienblaster
include whitelist-common.inc
include whitelist-run-common.inc
whitelist ${RUNUSER}/pulse
include whitelist-runuser-common.inc
whitelist /usr/share/games/alienblaster
whitelist /usr/share/timidity
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
net none
nodvd
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-dev
private-etc @x11,@sound,@games
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
