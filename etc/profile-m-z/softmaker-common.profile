# Firejail profile for softmaker-common
# This file is overwritten after every install/update
# Persistent local customizations
include softmaker-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# The official packages install the desktop file under /usr/local/share/applications
# with an absolute Exec line. These files are NOT handled by firecfg,
# therefore you must manually copy them in you home and remove '/usr/bin/'.

noblacklist ${HOME}/SoftMaker

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /usr/share/office2018
whitelist /usr/share/freeoffice2018
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-bin freeoffice-planmaker,freeoffice-presentations,freeoffice-textmaker,planmaker18,planmaker18free,presentations18,presentations18free,sh,textmaker18,textmaker18free
private-cache
private-dev
private-etc @tls-ca,SoftMaker,fstab
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
