# Firejail profile for youtube-viewer
# Description: Trizen's CLI Youtube viewer with login support
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-viewer.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*
blacklist ${RUNUSER}

noblacklist ${HOME}/.config/youtube-viewer

include allow-perl.inc
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/youtube-viewer
whitelist ${HOME}/.config/youtube-viewer
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
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
# private-bin ffmpeg,ffprobe,firefox,gtk-youtube-viewer,gtk2-youtube-viewer,gtk3-youtube-viewer,mpv,python*,smplayer,sh,which,vlc,youtube-dl,youtube-viewer
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,machine-id,mime.types,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl,X11,xdg
private-tmp

dbus-user none
dbus-system none