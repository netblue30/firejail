# Firejail profile for artha
# Description: A free cross-platform English thesaurus based on WordNet
# This file is overwritten after every install/update
# Persistent local customizations
include artha.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/artha.conf
noblacklist ${HOME}/.config/artha.log
noblacklist ${HOME}/.config/enchant

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# whitelisting in ${HOME} makes settings immutable, see #3112
#mkfile ${HOME}/.config/artha.conf
#mkdir ${HOME}/.config/enchant
#whitelist ${HOME}/.config/artha.conf
#whitelist ${HOME}/.config/artha.log
#whitelist ${HOME}/.config/enchant
whitelist /usr/share/artha
whitelist /usr/share/wordnet
#include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
# net none - breaks on Ubuntu
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
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin artha,enchant,notify-send
private-cache
private-dev
private-etc alternatives,fonts,machine-id
private-lib libnotify.so.*
private-tmp

# dbus-user none
# dbus-system none

memory-deny-write-execute
