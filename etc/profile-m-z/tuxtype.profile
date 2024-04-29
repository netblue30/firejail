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
include whitelist-common.inc


include whitelist-run-common.inc
whitelist ${RUNUSER}/pulse
include whitelist-runuser-common.inc
whitelist /usr/share/tuxtype
include whitelist-usr-share-common.inc
writable-var 	# game scores stored under /var/games
include whitelist-var-common.inc

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
private-etc @x11,@sound,@games,tuxtype
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
