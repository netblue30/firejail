# Firejail profile for mpv
# Description: Video player based on MPlayer/mplayer2
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mpv.local
# Persistent global definitions
include globals.local

# In order to save screenshots to a persistent location,
# edit ~/.config/mpv/foobar.conf:
#    screenshot-directory=~/Pictures

noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${HOME}/.netrc

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc
# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

read-only ${DESKTOP}
mkdir ${HOME}/.config/mpv
mkdir ${HOME}/.config/youtube-dl
mkfile ${HOME}/.netrc
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.config/youtube-dl
whitelist ${HOME}/.netrc
whitelist ${DESKTOP}
whitelist ${DOWNLOADS}
whitelist ${MUSIC}
whitelist ${PICTURES}
whitelist ${VIDEOS}
include whitelist-common.inc
whitelist /usr/share/lua
whitelist /usr/share/lua*
whitelist /usr/share/vulkan
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nogroups seems to cause issues with Nvidia drivers sometimes
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin env,mpv,python*,waf,youtube-dl
# private-cache causes slow OSD, see #2838
#private-cache
private-dev

dbus-user none
dbus-system none
