# Firejail profile for qgis
# Description: GIS application
# This file is overwritten after every install/update
# Persistent local customizations
include qgis.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/QGIS
nodeny  ${HOME}/.local/share/QGIS
nodeny  ${HOME}/.qgis2
nodeny  ${DOCUMENTS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/QGIS
mkdir ${HOME}/.qgis2
mkdir ${HOME}/.config/QGIS
allow  ${HOME}/.local/share/QGIS
allow  ${HOME}/.qgis2
allow  ${HOME}/.config/QGIS
allow  ${DOCUMENTS}
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
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,machine-id,pki,QGIS,QGIS.conf,resolv.conf,ssl,Trolltech.conf
private-tmp

dbus-user none
dbus-system none
