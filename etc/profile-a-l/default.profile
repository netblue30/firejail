# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include default.local
# Persistent global definitions
include globals.local

# generic GUI profile
# depending on your usage, you can enable some of the commands below:

include disable-common.inc
#include disable-devel.inc
#include disable-exec.inc
#include disable-interpreters.inc
include disable-programs.inc
#include disable-shell.inc
#include disable-write-mnt.inc
#include disable-xdg.inc

#include whitelist-common.inc
#include whitelist-runuser-common.inc
#include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

include landlock-common.inc

#apparmor
caps.drop all
#ipc-namespace
#machine-id
#net none
netfilter
#no3d
#nodvd
#nogroups
noinput
nonewprivs
noroot
#nosound
notv
#nou2f
novideo
protocol unix,inet,inet6
seccomp
#tracelog

#disable-mnt
#private
#private-bin program
#private-cache
private-dev
# see /usr/share/doc/firejail/profile.template for more common private-etc paths.
#private-etc alternatives,fonts,machine-id
#private-lib
#private-opt none
private-tmp

#dbus-user none
#dbus-system none

#deterministic-shutdown
#memory-deny-write-execute
#read-only ${HOME}
restrict-namespaces
