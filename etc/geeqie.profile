# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/geeqie.local

# Firejail profile for Geeqie
noblacklist ~/.config/geeqie
noblacklist ~/.local/share/geeqie
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix
seccomp
nosound

private-dev

#Experimental:
shell none
#private-bin geeqie
#private-etc X11
