# Firejail profile for clipgrab
# Description: A free video downloader and converter
# This file is overwritten after every install/update
# Persistent local customizations
include clipgrab.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Philipp Schmieder
noblacklist ${HOME}/.pki
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
# Breaks tray-icon, uncommend or add to clipgrab.local if you don't need it.
#nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

disable-mnt
private-cache
private-dev
private-tmp
