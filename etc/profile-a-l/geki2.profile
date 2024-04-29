# Firejail profile for geki2
# Persistent local customizations
include geki2.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-runuser-common.inc
whitelist /usr/share/games/geki2
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
private
private-bin geki2
private-dev
private-etc @x11,@sound,@games
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
