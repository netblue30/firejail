# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/caja.local

# Caja profile for Firejail

# Caja is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# is already a caja process running on MATE desktops firejail will have no effect.

noblacklist ~/.config/caja
noblacklist ~/.local/share/caja-python
noblacklist ~/.local/share/Trash

include /etc/firejail/disable-common.inc
# caja needs to be able to start arbitrary applications so we cannot blacklist their files
#include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin caja
# private-tmp
# private-dev
# private-etc fonts
