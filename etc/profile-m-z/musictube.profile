# Firejail profile for musictube
# Description: Stream music
# This file is overwritten after every install/update
# Persistent local customizations
include musictube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Flavio Tordini
noblacklist ${HOME}/.config/Flavio Tordini
noblacklist ${HOME}/.local/share/Flavio Tordini

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
whitelist ${HOME}/.cache/Flavio Tordini
whitelist ${HOME}/.config/Flavio Tordini
whitelist ${HOME}/.local/share/Flavio Tordini
whitelist /usr/share/musictube
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
private-bin musictube
private-cache
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
