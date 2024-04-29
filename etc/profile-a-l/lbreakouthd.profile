# Firejail profile for lbreakouthd
# Persistent local customizations
include lbreakouthd.local
# Persistent global definitions
include globals.local

# Note: this profile requires the current user to be a member of games group

noblacklist ${HOME}/.lbreakouthd

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.lbreakouthd
whitelist ${HOME}/.lbreakouthd
include whitelist-common.inc

whitelist /run/udev/control
whitelist /run/host/container-manager
include whitelist-run-common.inc
whitelist ${RUNUSER}/pulse
include whitelist-runuser-common.inc
whitelist /usr/share/games/lbreakouthd
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
private-bin lbreakouthd
private-dev
private-etc @x11,@sound,@games
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
