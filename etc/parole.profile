# Firejail profile for parole
# Description: Media player based on GStreamer framework
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/parole.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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
private-etc passwd,group,fonts,machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
