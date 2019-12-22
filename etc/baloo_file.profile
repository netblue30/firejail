# Firejail profile for baloo_file
# This file is overwritten after every install/update
# Persistent local customizations
include baloo_file.local
# Persistent global definitions
include globals.local

#private-etc Trolltech.conf,X11,alternatives,dbus-1,fonts,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,tor,xdg
# Make home directory read-only and allow writing only to ${HOME}/.local/share
# Note: Baloo will not be able to update the "first run" key in its configuration files.
# read-only ${HOME}
# read-write ${HOME}/.local/share

noblacklist ${HOME}/.config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloorc
noblacklist ${HOME}/.kde4/share/config/baloofilerc
noblacklist ${HOME}/.kde4/share/config/baloorc
noblacklist ${HOME}/.local/share/baloo

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
# net none
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
# blacklisting of ioprio_set system calls breaks baloo_file
seccomp !ioprio_set
shell none
# x11 xorg

private-bin baloo_file,baloo_file_extractor,baloo_filemetadata_temp_extractor,kbuildsycoca4
private-cache
private-dev
private-tmp
