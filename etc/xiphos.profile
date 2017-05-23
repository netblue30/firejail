# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/xiphos.local

# Firejail profile for xiphos
noblacklist ~/.sword
noblacklist ~/.xiphos

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

blacklist ~/.bashrc
blacklist ~/.Xauthority

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin xiphos
private-etc fonts,resolv.conf,sword
private-dev
private-tmp

whitelist ${HOME}/.sword
whitelist ${HOME}/.xiphos
