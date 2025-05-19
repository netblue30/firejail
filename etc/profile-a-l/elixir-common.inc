
blacklist ${RUNUSER}

ignore read-only ${HOME}/.mix

noblacklist ${HOME}/.mix
mkdir ${HOME}/.mix
#whitelist ${HOME}/.mix

include allow-bin-sh.inc

include disable-common.inc
include disable-exec.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

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
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary

disable-mnt
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types,rpc,services
private-tmp

dbus-user none
dbus-system none

restrict-namespaces

#memory-deny-write-execute # breaks JIT
