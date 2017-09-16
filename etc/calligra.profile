# Firejail profile for calligra
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/calligra.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Trolltech.conf
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.kde
whitelist ${HOME}/.themes
whitelist ${HOME}/Documents
whitelist /tmp/.X11-unix
# DBus is forced to use an ordinary unix socket
whitelist /tmp/dbus_session_socket
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
net none
nogroups
noroot
seccomp
shell none

private-bin calligra,calligraauthor,calligraconverter,calligraflow,calligraplan,calligraplanwork,calligrasheets,calligrastage,calligrawords,dbus-launch
private-dev
private-etc fonts,passwd,alternatives,X11

noexec /home
noexec /tmp
