# Firejail profile for loupe
# Description: GNOME's modern Image Viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include loupe.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.steam

#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-write-mnt.inc

#whitelist /usr/share/glycin-loaders
include whitelist-runuser-common.inc
#include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
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
protocol unix,netlink
#loupe decodes all images in their own sandbox via glycin
#https://gitlab.gnome.org/sophie-h/glycin#sandboxing-and-inner-workings
#seccomp
seccomp.block-secondary
tracelog

private-cache
private-dev
private-etc @x11
private-tmp
