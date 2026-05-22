# Firejail profile for tldr
# Description: Python CLI for tldr pages
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tldr.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/tldr

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

blacklist ${RUNUSER}
blacklist /usr/libexec

mkdir ${HOME}/.cache/tldr
whitelist ${HOME}/.cache/tldr

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-x11.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
seccomp

disable-mnt
private-bin python*,tldr
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
