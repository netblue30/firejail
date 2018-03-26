# Firejail profile for gnome-twitch
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-twitch.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/gnome-twitch
noblacklist ${HOME}/.local/share/gnome-twitch

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/gnome-twitch
mkdir ${HOME}/.local/share/gnome-twitch
whitelist ${HOME}/.cache/gnome-twitch
whitelist ${HOME}/.local/share/gnome-twitch
include /etc/firejail/whitelist-common.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
