# Firejail profile for basilisk
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/basilisk.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/moonchild productions/basilisk
noblacklist ${HOME}/.moonchild productions/basilisk

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/moonchild productions/basilisk
mkdir ${HOME}/.moonchild productions
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/moonchild productions/basilisk
whitelist ${HOME}/.moonchild productions
include /etc/firejail/whitelist-common.inc

apparmor
caps.drop all
# machine-id breaks pulse audio; it should work fine in setups where sound is not required
# machine-id
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
# private-bin basilisk
private-dev
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse
# private-opt basilisk
private-tmp

noexec ${HOME}

