# Firejail profile for cmus
# Description: Lightweight ncurses audio player
# This file is overwritten after every install/update
# Persistent local customizations
include cmus.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/cmus
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
netfilter
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp

private-bin cmus
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,group,ld.so.cache,ld.so.preload,machine-id,pki,pulse,resolv.conf,ssl
