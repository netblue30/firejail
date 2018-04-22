# Firejail profile for ppsspp
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ppsspp.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/ppsspp
# with >=llvm-4 mesa drivers need llvm stuff
noblacklist /usr/lib/llvm*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,netlink
seccomp
shell none

# private-dev is disabled to allow controller support
#private-dev
private-etc asound.conf,ca-certificates,drirc,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,nsswitch.conf,passwd,pulse,resolv.conf,ssl,pki,crypto-policies
private-opt ppsspp
private-tmp

noexec ${HOME}
noexec /tmp
