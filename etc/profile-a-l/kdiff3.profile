# Firejail profile for kdiff3
# Description: KDiff3 is a file and folder diff and merge tool.
# This file is overwritten after every install/update
# Persistent local customizations
include kdiff3.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kdiff3fileitemactionrc
noblacklist ${HOME}/.config/kdiff3rc

# Uncomment the next line (or put it into your kdiff3.local) if you don't need to compare files in disable-common.inc.
# by default we deny access only to .ssh and .gnupg
#include disable-common.inc
blacklist ${HOME}/.ssh
blacklist ${HOME}/.gnupg

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# Uncomment the next line (or put it into your kdiff3.local) if you don't need to compare files in disable-programs.inc.
#include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
# Uncomment the next lines (or put it into your kdiff3.local) if you don't need to compare files in /usr/share.
#include whitelist-usr-share-common.inc
# Uncomment the next line (or put it into your kdiff3.local) if you don't need to compare files in /var.
#include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin  kdiff3
private-cache
private-dev

dbus-user none
dbus-system none
