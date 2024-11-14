# Firejail profile for anki
# Description: flexible, intelligent flashcard program
# This file is overwritten after every install/update
# Persistent local customizations
include anki.local
# Persistent global definitions
include globals.local

# Add the following to anki.local if you don't need media playing/recording
# (lua is needed by mpv):
#ignore include allow-lua.inc

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.local/share/Anki2
noblacklist ${HOME}/.mplayer

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/Anki2
whitelist ${DOCUMENTS}
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.local/share/Anki2
whitelist ${HOME}/.mplayer
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
# QtWebengine needs chroot to set up its own sandbox
seccomp !chroot

disable-mnt
private-bin anki,mplayer,mpv,python*
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
