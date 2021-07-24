# Firejail profile for alienarena
# Description: Multiplayer retro sci-fi deathmatch game
# This file is overwritten after every install/update
# Persistent local customizations
include alienarena.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/cor-games

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/cor-games
allow  ${HOME}/.local/share/cor-games
allow  /usr/share/alienarena
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
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin alienarena
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,drirc,fonts,glvnd,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,nsswitch.conf,nvidia,pango,pki,protocols,pulse,resolv.conf,rpc,services,ssl,X11
private-tmp

dbus-user none
dbus-system none
