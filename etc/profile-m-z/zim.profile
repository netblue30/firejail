# Firejail profile for Zim
# Description: Desktop wiki & notekeeper
# This file is overwritten after every install/update
# Persistent local customizations
include zim.local
# Persistent global definitions
include globals.local

nodeny ${HOME}/.cache/zim
nodeny ${HOME}/.config/zim

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

deny /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/zim
mkdir ${HOME}/.config/zim
mkdir ${HOME}/Notebooks
allow ${HOME}/.cache/zim
allow ${HOME}/.config/zim
allow ${HOME}/Notebooks
allow ${DESKTOP}
allow ${DOCUMENTS}
allow ${DOWNLOADS}
allow ${MUSIC}
allow ${PICTURES}
allow ${VIDEOS}
allow /usr/share/zim
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
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
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin python*,zim
private-cache
private-dev
private-etc alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,pango,X11
private-tmp

dbus-user none
dbus-system none
