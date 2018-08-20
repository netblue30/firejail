# Firejail profile for claws-mail
# Description: Fast, lightweight and user-friendly GTK+2 based email client
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/claws-mail.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.claws-mail
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.signature

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

# If you want to read local mail stored in /var/mail, add the following to claws-mail.local:
# noblacklist /var/mail
# noblacklist /var/spool/mail
# writable-var
