# Firejail profile for ardour5
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ardour5.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /usr/local/bin

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/ardour4
whitelist ${HOME}/.config/ardour5
whitelist ${HOME}/.lv2
whitelist ${HOME}/.vst
whitelist ${HOME}/Documents
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
net none
nogroups
noroot
seccomp
shell none

private-bin sh,ardour5,ardour5-copy-mixer,ardour5-export,ardour5-fix_bbtppq,grep,sed,ldd,nm
private-dev
private-etc pulse,X11,alternatives,ardour4,ardour5,fonts
private-tmp

noexec /home
noexec /tmp
