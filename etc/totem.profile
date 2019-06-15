# Firejail profile for totem
# Description: Simple media player for the GNOME desktop based on GStreamer
# This file is overwritten after every install/update
# Persistent local customizations
include totem.local
# Persistent global definitions
include globals.local

# Allow lua (required for youtube video)
include allow-lua.inc

noblacklist ${HOME}/.config/totem
noblacklist ${HOME}/.local/share/totem
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
netfilter
# nodbus - makes settings immutable
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none

private-bin totem
# totem needs access to ~/.cache/tracker or it exits
#private-cache
private-dev
# private-etc alternatives,fonts,machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
private-tmp

