# Firejail profile for youtube-viewer clones
# Description: common profile for Trizen's Youtube viewers
# This file is overwritten after every install/update
# Persistent local customizations
include youtube-viewers-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.cache/youtube-dl
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.local/state/mpv

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
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/youtube-dl/youtube-sigfuncs
whitelist ${HOME}/.config/mpv
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
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
tracelog

disable-mnt
private-bin bash,ffmpeg,ffprobe,mpv,perl,python*,sh,smplayer,stty,wget,wget2,which,youtube-dl,yt-dlp
private-cache
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types
private-tmp

dbus-system none

restrict-namespaces
