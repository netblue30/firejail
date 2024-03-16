# Firejail profile for koreader
# Description: Ebook reader application
# This file is overwritten after every install/update
# Persistent local customizations
include koreader.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

noblacklist ${HOME}/.config/koreader
noblacklist ${DOCUMENTS}

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/koreader
whitelist ${HOME}/.config/koreader
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
#no3d
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
seccomp
seccomp.block-secondary
tracelog

private-cache
private-dev
private-etc
private-lib
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.config/koreader
read-write ${DOWNLOADS}
restrict-namespaces
