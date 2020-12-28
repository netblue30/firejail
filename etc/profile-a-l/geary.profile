# Firejail profile for geary
# Description: Lightweight email client designed for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include geary.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/geary
noblacklist ${HOME}/.config/geary
noblacklist ${HOME}/.local/share/geary
noblacklist ${HOME}/.mozilla

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/geary
mkdir ${HOME}/.config/geary
mkdir ${HOME}/.local/share/geary
whitelist ${HOME}/.cache/geary
whitelist ${HOME}/.config/geary
whitelist ${HOME}/.local/share/geary
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${DOWNLOADS}
whitelist /usr/share/geary
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
# Add ignore private-bin to geary.local for hyperlink support
private-bin geary
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,hostname,hosts,pki,resolv.conf,selinux,ssl,xdg
private-tmp

dbus-user filter
dbus-user.own org.gnome.Geary
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.secrets
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini
