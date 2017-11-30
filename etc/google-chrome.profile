# Firejail profile for google-chrome
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-chrome.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/google-chrome
noblacklist ${HOME}/.config/google-chrome
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/google-chrome
mkdir ${HOME}/.config/google-chrome
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/google-chrome
whitelist ${HOME}/.config/google-chrome
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.keep sys_chroot,sys_admin
netfilter
nodvd
nogroups
notv
shell none

disable-mnt
private-dev
# private-tmp - problems with multiple browser sessions

noexec ${HOME}
noexec /tmp
