# Firejail profile for openshot
# Description: Create and edit videos and movies
# This file is overwritten after every install/update
# Persistent local customizations
include openshot.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.openshot
noblacklist ${HOME}/.openshot_qt

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/blender
whitelist /usr/share/inkscape
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin blender,inkscape,openshot,openshot-qt,python3*
private-cache
private-dev
private-tmp

dbus-user filter
dbus-system none
