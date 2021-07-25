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
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Gitter
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/autostart
whitelist ${HOME}/.config/Gitter
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
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
private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,pulse,resolv.conf,ssl
private-opt Gitter
private-dev
private-tmp

