# Firejail profile for straw-viewer
# Description: Fork of youtube-viewer acts like an invidious frontend
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include straw-viewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/straw-viewer
noblacklist ${HOME}/.config/straw-viewer

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/straw-viewer
mkdir ${HOME}/.cache/straw-viewer
whitelist ${HOME}/.cache/straw-viewer
whitelist ${HOME}/.config/straw-viewer
whitelist ${DOWNLOADS}
include whitelist-common.inc
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
shell none
tracelog

disable-mnt
private-bin bash,ffmpeg,ffprobe,gtk-straw-viewer,mpv,perl,python*,sh,smplayer,straw-viewer,stty,vlc,wget,which,youtube-dl
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,machine-id,mime.types,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl,X11,xdg
private-tmp

dbus-user none
dbus-system none
