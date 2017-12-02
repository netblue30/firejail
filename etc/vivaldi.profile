# Firejail profile for vivaldi
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/vivaldi.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/vivaldi
noblacklist ${HOME}/.config/vivaldi

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/vivaldi
mkdir ${HOME}/.config/vivaldi
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/vivaldi
whitelist ${HOME}/.config/vivaldi
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
