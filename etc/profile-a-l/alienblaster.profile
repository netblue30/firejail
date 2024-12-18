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

mkdir ${HOME}/.alienblaster
mkfile ${HOME}/.alienblaster_highscore
whitelist ${HOME}/.alienblaster
whitelist ${HOME}/.alienblaster_highscore
whitelist ${RUNUSER}/pulse
whitelist /usr/share/games/alienblaster
whitelist /usr/share/timidity
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
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
private-etc @games,@sound,@x11
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
