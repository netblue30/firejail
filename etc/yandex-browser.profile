# Firejail profile for yandex-browser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/yandex-browser.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/yandex-browser
noblacklist ${HOME}/.cache/yandex-browser-beta
noblacklist ${HOME}/.config/yandex-browser
noblacklist ${HOME}/.config/yandex-browser-beta
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/yandex-browser
mkdir ${HOME}/.cache/yandex-browser-beta
mkdir ${HOME}/.config/yandex-browser
mkdir ${HOME}/.config/yandex-browser-beta
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/yandex-browser
whitelist ${HOME}/.cache/yandex-browser-beta
whitelist ${HOME}/.config/yandex-browser
whitelist ${HOME}/.config/yandex-browser-beta
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc

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
