# Firejail profile for natron
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/natron.local
# Persistent global definitions
include /etc/firejail/globals.local

# Contributed by triceratops1 (https://github.com/triceratops1)

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /usr/local/bin
blacklist /usr/local/sbin

whitelist ${DOWNLOADS}
whitelist ${HOME}/.Natron
whitelist ${HOME}/.cache/INRIA/Natron/
whitelist ${HOME}/.config/INRIA/
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.themes
whitelist ${HOME}/Videos
whitelist /opt/natron/
whitelist /tmp/.X11-unix/
include /etc/firejail/whitelist-common.inc

ipc-namespace
shell none

private-bin natron
private-etc fonts,X11,pulse

noexec ${HOME}
noexec /tmp
