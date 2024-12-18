# Firejail profile for audacious
# Description: Small and fast audio player which supports lots of formats
# This file is overwritten after every install/update
# Persistent local customizations
include audacious.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Audaciousrc
noblacklist ${HOME}/.config/audacious
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

#private-bin audacious
private-cache
private-dev
private-tmp

dbus-user filter
dbus-user.own org.atheme.audacious
dbus-user.own org.mpris.MediaPlayer2.audacious
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.gtk.vfs.UDisks2VolumeMonitor
dbus-user.talk org.mpris.MediaPlayer2.Player
dbus-system none

restrict-namespaces
