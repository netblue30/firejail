# Firejail profile for uget-gtk
# This file is overwritten after every install/update
# Persistent local customizations
include uget-gtk.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/uGet

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.config/uGet
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/uGet
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-bin uget-gtk
private-dev
private-tmp

restrict-namespaces
