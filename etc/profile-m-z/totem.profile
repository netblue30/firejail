# Firejail profile for totem
# Description: Simple media player for the GNOME desktop based on GStreamer
# This file is overwritten after every install/update
# Persistent local customizations
include totem.local
# Persistent global definitions
include globals.local

# Allow lua (required for youtube video)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

noblacklist ${HOME}/.config/totem
noblacklist ${HOME}/.local/share/totem

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.config/totem
mkdir ${HOME}/.local/share/totem
whitelist ${HOME}/.config/totem
whitelist ${HOME}/.local/share/totem
whitelist ${DESKTOP}
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${MUSIC}
whitelist ${PICTURES}
whitelist ${VIDEOS}
include whitelist-common.inc
include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
netfilter
nogroups
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
# dbus-system none
