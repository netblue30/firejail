# Firejail profile for kdenlive
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kdenlive.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt

# Apparently these break kdenlive for some people - they work for me though?
# whitelist ${DOWNLOADS}
# whitelist ${HOME}/.config/
# whitelist ${HOME}/Videos
# whitelist ${HOME}/kdenlive
whitelist /tmp/.X11-unix
# DBus is forced to use an ordinary unix socket
whitelist /tmp/dbus_session_socket
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
nogroups
noroot
seccomp
shell none

private-bin kdenlive,kdenlive_render,dbus-launch,melt,ffmpeg,ffplay,ffprobe,dvdauthor,genisoimage,vlc,xine,kdeinit5,kshell5,kdeinit5_shutdown,kdeinit5_wrapper,kdeinit4,kshell4,kdeinit4_shutdown,kdeinit4_wrapper
private-dev
private-etc fonts,alternatives,X11,pulse,passwd
