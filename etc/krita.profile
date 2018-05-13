# Firejail profile for krita
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/krita.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/kritarc
noblacklist ${HOME}/.local/share/krita

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
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
