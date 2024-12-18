# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include links-common.local

# common profile for links browsers

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
# Additional noblacklist files/directories (blacklisted in disable-programs.inc)
# used as associated programs can be added in your links-common.local.
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
# Add 'ignore machine-id' to your links-common.local if you want to restrict access to
# the user-configured associated media player.
machine-id
netfilter
# Add 'ignore no3d' to your links-common.local if you want to restrict access to
# the user-configured associated media player.
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
# Add 'ignore nosound' to your links-common.local if you want to restrict access to
# the user-configured associated media player.
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
# Add 'private-bin PROGRAM1,PROGRAM2' to your links-common.local if you want to use user-configured programs.
private-bin sh
private-cache
private-dev
private-etc @tls-ca
# Add the next line to your links-common.local to allow external media players.
#private-etc alsa,asound.conf,machine-id,openal,pulse
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
