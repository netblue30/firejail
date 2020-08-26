# Firejail profile for balsa
# Description: GNOME mail client
# This file is overwritten after every install/update
# Persistent local customizations
include balsa.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.balsa
# Comment to use GPG
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/mail
noblacklist /var/spool/mail

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Uncomment to allow gpg
# whitelist ${RUNUSER}/gnupg
whitelist /usr/share/balsa
# Uncomment to allow gpg
# whitelist /usr/share/gnupg
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

disable-mnt
# Add gpg,gpg2,gpgsm,gpgconf,pinentry to allow gpg
private-bin balsa,balsa-ab
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,gtk-2.0,gtk-3.0,groups,hostname,hosts,mailname,passwd,pki,resolv.conf,selinux,ssl,xdg
private-tmp
writable-var

dbus-user filter
dbus-user.own org.desktop.Balsa
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.freedesktop.Notifications
dbus-system none

# Comment to use gpg
read-only ${HOME}/.gnupg
