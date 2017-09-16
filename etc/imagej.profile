# Firejail profile for imagej
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/imagej.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /usr/local/bin
blacklist /usr/local/sbin

whitelist ${DOWNLOADS}
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.gtkrc.mine
whitelist ${HOME}/.imagej
whitelist ${HOME}/.themes
whitelist ${HOME}/Pictures
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
net none
nogroups
nonewprivs
noroot
seccomp

private-bin imagej,bash,grep,sort,tail,tr,cut,whoami,hostname,uname,mkdir,ls,touch,free,awk,update-java-alternatives,basename,xprop,rm,ln
private-dev
# private-etc passwd,alternatives,hosts,fonts,X11
private-tmp
