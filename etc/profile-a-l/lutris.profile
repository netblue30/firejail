# Firejail profile for lutris
# Description: Multi-library game handler with special support for Wine
# This file is overwritten after every install/update
# Persistent local customizations
include lutris.local
# Persistent global definitions
include globals.local

nodeny  ${PATH}/llvm*
nodeny  ${HOME}/Games
nodeny  ${HOME}/.cache/lutris
nodeny  ${HOME}/.cache/winetricks
nodeny  ${HOME}/.config/lutris
nodeny  ${HOME}/.local/share/lutris
# noblacklist ${HOME}/.wine
nodeny  /tmp/.wine-*
# Don't block access to /sbin and /usr/sbin to allow using ldconfig. Otherwise
# Lutris won't even start.
nodeny  /sbin
nodeny  /usr/sbin

ignore noexec ${HOME}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/Games
mkdir ${HOME}/.cache/lutris
mkdir ${HOME}/.cache/winetricks
mkdir ${HOME}/.config/lutris
mkdir ${HOME}/.local/share/lutris
# mkdir ${HOME}/.wine
allow  ${DOWNLOADS}
allow  ${HOME}/Games
allow  ${HOME}/.cache/lutris
allow  ${HOME}/.cache/winetricks
allow  ${HOME}/.config/lutris
allow  ${HOME}/.local/share/lutris
# whitelist ${HOME}/.wine
allow  /usr/share/lutris
allow  /usr/share/wine
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

# allow-debuggers
# apparmor
caps.drop all
ipc-namespace
# net none
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

# Add the next line to your lutris.local if you do not need controller support.
#private-dev
private-tmp

dbus-user filter
dbus-user.own net.lutris.Lutris
dbus-user.talk com.feralinteractive.GameMode
dbus-system none
