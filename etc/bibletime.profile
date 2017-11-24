# Firejail profile for bibletime
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bibletime.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist ${HOME}/.Xauthority
blacklist ${HOME}/.bashrc

noblacklist ${HOME}/.bibletime
noblacklist ${HOME}/.sword

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.bibletime
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
