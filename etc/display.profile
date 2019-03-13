# Firejail profile for display
# This file is overwritten after every install/update
# Persistent local customizations
include display.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix
seccomp
shell none
# x11 xorg - problems on kubuntu 17.04

private-bin display,python*
private-dev
# On Debian-based systems, display is a symlink in /etc/alternatives
private-etc alternatives
private-tmp
