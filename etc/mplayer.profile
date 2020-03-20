# Firejail profile for mplayer
# Description: Movie player for Unix-like systems
# This file is overwritten after every install/update
# Persistent local customizations
include mplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.mplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
#X11: include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
# net none - mplayer can be used for streaming.
netfilter
# nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin mplayer
private-dev
private-tmp

