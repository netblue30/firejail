# Firejail profile for pybitmessage
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pybitmessage.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/whitelist-var-common.inc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-interpreters.inc

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

noblacklist /sbin
noblacklist /usr/local/sbin
noblacklist /usr/sbin

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin pybitmessage,python*,sh,ldconfig,env,bash,stat
private-dev
private-etc PyBitmessage,PyBitmessage.conf,Trolltech.conf,fonts,gtk-2.0,hosts,ld.so.cache,ld.so.preload,localtime,pki,resolv.conf,selinux,sni-qt.conf,system-fips,xdg,ca-certificates,ssl,pki,crypto-policies
#private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
