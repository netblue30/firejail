# Firejail profile for mrrescue
# Description: Arcade-style fire fighting game
# This file is overwritten after every install/update
# Persistent local customizations
include mrrescue.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/love

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/love
whitelist ${HOME}/.local/share/love
whitelist /usr/share/mrrescue
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin love,mrrescue,sh
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload,machine-id
private-tmp

dbus-user none
dbus-system none
