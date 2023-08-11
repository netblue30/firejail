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
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# blacklisting of ioprio_set system calls breaks auto-updating of
# MPD's database when files in music_directory are changed
seccomp !ioprio_set

#private-bin bash,mpd
private-cache
private-dev
private-tmp

dbus-user filter
dbus-user.talk org.mpris.MediaPlayer2.mpd
dbus-system none

restrict-namespaces
