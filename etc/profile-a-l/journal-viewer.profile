# Firejail profile for journal-viewer
# Description: Visualize systemd logs
# This file is overwritten after every install/update
# Persistent local customizations
include journal-viewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/journal-viewer
noblacklist ${HOME}/.local/share/com.vmingueza.journal-viewer

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/journal-viewer
mkdir ${HOME}/.local/share/com.vmingueza.journal-viewer
whitelist ${HOME}/.cache/journal-viewer
whitelist ${HOME}/.local/share/com.vmingueza.journal-viewer
whitelist /run/log/journal
whitelist /var/log/journal
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin journal-viewer
private-cache
private-dev
private-etc machine-id
private-lib webkit2gtk-*
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
read-only ${HOME}
read-write ${HOME}/.cache/journal-viewer
read-write ${HOME}/.local/share/com.vmingueza.journal-viewer
writable-var-log
