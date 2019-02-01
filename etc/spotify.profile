# Firejail profile for spotify
# This file is overwritten after every install/update
# Persistent local customizations
include spotify.local
# Persistent global definitions
include globals.local

blacklist ${HOME}/.bashrc
blacklist /lost+found
blacklist /sbin
blacklist /srv

noblacklist ${HOME}/.cache/spotify
noblacklist ${HOME}/.config/spotify
noblacklist ${HOME}/.local/share/spotify

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/spotify
mkdir ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
whitelist ${HOME}/.cache/spotify
whitelist ${HOME}/.config/spotify
whitelist ${HOME}/.local/share/spotify
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
#nodbus - dbus needed for MPRIS
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin spotify,bash,sh,zenity
private-dev
private-etc fonts,group,ld.so.cache,machine-id,pulse,resolv.conf,hosts,nsswitch.conf,host.conf,ca-certificates,ssl,pki,crypto-policies
private-opt spotify
private-tmp

noexec ${HOME}
noexec /tmp
