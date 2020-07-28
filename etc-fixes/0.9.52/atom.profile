# Firejail profile for atom
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/atom.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.keep sys_admin,sys_chroot
# net none
netfilter
nodvd
nogroups
nosound
notv
novideo
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
