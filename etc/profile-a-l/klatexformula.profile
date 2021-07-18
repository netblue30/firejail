# Firejail profile for klatexformula
# Description: generating images from LaTeX equations
# This file is overwritten after every install/update
# Persistent local customizations
include klatexformula.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kde/share/apps/klatexformula
noblacklist ${HOME}/.klatexformula

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
machine-id
net none
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

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
