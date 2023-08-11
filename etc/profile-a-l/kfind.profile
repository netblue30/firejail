# Firejail profile for kfind
# Description: File search utility
# This file is overwritten after every install/update
# Persistent local customizations
include kfind.local
# Persistent global definitions
include globals.local

# searching in blacklisted or masked paths fails silently
# adjust filesystem restrictions as necessary

#noblacklist ${HOME}/.cache/kfind # disable-programs.inc is disabled, see below
#noblacklist ${HOME}/.config/kfindrc
#noblacklist ${HOME}/.kde/share/config/kfindrc
#noblacklist ${HOME}/.kde4/share/config/kfindrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
#include disable-programs.inc

apparmor
caps.drop all
machine-id
#net none
netfilter
no3d
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

#private-bin kbuildsycoca4,kdeinit4,kfind
private-dev
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
