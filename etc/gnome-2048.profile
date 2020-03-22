# Firejail profile for gnome-2048
# Description: Sliding tile puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-2048.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/gnome-2048

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

mkdir ${HOME}/.local/share/gnome-2048
whitelist ${HOME}/.local/share/gnome-2048
include whitelist-common.inc

apparmor
caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-tmp

