# Firejail profile for xpdf
# Description: Portable Document Format (PDF) reader
# This file is overwritten after every install/update
# Persistent local customizations
include xpdf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xpdfrc
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
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

private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
