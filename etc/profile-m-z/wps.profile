# Firejail profile for wps
# Description: WPS Office - Writer
# This file is overwritten after every install/update
# Persistent local customizations
include wps.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kingsoft
noblacklist ${HOME}/.config/Kingsoft
noblacklist ${HOME}/.local/share/Kingsoft

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
# Add the next line to your wps.local if you don't use network features.
#net none
netfilter
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
protocol unix,inet,inet6
# seccomp causes some minor issues. Add the next line to your wps.local if you can live with those.
#seccomp
tracelog

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
