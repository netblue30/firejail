# Firejail profile for transmission-show
# Description: CLI utility to show BitTorrent .torrent file metadata
# This file is overwritten after every install/update
# Persistent local customizations
include transmission-show.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none
tracelog

private-dev
private-etc alternatives,hosts,nsswitch.conf
private-lib
private-tmp

memory-deny-write-execute
