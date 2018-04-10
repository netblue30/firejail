# Firejail profile for spotify
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/spotify.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist ${HOME}/.bashrc
blacklist /lost+found
blacklist /sbin
blacklist /srv
blacklist /sys

noblacklist ${HOME}/.cache/spotify
noblacklist ${HOME}/.config/spotify
noblacklist ${HOME}/.local/share/spotify

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/spotify
mkdir ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
whitelist ${HOME}/.cache/spotify
whitelist ${HOME}/.config/spotify
whitelist ${HOME}/.local/share/spotify
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin spotify,bash,sh,zenity
private-dev
private-etc fonts,group,ld.so.cache,machine-id,pulse,resolv.conf
private-opt spotify
private-tmp

noexec ${HOME}
noexec /tmp
