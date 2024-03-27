# Firejail profile for kdiff3
# Description: KDiff3 is a file and folder diff and merge tool.
# This file is overwritten after every install/update
# Persistent local customizations
include kdiff3.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kdiff3fileitemactionrc
noblacklist ${HOME}/.config/kdiff3rc

# Add the next line to your kdiff3.local if you don't need to compare files in disable-common.inc.
# By default we deny access only to .ssh and .gnupg.
#include disable-common.inc
blacklist ${HOME}/.gnupg
blacklist ${HOME}/.ssh

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
# Add the next line to your kdiff3.local if you don't need to compare files in disable-programs.inc.
#include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Add the next line to your kdiff3.local if you don't need to compare files in /run.
#include whitelist-run-common.inc
include whitelist-runuser-common.inc
# Add the next line to your kdiff3.local if you don't need to compare files in /usr/share.
#include whitelist-usr-share-common.inc
# Add the next line to your kdiff3.local if you don't need to compare files in /var.
#include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin kdiff3
private-cache
private-dev
private-etc @x11

dbus-user none
dbus-system none

restrict-namespaces
