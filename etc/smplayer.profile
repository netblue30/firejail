# Firejail profile for smplayer
# Description: Complete front-end for MPlayer and mpv
# This file is overwritten after every install/update
# Persistent local customizations
include smplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${HOME}/.mplayer

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/smplayer
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nodbus - problems with KDE
# nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin env,mplayer,mpv,python*,smplayer,smtube,youtube-dl
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

