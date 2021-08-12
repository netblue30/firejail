# Firejail profile for dosbox
# Description: x86 emulator with Tandy/Herc/CGA/EGA/VGA/SVGA graphics, sound and DOS
# This file is overwritten after every install/update
# Persistent local customizations
include dosbox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.dosbox
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin dosbox
private-dev
private-tmp

dbus-user none
dbus-system none
