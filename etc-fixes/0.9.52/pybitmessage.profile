# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/default.local
# Persistent global definitions
include /etc/firejail/globals.local

# generic gui profile
# depending on your usage, you can enable some of the commands below:
noblacklist /sbin
noblacklist /usr/local/sbin
noblacklist /usr/sbin

noexec /sbin
noexec /usr/local/sbin
noexec /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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
private-etc PyBitmessage,PyBitmessage.conf,Trolltech.conf,fonts,gtk-2.0,hosts,ld.so.cache,ld.so.preload,localtime,pki,resolv.conf,selinux,sni-qt.conf,system-fips,xdg
#private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
