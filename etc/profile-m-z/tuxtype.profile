# Firejail profile for tuxtype
# Persistent local customizations
include tuxtype.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.tuxtype

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.tuxtype
whitelist ${HOME}/.tuxtype
whitelist ${RUNUSER}/pulse
whitelist /usr/share/tuxtype
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

writable-var # game scores are stored under /var/games

apparmor
caps.drop all
ipc-namespace
net none
netfilter
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
private-bin tuxtype
private-dev
private-etc @games,@sound,@x11,tuxtype
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
