# Firejail profile for email-common
# Description: Common profile for GUI mail clients
# This file is overwritten after every install/update
# Persistent local customizations
include email-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.bsfilter
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.signature
# when storing mail outside the default ${HOME}/Mail path, 'noblacklist' the custom path in your email-common.local
# and 'blacklist' it in your disable-common.local too so it is kept hidden from other applications
noblacklist ${HOME}/Mail
noblacklist /etc/clamav
noblacklist /var/lib/clamav
noblacklist /var/mail
noblacklist /var/spool/mail

noblacklist ${DOCUMENTS}

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.gnupg
mkfile ${HOME}/.config/mimeapps.list
mkfile ${HOME}/.signature
whitelist ${HOME}/.bogofilter
whitelist ${HOME}/.bsfilter
whitelist ${HOME}/.config/mimeapps.list
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.signature
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
# when storing mail outside the default ${HOME}/Mail path, 'whitelist' the custom path in your email-common.local
whitelist ${HOME}/Mail
whitelist ${RUNUSER}/gnupg
whitelist /usr/share/bogofilter
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /var/lib/clamav
whitelist /var/mail
whitelist /var/spool/mail
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# encrypting and signing email
writable-run-user
writable-var

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

#disable-mnt
private-cache
private-dev
private-etc @tls-ca,@x11,bogofilter,bogofilter.cf,clamav,gnupg,hosts.conf,mailname,timezone
private-tmp

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.*
dbus-user.talk org.gnome.seahorse.*
# Allow D-Bus communication with Firefox for opening links
dbus-user.talk org.mozilla.*
dbus-system none

read-only ${HOME}/.signature
restrict-namespaces
