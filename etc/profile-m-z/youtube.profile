# Firejail profile for youtube
# Description: Unofficial electron based desktop wrapper for YouTube
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore nou2f

noblacklist ${HOME}/.config/Youtube

include disable-shell.inc

mkdir ${HOME}/.config/Youtube
whitelist ${HOME}/.config/Youtube
whitelist /opt/Youtube

private-bin electron,electron[0-9],electron[0-9][0-9],youtube
private-etc @tls-ca,@x11,bumblebee,host.conf,mime.types

# Redirect
include electron-common.profile
