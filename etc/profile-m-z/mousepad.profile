# Firejail profile for mousepad
# Description: Simple Xfce oriented text editor
# This file is overwritten after every install/update
# Persistent local customizations
include mousepad.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Mousepad

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
tracelog

private-bin mousepad
private-dev
private-lib
private-tmp
