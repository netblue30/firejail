# Firejail profile for Chatterino
# Description: Chat client for https://twitch.tv
# This file is overwritten after every install/update
# Persistent local customizations
include chatterino.local
# Persistent global definitions
include globals.local

# To upload images, whitelist/noblacklist their path in chatterino.local.
#whitelist ${PICTURES}
# For custom notification sounds, whitelist/noblacklist their path in chatterino.local.
#whitelist ${MUSIC}

# Also allow access to mpv/vlc, they're usable via streamlink.
noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/pulse
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/chatterino
noblacklist ${HOME}/.local/share/vlc
noblacklist ${HOME}/.local/state/mpv

# Allow Lua for mpv (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow Python for Streamlink integration (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

# Also allow read-only access to mpv/VLC, they're usable via streamlink.
mkdir ${HOME}/.local/share/chatterino
# VLC preferences will fail to save with read-only set.
whitelist ${HOME}/.local/share/chatterino
whitelist-ro ${HOME}/.config/mpv
whitelist-ro ${HOME}/.config/pulse
whitelist-ro ${HOME}/.config/vlc
whitelist-ro ${HOME}/.local/share/vlc
whitelist-ro /usr/share/mpv
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
private-bin chatterino,cvlc,env,ffmpeg,mpv,nvlc,pgrep,python*,qvlc,rvlc,streamlink,svlc,vlc
# private-cache may cause issues with mpv (see #2838)
private-cache
private-dev
private-etc @tls-ca,@x11,dbus-1,rpc,services
private-srv none
private-tmp

dbus-user filter
dbus-user.own com.chatterino.*
# Allow notifications.
dbus-user.talk org.freedesktop.Notifications
# For media player integration.
dbus-user.talk org.freedesktop.ScreenSaver
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.own org.mpris.MediaPlayer2.chatterino
dbus-user.talk org.mpris.MediaPlayer2.Player
dbus-system none

# Prevents browsers/players from lingering after Chatterino is closed.
#deterministic-shutdown
# memory-deny-write-execute may break streamlink and browser integration.
#memory-deny-write-execute
restrict-namespaces
