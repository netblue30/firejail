# Firejail profile for pdfmod
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pdfmod.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/pdfmod
noblacklist ${HOME}/.config/pdfmod

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
net none
no3d
nodbus
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

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
