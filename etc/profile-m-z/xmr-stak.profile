# Firejail profile for xmr-stak
# This file is overwritten after every install/update
# Persistent local customizations
include xmr-stak.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.xmr-stak

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.xmr-stak
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private ${HOME}/.xmr-stak
private-bin xmr-stak
private-dev
private-etc alternatives,ca-certificates,crypto-policies,ld.so.cache,ld.so.preload,nsswitch.conf,pki,resolv.conf,ssl
#private-lib libxmrstak_opencl_backend,libxmrstak_cuda_backend
private-opt cuda
private-tmp

memory-deny-write-execute
