# Firejail profile for kdenlive
# Description: Non-linear video editor
# This file is overwritten after every install/update
# Persistent local customizations
include kdenlive.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/kdenlive
noblacklist ${HOME}/.config/kdenliverc
noblacklist ${HOME}/.local/share/kdenlive

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
# net none
# nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,netlink
seccomp
shell none

private-bin kdenlive,kdenlive_render,dbus-launch,melt,ffmpeg,ffplay,ffprobe,dvdauthor,genisoimage,vlc,xine,kdeinit5,kshell5,kdeinit5_shutdown,kdeinit5_wrapper,kdeinit4,kshell4,kdeinit4_shutdown,kdeinit4_wrapper,mlt-melt
private-dev
# private-etc alternatives,fonts,kde4rc,kde5rc,ld.so.cache,machine-id,passwd,pulse,xdg,X11

# noexec ${HOME}
noexec /tmp
