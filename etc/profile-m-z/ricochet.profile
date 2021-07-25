# Firejail profile for ricochet
# This file is overwritten after every install/update
# Persistent local customizations
include ricochet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/Ricochet

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.local/share/Ricochet
whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/Ricochet
include whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
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

disable-mnt
private-bin ricochet,tor
private-dev
#private-etc alternatives,alternatives,ca-certificates,crypto-policies,fonts,pki,ssl,tor,X11

