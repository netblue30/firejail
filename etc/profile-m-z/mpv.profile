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
# screenshot-directory=~/Pictures

# mpv has a powerful Lua API and some of the Lua scripts interact with
# external resources which are blocked by firejail. In such cases you need to
# allow these resources by:
#  - noblacklisting additional paths
#  - whitelisting additional paths
#  - adding additional binaries to private-bin
#  - changing/weakening the D-Bus policy
#  - ...
#
# Often these scripts require a shell:
#include allow-bin-sh.inc
#private-bin sh

noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${HOME}/.config/yt-dlp
noblacklist ${HOME}/.config/yt-dlp.conf
noblacklist ${HOME}/.local/state/mpv
noblacklist ${HOME}/.netrc
noblacklist ${HOME}/yt-dlp.conf
noblacklist ${HOME}/yt-dlp.conf.txt

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

read-only ${DESKTOP}
mkdir ${HOME}/.cache/mpv
mkdir ${HOME}/.config/mpv
mkdir ${HOME}/.local/state/mpv
mkfile ${HOME}/.netrc
whitelist ${HOME}/.cache/mpv
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.config/youtube-dl
whitelist ${HOME}/.config/yt-dlp
whitelist ${HOME}/.config/yt-dlp.conf
whitelist ${HOME}/.local/state/mpv
whitelist ${HOME}/.netrc
whitelist ${HOME}/yt-dlp.conf
whitelist ${HOME}/yt-dlp.conf.txt
whitelist /usr/share/lua*
whitelist /usr/share/mpv
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp !set_mempolicy
seccomp.block-secondary
tracelog

# mpv links to libluajit, so no need to reference "lua*" in private-bin:
# https://github.com/netblue30/firejail/pull/5711#discussion_r1125622615
private-bin env,mpv,python*,waf,youtube-dl,yt-dlp
# private-cache causes slow OSD, see #2838
#private-cache
private-dev

dbus-user none
dbus-system none

restrict-namespaces
