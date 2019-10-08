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
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot,!ioperm
shell none

private-cache
private-dev
