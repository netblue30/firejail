# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/viewnior.local

# Firejail profile for viewnior
noblacklist ~/.config/viewnior
noblacklist ~/.Steam
noblacklist ~/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

blacklist ~/.bashrc
blacklist ~/.Xauthority

caps.drop all
net none
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin viewnior
private-dev
private-etc fonts
private-tmp
