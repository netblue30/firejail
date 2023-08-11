# Firejail profile for xplayer
# This file is overwritten after every install/update
# Persistent local customizations
include xplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xplayer
noblacklist ${HOME}/.local/share/xplayer

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

read-only ${DESKTOP}
mkdir ${HOME}/.config/xplayer
mkdir ${HOME}/.local/share/xplayer
whitelist ${HOME}/.config/xplayer
whitelist ${HOME}/.local/share/xplayer
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-var-common.inc

#apparmor # makes settings immutable
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
tracelog

private-bin xplayer,xplayer-audio-preview,xplayer-video-thumbnailer
private-dev
#private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,machine-id,pki,pulse,ssl
private-tmp

# makes settings immutable
#dbus-user none
#dbus-system none

restrict-namespaces
