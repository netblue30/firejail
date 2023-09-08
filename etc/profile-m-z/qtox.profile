# Firejail profile for qtox
# Description: Powerful Tox client written in C++/Qt that follows the Tox design guidelines
# This file is overwritten after every install/update
# Persistent local customizations
include qtox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Tox
noblacklist ${HOME}/.config/tox

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/tox
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/tox
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin qtox
private-cache
private-dev
private-etc @tls-ca
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute # breaks on Arch (see issue #1803)
restrict-namespaces
