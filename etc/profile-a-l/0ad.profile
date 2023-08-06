# Firejail profile for 0ad
# Description: Real-time strategy game of ancient warfare
# This file is overwritten after every install/update
# Persistent local customizations
include 0ad.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/0ad
noblacklist ${HOME}/.config/0ad
noblacklist ${HOME}/.local/share/0ad

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/0ad
mkdir ${HOME}/.config/0ad
mkdir ${HOME}/.local/share/0ad
whitelist ${HOME}/.cache/0ad
whitelist ${HOME}/.config/0ad
whitelist ${HOME}/.local/share/0ad
whitelist /usr/share/0ad
whitelist /usr/share/games
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
tracelog

disable-mnt
private-bin 0ad,pyrogenesis,sh,which
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
