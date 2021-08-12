# Firejail profile for rtorrent
# Description: Ncurses BitTorrent client based on LibTorrent from rakshasa
# This file is overwritten after every install/update
# Persistent local customizations
include rtorrent.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

caps.drop all
machine-id
netfilter
nodvd
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin rtorrent
private-cache
private-dev
private-tmp
