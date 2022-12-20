# Firejail profile for netsurf
# Description: Lightweight and fast web browser
# This file is overwritten after every install/update
# Persistent local customizations
include netsurf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/netsurf
noblacklist ${HOME}/.config/netsurf

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/netsurf
mkdir ${HOME}/.config/netsurf
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/netsurf
whitelist ${HOME}/.config/netsurf
include whitelist-common.inc

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

restrict-namespaces
