# Firejail profile for google-play-music-desktop-player
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-play-music-desktop-player.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Google Play Music Desktop Player

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# whitelist ${HOME}/.config/pulse
# whitelist ${HOME}/.pulse
whitelist ${HOME}/.config/Google Play Music Desktop Player
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
# noexec /tmp breaks mpris support
#noexec /tmp
