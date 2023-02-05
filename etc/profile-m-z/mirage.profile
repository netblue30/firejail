# Firejail profile for mirage
# Description: Desktop client for Matrix
# This file is overwritten after every install/update
# Persistent local customizations
include mirage.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mirage
noblacklist ${HOME}/.config/mirage
noblacklist ${HOME}/.local/share/mirage
noblacklist /sbin

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/mirage
mkdir ${HOME}/.config/mirage
mkdir ${HOME}/.local/share/mirage
whitelist ${HOME}/.cache/mirage
whitelist ${HOME}/.config/mirage
whitelist ${HOME}/.local/share/mirage
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin ldconfig,mirage
private-cache
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types,selinux
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
