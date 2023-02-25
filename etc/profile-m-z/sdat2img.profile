# Firejail profile for sdat2img
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sdat2img.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
net none
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

private-bin env,python*,sdat2img
private-cache
private-dev

dbus-user none
dbus-system none

restrict-namespaces
