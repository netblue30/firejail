# Firejail profile for keepass
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

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
