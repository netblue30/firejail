# Firejail profile for calibre
# Description: Powerful and easy to use e-book manager
# This file is overwritten after every install/update
# Persistent local customizations
include calibre.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/calibre
noblacklist ${HOME}/.config/calibre
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
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
protocol unix,inet,inet6,netlink
seccomp !chroot

private-dev
private-tmp

#restrict-namespaces
