# Firejail profile for gthumb
# Description: Image viewer and browser
# This file is overwritten after every install/update
# Persistent local customizations
include gthumb.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gthumb
noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

caps.drop all
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
tracelog

private-bin gthumb
private-cache
private-dev
private-tmp
