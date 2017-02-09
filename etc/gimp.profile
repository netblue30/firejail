# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gimp.local

# gimp
noblacklist ${HOME}/.gimp*
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp

noexec ${HOME}
noexec /tmp

private-dev
private-tmp
