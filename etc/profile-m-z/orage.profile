# Firejail profile for orage
# Description: Calendar for Xfce Desktop Environment
# This file is overwritten after every install/update
# Persistent local customizations
include orage.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/orage
noblacklist ${HOME}/.local/share/orage

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
#nosound # calendar application, It must be able to play sound to wake you up.
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
