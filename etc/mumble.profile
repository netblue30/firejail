# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/mumble.local

# mumble profile
noblacklist ${HOME}/.config/Mumble
noblacklist ${HOME}/.local/share/data/Mumble
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ${HOME}/.config/Mumble
mkdir ${HOME}/.local/share/data/Mumble
whitelist ${HOME}/.config/Mumble
whitelist ${HOME}/.local/share/data/Mumble
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
nonewprivs
nogroups
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin mumble
private-tmp

noexec ${HOME}
noexec /tmp
