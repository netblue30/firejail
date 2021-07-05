# Firejail profile for netsurf
# Description: Lightweight and fast web browser
# This file is overwritten after every install/update
# Persistent local customizations
include netsurf.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/netsurf
nodeny  ${HOME}/.config/netsurf

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/netsurf
mkdir ${HOME}/.config/netsurf
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/netsurf
allow  ${HOME}/.config/netsurf
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
