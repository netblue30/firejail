# Firejail profile for streamlink
# Description: CLI utility which pipes video streams from various services
# into a video player
# This file is overwritten after every install/update
# Persistent local customizations
include streamlink.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.cache/vlc
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/streamlink
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/vlc
noblacklist ${HOME}/.local/state/mpv
noblacklist ${HOME}/.local/state/streamlink
noblacklist ${HOME}/.mplayer

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

# Add the next lines to streamlink.local to restrict $HOME for your favorite
# player, e.g. mpv
#read-only ${DESKTOP}
#mkdir ${HOME}/.cache/mpv
#mkdir ${HOME}/.config/mpv
#mkdir ${HOME}/.config/streamlink
#mkdir ${HOME}/.local/state/mpv
#mkdir ${HOME}/.local/state/streamlink
#whitelist ${HOME}/.cache/mpv
#whitelist ${HOME}/.config/mpv
#whitelist ${HOME}/.config/streamlink
#whitelist ${HOME}/.local/state/mpv
#whitelist ${HOME}/.local/state/streamlink
#whitelist /usr/share/lua*
#whitelist /usr/share/mpv
#include whitelist-common.inc
#include whitelist-player-common.inc
#include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noprinters
noroot
nou2f
protocol unix,inet,inet6,netlink
# https://github.com/netblue30/firejail/commit/2c5119d751cc78e52922544a52a0332f59304639
seccomp !set_mempolicy

# May break --webbrowser option
private-bin streamlink,python*,mpv,vlc,cvlc,nvlc,qvlc,rvlc,svlc,vlc,mplayer,ffmpeg,chromium*,google-chrome*,microsoft-edge*,brave*,vivaldi*
private-dev

dbus-user none
# Add the next lines to streamlink.local to enable MPRIS for your favorite
# player, e.g. mpv
#dbus-user filter
#dbus-user.own org.mpris.MediaPlayer2.mpv
#dbus-user.own org.mpris.MediaPlayer2.mpv.*
#dbus-user.talk org.mpris.MediaPlayer2.*
dbus-system none

restrict-namespaces
