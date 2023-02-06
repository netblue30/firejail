# Firejail profile for email-common
# Description: Common profile for GUI mail clients
# This file is overwritten after every install/update
# Persistent local customizations
include email-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.signature
# when storing mail outside the default ${HOME}/Mail path, 'noblacklist' the custom path in your email-common.local
# and 'blacklist' it in your disable-common.local too so it is kept hidden from other applications
noblacklist ${HOME}/Mail
noblacklist /var/mail
noblacklist /var/spool/mail

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.gnupg
mkfile ${HOME}/.config/mimeapps.list
mkfile ${HOME}/.signature
whitelist ${HOME}/.config/mimeapps.list
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.signature
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
# when storing mail outside the default ${HOME}/Mail path, 'whitelist' the custom path in your email-common.local
whitelist ${HOME}/Mail
whitelist ${RUNUSER}/gnupg
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
tracelog

# disable-mnt
private-cache
private-dev
private-etc @tls-ca,@x11,gnupg,hosts.conf,mailname,selinux,timezone
private-tmp
# encrypting and signing email
writable-run-user
writable-var

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.*
dbus-user.talk org.gnome.seahorse.*
dbus-user.talk org.mozilla.*
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.signature
restrict-namespaces
