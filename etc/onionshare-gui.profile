# Firejail profile for onionshare-gui
# This file is overwritten after every install/update
# Persistent local customizations
include onionshare-gui.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/onionshare

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
