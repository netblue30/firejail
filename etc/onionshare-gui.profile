# Firejail profile for onionshare-gui
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/onionshare-gui.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/onionshare

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
