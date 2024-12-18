# Firejail profile for kdenlive
# Description: Non-linear video editor
# This file is overwritten after every install/update
# Persistent local customizations
include kdenlive.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.cache/kdenlive
noblacklist ${HOME}/.config/kdenliverc
noblacklist ${HOME}/.local/share/kdenlive
noblacklist ${HOME}/.local/share/kxmlgui5/kdenlive

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

apparmor
caps.drop all
#net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,netlink
seccomp

private-bin dbus-launch,dvdauthor,ffmpeg,ffplay,ffprobe,genisoimage,kdeinit4,kdeinit4_shutdown,kdeinit4_wrapper,kdeinit5,kdeinit5_shutdown,kdeinit5_wrapper,kdenlive,kdenlive_render,kshell4,kshell5,melt,mlt-melt,vlc,xine
private-dev
#private-etc alternatives,fonts,kde4rc,kde5rc,ld.so.cache,machine-id,passwd,pulse,X11,xdg

#dbus-user none
#dbus-system none

restrict-namespaces
