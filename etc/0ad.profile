# Firejail profile for 0ad
# Description: Real-time strategy game of ancient warfare
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/0ad.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/0ad
noblacklist ${HOME}/.config/0ad
noblacklist ${HOME}/.local/share/0ad

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/0ad
mkdir ${HOME}/.config/0ad
mkdir ${HOME}/.local/share/0ad
whitelist ${HOME}/.cache/0ad
whitelist ${HOME}/.config/0ad
whitelist ${HOME}/.local/share/0ad
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin 0ad,pyrogenesis,sh,which
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
