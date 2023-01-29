# Firejail profile for inkscape
# Description: Vector-based drawing program
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include inkscape.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/inkscape
noblacklist ${HOME}/.config/inkscape
noblacklist ${HOME}/.inkscape
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}
# Allow exporting .xcf files
noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.gimp*


# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/inkscape
include whitelist-run-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
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
tracelog

# private-bin inkscape,potrace,python* - problems on Debian stretch
private-cache
private-dev
private-etc ImageMagick*,inkscape: GUI,python*
private-tmp

dbus-user none
dbus-system none

# memory-deny-write-execute
restrict-namespaces
