# Firejail profile for polari
# Description: Internet Relay Chat (IRC) client
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/polari.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/telepathy
mkdir ${HOME}/.config/telepathy-account-widgets
mkdir ${HOME}/.local/share/Empathy
mkdir ${HOME}/.local/share/TpLogger
mkdir ${HOME}/.local/share/telepathy
mkdir ${HOME}/.purple
whitelist ${HOME}/.cache/telepathy
whitelist ${HOME}/.config/telepathy-account-widgets
whitelist ${HOME}/.local/share/Empathy
whitelist ${HOME}/.local/share/TpLogger
whitelist ${HOME}/.local/share/telepathy
whitelist ${HOME}/.purple
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
