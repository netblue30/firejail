# Firejail profile for geeqie
# Description: Image viewer using GTK
# This file is overwritten after every install/update
# Persistent local customizations
include geeqie.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/geeqie
noblacklist ${HOME}/.config/geeqie
noblacklist ${HOME}/.local/share/geeqie

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
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
# remove inet,inet6 to disable network access
protocol unix,inet,inet6
seccomp

#private-bin geeqie
private-dev

restrict-namespaces
