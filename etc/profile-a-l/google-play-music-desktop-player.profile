# Firejail profile for google-play-music-desktop-player
# This file is overwritten after every install/update
# Persistent local customizations
include google-play-music-desktop-player.local
# Persistent global definitions
include globals.local

# noexec /tmp breaks mpris support
ignore noexec /tmp

noblacklist ${HOME}/.config/Google Play Music Desktop Player

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/Google Play Music Desktop Player
#whitelist ${HOME}/.config/pulse
#whitelist ${HOME}/.pulse
whitelist ${HOME}/.config/Google Play Music Desktop Player
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private-dev
private-tmp

restrict-namespaces
