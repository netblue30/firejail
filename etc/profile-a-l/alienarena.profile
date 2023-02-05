# Firejail profile for alienarena
# Description: Multiplayer retro sci-fi deathmatch game
# This file is overwritten after every install/update
# Persistent local customizations
include alienarena.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/cor-games

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/cor-games
whitelist ${HOME}/.local/share/cor-games
whitelist /usr/share/alienarena
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin alienarena
private-cache
private-dev
private-etc @tls-ca,@x11,bumblebee,glvnd,host.conf,rpc,services
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
