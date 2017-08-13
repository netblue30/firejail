# Firejail profile for google-chrome-beta
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-chrome-beta.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/google-chrome-beta
noblacklist ~/.config/google-chrome-beta
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/google-chrome-beta
mkdir ~/.config/google-chrome-beta
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/google-chrome-beta
whitelist ~/.config/google-chrome-beta
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
