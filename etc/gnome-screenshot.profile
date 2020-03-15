# Firejail profile for gnome-screenshot
# Description: GNOME screenshot tool
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-screenshot.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}
noblacklist ${HOME}/.cache/gnome-screenshot

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${RUNUSER}/bus
whitelist ${RUNUSER}/pulse
whitelist ${RUNUSER}/gdm/Xauthority
whitelist ${RUNUSER}/wayland-0
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
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

disable-mnt
private-bin gnome-screenshot
private-dev
private-etc dconf,fonts,gtk-3.0,localtime,machine-id
private-tmp
