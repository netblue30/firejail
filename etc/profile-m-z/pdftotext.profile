# Firejail profile for pdftotext
# Description: Portable Document Format (PDF) to text converter
# This file is overwritten after every install/update
# Persistent local customizations
include pdftotext.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
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
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog
x11 none

private-bin pdftotext
private-cache
private-dev
private-etc alternatives
private-tmp

dbus-user none
dbus-system none
