# Firejail profile for xfce4-notes
# Description: Notes application for the Xfce4 desktop
# This file is overwritten after every install/update
# Persistent local customizations
include xfce4-notes.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/xfce4/xfce4-notes.gtkrc
nodeny  ${HOME}/.config/xfce4/xfce4-notes.rc
nodeny  ${HOME}/.local/share/notes

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
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

