# Firejail profile for Popcorn-Time
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Popcorn-Time.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.Popcorn-Time
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/Popcorn-Time
mkdir ~/.config/Popcorn-Time
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/Popcorn-Time
whitelist ~/.config/Popcorn-Time
whitelist ~/.pki
whitelist ~/.Popcorn-Time
include /etc/firejail/whitelist-common.inc

caps.keep sys_chroot,sys_admin
netfilter
nodvd
nogroups
notv
novideo
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
