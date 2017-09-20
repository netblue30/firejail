# Firejail profile for xmr-stak-cpu
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xmr-stak-cpu.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
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

disable-mnt
private
private-bin xmr-stak-cpu
private-dev
private-etc xmr-stak-cpu.json
private-lib
private-opt none
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
