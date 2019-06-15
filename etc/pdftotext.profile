# Firejail profile for pdftotext
# This file is overwritten after every install/update
# Persistent local customizations
include pdftotext.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
include whitelist-var-common.inc

caps.drop all
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
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin pdftotext
private-dev
private-etc alternatives
private-tmp
