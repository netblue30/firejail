# Firejail profile for display
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/display.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
nodbus
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
