# Firejail profile for statusof
# Description: Small python script to check the status of a list of urls
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include statusof.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

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
protocol inet
seccomp
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private
private-bin python*,statusof
private-cache
private-dev
private-etc @network,@tls-ca,httpd
private-lib engines*,libcrypto.so.*,libssl.so.*,libz.so.*,python*
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces
