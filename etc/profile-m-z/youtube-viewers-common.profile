# Firejail profile for youtube-viewer clones
# Description: common profile for Trizen's Youtube viewers
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-viewers-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.cache/youtube-dl

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

whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/youtube-dl/youtube-sigfuncs
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
private-bin bash,ffmpeg,ffprobe,firefox,mpv,perl,python*,sh,smplayer,stty,vlc,wget,which,xterm,youtube-dl
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,machine-id,mime.types,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl,X11,xdg
private-tmp

dbus-user none
dbus-system none
