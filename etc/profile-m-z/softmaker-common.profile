# Firejail profile for softmaker-common
# This file is overwritten after every install/update
# Persistent local customizations
include softmaker-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# The offical packages install the desktop file under /usr/local/share/applications
# with an absolute Exec line. These files are NOT handelt by firecfg,
# therefore you must manualy copy them in you home and remove '/usr/bin/'.

noblacklist ${HOME}/SoftMaker

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
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
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin freeoffice-planmaker,freeoffice-presentations,freeoffice-textmaker,planmaker18,planmaker18free,presentations18,presentations18free,sh,textmaker18,textmaker18free
private-cache
private-dev
private-etc ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,SoftMaker,ssl
private-tmp

dbus-user none
dbus-system none
