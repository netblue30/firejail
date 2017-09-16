# Firejail profile for brackets
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/brackets.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Brackets
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.themes
whitelist ${HOME}/Documents
whitelist /opt/brackets/
whitelist /opt/google/
whitelist /tmp/.X11-unix
include /etc/firejail/whitelist-common.inc

caps.drop all
# Comment out or use --ignore=net if you want to install extensions or themes
net none
# Disable these if you use live preview (until I figure out a workaround)
# Doing so should be relatively safe since there is no network access
noroot
seccomp

private-bin bash,brackets,readlink,dirname,google-chrome,cat
private-dev
