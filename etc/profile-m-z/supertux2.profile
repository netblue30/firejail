# Firejail profile for supertux2
# Description: Jump'n run like game
# This file is overwritten after every install/update
# Persistent local customizations
include supertux2.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/supertux2

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/supertux2
allow  ${HOME}/.local/share/supertux2
allow  /usr/share/supertux2
allow  /usr/share/games/supertux2	# Debian version
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
protocol unix,netlink
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
# private-bin supertux2
private-cache
private-etc machine-id
private-dev
private-tmp

dbus-user none
dbus-system none
