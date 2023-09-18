# Firejail profile for gwenview
# Description: Image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gwenview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.config/gwenviewrc
noblacklist ${HOME}/.config/org.kde.gwenviewrc
noblacklist ${HOME}/.gimp*
noblacklist ${HOME}/.kde/share/apps/gwenview
noblacklist ${HOME}/.kde/share/config/gwenviewrc
noblacklist ${HOME}/.kde4/share/apps/gwenview
noblacklist ${HOME}/.kde4/share/config/gwenviewrc
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.local/share/gwenview
noblacklist ${HOME}/.local/share/kxmlgui5/gwenview
noblacklist ${HOME}/.local/share/org.kde.gwenview

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#net none
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
#tracelog

private-bin gimp*,gwenview,kbuildsycoca4,kdeinit4
private-dev
private-etc @x11,gimp

#dbus-user none
#dbus-system none

#memory-deny-write-execute
restrict-namespaces
