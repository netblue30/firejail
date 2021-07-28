# Firejail profile for rednotebook
# Description: Daily journal with calendar, templates and keyword searching
# This file is overwritten after every install/update
# Persistent local customizations
include rednotebook.local
# Persistent global definitions
include globals.local

nodeny ${HOME}/.cache/rednotebook
nodeny ${HOME}/.rednotebook

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/rednotebook
mkdir ${HOME}/.rednotebook
allow ${HOME}/.cache/rednotebook
allow ${HOME}/.rednotebook
allow ${DESKTOP}
allow ${DOCUMENTS}
allow ${DOWNLOADS}
allow ${MUSIC}
allow ${PICTURES}
allow ${VIDEOS}
allow /usr/libexec/webkit2gtk-4.0
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
private-bin python3*,rednotebook
private-cache
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,pango,X11
private-tmp

dbus-user none
dbus-system none
