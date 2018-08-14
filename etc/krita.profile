# Firejail profile for krita
# Description: Pixel-based image manipulation program
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/krita.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/kritarc
noblacklist ${HOME}/.local/share/krita
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

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
include /etc/firejail/disable-xdg.inc

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

private-cache
private-dev
private-tmp

# noexec ${HOME} may break krita, see issue #1953
# noexec ${HOME}
noexec /tmp
