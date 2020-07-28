# Firejail profile for globaltime
# This file is overwritten after every install/update
# Persistent local customizations
include globaltime.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/globaltime

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-cache
private-dev
private-tmp

