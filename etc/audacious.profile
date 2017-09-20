# Firejail profile for audacious
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/audacious.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/Audaciousrc
noblacklist ~/.config/audacious

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
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
