# Firejail profile for Nicotine Plus
# Description: Soulseek music-sharing client
# This file is overwritten after every install/update
# Persistent local customizations
include nicotine.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.nicotine

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.nicotine
whitelist ${DOWNLOADS}
whitelist ${HOME}/.nicotine
whitelist /usr/share/GeoIP
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin nicotine,python2*
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
