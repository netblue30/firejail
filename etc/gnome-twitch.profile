# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gnome-twitch.local

# Firejail profile for Gnome Twitch
noblacklist ${HOME}/.cache/gnome-twitch
noblacklist ${HOME}/.local/share/gnome-twitch

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/gnome-twitch
whitelist ${HOME}/.cache/gnome-twitch
mkdir ${HOME}/.local/share/gnome-twitch
whitelist ${HOME}/.local/share/gnome-twitch
include /etc/firejail/whitelist-common.inc

caps.drop all
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
