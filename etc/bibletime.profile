# Firejail profile for bibletime
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bibletime.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist ~/.Xauthority
blacklist ~/.bashrc

noblacklist ~/.bibletime
noblacklist ~/.config/qt5ct
noblacklist ~/.sword

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.bibletime
whitelist ${HOME}/.config/qt5ct
whitelist ${HOME}/.sword
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

# private-bin bibletime,qt5ct
private-dev
private-etc fonts,resolv.conf,sword,sword.conf,passwd
private-tmp
