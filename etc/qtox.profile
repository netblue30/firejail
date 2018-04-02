# Firejail profile for qtox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qtox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/tox

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/tox
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/tox
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin qtox
private-etc fonts,resolv.conf,ld.so.cache,localtime
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
