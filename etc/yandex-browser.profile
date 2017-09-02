# Firejail profile for yandex-browser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/yandex-browser.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/yandex-browser
noblacklist ~/.cache/yandex-browser-beta
noblacklist ~/.config/yandex-browser
noblacklist ~/.config/yandex-browser-beta
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/yandex-browser
mkdir ~/.cache/yandex-browser-beta
mkdir ~/.config/yandex-browser
mkdir ~/.config/yandex-browser-beta
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/yandex-browser
whitelist ~/.cache/yandex-browser-beta
whitelist ~/.config/yandex-browser
whitelist ~/.config/yandex-browser-beta
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
