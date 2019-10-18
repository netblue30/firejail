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
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc

apparmor
caps.drop all
ipc-namespace
# net none - breaks update functionality and AppArmor on Ubuntu systems
# uncomment (or put 'net none' in your ocenaudio.local) when needed
#net none
netfilter
no3d
# nodbus - breaks preferences, comment (or put 'ignore nodbus' in your oceanaudio.local) when needed
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

private-bin ocenaudio
private-cache
private-dev
private-etc alternatives,asound.conf,fonts,ld.so.cache,pulse
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
