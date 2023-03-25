# Firejail profile for ssh-agent
# Description: OpenSSH authentication agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssh-agent.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

ignore noexec ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-X11.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
noinput
nogroups
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog
x11 none

disable-mnt
private-bin ssh-agent
private-cache
private-dev
writable-run-user

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
