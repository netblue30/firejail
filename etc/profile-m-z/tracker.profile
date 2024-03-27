# Firejail profile for tracker
# Description: Metadata database, indexer and search tool
# This file is overwritten after every install/update
# Persistent local customizations
include tracker.local
# Persistent global definitions
include globals.local

# Tracker is started by systemd on most systems. Therefore it is not firejailed by default

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc

include whitelist-runuser-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
tracelog

#private-bin tracker
#private-dev
#private-tmp

restrict-namespaces
