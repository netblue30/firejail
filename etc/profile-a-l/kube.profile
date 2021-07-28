# Firejail profile for kube
# Description: Qt mail client
# This file is overwritten after every install/update
# Persistent local customizations
include kube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.cache/kube
noblacklist ${HOME}/.config/kube
noblacklist ${HOME}/.config/sink
noblacklist ${HOME}/.local/share/kube
noblacklist ${HOME}/.local/share/sink

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.gnupg
mkdir ${HOME}/.cache/kube
mkdir ${HOME}/.config/kube
mkdir ${HOME}/.config/sink
mkdir ${HOME}/.local/share/kube
mkdir ${HOME}/.local/share/sink
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${HOME}/.cache/kube
whitelist ${HOME}/.config/kube
whitelist ${HOME}/.config/sink
whitelist ${HOME}/.local/share/kube
whitelist ${HOME}/.local/share/sink
whitelist ${RUNUSER}/gnupg
whitelist /usr/share/kube
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
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
shell none
tracelog

# disable-mnt
# Add "gpg,gpg2,gpg-agent,pinentry-curses,pinentry-emacs,pinentry-fltk,pinentry-gnome3,pinentry-gtk,pinentry-gtk2,pinentry-gtk-2,pinentry-qt,pinentry-qt4,pinentry-tty,pinentry-x2go,pinentry-kwallet" for gpg
# Add "ignore private-bin" for hyperlinks or have a look at the private-bins in firefox.profile and firefox-common.profile.
private-bin kube,sink_synchronizer
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,gcrypt,gtk-2.0,gtk-3.0,hostname,hosts,pki,resolv.conf,selinux,ssl,xdg
private-tmp
writable-run-user

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.freedesktop.Notifications
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini
