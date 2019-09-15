# Firejail profile for keepassxc
# Description: Cross Platform Password Manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepassxc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/keepassxc
noblacklist ${HOME}/.keepassxc
# 2.2.4 needs this path when compiled with "Native messaging browser extension"
noblacklist ${HOME}/.mozilla
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nodvd
# Breaks 'Lock database when session is locked or lid is closed' (#2899),
# you can safely uncomment it or add to keepassxc.local if you don't need this feature.
#nodbus
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none

private-bin keepassxc,keepassxc-cli,keepassxc-proxy
private-dev
private-etc alternatives,fonts,ld.so.cache,machine-id
private-tmp

# Mutex is stored in /tmp by default, which is broken by private-tmp
join-or-start keepassxc
