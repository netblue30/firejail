# Firejail profile for smplayer
# Description: Complete front-end for MPlayer and mpv
# This file is overwritten after every install/update
# Persistent local customizations
include smplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.mplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nodbus - problems with KDE
# nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin smplayer,smtube,mplayer,mpv,youtube-dl,python*,env
private-dev
private-tmp

