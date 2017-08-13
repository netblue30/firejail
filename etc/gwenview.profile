# Firejail profile for gwenview
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gwenview.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/gwenviewrc
noblacklist ~/.config/org.kde.gwenviewrc
noblacklist ~/.kde/share/apps/gwenview
noblacklist ~/.kde/share/config/gwenviewrc
noblacklist ~/.kde4/share/apps/gwenview
noblacklist ~/.kde4/share/config/gwenviewrc
noblacklist ~/.local/share/gwenview
noblacklist ~/.local/share/org.kde.gwenview

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin gwenview,kbuildsycoca4,gimp,gimp-2.8
private-dev
# private-etc X11

noexec ${HOME}
noexec /tmp
