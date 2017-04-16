# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/meld.local

# Firejail profile for meld
noblacklist ${HOME}/.local/share/meld

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
