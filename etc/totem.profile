# Firejail profile for totem
# Description: Simple media player for the GNOME desktop based on GStreamer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/totem.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/totem
noblacklist ${HOME}/.local/share/totem
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
netfilter
# nodbus - makes settings immutable
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-bin totem
# totem needs access to ~/.cache/tracker or it exits
#private-cache
private-dev
# private-etc fonts,machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp
