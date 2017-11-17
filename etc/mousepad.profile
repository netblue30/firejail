# Firejail profile for mousepad
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mousepad.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Mousepad

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none
tracelog

private-bin mousepad
private-dev
private-lib
private-tmp
