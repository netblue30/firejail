# Firejail profile for lynx
# Description: Classic non-graphical (text-mode) web browser
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lynx.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

include whitelist-runuser-common.inc

caps.drop all
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
protocol unix,inet,inet6
seccomp
tracelog

#private-bin lynx
private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,pki,ssl
private-tmp

restrict-namespaces
