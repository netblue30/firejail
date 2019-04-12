# Firejail profile for Viber
# This file is overwritten after every install/update
# Persistent local customizations
include Viber.local
# Persistent global definitions
include globals.local


noblacklist ${HOME}/.ViberPC

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.ViberPC
include whitelist-common.inc

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
private-etc hosts,fonts,mailcap,resolv.conf,X11,pulse,alternatives,localtime,nsswitch.conf,ssl,proxychains.conf,pki,ca-certificates,crypto-policies,machine-id,asound.conf
private-tmp


env QTWEBENGINE_DISABLE_SANDBOX=1
