# Firejail profile for smplayer
# Description: Complete front-end for MPlayer and mpv
# This file is overwritten after every install/update
# Persistent local customizations
include smplayer.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/smplayer
nodeny  ${HOME}/.config/youtube-dl
nodeny  ${HOME}/.mplayer

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

nodeny  ${MUSIC}
nodeny  ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

allow  /usr/share/lua*
allow  /usr/share/smplayer
allow  /usr/share/vulkan
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin env,mplayer,mpv,python*,smplayer,smtube,waf,youtube-dl
private-dev
private-tmp

# problems with KDE
# dbus-user none
# dbus-system none
