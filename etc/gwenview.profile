# Firejail profile for gwenview
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gwenview.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.config/gwenviewrc
noblacklist ${HOME}/.config/org.kde.gwenviewrc
noblacklist ${HOME}/.gimp*
noblacklist ${HOME}/.kde/share/apps/gwenview
noblacklist ${HOME}/.kde/share/config/gwenviewrc
noblacklist ${HOME}/.kde4/share/apps/gwenview
noblacklist ${HOME}/.kde4/share/config/gwenviewrc
noblacklist ${HOME}/.local/share/gwenview
noblacklist ${HOME}/.local/share/org.kde.gwenview

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
# net none
# nodbus
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

private-bin gwenview,gimp*,kbuildsycoca4,kdeinit4
private-dev
private-etc fonts,gimp,gtk-2.0,kde4rc,kde5rc,ld.so.cache,machine-id,pulse,xdg

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
