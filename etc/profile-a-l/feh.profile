# Firejail profile for feh
# Description: imlib2 based image viewer
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include feh.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/feh

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-run-common.inc
include whitelist-runuser-common.inc

# Add the next line to your feh.local to enable network access.
#include feh-network.inc.profile

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog

private-bin feh,jpegexiforient,jpegtran
private-cache
private-dev
private-etc feh
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
