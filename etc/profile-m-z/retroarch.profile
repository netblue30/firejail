# Firejail profile for retroarch
# Description: retroarch is a frontend to libretro emulator cores.
# This file is overwritten after every install/update
# Persistent local customizations
include retroarch.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/retroarch
whitelist ${HOME}/.config/retroarch
whitelist /run/udev
whitelist /usr/share/retroarch
whitelist /usr/share/libretro
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
# If you need access to cameras, add `ignore novideo` to retroarch.local
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin retroarch
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
