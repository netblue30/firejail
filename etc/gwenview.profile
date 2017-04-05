# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gwenview.local

# KDE gwenview profile
noblacklist ~/.kde4/share/apps/gwenview
noblacklist ~/.kde4/share/config/gwenviewrc
noblacklist ~/.kde/share/apps/gwenview
noblacklist ~/.kde/share/config/gwenviewrc
noblacklist ~/.config/gwenviewrc
noblacklist ~/.config/org.kde.gwenviewrc
noblacklist ~/.local/share/org.kde.gwenview
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
tracelog

private-dev

# Experimental:
#shell none
#private-bin gwenview,kbuildsycoca4,gimp,gimp-2.8
#private-etc X11
