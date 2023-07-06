# Firejail profile for leafpad
# Description: GTK-based simple text editor
# This file is overwritten after every install/update
# Persistent local customizations
include leafpad.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/leafpad

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
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

private-bin leafpad
private-dev
private-lib
private-tmp

restrict-namespaces
