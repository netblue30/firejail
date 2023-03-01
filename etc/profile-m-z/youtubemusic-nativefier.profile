# Firejail profile for youtubemusic-nativefier
# Description: Unofficial electron based desktop warpper for YouTube Music
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/youtubemusic-nativefier-040164

include disable-shell.inc

mkdir ${HOME}/.config/youtubemusic-nativefier-040164
whitelist ${HOME}/.config/youtubemusic-nativefier-040164

private-bin electron,electron[0-9],electron[0-9][0-9],youtubemusic-nativefier
private-etc @tls-ca,@x11,bumblebee,host.conf,mime.types
private-opt youtubemusic-nativefier

# Redirect
include electron-common.profile
