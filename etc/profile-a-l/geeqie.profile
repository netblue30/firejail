# Firejail profile for geeqie
# Description: Image viewer using GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include geeqie.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/geeqie
noblacklist ${HOME}/.config/geeqie
noblacklist ${HOME}/.local/share/geeqie

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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

# private-bin geeqie
private-dev
