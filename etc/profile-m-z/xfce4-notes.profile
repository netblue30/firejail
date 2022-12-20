# Firejail profile for xfce4-notes
# Description: Notes application for the Xfce4 desktop
# This file is overwritten after every install/update
# Persistent local customizations
include xfce4-notes.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xfce4/xfce4-notes.gtkrc
noblacklist ${HOME}/.config/xfce4/xfce4-notes.rc
noblacklist ${HOME}/.local/share/notes

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
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

disable-mnt
private-cache
private-dev
private-tmp

restrict-namespaces
