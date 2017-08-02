# Persistent global definitions go here
include /etc/firejail/global.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/liferea.local

#######################
# profile for Liferea #
#######################
noblacklist ~/.config/liferea
mkdir ~/.config/liferea
whitelist ~/.config/liferea

noblacklist ~/.local/share/liferea
mkdir ~/.local/share/liferea
whitelist ~/.local/share/liferea

noblacklist ~/.cache/liferea
mkdir ~/.cache/liferea
whitelist ~/.cache/liferea

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/whitelist-common.inc

caps.drop all
#ipc-namespace
netfilter
#no3d
nogroups
nonewprivs
noroot
#nosound
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp
disable-mnt

noexec ${HOME}
noexec /tmp
