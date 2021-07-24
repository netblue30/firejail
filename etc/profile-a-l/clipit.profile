# Firejail profile for clipit
# Description: Lightweight GTK+ clipboard manager
# This file is overwritten after every install/update
# Persistent local customizations
include clipit.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/clipit
nodeny  ${HOME}/.local/share/clipit

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/clipit
mkdir ${HOME}/.local/share/clipit
allow  ${HOME}/.config/clipit
allow  ${HOME}/.local/share/clipit
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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
shell none

disable-mnt
private-cache
private-dev
private-tmp

