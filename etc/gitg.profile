# Firejail profile for gitg
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gitg.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.local/share/gitg
noblacklist ${HOME}/.ssh

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
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

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
