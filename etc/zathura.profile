# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/zathura.local

# zathura document viewer profile
noblacklist ~/.config/zathura
noblacklist ~/.local/share/zathura
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
net none
nogroups
nonewprivs
noroot
nosound
shell none
seccomp
protocol unix

private-bin zathura
private-dev
private-etc fonts
private-tmp

read-only ~/
read-write ~/.local/share/zathura/
