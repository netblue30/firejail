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
private-etc PyBitMessage,PyBitMessage.conf,Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

