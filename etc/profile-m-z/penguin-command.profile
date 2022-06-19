# Firejail profile for open-invaders
# Description: Space Invaders clone
# This file is overwritten after every install/update
# Persistent local customizations
include penguin-command.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.penguin-command

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

whitelist ${HOME}/.penguin-command
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp

private-bin penguin-command
private-dev
private-tmp

dbus-user none
dbus-system none
