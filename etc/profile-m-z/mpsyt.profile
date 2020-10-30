# Firejail profile for mpsyt
# Description: Terminal based YouTube player and downloader
# This file is overwritten after every install/update
# Persistent local customizations
include mpsyt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mps-youtube
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${HOME}/.mplayer
noblacklist ${HOME}/.netrc
noblacklist ${HOME}/mps

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/mps-youtube
mkdir ${HOME}/.config/mpv
mkdir ${HOME}/.config/youtube-dl
mkdir ${HOME}/.mplayer
mkdir ${HOME}/mps
whitelist ${HOME}/.config/mps-youtube
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.config/youtube-dl
whitelist ${HOME}/.mplayer
whitelist ${HOME}/.netrc
whitelist ${HOME}/mps
include whitelist-common.inc
include whitelist-players.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
# Seems to cause issues with Nvidia drivers sometimes
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

private-bin env,ffmpeg,mplayer,mpsyt,mpv,python*,youtube-dl
#private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
