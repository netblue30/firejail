# Firejail profile for mumble
# Description: Low latency encrypted VoIP client
# This file is overwritten after every install/update
# Persistent local customizations
include mumble.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Mumble
noblacklist ${HOME}/.local/share/data/Mumble
noblacklist ${HOME}/.local/share/Mumble

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.config/Mumble
mkdir ${HOME}/.local/share/data/Mumble
mkdir ${HOME}/.local/share/Mumble
whitelist ${HOME}/.config/Mumble
whitelist ${HOME}/.local/share/data/Mumble
whitelist ${HOME}/.local/share/Mumble
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-bin mumble
private-tmp

#memory-deny-write-execute # breaks on Arch (see issue #1803)
restrict-namespaces
