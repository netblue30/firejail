# Firejail profile for falkon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/falkon.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/falkon
noblacklist ${HOME}/.config/falkon

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ~/.cache/falkon
whitelist ~/.config/falkon
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
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
