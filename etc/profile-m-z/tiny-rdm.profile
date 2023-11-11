# Firejail profile for tiny-rdm
# Description: A Modern Redis GUI Client
# This file is overwritten after every install/update
# Persistent local customizations
include tiny-rdm.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/tiny-rdm
noblacklist ${HOME}/.config/TinyRDM

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-proc.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/tiny-rdm
mkdir ${HOME}/.config/TinyRDM
whitelist ${HOME}/.cache/tiny-rdm
whitelist ${HOME}/.config/TinyRDM
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
nosound
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin tiny-rdm
private-cache
private-dev
private-etc @network,@tls-ca,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
