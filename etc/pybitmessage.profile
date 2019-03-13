# Firejail profile for pybitmessage
# This file is overwritten after every install/update
# Persistent local customizations
include pybitmessage.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/local/sbin
noblacklist /usr/sbin

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-interpreters.inc

include whitelist-var-common.inc

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
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin pybitmessage,python*,sh,ldconfig,env,bash,stat
private-dev
private-etc alternatives,PyBitmessage,PyBitmessage.conf,Trolltech.conf,fonts,gtk-2.0,hosts,ld.so.cache,ld.so.preload,localtime,pki,resolv.conf,selinux,sni-qt.conf,system-fips,xdg,ca-certificates,ssl,pki,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp
