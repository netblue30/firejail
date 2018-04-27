# Firejail profile for gajim
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gajim.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/gajim
noblacklist ${HOME}/.config/gajim
noblacklist ${HOME}/.local/share/gajim

# Allow Python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/gajim
mkdir ${HOME}/.config/gajim
mkdir ${HOME}/.local/share/gajim
mkdir ${HOME}/Downloads
whitelist ${HOME}/.cache/gajim
whitelist ${HOME}/.config/gajim
whitelist ${HOME}/.local/share/gajim
whitelist ${HOME}/Downloads
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin python,gajim
private-dev
private-etc alsa,asound.conf,ca-certificates,crypto-policies,fonts,group,hostname,hosts,ld.so.cache,ld.so.conf,localtime,machine-id,passwd,pki,pulse,resolv.conf,ssl
private-tmp
