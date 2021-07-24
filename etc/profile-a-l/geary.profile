# Firejail profile for geary
# Description: Lightweight email client designed for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include geary.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/evolution
nodeny  ${HOME}/.cache/folks
nodeny  ${HOME}/.cache/geary
nodeny  ${HOME}/.config/evolution
nodeny  ${HOME}/.config/geary
nodeny  ${HOME}/.local/share/evolution
nodeny  ${HOME}/.local/share/geary
nodeny  ${HOME}/.mozilla

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/evolution
mkdir ${HOME}/.cache/folks
mkdir ${HOME}/.cache/geary
mkdir ${HOME}/.config/evolution
mkdir ${HOME}/.config/geary
mkdir ${HOME}/.local/share/evolution
mkdir ${HOME}/.local/share/geary
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/evolution
allow  ${HOME}/.cache/folks
allow  ${HOME}/.cache/geary
allow  ${HOME}/.config/evolution
allow  ${HOME}/.config/geary
allow  ${HOME}/.local/share/evolution
allow  ${HOME}/.local/share/geary
allow  ${HOME}/.mozilla/firefox/profiles.ini
allow  /usr/share/geary
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
seccomp.block-secondary
shell none
tracelog

# disable-mnt
# Add 'ignore private-bin' to geary.local for hyperlink support
private-bin geary
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,hostname,hosts,pki,resolv.conf,ssl,xdg
private-tmp

dbus-user filter
dbus-user.own org.gnome.Geary
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.Contacts
dbus-user.talk org.gnome.OnlineAccounts
dbus-user.talk org.gnome.evolution.dataserver.AddressBook10
dbus-user.talk org.gnome.evolution.dataserver.Sources5
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini
