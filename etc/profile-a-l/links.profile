# Firejail profile for links
# Description: Text WWW browser
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include links.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.links

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# Additional noblacklist files/directories (blacklisted in disable-programs.inc)
# used as associated programs can be added in your links.local.
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.links
whitelist ${HOME}/.links
whitelist ${DOWNLOADS}
include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
# Add 'ignore machine-id' to your links.local if you want to restrict access to
# the user-configured associated media player.
machine-id
netfilter
# Add 'ignore no3d' to your links.local if you want to restrict access to
# the user-configured associated media player.
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
# Add 'ignore nosound' to your links.local if you want to restrict access to
# the user-configured associated media player.
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
# Add  'private-bin PROGRAM1,PROGRAM2' to your links.local  if you want to use user-configured programs.
private-bin links,sh
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,nsswitch.conf,pki,resolv.conf,ssl
# Add the next line to your links.local to allow external media players.
# private-etc alsa,asound.conf,machine-id,openal,pulse
private-tmp

memory-deny-write-execute
