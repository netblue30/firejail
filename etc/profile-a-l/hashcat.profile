# Firejail profile for hashcat
# Description: World's fastest and most advanced password recovery utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include hashcat.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

noblacklist ${HOME}/.hashcat
noblacklist /usr/include
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
x11 none

disable-mnt
private-bin hashcat
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
