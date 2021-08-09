# Firejail profile for qlipper
# Description: Lightweight and cross-platform clipboard history applet
# This file is overwritten after every install/update
# Persistent local customizations
include qlipper.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Qlipper

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

