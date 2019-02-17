# Firejail profile for gpredict
# Description: Satellite tracking program
# This file is overwritten after every install/update
# Persistent local customizations
include gpredict.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Gpredict

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${HOME}/.config/Gpredict
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin gpredict
private-dev
private-etc alternatives,fonts,resolv.conf,ca-certificates,ssl,pki,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp
