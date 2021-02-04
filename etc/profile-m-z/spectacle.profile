# Firejail profile for spectacle
# Description: Spectacle is a simple application for capturing desktop screenshots.
# This file is overwritten after every install/update
# Persistent local customizations
include spectacle.local
# Persistent global definitions
include globals.local

# Uncomment the following lines to use sharing services.
#netfilter
#ignore net none
#private-etc ca-certificates,crypto-policies,pki,resolv.conf,ssl
#protocol unix,inet,inet6

noblacklist ${HOME}/.config/spectaclerc
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile  ${HOME}/.config/spectaclerc
whitelist ${HOME}/.config/spectaclerc
whitelist ${PICTURES}
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
private-bin spectacle
private-cache
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d
private-tmp

dbus-user filter
dbus-user.own org.kde.spectacle
dbus-user.talk org.freedesktop.FileManager1
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kglobalaccel
dbus-system none
