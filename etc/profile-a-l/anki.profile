# Firejail profile for anki
# Description: flexible, intelligent flashcard program
# This file is overwritten after every install/update
# Persistent local customizations
include anki.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.local/share/Anki2

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/Anki2
whitelist ${DOCUMENTS}
whitelist ${HOME}/.local/share/Anki2
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
protocol unix,inet,inet6
# QtWebengine needs chroot to set up its own sandbox
seccomp !chroot

disable-mnt
private-bin anki,python*
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
