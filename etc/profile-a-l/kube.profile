# Firejail profile for kube
# Description: Qt mail client
# This file is overwritten after every install/update
# Persistent local customizations
include kube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/kube
noblacklist ${HOME}/.config/kube
noblacklist ${HOME}/.config/sink
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/kube
noblacklist ${HOME}/.local/share/sink

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.cache/kube
mkdir ${HOME}/.config/kube
mkdir ${HOME}/.config/sink
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.local/share/kube
mkdir ${HOME}/.local/share/sink
whitelist ${HOME}/.cache/kube
whitelist ${HOME}/.config/kube
whitelist ${HOME}/.config/sink
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.local/share/kube
whitelist ${HOME}/.local/share/sink
whitelist ${RUNUSER}/gnupg
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/kube
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

#disable-mnt
# Add "gpg,gpg2,gpg-agent,pinentry-curses,pinentry-emacs,pinentry-fltk,pinentry-gnome3,pinentry-gtk,pinentry-gtk2,pinentry-gtk-2,pinentry-qt,pinentry-qt4,pinentry-tty,pinentry-x2go,pinentry-kwallet" for gpg
private-bin kube,sink_synchronizer
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp
writable-run-user

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.freedesktop.Notifications
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*
dbus-system none

restrict-namespaces
