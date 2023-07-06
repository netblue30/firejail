# Firejail profile for pix
# This file is overwritten after every install/update
# Persistent local customizations
include pix.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/pix
noblacklist ${HOME}/.local/share/pix
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

private-bin pix
private-cache
private-dev
private-tmp

restrict-namespaces
