# Firejail profile for caja
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/caja.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/caja
noblacklist ~/.local/share/Trash
noblacklist ~/.local/share/caja-python

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix
seccomp
shell none
tracelog

# private-bin caja
# private-dev
# private-etc fonts
# private-tmp

# CLOBBERED COMMENTS
# Caja is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# caja needs to be able to start arbitrary applications so we cannot blacklist their files
# is already a caja process running on MATE desktops firejail will have no effect.
