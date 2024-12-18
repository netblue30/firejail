# Firejail profile for tin
# Description: ncurses-based Usenet newsreader
# This file is overwritten after every install/update
# Persistent local customizations
include tin.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.newsrc
noblacklist ${HOME}/.tin

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

mkdir ${HOME}/.tin
mkfile ${HOME}/.newsrc
# Note: files/directories directly in ${HOME} can't be whitelisted, as
# tin saves .newsrc by renaming a temporary file, which is not possible for
# bind-mounted files.
#whitelist ${HOME}/.newsrc
#whitelist ${HOME}/.tin
#include whitelist-common.inc
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
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin rtin,tin
private-cache
private-dev
private-etc terminfo,tin
private-lib terminfo
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
