# Firejail profile for netsurf
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/netsurf.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/netsurf
noblacklist ${HOME}/.config/netsurf

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/netsurf
mkdir ${HOME}/.config/netsurf
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/netsurf
whitelist ${HOME}/.config/netsurf
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
