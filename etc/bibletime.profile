# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/bibletime.local

# Firejail profile for BibleTime
noblacklist ~/.bibletime
noblacklist ~/.config/qt5ct
noblacklist ~/.sword

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

blacklist ~/.bashrc
blacklist ~/.Xauthority

whitelist ${HOME}/.bibletime
whitelist ${HOME}/.config/qt5ct
whitelist ${HOME}/.sword


caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

#private-bin bibletime,qt5ct
private-etc fonts,resolv.conf,sword,sword.conf,passwd
private-dev
private-tmp
