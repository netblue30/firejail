# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gitg.local

# Firejail profile for gitg
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.local/share/gitg

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
