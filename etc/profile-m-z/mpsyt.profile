# Firejail profile for mpsyt
# Description: Terminal based YouTube player and downloader
# This file is overwritten after every install/update
# Persistent local customizations
include mpsyt.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/mps-youtube
nodeny  ${HOME}/.config/mpv
nodeny  ${HOME}/.config/youtube-dl
nodeny  ${HOME}/.mplayer
nodeny  ${HOME}/.netrc
nodeny  ${HOME}/mps

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

nodeny  ${MUSIC}
nodeny  ${VIDEOS}

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
allow  ${HOME}/.config/mps-youtube
allow  ${HOME}/.config/mpv
allow  ${HOME}/.config/youtube-dl
allow  ${HOME}/.mplayer
allow  ${HOME}/.netrc
allow  ${HOME}/mps
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
# Seems to cause issues with Nvidia drivers sometimes
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

private-bin env,ffmpeg,mplayer,mpsyt,mpv,python*,youtube-dl
#private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
