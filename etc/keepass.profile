# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/keepass.local

# keepass password manager profile
noblacklist ${HOME}/.keepass
noblacklist ${HOME}/.config/keepass
noblacklist ${HOME}/.config/KeePass
noblacklist ${HOME}/.local/share/keepass
noblacklist ${HOME}/.local/share/KeePass
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/*.kdb

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
#ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp
