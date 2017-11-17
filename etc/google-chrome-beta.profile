# Firejail profile for google-chrome-beta
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-chrome-beta.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/google-chrome-beta
noblacklist ${HOME}/.config/google-chrome-beta
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/google-chrome-beta
mkdir ${HOME}/.config/google-chrome-beta
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/google-chrome-beta
whitelist ${HOME}/.config/google-chrome-beta
whitelist ${HOME}/.pki
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
