# Firejail profile for rsync
# Description: a fast, versatile, remote (and local) file-copying tool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include rsync.local
# Persistent global definitions
include globals.local

# Warning: This profile is writte to use rsync as an client for downloading,
# it is not writen to use rsync as an daemon (rsync --daemon) or to create backups.

# Usage: firejail --profile=rsync-download_only rsync

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Uncomment or add to rsync.local to enable extra hardening
#whitelist ${DOWNLOADS}
include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin rsync
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
