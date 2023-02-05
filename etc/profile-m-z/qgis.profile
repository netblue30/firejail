# Firejail profile for qgis
# Description: GIS application
# This file is overwritten after every install/update
# Persistent local customizations
include qgis.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/QGIS
noblacklist ${HOME}/.local/share/QGIS
noblacklist ${HOME}/.qgis2
noblacklist ${DOCUMENTS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/QGIS
mkdir ${HOME}/.qgis2
mkdir ${HOME}/.config/QGIS
whitelist ${HOME}/.local/share/QGIS
whitelist ${HOME}/.qgis2
whitelist ${HOME}/.config/QGIS
whitelist ${DOCUMENTS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
machine-id
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
# blacklisting of mbind system calls breaks old version
seccomp !mbind
protocol unix,inet,inet6,netlink
tracelog

disable-mnt
private-cache
private-dev
private-etc @tls-ca,QGIS,QGIS.conf,Trolltech.conf
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
