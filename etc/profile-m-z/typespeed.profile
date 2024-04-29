# Firejail profile for typespeed
# Persistent local customizations
include typespeed.local
# Persistent global definitions
include globals.local

# Note: this profile requires the current user to be a member of games group

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-runuser-common.inc
whitelist /usr/share/typespeed
include whitelist-usr-share-common.inc
writable-var 	# game scores stored under /var/games
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private
private-dev
private-etc @x11,@sound,@games
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
