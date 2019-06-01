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
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# apparmor
caps.drop all
ipc-namespace
netfilter
nonewprivs
noroot
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

# private-etc samba,gcrypt,drirc,fonts,mpd.conf,kde5rc,passwd,xdg,hosts,ssl
private-bin cantata,mpd,perl
private-dev
