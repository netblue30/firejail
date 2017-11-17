# Firejail profile for gnome-weather
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-weather.local
# Persistent global definitions
include /etc/firejail/globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.cache/libgweather

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
# private-bin gjs gnome-weather
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
