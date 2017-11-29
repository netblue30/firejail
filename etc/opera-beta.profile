# Firejail profile for opera-beta
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/opera-beta.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/opera-beta
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/opera
mkdir ${HOME}/.config/opera-beta
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/opera
whitelist ${HOME}/.config/opera-beta
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc

netfilter
nodvd
notv

disable-mnt
