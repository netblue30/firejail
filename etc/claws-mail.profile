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
# when storing mail outside the default ${HOME}/Mail path, 'noblacklist' the custom path in your claws-mail.local
# and 'blacklist' it in your disable-common.local too so it is  kept hidden from other applications
noblacklist ${HOME}/Mail

noblacklist ${DOCUMENTS}
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/doc/claws-mail
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
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
