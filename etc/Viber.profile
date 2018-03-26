# Firejail profile for Viber
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Viber.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.ViberPC

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.ViberPC
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin sh,bash,dig,awk,Viber
private-etc hosts,fonts,mailcap,resolv.conf,X11,pulse,alternatives,localtime,nsswitch.conf,ssl,proxychains.conf,pki,ca-certificates,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp

env QTWEBENGINE_DISABLE_SANDBOX=1
