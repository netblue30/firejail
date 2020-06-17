# Firejail profile for vlc
# Description: Multimedia player and streamer
# This file is overwritten after every install/update
# Persistent local customizations
include vlc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/vlc
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/vlc
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/vlc
mkdir ${HOME}/.config/vlc
mkdir ${HOME}/.local/share/vlc
whitelist ${HOME}/.cache/vlc
whitelist ${HOME}/.config/vlc
whitelist ${HOME}/.local/share/vlc
whitelist ${MUSIC}
whitelist ${VIDEOS}
include whitelist-var-common.inc

#apparmor - on Ubuntu 18.04 it refuses to start without dbus access
caps.drop all
netfilter
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin cvlc,nvlc,qvlc,rvlc,svlc,vlc
private-dev
private-tmp

# dbus needed for MPRIS
# dbus-user none
# dbus-system none

# mdwe is disabled due to breaking hardware accelerated decoding
#memory-deny-write-execute
