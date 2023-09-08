# Firejail profile for skanlite
# Description: Image scanner based on the KSane backend
# This file is overwritten after every install/update
# Persistent local customizations
include skanlite.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
#novideo
protocol unix,inet,inet6,netlink
# blacklisting of ioperm system calls breaks skanlite
seccomp !ioperm

#private-bin kbuildsycoca4,kdeinit4,skanlite
#private-dev
#private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
