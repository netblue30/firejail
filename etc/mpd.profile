# Firejail profile for mpd
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mpd.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt

whitelist ${HOME}/.config/pulse/
whitelist ${HOME}/.mpdconf
whitelist ${HOME}/.pulse/
whitelist ${HOME}/Music
whitelist ${HOME}/mpd
include /etc/firejail/whitelist-common.inc

caps.drop all
noroot
seccomp

private-bin mpd,bash
private-dev
read-only ${HOME}/Music/
