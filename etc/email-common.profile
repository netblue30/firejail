# Firejail profile for email-common
# Description: Common profile for claws-mail and sylpheed email clients
# This file is overwritten after every install/update
# Persistent local customizations
include email-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.signature
# when storing mail outside the default ${HOME}/Mail path, 'noblacklist' the custom path in your email-common.local
# and 'blacklist' it in your disable-common.local too so it is  kept hidden from other applications
noblacklist ${HOME}/Mail

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${DOWNLOADS}
mkfile ${HOME}/.config/mimeapps.list
mkdir ${HOME}/.gnupg
mkfile ${HOME}/.signature
whitelist ${HOME}/.config/mimeapps.list
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.signature
# when storing mail outside the default ${HOME}/Mail path, 'whitelist' the custom path in your email-common.local
whitelist ${HOME}/Mail
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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

private-cache
private-dev
private-tmp

# encrypting and signing email
read-only ${HOME}/.config/mimeapps.list
writable-run-user

# If you want to read local mail stored in /var/mail, add the following to email-common.local:
# whitelist /var/mail
# whitelist /var/spool/mail
# writable-var
