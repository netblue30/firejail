# Firejail profile for mpv
# Description: Video player based on MPlayer/mplayer2
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mpv.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${HOME}/.netrc

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc
# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

noblacklist ${MUSIC}
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/vulkan
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
# Seems to cause issues with Nvidia drivers sometimes
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin env,mpv,python*,youtube-dl
# Causes slow OSD, see #2838
#private-cache
private-dev
