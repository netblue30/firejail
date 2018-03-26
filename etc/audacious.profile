# Firejail profile for audacious
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/audacious.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Audaciousrc
noblacklist ${HOME}/.config/audacious

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
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin audacious
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
