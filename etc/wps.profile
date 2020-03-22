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
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
# Uncomment the next line (or add to wps.local) if you don't use network features.
#net none
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
# seccomp cause some minor issues, if you can live with them enable it.
#seccomp
shell none
tracelog

private-cache
private-dev
private-tmp
