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

# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/gajim
mkdir ${HOME}/.config/gajim
mkdir ${HOME}/.local/share/gajim
whitelist ${HOME}/.cache/gajim
whitelist ${HOME}/.config/gajim
whitelist ${HOME}/.local/share/gajim
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
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
private-bin bash,gajim,gajim-history-manager,gpg,gpg2,paplay,python,python3,sh,zsh
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,group,hostname,hosts,ld.so.cache,ld.so.conf,localtime,machine-id,passwd,pki,pulse,resolv.conf,ssl
private-tmp

join-or-start gajim
