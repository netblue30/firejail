# Firejail profile for twitch
# Description: Unofficial electron based desktop warpper for Twitch
# This file is overwritten after every install/update
# Persistent local customizations
include twitch.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore nou2f
ignore novideo

noblacklist ${HOME}/.config/Twitch

include disable-shell.inc

mkdir ${HOME}/.config/Twitch
whitelist ${HOME}/.config/Twitch

private-bin electron,electron[0-9],electron[0-9][0-9],twitch
private-etc @tls-ca,@x11,bumblebee,host.conf,mime.types
private-opt Twitch

# Redirect
include electron.profile
