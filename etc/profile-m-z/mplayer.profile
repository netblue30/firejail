# Firejail profile for mplayer
# Description: Movie player for Unix-like systems
# This file is overwritten after every install/update
# Persistent local customizations
include mplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.mplayer

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

read-only ${DESKTOP}
mkdir ${HOME}/.mplayer
whitelist ${HOME}/.mplayer
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#net none # mplayer can be used for streaming.
netfilter
#nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp

private-bin mplayer
private-dev
private-tmp

restrict-namespaces
