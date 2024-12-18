# Firejail profile for krita
# Description: Pixel-based image manipulation program
# This file is overwritten after every install/update
# Persistent local customizations
include krita.local
# Persistent global definitions
include globals.local

# noexec ${HOME} may break krita, see issue #1953
ignore noexec ${HOME}

noblacklist ${HOME}/.config/kritarc
noblacklist ${HOME}/.local/share/krita
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
#net none
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
protocol unix
seccomp

private-cache
private-dev
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
