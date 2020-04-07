# Firejail profile for supertux2
# Description: Jump'n run like game
# This file is overwritten after every install/update
# Persistent local customizations
include supertux2.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/supertux2

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.local/share/supertux2
whitelist ${HOME}/.local/share/supertux2
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none

disable-mnt
# private-bin supertux2
private-dev
private-tmp

dbus-user none
dbus-system none
