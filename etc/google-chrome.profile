# Firejail profile for google-chrome
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-chrome.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/google-chrome
noblacklist ~/.config/google-chrome
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/google-chrome
mkdir ~/.config/google-chrome
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/google-chrome
whitelist ~/.config/google-chrome
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

caps.keep sys_chroot,sys_admin
netfilter
nodvd
nogroups
notv
shell none

private-dev
# private-tmp - problems with multiple browser sessions

noexec ${HOME}
noexec /tmp
