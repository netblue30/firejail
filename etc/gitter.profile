# Firejail profile for gitter
# This file is overwritten after every install/update
# Persistent local customizations
include gitter.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/autostart
noblacklist ${HOME}/.config/Gitter

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/autostart
whitelist ${HOME}/.config/Gitter
include whitelist-var-common.inc

caps.drop all
# machine-id breaks audio; it should work fine in setups where sound is not required
machine-id
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin bash,env,gitter
private-etc alternatives,fonts,pulse,resolv.conf,ca-certificates,ssl,pki,crypto-policies
private-opt Gitter
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
