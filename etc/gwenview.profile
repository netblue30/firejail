# Persistent global definitions go here
include /etc/firejail/globals.local

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
noblacklist ~/.local/share/gwenview
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
shell none
tracelog

private-bin gwenview,kbuildsycoca4,gimp,gimp-2.8
private-dev

# Experimental:
#private-etc X11

noexec ${HOME}
noexec /tmp
