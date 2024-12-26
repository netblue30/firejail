quiet
# Persistent local customizations
include buku.local
# Persistent global definitions
include globals.local

# Opening an editor in buku seems to require POSIX shell
include allow-bin-sh.inc
include allow-python3.inc

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

mkdir ${HOME}/.local/share/buku
whitelist ${HOME}/.local/share/buku
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
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
# Some editors like kakoune require unix protocol.
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
#private-bin interferes with opening arbitrary editors in buku.
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
#memory-deny-write-execute breaks editors used in buku
