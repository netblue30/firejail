# Firejail profile for parole
# Description: Media player based on GStreamer framework
# This file is overwritten after every install/update
# Persistent local customizations
include parole.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none

private-bin parole,dbus-launch
private-cache
private-etc alternatives,passwd,group,fonts,machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
