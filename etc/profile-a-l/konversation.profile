# Firejail profile for konversation
# Description: User friendly Internet Relay Chat (IRC) client for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include konversation.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/konversationrc
noblacklist ${HOME}/.config/konversation.notifyrc
noblacklist ${HOME}/.kde/share/config/konversationrc
noblacklist ${HOME}/.kde4/share/config/konversationrc
noblacklist ${HOME}/.local/share/kxmlgui5/konversation

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

private-bin kbuildsycoca4,konversation
private-cache
private-dev
private-tmp

#memory-deny-write-execute
restrict-namespaces
