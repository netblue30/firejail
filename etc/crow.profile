# Firejail profile for crow
# This file is overwritten after every install/update
# Persistent local customizations
include crow.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/crow
noblacklist ${HOME}/.cache/gstreamer-1.0

mkdir ${HOME}/.config/crow
mkdir ${HOME}/.cache/gstreamer-1.0

whitelist ${HOME}/.config/crow
whitelist ${HOME}/.cache/gstreamer-1.0

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc

# apparmor
caps.drop all
# ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
# tracelog

disable-mnt
private-bin crow
# private-cache
private-dev
private-etc ca-certificates,ssl,machine-id,dconf,nsswitch.conf,resolv.conf,fonts,asound.conf,pulse,pki,crypto-policies
# private-lib
private-opt none
private-tmp
private-srv none

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
