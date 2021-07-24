# Firejail profile for pix
# This file is overwritten after every install/update
# Persistent local customizations
include pix.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/pix
nodeny  ${HOME}/.local/share/pix
nodeny  ${HOME}/.Steam
nodeny  ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
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
shell none
tracelog

private-bin pix
private-cache
private-dev
private-tmp
