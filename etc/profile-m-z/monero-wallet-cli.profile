# Firejail profile for monero-wallet-cli
# Description: CLI wallet for monero cryptocurrency
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include monero-wallet-cli.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
# Superseded by disable-mnt
#include disable-write-mnt.inc
include disable-X11.inc
include disable-xdg.inc

mkdir ${HOME}/.shared-ringdb
whitelist ${HOME}/.shared-ringdb
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
notpm
notv
nou2f
novideo
protocol inet,inet6
seccomp
seccomp.block-secondary

disable-mnt
private-bin monero-wallet-cli
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute