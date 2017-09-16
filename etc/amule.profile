# Firejail profile for amule
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/amule.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.aMule

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.aMule
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
nogroups
nonewprivs
noroot
seccomp
shell none

private-bin amule
private-dev
private-tmp
