# Firejail profile for display
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/display.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none
# x11 xorg - problems on kubuntu 17.04

private-bin display,python*
private-dev
# private-etc none - on Debian-based systems display is a symlink in /etc/alternatives
private-tmp
