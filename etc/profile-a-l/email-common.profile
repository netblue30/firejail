# Firejail profile for email-common
# Description: Common profile for claws-mail and sylpheed email clients
# This file is overwritten after every install/update
# Persistent local customizations
include email-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.mozilla
nodeny  ${HOME}/.signature
# when storing mail outside the default ${HOME}/Mail path, 'noblacklist' the custom path in your email-common.local
# and 'blacklist' it in your disable-common.local too so it is  kept hidden from other applications
nodeny  ${HOME}/Mail

nodeny  ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.gnupg
mkfile ${HOME}/.config/mimeapps.list
mkfile ${HOME}/.signature
allow  ${HOME}/.config/mimeapps.list
allow  ${HOME}/.mozilla/firefox/profiles.ini
allow  ${HOME}/.gnupg
allow  ${HOME}/.signature
allow  ${DOCUMENTS}
allow  ${DOWNLOADS}
# when storing mail outside the default ${HOME}/Mail path, 'whitelist' the custom path in your email-common.local
allow  ${HOME}/Mail
allow  ${RUNUSER}/gnupg
allow  /usr/share/gnupg
allow  /usr/share/gnupg2
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
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,gnupg,groups,gtk-2.0,gtk-3.0,hostname,hosts,hosts.conf,mailname,nsswitch.conf,passwd,pki,resolv.conf,selinux,ssl,xdg
private-tmp
# encrypting and signing email
writable-run-user

dbus-system none

# If you want to read local mail stored in /var/mail, add the following to email-common.local:
#noblacklist /var/mail
#noblacklist /var/spool/mail
#whitelist /var/mail
#whitelist /var/spool/mail
#writable-var

read-only ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.signature
