# Firejail profile for rtorrent
# Description: Ncurses BitTorrent client based on LibTorrent from rakshasa
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/rtorrent.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin rtorrent
private-cache
private-dev
private-tmp
