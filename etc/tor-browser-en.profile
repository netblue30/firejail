# Firejail profile for tor-browser-en
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/tor-browser-en.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /usr/local/bin
blacklist /var

whitelist ${HOME}/.tor-browser-en
whitelist /dev/dri
whitelist /dev/full
whitelist /dev/null
whitelist /dev/ptmx
whitelist /dev/pts
whitelist /dev/random
whitelist /dev/shm
whitelist /dev/snd
whitelist /dev/tty
whitelist /dev/urandom
whitelist /dev/video0
whitelist /dev/zero
include /etc/firejail/whitelist-common.inc

caps.drop all
noroot
seccomp
shell none

private-bin bash,grep,sed,tail,tor-browser-en,env,id,readlink,dirname,test,mkdir,ln,sed,cp,rm,getconf,file,expr
# FIXME: Spoof D-Bus machine id (tor-browser segfaults when it is missing!)
# https://github.com/netblue30/firejail/issues/955
private-etc X11,pulse,machine-id
private-tmp

noexec /tmp
