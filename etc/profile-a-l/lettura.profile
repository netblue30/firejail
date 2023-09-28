# Firejail profile for lettura
# Description: Another free and open-source feed reader
# This file is overwritten after every install/update
# Persistent local customizations
include lettura.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/lettura
noblacklist ${HOME}/.config/com.lettura.dev
noblacklist ${HOME}/.lettura
noblacklist ${HOME}/.local/share/com.lettura.dev

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/lettura
mkdir ${HOME}/.config/com.lettura.dev
mkdir ${HOME}/.lettura
mkdir ${HOME}/.local/share/com.lettura.dev
whitelist ${HOME}/.cache/lettura
whitelist ${HOME}/.config/com.lettura.dev
whitelist ${HOME}/.lettura
whitelist ${HOME}/.local/share/com.lettura.dev
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
#nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin lettura
private-cache
private-dev
private-etc @network,@sound,@tls-ca,@x11,mime.types
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*
dbus-system none

restrict-namespaces
