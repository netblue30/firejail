# Firejail profile for totem
# Description: Simple media player for the GNOME desktop based on GStreamer
# This file is overwritten after every install/update
# Persistent local customizations
include totem.local
# Persistent global definitions
include globals.local

# Allow lua (blacklisted by disable-interpreters.inc)
# required for youtube video
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

nodeny  ${HOME}/.config/totem
nodeny  ${HOME}/.local/share/totem

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

read-only ${DESKTOP}
mkdir ${HOME}/.config/totem
mkdir ${HOME}/.local/share/totem
allow  ${HOME}/.config/totem
allow  ${HOME}/.local/share/totem
allow  /usr/share/totem
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin totem
# totem needs access to ~/.cache/tracker or it exits
#private-cache
private-dev
# private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,machine-id,pki,pulse,ssl
private-tmp

# makes settings immutable
# dbus-user none
dbus-system none
