# Firejail profile for pdfchain
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pdfchain.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
no3d
nodbus
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-bin pdfchain,pdftk,sh
private-dev
private-etc dconf,fonts,gtk-3.0,xdg
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
