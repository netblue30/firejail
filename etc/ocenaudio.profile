# Firejail profile for ocenaudio
# Description: Cross-platform, easy to use, fast and functional audio editor
# This file is overwritten after every install/update
# Persistent local customizations
include ocenaudio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/ocenaudio
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
net none
no3d
# nodbus - breaks preferences, comment when needed
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

# disable-mnt
# private
private-bin ocenaudio
private-cache
private-dev
private-etc asound.conf,fonts,pulse
# private-lib
private-tmp

# memory-deny-write-execute - breaks on Arch
noexec ${HOME}
noexec /tmp
