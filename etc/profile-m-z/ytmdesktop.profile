# Firejail profile for ytmdesktop
# Description: Unofficial electron based desktop wrapper for YouTube Music
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

ignore dbus-user none

noblacklist ${HOME}/.config/youtube-music-desktop-app

mkdir ${HOME}/.config/youtube-music-desktop-app
whitelist ${HOME}/.config/youtube-music-desktop-app
whitelist /opt/ytmdesktop

#private-bin env,youtube-music-desktop-app,ytmdesktop
private-etc @tls-ca,@x11,bumblebee,host.conf,mime.types

# Redirect
include electron-common.profile
