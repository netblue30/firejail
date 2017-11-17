# Firejail profile for stellarium
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/stellarium.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/stellarium
noblacklist ${HOME}/.stellarium

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/stellarium
mkdir ${HOME}/.stellarium
whitelist ${HOME}/.config/stellarium
whitelist ${HOME}/.stellarium
include /etc/firejail/whitelist-common.inc
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
tracelog

disable-mnt
private-bin stellarium
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
