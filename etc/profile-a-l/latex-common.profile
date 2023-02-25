# Firejail profile for latex-common
# This file is overwritten after every install/update
# Persistent local customizations
include latex-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /var/lib
include whitelist-runuser-common.inc
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
tracelog

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
