# Firejail profile for konversation
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/konversation.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/konversationrc
noblacklist ${HOME}/.kde/share/config/konversationrc
noblacklist ${HOME}/.kde4/share/config/konversationrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin konversation,kbuildsycoca4
private-dev
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
