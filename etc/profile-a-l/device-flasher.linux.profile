# Firejail profile for device-flasher.linux
# Description: CalyxOS' device flasher
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include device-flasher.linux.local
# Persistent global definitions
include globals.local

# Usage: Run firejail ./device-flasher.linux in the folder with it and your
# factory image.

ignore noexec ${HOME}

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

blacklist ${RUNUSER}
blacklist /opt
blacklist /srv
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}

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
protocol inet,inet6,netlink
seccomp
seccomp.block-secondary

disable-mnt
private-bin cut,grep,sed,sh,sleep,which
private-cache
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute
restrict-namespaces
