# Firejail profile for ballbuster
# Description: Move the paddle to bounce the ball and break all the bricks
# This file is overwritten after every install/update
# Persistent local customizations
include ballbuster.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.ballbuster.hs

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/.ballbuster.hs
whitelist ${HOME}/.ballbuster.hs
whitelist /usr/share/ballbuster
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
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
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin ballbuster
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
