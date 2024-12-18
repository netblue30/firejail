# Firejail profile for RPCS3 emulator
# Description: RPCS3 emulator
# This file is overwritten after every install/update
# Persistent local customizations
include rpcs3.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/rpcs3
noblacklist ${HOME}/.cache/rpcs3
# Don't block access to /sbin and /usr/sbin to allow using ldconfig. Otherwise
# won't even start.
noblacklist /sbin
noblacklist /usr/sbin

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc # disable if PPU compilation crashes
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/rpcs3
mkdir ${HOME}/.config/rpcs3
whitelist ${HOME}/.cache/rpcs3
whitelist ${HOME}/.config/rpcs3
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
netfilter
nodvd
nogroups
#noinput
nonewprivs
noroot
noprinters
notv
nou2f
novideo
protocol unix,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
#private-cache
# seems to need awk
#private-etc alternatives,ca-certificates,crypto-policies,machine-id,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
