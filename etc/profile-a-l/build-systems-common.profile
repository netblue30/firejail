# Firejail profile for build-systems-common
# This file is overwritten after every install/update
# Persistent local customizations
include build-systems-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

ignore noexec ${HOME}
ignore noexec /tmp

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allows files commonly used by IDEs
include allow-common-devel.inc

# Allow ssh (blacklisted by disable-common.inc)
#include allow-ssh.inc

blacklist ${RUNUSER}

include disable-common.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

#whitelist ${HOME}/Projects
#include whitelist-common.inc

whitelist /usr/share/pkgconfig
include whitelist-run-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
#net none
netfilter
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
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
