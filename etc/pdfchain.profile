# Firejail profile for pdfchain
# This file is overwritten after every install/update
# Persistent local customizations
include pdfchain.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

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
nou2f
novideo
protocol unix
seccomp
shell none

private-bin pdfchain,pdftk,sh
private-dev
private-etc alternatives,dconf,fonts,gtk-3.0,xdg
private-tmp

memory-deny-write-execute
