# Firejail profile for kopete
# Description: Instant messaging and chat application
# This file is overwritten after every install/update
# Persistent local customizations
include kopete.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kde/share/apps/kopete
noblacklist ${HOME}/.kde/share/config/kopeterc
noblacklist ${HOME}/.kde4/share/apps/kopete
noblacklist ${HOME}/.kde4/share/config/kopeterc
noblacklist ${HOME}/.local/share/kxmlgui5/kopete

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /var/lib/winpopup
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
protocol unix,inet,inet6,netlink
seccomp

private-dev
private-tmp
writable-var

restrict-namespaces
