# Firejail profile for Cantata
# Description: Multimedia player - Qt5 client for the music Player daemon (MPD)
# This file is overwritten during software install.
# Persistent local customizations
include cantata.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/cantata
noblacklist ${HOME}/.config/cantata
noblacklist ${HOME}/.local/share/cantata
noblacklist ${MUSIC}

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

#apparmor
caps.drop all
ipc-namespace
netfilter
noinput
nonewprivs
noroot
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

#private-etc alternatives,drirc,fonts,gcrypt,hosts,kde5rc,mpd.conf,passwd,samba,ssl,xdg
private-bin cantata,mpd,perl
private-dev

restrict-namespaces
