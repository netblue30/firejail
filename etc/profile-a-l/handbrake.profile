# Firejail profile for handbrake
# Description: Versatile DVD ripper and video transcoder (GTK+ GUI)
# This file is overwritten after every install/update
# Persistent local customizations
include handbrake.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ghb
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
nogroups
noinput
nonewprivs
noroot
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

dbus-user none
dbus-system none
