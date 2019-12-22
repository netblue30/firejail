# Firejail profile for mpd
# Description: Music Player Daemon
# This file is overwritten after every install/update
# Persistent local customizations
include mpd.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mpd
noblacklist ${HOME}/.mpd
noblacklist ${HOME}/.mpdconf
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# blacklisting of ioprio_set system calls breaks auto-updating of
# MPD's database when files in music_directory are changed
seccomp !ioprio_set
shell none

#private-bin bash,mpd
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,default,fonts,gconf,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,mpd.conf,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

