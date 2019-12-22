# Firejail profile for kdenlive
# Description: Non-linear video editor
# This file is overwritten after every install/update
# Persistent local customizations
include kdenlive.local
# Persistent global definitions
include globals.local

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
ignore noexec ${HOME}

noblacklist ${HOME}/.cache/kdenlive
noblacklist ${HOME}/.config/kdenliverc
noblacklist ${HOME}/.local/share/kdenlive

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
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

private-bin dbus-launch,dvdauthor,ffmpeg,ffplay,ffprobe,genisoimage,kdeinit4,kdeinit4_shutdown,kdeinit4_wrapper,kdeinit5,kdeinit5_shutdown,kdeinit5_wrapper,kdenlive,kdenlive_render,kshell4,kshell5,melt,mlt-melt,vlc,xine
private-dev
