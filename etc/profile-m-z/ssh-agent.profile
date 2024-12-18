# Firejail profile for ssh-agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssh-agent.local
# Persistent global definitions
include globals.local

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-programs.inc
include disable-x11.inc

include whitelist-usr-share-common.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
tracelog

writable-run-user

dbus-user none
dbus-system none

restrict-namespaces
