# Firejail profile for handbrake
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/handbrake.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/ghb

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
