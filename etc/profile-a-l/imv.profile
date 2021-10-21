# Firejail profile for imv
# Description: imv is an image viewer.
# This file is overwritten after every install/update
# Persistent local customizations
include imv.local
# Persistent global definitions
include globals.local

include allow-bin-sh.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
# Users may want to view images in ${HOME}
#include disable-xdg.inc

# Users may want to view images in ${HOME}
#include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
# Users may want to view images in /usr/share
#include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin imv,imv-wayland,imv-x11,sh
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
