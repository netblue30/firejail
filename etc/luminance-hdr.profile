# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/luminance-hdr.local

# luminance-hdr
noblacklist ${HOME}/.config/Luminance
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
#ipc-namespace
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp

private-tmp
private-dev
