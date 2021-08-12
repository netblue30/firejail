# Firejail profile for vym
# Description: Mindmapping tool
# This file is overwritten after every install/update
# Persistent local customizations
include vym.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/InSilmaril

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

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
private-dev
private-tmp

