# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/steam.local

# Steam profile (applies to games/apps launched from Steam as well)
noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/steam
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
ipc-namespace
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-dev
private-tmp
