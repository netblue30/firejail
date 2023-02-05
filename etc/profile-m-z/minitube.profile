# Firejail profile for minitube
# Description: Native Youtube viewer for Linux
# This file is overwritten after every install/update
# Persistent local customizations
include minitube.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}
noblacklist ${HOME}/.cache/Flavio Tordini
noblacklist ${HOME}/.config/Flavio Tordini
noblacklist ${HOME}/.local/share/Flavio Tordini

include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Flavio Tordini
mkdir ${HOME}/.config/Flavio Tordini
mkdir ${HOME}/.local/share/Flavio Tordini
whitelist ${PICTURES}
whitelist ${HOME}/.cache/Flavio Tordini
whitelist ${HOME}/.config/Flavio Tordini
whitelist ${HOME}/.local/share/Flavio Tordini
whitelist /usr/share/minitube
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
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-bin minitube
private-cache
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types,selinux
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
