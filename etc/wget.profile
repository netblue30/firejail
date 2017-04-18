# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/wget.local

# wget profile
quiet
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

blacklist /tmp/.X11-unix

# private-bin wget
private-dev
# private-etc resolv.conf
private-tmp

noexec ${HOME}
noexec /tmp
