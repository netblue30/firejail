# Firejail profile for electron
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/electron.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}

apparmor
caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
