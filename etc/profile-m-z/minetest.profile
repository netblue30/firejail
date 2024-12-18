# Firejail profile for minetest
# Description: Multiplayer infinite-world block sandbox
# This file is overwritten after every install/update
# Persistent local customizations
include minetest.local
# Persistent global definitions
include globals.local

# In order to save in-game screenshots to a persistent location,
# edit ~/.minetest/minetest.conf:
# screenshot_path = /home/<USER>/.minetest/screenshots

noblacklist ${HOME}/.cache/minetest
noblacklist ${HOME}/.minetest

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/minetest
mkdir ${HOME}/.minetest
whitelist ${HOME}/.cache/minetest
whitelist ${HOME}/.minetest
whitelist /usr/share/games/minetest
whitelist /usr/share/minetest
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
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
tracelog

disable-mnt
private-bin minetest,rm
# cache is used for storing assets when connecting to servers
#private-cache
private-dev
# private-etc needs to be updated, see #1702
#private-etc alternatives,asound.conf,ca-certificates,crypto-policies,drirc,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,machine-id,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
