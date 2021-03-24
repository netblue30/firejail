# Firejail profile for amarok
# Description: Easy to use media player based on the KDE Platform
# This file is overwritten after every install/update
# Persistent local customizations
include amarok.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# seccomp
shell none

# private-bin amarok
private-dev
# private-etc alternatives,asound.conf,ca-certificates,crypto-policies,machine-id,pki,pulse,ssl
private-tmp

# If you ain't on kde-plasma you need to uncomment the following
dbus-user filter
dbus-user.own org.kde.amarok
#dbus-user.own org.kde.kded
#dbus-user.own org.kde.klauncher
# The following one is needed for keyboard shortcuts even on kde. 
#dbus-user.own org.kde.kglobalaccel
dbus-user.own org.mpris.amarok
dbus-user.own org.mpris.MediaPlayer2.amarok
dbus-user.talk org.freedesktop.Notifications
#dbus-user.talk org.kde.knotify
dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none
