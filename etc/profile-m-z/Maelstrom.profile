# Firejail profile for Maelstrom
# Description: A space combat game
# This file is overwritten after every install/update
# Persistent local customizations
include Maelstrom.local
# Persistent global definitions
include globals.local

nodeny  /var/lib/games/Maelstrom-Scores

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

allow  /var/lib/games
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
#nonewprivs
#noroot
notv
nou2f
novideo
#protocol unix
#seccomp
shell none
tracelog

disable-mnt
private-bin Maelstrom
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
