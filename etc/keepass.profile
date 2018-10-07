# Firejail profile for keepass
# Description: An easy-to-use password manager
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/keepass.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/KeePass
noblacklist ${HOME}/.config/keepass
noblacklist ${HOME}/.keepass
noblacklist ${HOME}/.local/share/KeePass
noblacklist ${HOME}/.local/share/keepass
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
