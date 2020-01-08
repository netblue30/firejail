# Firejail profile for pdftotext
# Description: Portable Document Format (PDF) to text converter
# This file is overwritten after every install/update
# Persistent local customizations
include pdftotext.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist /usr/share/poppler
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-bin pdftotext
private-cache
private-dev
private-etc alternatives
private-tmp
