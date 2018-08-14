# Firejail profile for gitter
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gitter.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/autostart
noblacklist ${HOME}/.config/Gitter

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/autostart
whitelist ${HOME}/.config/Gitter
include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin bash,env,gitter
private-etc fonts,pulse,resolv.conf,ca-certificates,ssl,pki,crypto-policies
private-opt Gitter
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
