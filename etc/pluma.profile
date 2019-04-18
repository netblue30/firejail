# Firejail profile for pluma
# Description: Official text editor of the MATE desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include pluma.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/pluma
noblacklist ${HOME}/.pythonrc.py

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
machine-id
# net none - makes settings immutable
no3d
# nodbus - makes settings immutable
nodvd
nogroups
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

private-bin pluma
private-dev
# private-etc alternatives,fonts
private-lib pluma
private-tmp

memory-deny-write-execute

join-or-start pluma
