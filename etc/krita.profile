# Firejail profile for krita
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/krita.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/kritarc
noblacklist ${HOME}/.local/share/krita

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

apparmor
caps.drop all
ipc-namespace
# net none
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
