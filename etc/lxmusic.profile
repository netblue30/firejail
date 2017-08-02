# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/lxmusic.local

noblacklist ~/.cache/xmms2
noblacklist ~/.config/xmms2

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
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
