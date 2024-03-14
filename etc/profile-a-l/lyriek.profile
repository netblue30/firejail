# Firejail profile for lyriek
# Description: A multi-threaded GTK application to fetch lyrics of currently playing songs
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lyriek.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin lyriek
private-cache
private-dev
private-etc @network,@tls-ca
private-lib
private-tmp

dbus-user filter
dbus-user.talk org.mpris.MediaPlayer2.mpd
dbus-system none

read-only ${HOME}
restrict-namespaces
