# Firejail profile for electron
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/electron.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/Rocket.Chat
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ~/.config/Rocket.Chat

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
