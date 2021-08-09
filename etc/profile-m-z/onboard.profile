# Firejail profile for onboard
# Description: On-screen keyboard
# This file is overwritten after every install/update
# Persistent local customizations
include onboard.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/onboard

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

mkdir ${HOME}/.config/onboard
whitelist ${HOME}/.config/onboard
whitelist /usr/share/onboard
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
no3d
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-cache
private-bin onboard,python*,tput
private-dev
private-etc alternatives,dbus-1,dconf,fonts,gtk-2.0,gtk-3.0,locale,locale.alias,locale.conf,mime.types,selinux,X11,xdg
private-tmp

dbus-system none
