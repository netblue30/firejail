# Firejail profile for ppsspp
# Description: A PSP emulator written in C++
# This file is overwritten after every install/update
# Persistent local customizations
include ppsspp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ppsspp
noblacklist ${DOCUMENTS}
# with >=llvm-4 mesa drivers need llvm stuff
noblacklist /usr/lib/llvm*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

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
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,drirc,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,machine-id,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl
private-opt ppsspp
private-tmp

