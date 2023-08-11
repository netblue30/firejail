# Firejail profile for mpv
# Description: Graphical audio CD ripper and encoder
# This file is overwritten after every install/update
# Persistent local customizations
include sound-juicer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/sound-juicer
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nogroups
noinput
nonewprivs
noroot
nosound
nou2f
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

private-cache
private-dev
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
