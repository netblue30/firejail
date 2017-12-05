# Firejail profile for evince
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/evince.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus

noblacklist ${HOME}/.config/evince

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
# net none breaks AppArmor on Ubuntu systems
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin evince,evince-previewer,evince-thumbnailer
private-dev
private-etc fonts
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
