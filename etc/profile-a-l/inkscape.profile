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

mkdir ${HOME}/.cache/inkscape
mkdir ${HOME}/.config/inkscape
mkdir ${HOME}/.inkscape
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${PICTURES}
whitelist ${HOME}/.cache/inkscape
whitelist ${HOME}/.config/inkscape
whitelist ${HOME}/.inkscape
whitelist /usr/share/inkscape
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
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

#private-bin inkscape,potrace,python* # problems on Debian stretch
private-cache
private-dev
private-etc @x11,ImageMagick*,python*
private-tmp

dbus-user filter
dbus-user.own org.inkscape.Inkscape
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gtk.vfs.*
dbus-system none

restrict-namespaces
