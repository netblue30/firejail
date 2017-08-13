# Firejail profile for 2048-qt
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/2048-qt.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/2048-qt
noblacklist ~/.config/xiaoyong

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
