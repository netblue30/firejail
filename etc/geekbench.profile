# Firejail profile for geekbench
# Description: A cross-platform benchmark that measures processor and memory performance
# This file is overwritten after every install/update
# Persistent local customizations
include geekbench.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

inclue whitelist-var-common.inc

apparmor
caps.drop all
hostname geekbench
ipc-namespace
machine-id
netfilter
no3d
nodbus
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
tracelog

disable-mnt
private-bin bash,geekbenc*,sh
private-cache
private-dev
private-etc alternatives,groups,passwd,lsb-release
private-lib libstdc++.so.*
private-opt none
private-tmp

# memory-deny-write-execute - Breaks on Arch
noexec ${HOME}
noexec /tmp

# never write anything
read-only ${HOME}
