# Firejail profile for lutris
# Description: Multi-library game handler with special support for Wine
# This file is overwritten after every install/update
# Persistent local customizations
include lutris.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/llvm*
noblacklist ${HOME}/Games
noblacklist ${HOME}/.cache/lutris
noblacklist ${HOME}/.cache/winetricks
noblacklist ${HOME}/.config/lutris
noblacklist ${HOME}/.local/share/lutris
# noblacklist ${HOME}/.wine
noblacklist /tmp/.wine-*

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
whitelist ${DOWNLOADS}
whitelist ${HOME}/Games
whitelist ${HOME}/.cache/lutris
whitelist ${HOME}/.cache/winetricks
whitelist ${HOME}/.config/lutris
whitelist ${HOME}/.local/share/lutris
# whitelist ${HOME}/.wine
whitelist /usr/share/lutris
whitelist /usr/share/wine
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

# uncomment the following line if you do not need controller support
# private-dev
private-tmp

dbus-user none
dbus-system none
