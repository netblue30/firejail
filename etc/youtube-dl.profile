# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/youtube-dl.local

# Firejail profile for youtube-dl

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

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
tracelog
quiet

private-dev

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp
