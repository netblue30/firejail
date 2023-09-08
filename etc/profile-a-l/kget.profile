# Firejail profile for kget
# Description: Download manager
# This file is overwritten after every install/update
# Persistent local customizations
include kget.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kgetrc
noblacklist ${HOME}/.kde/share/apps/kget
noblacklist ${HOME}/.kde/share/config/kgetrc
noblacklist ${HOME}/.kde4/share/apps/kget
noblacklist ${HOME}/.kde4/share/config/kgetrc
noblacklist ${HOME}/.local/share/kget
noblacklist ${HOME}/.local/share/kxmlgui5/kget

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
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

private-dev
private-tmp

#memory-deny-write-execute
restrict-namespaces
