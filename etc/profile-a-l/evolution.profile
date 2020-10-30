# Firejail profile for evolution
# Description: Groupware suite with mail client and organizer
# This file is overwritten after every install/update
# Persistent local customizations
include evolution.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.cache/evolution
noblacklist ${HOME}/.config/evolution
noblacklist ${HOME}/.local/share/evolution
noblacklist ${HOME}/.local/share/pki
noblacklist /var/mail
noblacklist /var/spool/mail

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.bogofilter
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.pki
mkdir ${HOME}/.cache/evolution
mkdir ${HOME}/.config/evolution
mkdir ${HOME}/.local/share/evolution
mkdir ${HOME}/.local/share/pki
whitelist ${HOME}/.bogofilter
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${HOME}/.pki
whitelist ${HOME}/.cache/evolution
whitelist ${HOME}/.config/evolution
whitelist ${HOME}/.local/share/evolution
whitelist ${HOME}/.local/share/pki
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${RUNUSER}/gnupg
whitelist /usr/share/evolution
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /var/mail
whitelist /var/spool/mail
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# no3d breaks under wayland
# no3d
nodvd
nogroups
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
# To use private-bin add all evolution,gpg,pinentry binaries and follow firefox.profile for hyperlink support
# private-bin evolution
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,groups,gtk-2.0,gtk-3.0,hostname,hosts,mailname,passwd,pki,resolv.conf,selinux,ssl,xdg
private-tmp
writable-run-user
writable-var

dbus-user filter
dbus-user.own org.gnome.Evolution
dbus-user.talk ca.desrt.dconf
# Uncomment to have keyring access
# dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.SystemPrompter
dbus-user.talk org.gnome.OnlineAccounts
dbus-user.talk org.freedesktop.Notifications
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini
