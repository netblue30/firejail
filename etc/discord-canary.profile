# Firejail profile for discord-canary
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/discord-canary.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/discordcanary

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
