# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/google-play-music-desktop-player.local

# Google Play Music desktop player profile
noblacklist ~/.config/Google Play Music Desktop Player

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

#whitelist ~/.pulse
#whitelist ~/.config/pulse
whitelist ~/.config/Google Play Music Desktop Player

caps.drop all
#ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp
disable-mnt

noexec ${HOME}
noexec /tmp
