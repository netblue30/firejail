# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gnome-weather.local

# gnome-weather profile

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them
noblacklist ~/.cache/libgweather

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
netfilter
shell none
tracelog

# private-bin gjs gnome-weather
private-tmp
private-dev
# private-etc fonts
disable-mnt

noexec ${HOME}
noexec /tmp
