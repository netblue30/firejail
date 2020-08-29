# Firejail profile for kmail
# Description: Full featured graphical email client
# This file is overwritten after every install/update
# Persistent local customizations
include kmail.local
# Persistent global definitions
include globals.local

# kmail has problems launching akonadi in debian and ubuntu.
# one solution is to have akonadi already running when kmail is started

noblacklist ${HOME}/.gnupg
# noblacklist ${HOME}/.kde/
# noblacklist ${HOME}/.kde4/
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.cache/akonadi*
noblacklist ${HOME}/.cache/kmail2
noblacklist ${HOME}/.config/akonadi*
noblacklist ${HOME}/.config/baloorc
noblacklist ${HOME}/.config/emaildefaults
noblacklist ${HOME}/.config/emailidentities
noblacklist ${HOME}/.config/kmail2rc
noblacklist ${HOME}/.config/kmailsearchindexingrc
noblacklist ${HOME}/.config/mailtransports
noblacklist ${HOME}/.config/specialmailcollectionsrc
noblacklist ${HOME}/.local/share/akonadi*
noblacklist ${HOME}/.local/share/apps/korganizer
noblacklist ${HOME}/.local/share/contacts
noblacklist ${HOME}/.local/share/emailidentities
noblacklist ${HOME}/.local/share/kmail2
noblacklist ${HOME}/.local/share/kxmlgui5/kmail
noblacklist ${HOME}/.local/share/kxmlgui5/kmail2
noblacklist ${HOME}/.local/share/local-mail
noblacklist ${HOME}/.local/share/notes
noblacklist /tmp/akonadi-*
noblacklist /var/mail
noblacklist /var/spool/mail

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.gnupg
# mkdir ${HOME}/.kde/
# mkdir ${HOME}/.kde4/
mkdir ${HOME}/.cache/akonadi*
mkdir ${HOME}/.cache/kmail2
mkdir ${HOME}/.config/akonadi*
mkdir ${HOME}/.config/baloorc
mkdir ${HOME}/.config/emaildefaults
mkdir ${HOME}/.config/emailidentities
mkdir ${HOME}/.config/kmail2rc
mkdir ${HOME}/.config/kmailsearchindexingrc
mkdir ${HOME}/.config/mailtransports
mkdir ${HOME}/.config/specialmailcollectionsrc
mkdir ${HOME}/.local/share/akonadi*
mkdir ${HOME}/.local/share/apps/korganizer
mkdir ${HOME}/.local/share/contacts
mkdir ${HOME}/.local/share/emailidentities
mkdir ${HOME}/.local/share/kmail2
mkdir ${HOME}/.local/share/kxmlgui5/kmail
mkdir ${HOME}/.local/share/kxmlgui5/kmail2
mkdir ${HOME}/.local/share/local-mail
mkdir ${HOME}/.local/share/notes
mkdir /tmp/akonadi-*
whitelist ${HOME}/.gnupg
# whitelist ${HOME}/.kde/
# whitelist ${HOME}/.kde4/
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${HOME}/.cache/akonadi*
whitelist ${HOME}/.cache/kmail2
whitelist ${HOME}/.config/akonadi*
whitelist ${HOME}/.config/baloorc
whitelist ${HOME}/.config/emaildefaults
whitelist ${HOME}/.config/emailidentities
whitelist ${HOME}/.config/kmail2rc
whitelist ${HOME}/.config/kmailsearchindexingrc
whitelist ${HOME}/.config/mailtransports
whitelist ${HOME}/.config/specialmailcollectionsrc
whitelist ${HOME}/.local/share/akonadi*
whitelist ${HOME}/.local/share/apps/korganizer
whitelist ${HOME}/.local/share/contacts
whitelist ${HOME}/.local/share/emailidentities
whitelist ${HOME}/.local/share/kmail2
whitelist ${HOME}/.local/share/kxmlgui5/kmail
whitelist ${HOME}/.local/share/kxmlgui5/kmail2
whitelist ${HOME}/.local/share/local-mail
whitelist ${HOME}/.local/share/notes
whitelist ${DOWNLOADS}
whitelist ${DOCUMENTS}
whitelist ${RUNUSER}/gnupg
whitelist /tmp/akonadi-*
whitelist /usr/share/akonadi
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/kconf_update
whitelist /usr/share/kf5
whitelist /usr/share/kservices5
whitelist /usr/share/qlogging-categories5
whitelist /var/mail
whitelist /var/spool/mail
include whitelist-common.inc
include whitelist-runnuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
# we need to allow chroot, io_getevents, ioprio_set, io_setup, io_submit system calls
seccomp !chroot,!io_getevents,!io_setup,!io_submit,!ioprio_set
# tracelog

private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,drirc,fonts,gcrypt,gtk-2.0,gtk-3.0,groups,hostname,hosts,ld.so.preload,ld.so.cache,mailname,nsswitch.conf,passwd,pki,resolv.conf,selinux,ssl,xdg
# private-tmp - interrupts connection to akonadi, breaks opening of email attachments
writable-run-user
writable-var

# dbus-user none
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini