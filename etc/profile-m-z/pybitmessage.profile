# Firejail profile for pybitmessage
# This file is overwritten after every install/update
# Persistent local customizations
include pybitmessage.local
# Persistent global definitions
include globals.local

nodeny  /sbin
nodeny  /usr/local/sbin
nodeny  /usr/sbin

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
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
noinput
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
private-bin bash,env,ldconfig,pybitmessage,python*,sh,stat
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,gtk-2.0,hosts,ld.so.cache,ld.so.preload,localtime,pki,pki,PyBitmessage,PyBitmessage.conf,resolv.conf,selinux,sni-qt.conf,ssl,system-fips,Trolltech.conf,xdg
private-tmp

