# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/deadbeef.local

# DeaDBeeF media player profile
noblacklist ${HOME}/.config/deadbeef

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
