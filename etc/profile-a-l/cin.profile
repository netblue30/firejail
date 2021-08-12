# Firejail profile for cin
# This file is overwritten after every install/update
# Persistent local customizations
include cin.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bcast5

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
ipc-namespace
net none
nodvd
#nogroups
noinput
nonewprivs
notv
nou2f
noroot
protocol unix

# If a 1-1.2% gap per thread hurts you, add 'ignore seccomp' to your cin.local.
seccomp
shell none

#private-bin cin,ffmpeg
private-cache
private-dev

dbus-user none
dbus-system none
