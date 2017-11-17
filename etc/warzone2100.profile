# Firejail profile for warzone2100
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/warzone2100.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.warzone2100-3.*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# mkdir ${HOME}/.warzone2100-3.1
# mkdir ${HOME}/.warzone2100-3.2
whitelist ${HOME}/.warzone2100-3.1
whitelist ${HOME}/.warzone2100-3.2
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin warzone2100
private-dev
private-tmp
