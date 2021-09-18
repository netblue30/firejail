# Firejail profile for pragha
# Description: A lightweight GTK music player
# This file is overwritten after every install/update
# Persistent local customizations
include pragha.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/pragha
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-3.0,host.conf,hostname,hosts,ld.so.preload,machine-id,pki,pulse,resolv.conf,ssl,xdg
private-tmp

