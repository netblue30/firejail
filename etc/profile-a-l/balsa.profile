# Firejail profile for balsa
# Description: GNOME mail client
# This file is overwritten after every install/update
# Persistent local customizations
include balsa.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.balsa
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.mozilla
nodeny  ${HOME}/.signature
nodeny  ${HOME}/mail
nodeny  /var/mail
nodeny  /var/spool/mail

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.balsa
mkdir ${HOME}/.gnupg
mkfile ${HOME}/.signature
mkdir ${HOME}/mail
allow  ${HOME}/.balsa
allow  ${HOME}/.gnupg
allow  ${HOME}/.mozilla/firefox/profiles.ini
allow  ${HOME}/.signature
allow  ${HOME}/mail
allow  ${RUNUSER}/gnupg
allow  /usr/share/balsa
allow  /usr/share/gnupg
allow  /usr/share/gnupg2
allow  /var/mail
allow  /var/spool/mail
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
# Add "pinentry-curses,pinentry-emacs,pinentry-fltk,pinentry-gnome3,pinentry-gtk,pinentry-gtk2,pinentry-gtk-2,pinentry-qt,pinentry-qt4,pinentry-tty,pinentry-x2go,pinentry-kwallet" for gpg
# Add "ignore private-bin" for hyperlinks or have a look at the private-bins in firefox.profile and firefox-common.profile.
private-bin balsa,balsa-ab,gpg,gpg-agent,gpg2,gpgsm
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,groups,gtk-2.0,gtk-3.0,hostname,hosts,mailname,passwd,pki,resolv.conf,selinux,ssl,xdg
private-tmp
writable-run-user
writable-var

dbus-user filter
dbus-user.own org.desktop.Balsa
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.SystemPrompter
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini