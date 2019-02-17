# Firejail profile for qtox
# Description: Powerful Tox client written in C++/Qt that follows the Tox design guidelines
# This file is overwritten after every install/update
# Persistent local customizations
include qtox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/tox

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/tox
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/tox
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin qtox
private-etc alternatives,fonts,resolv.conf,ld.so.cache,localtime,ca-certificates,ssl,pki,crypto-policies,machine-id,pulse
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
