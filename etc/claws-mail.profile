# Firejail profile for claws-mail
# Description: Fast, lightweight and user-friendly GTK+2 based email client
# This file is overwritten after every install/update
# Persistent local customizations
include claws-mail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.claws-mail
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.signature

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/ca-certificates
whitelist /usr/share/doc
include whitelist-usr-share-common.inc

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

private-cache
private-dev
private-tmp

# If you want to read local mail stored in /var/mail, add the following to claws-mail.local:
# noblacklist /var/mail
# noblacklist /var/spool/mail
# writable-var
