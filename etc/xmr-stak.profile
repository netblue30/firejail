# Firejail profile for xmr-stak
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xmr-stak.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.xmr-stak
noblacklist /usr/lib/llvm*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.xmr-stak
include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
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
private ${HOME}/.xmr-stak
private-bin xmr-stak
private-dev
private-etc ca-certificates,crypto-policies,nsswitch.conf,pki,resolv.conf,ssl
#private-lib libxmrstak_opencl_backend,libxmrstak_cuda_backend
private-opt cuda
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
