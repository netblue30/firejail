# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/nautilus.local

# nautilus profile

# Nautilus is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# is already a nautilus process running on gnome desktops firejail will have no effect.

noblacklist ~/.config/nautilus
noblacklist ~/.local/share/nautilus
noblacklist ~/.local/share/nautilus-python
noblacklist ~/.local/share/Trash

include /etc/firejail/disable-common.inc
# nautilus needs to be able to start arbitrary applications so we cannot blacklist their files
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

# private-bin nautilus
# private-tmp
# private-dev
# private-etc fonts
