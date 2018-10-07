# Firejail profile for nylas
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/nylas.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Nylas Mail
noblacklist ${HOME}/.nylas-mail

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Nylas Mail
whitelist ${HOME}/.nylas-mail
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
