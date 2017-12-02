# Firejail profile for chromium
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/chromium.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/chromium
noblacklist ${HOME}/.config/chromium
noblacklist ${HOME}/.config/chromium-flags.conf
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/chromium
mkdir ${HOME}/.config/chromium
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/chromium
whitelist ${HOME}/.config/chromium
whitelist ${HOME}/.config/chromium-flags.conf
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
# private-bin chromium,chromium-browser,chromedriver
private-dev
# private-tmp - problems with multiple browser sessions

noexec ${HOME}
noexec /tmp
