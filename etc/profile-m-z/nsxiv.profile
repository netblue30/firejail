# Persistent local customizations
include nsxiv.local
# Persistent global definitions
include globals.local

include allow-bin-sh.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/nsxiv
mkdir ${HOME}/.config/nsxiv
whitelist ${HOME}/.cache/nsxiv
whitelist ${HOME}/.config/nsxiv
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
seccomp.block-secondary
tracelog

private-dev
private-tmp

deterministic-shutdown
memory-deny-write-execute
