# Firejail profile for qmmp
# Description: Feature-rich audio player with support of many formats
# This file is overwritten after every install/update
# Persistent local customizations
include qmmp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.qmmp
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
netfilter
#no3d
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-bin bzip2,gzip,qmmp,tar,unzip
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
