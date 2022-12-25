# Firejail profile for Chatterino
# Description: Chat client for https://twitch.tv
# This file is overwritten after every install/update
# Persistent local customizations
include chatterino.local
# Persistent global definitions
include globals.local

# Also allow access to mpv/vlc, they're usable via streamlink.
noblacklist ${HOME}/.cache/vlc
noblacklist ${HOME}/.config/aacs
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/pulse
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/chatterino
noblacklist ${HOME}/.local/share/vlc
# To upload images, whitelist/noblacklist their path in chatterino.local.
#noblacklist ${HOME}/Pictures/
# For custom notification sounds, whitelist/noblacklist their path in chatterino.local.
#noblacklist ${HOME}/Music/

# Allow Python for Streamlink integration (blacklisted by disable-interpreters.inc)
include allow-python3.inc

# Allow Lua for mpv (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# disable-*.inc includes
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

# Also allow access to mpv/vlc, they're usable via streamlink.
mkdir ${HOME}/.cache/vlc
mkdir ${HOME}/.config/aacs
mkdir ${HOME}/.config/mpv
mkdir ${HOME}/.config/pulse
mkdir ${HOME}/.config/vlc
mkdir ${HOME}/.local/share/chatterino
mkdir ${HOME}/.local/share/vlc
whitelist ${HOME}/.cache/vlc
whitelist ${HOME}/.config/aacs
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.config/pulse
whitelist ${HOME}/.config/vlc
whitelist ${HOME}/.local/share/chatterino
whitelist ${HOME}/.local/share/vlc
# To upload images, whitelist/noblacklist their path in chatterino.local.
#whitelist ${HOME}/Pictures/pic1.png
# For custom notification sounds, whitelist/noblacklist their path in chatterino.local.
#whitelist ${HOME}/Music/
# whitelist-*.inc includes
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# Streamlink+VLC doesn't seem to close properly with apparmor enabled.
#apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noprinters
noroot
notv
nou2f
# Netlink is required for streamlink integration.
protocol unix,inet,inet6,netlink
# Seccomp may break browser integration.
seccomp
seccomp.block-secondary
tracelog

disable-mnt
# Add more private-bin lines for browsers or video players to chatterino.local if wanted.
private-bin chatterino,pgrep
private-bin ffmpeg,python*,streamlink
private-bin cvlc,nvlc,qvlc,rvlc,svlc,vlc
private-bin env,mpv,python*,waf,youtube-dl,yt-dlp
# private-cache may cause issues with mpv (see #2838)
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,dbus-1,fonts,hostname,hosts,kde4rc,kde5rc,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,nvidia,passwd,pulse,resolv.conf,rpc,services,ssl,Trolltech.conf,X11
private-srv none
private-tmp

dbus-user filter
dbus-user.own com.chatterino.*
# Allow notifications.
dbus-user.talk org.freedesktop.Notifications
# For media player integration.
dbus-user.talk org.freedesktop.ScreenSaver
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.mpris.MediaPlayer2.Player
dbus-system none

# Prevents browsers/players from lingering after Chatterino is closed.
#deterministic-shutdown
# memory-deny-write-execute may break streamlink and browser integration.
#memory-deny-write-execute
restrict-namespaces
