# Firejail profile for brackets
# This file is overwritten after every install/update
# Persistent local customizations
include brackets.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Brackets
#noblacklist /opt/brackets
#noblacklist /opt/google

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot,!ioperm

private-cache
private-dev

#restrict-namespaces
