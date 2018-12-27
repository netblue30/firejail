# Firejail profile for gajim
# Description: GTK+-based Jabber client
# This file is overwritten after every install/update
# Persistent local customizations
include gajim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/gajim
noblacklist ${HOME}/.config/gajim
noblacklist ${HOME}/.local/share/gajim

# Allow Python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python3*
noblacklist /usr/lib64/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/gajim
mkdir ${HOME}/.config/gajim
mkdir ${HOME}/.local/share/gajim
mkdir ${HOME}/Downloads
whitelist ${HOME}/.cache/gajim
whitelist ${HOME}/.config/gajim
whitelist ${HOME}/.local/share/gajim
whitelist ${HOME}/Downloads
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog
shell none

disable-mnt
private-bin python,python3,sh,gpg,gpg2,gajim,bash,zsh,paplay,gajim-history-manager
private-cache
private-dev
private-etc alsa,asound.conf,ca-certificates,crypto-policies,fonts,group,hostname,hosts,ld.so.cache,ld.so.conf,localtime,machine-id,passwd,pki,pulse,resolv.conf,ssl
private-tmp

noexec ${HOME}
noexec /tmp
