# Firejail profile for gnome-twitch
# Description: GNOME Twitch app for watching Twitch.tv streams without a browser or flash
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-twitch.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/gnome-twitch
noblacklist ${HOME}/.local/share/gnome-twitch

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/gnome-twitch
mkdir ${HOME}/.local/share/gnome-twitch
whitelist ${HOME}/.cache/gnome-twitch
whitelist ${HOME}/.local/share/gnome-twitch
include whitelist-common.inc

caps.drop all
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

